import requests
import re
import metadata
import sql
import concurrent
import sqlite3
import time

# ==================== Retrieving xkcd content ====================

def latest_comic():
    # Gets the latest comic from xkcd
    url = "https://xkcd.com/info.0.json" 
    response = requests.get(url)
    return response.json()

def get_comic(num, session):
    # Gets a comic from xkcd by number
    url = f"https://xkcd.com/{str(num)}/info.0.json" 
    response = session.get(url)
    return response.json()

# ==================== Retrieving explain xkcd content ====================

# ========== Filling transcript info into table ==========

def fill_transcript_info_missing(database, table):
    # Retrieves the transcript info for xkcd comics missing in the database
    _, cur, session = metadata.start_session(database)
    sql.add_columns(sql.get_transcript_columns(), table, cur)
    ids = get_transcript_info_missing(table, cur)
    if len(ids) == 0:
        print("All comics have transcript information.")
        return
    retries = []
    with concurrent.futures.ThreadPoolExecutor(max_workers=10) as executor:
        futures = {executor.submit(get_and_store_transcript_info, id, session, database, table): id for id in ids}
        for future in concurrent.futures.as_completed(futures):
            result = future.result()
            if result is not None: # Function returns comic ID when it fails
                retries.append(result)
    if not retries:
        print("Success! All comics successfully processed.")
        return
    # Retry more slowly if any are missed
    fails = []
    for retry in retries:
        fails = get_and_store_transcript_info(retry, session, database, table)
    if not fails:
        print("Success! All comics successfully processed.")
    else:
        print(f"Some comics were not processed: {fails}")

def fill_category_info_missing(database, table):
    # Retrieves the transcript info for xkcd comics missing in the database
    _, cur, session = metadata.start_session(database)
    sql.add_columns(sql.get_transcript_columns(), table, cur)
    ids = get_category_info_missing(table, cur)
    if len(ids) == 0:
        print("All comics have categories.")
        return
    retries = []
    with concurrent.futures.ThreadPoolExecutor(max_workers=10) as executor:
        futures = {executor.submit(get_and_store_categories, id, session, database, table): id for id in ids}
        for future in concurrent.futures.as_completed(futures):
            result = future.result()
            if result is not None: # Function returns comic ID when it fails
                retries.append(result)
    if not retries:
        print("Success! All comics successfully processed.")
        return
    # Retry more slowly if any are missed
    fails = []
    for retry in retries:
        fails = get_and_store_categories(retry, session, database, table)
    if not fails:
        print("Success! All comics successfully processed.")
    else:
        print(f"Some comics were not processed: {fails}")

def get_transcript_info_missing(table, cur):
    # Returns a list of each Dialogue in the table that hasn't been added by metadata
    last_posted = latest_comic()['num']
    missing = []
    for id in range(1, last_posted + 1):
        result = cur.execute(f"SELECT Description FROM {table} WHERE ComicID = ?", (id,)).fetchone()
        if not result:
            missing.append(id)
        else:
            if not result[0]:
                missing.append(id)            
    return missing

def get_category_info_missing(table, cur):
    # Returns a list of each Dialogue in the table that hasn't been added by metadata
    last_posted = latest_comic()['num']
    missing = []
    for id in range(1, last_posted + 1):
        result = cur.execute(f"SELECT Categories FROM {table} WHERE ComicID = ?", (id,)).fetchone()
        if not result or not result[0]:
            missing.append(id) 
        else:
            time.sleep(0.5)       
    return missing

def get_and_store_transcript_info(id, session, database, table):
    # Retrives and stores metadata in for a comic based on its id
    conn = sqlite3.connect(database)
    cur = conn.cursor()
    print("Filling transcript information for xkcd " + str(id) + "...")
    try:
        data_str = get_tr_txt(id, session)
        if not data_str:
            raise ValueError("No transcript text found.")
        speech, on_screen, desc = get_all_from_tr_txt(data_str)
        params = (speech, on_screen, desc)
        statement = sql.get_transcript_statement(table, id)
        cur.execute(statement, params)
        conn.commit()
    except Exception as e:
        print(f"An error occurred while processing Comic {id}: {e}")
    finally:
        conn.close()

# ========== Getting specific transcript text  ==========

def get_tr_txt(num, session):
    # Gets the text of the transcript for an xkcd comic
    try:
        data = get_transcript_page(num, session)
        if not data:
            return None
        return str(data['parse']['wikitext'])
    except:
        return None

def get_all_from_tr_txt(data_str):
    transcript = get_transcript_from_tr_txt(data_str)
    lines = transcript.split("\n")
    speech = []
    description = []
    on_screen = []
    # It looks scary, but it just looks for names of one or more words followed by a colon,
    # whitespace, and character. It can contain dashes, commas, parentheticals/bracketed statements, and an honorific.
    speech_search = r"^(?:(?:[\w]{2,4}\.\s)?[-',\w]+(\s[-',\w]+)*)\s?(?:(?:\[|\().+\s*(?:\]|\)))?:\s\S"
    for line in lines:
        # Remove whitespace
        line = line.strip()
        line = line.removeprefix(":")
        if len(line) == 0 or line.isspace():
            continue
        elif line.upper().startswith(("MY HOBBY", "CAPTION")):
            on_screen.append(line)
        elif line.startswith("["):
            line = line.replace("[", "")
            line = line.replace("]", "")
            description.append(line)
        elif re.match(speech_search, line):
            # TODO: Further refine this check
            speech.append(line)
        else:
            on_screen.append(line)
    for list in [speech, description, on_screen]:
        list = list_check(list)
        
    return ('\n'.join(speech), '\n'.join(on_screen), '\n'.join(description))

def is_actually_just_description(line):
    speech_exceptions = ["AXIS:", "LABEL:", "ARROW:", "LINE:", "SIGN:", "NAME:", "TITLE:", "POSTER:"]
    for word in speech_exceptions:
        index = line.upper().find(word)
        if index != -1:
            line = line[index + len(word):]  # Adjust this if you want to exclude the word
            return True, line.strip()
    return False, line 

def list_check(list):
    if len(list) == 0:
            return list
    if list[-1].count("\"") % 2 != 0:
        list[-1] = list[-1].removesuffix("\"")
    elif list[-1].count("\'") % 2 != 0:
        list[-1] = list[-1].removesuffix("'")
    return list

def get_and_store_categories(id, session, database, table):
    conn = sqlite3.connect(database)
    cur = conn.cursor()
    print("Filling category information for xkcd " + str(id) + "...")
    try:
        category_data = get_category_data(id, session)
        if not category_data:
            raise ValueError("No categories found.")
        categories = categories_from_data(category_data)
        nameString = '"{}"'.format('";"'.join(categories)) 
        final = nameString.replace("Category:", "")
        final2 = final.replace("\"", "")
        final2 = final2.replace("All comics;", "")
        final2 = final2.replace("All pages;", "")
        statement = f"UPDATE {table} SET Categories = ? WHERE ComicID = {id}"
        cur.execute(statement, (final2,))
        conn.commit()
    except Exception as e:
        print(f"An error occurred while processing Comic {id}: {e}")
    finally:
        conn.close()

def categories_from_data(category_data):
    page_id = next(iter(category_data['query']['pages']))
    categories = category_data['query']['pages'][page_id].get('categories', [])
    return [category['title'] for category in categories]

def get_category_data(num, session):
    # Returns the JSON category data for a comic of given number
    URL = "https://www.explainxkcd.com/wiki/api.php"
    try:
        page = format_page_title(num, session)
    except:
        print("Error getting categories: Invalid ID")
    PARAMS = {
                "action": "query",
                "format": "json",
                "titles": page,
                "prop": "categories"
            }
    R = session.get(url=URL, params=PARAMS)
    return R.json()

def format_categories(data):
    try:
        page_id = next(iter(data['query']['pages']))
        categories = data['query']['pages'][page_id].get('categories', [])
        category_titles = [category['title'] for category in categories]
        return category_titles
    except:
        return

def get_transcript_from_tr_txt(data_str):
    # Neatens up the given transcript section of a comic
    data_str = remove_str_start(data_str, "==Transcript==")
    data_str = remove_str_start(data_str, "== Transcript ==")
    data_str = remove_str_end(data_str, "{{Comic discussion}}")
    for newline in ["\\n:", "\n:", "\\n#", "\n#", "\\n"]:
        data_str = data_str.replace(newline, "\n")
    data_str = data_str.replace("\\'", "'")
    data_str = data_str.replace(" &ndash;", "–")
    data_str = data_str.replace("&nbsp;", " ")
    data_str = data_str.strip("\n} ")
    # This removes HTML tags from the transcript unless they're part of the comic (thanks Randall...)
    regex_html_tags = r"((?!<nowiki>.*?)(<[^>]+>)(?!(.*?</nowiki>)|>))|(<[^>]+>(?=.*<nowiki>))|(<[^>]*nowiki[^>]*>)"
    data_str = re.sub(regex_html_tags, '', data_str)
    return str(data_str)

# ===== Helpers for getting transcripts =====

def get_transcript_page(num, session):
    # Returns the JSON transcript data for a comic of given number
    URL = "https://www.explainxkcd.com/wiki/api.php"
    try:
        page = format_page_title(num, session)
    except:
        print("Error retreiving transcript: Invalid ID")
    sections = get_sections(page, session)
    for section_data in sections:
        if section_data['line'] == "Transcript":
            section_num = section_data.get('index')
            break
    if section_num == None:
        return None
    PARAMS = {
                "action": "parse",
                "format": "json",
                "page": page,
                "prop": "wikitext",
                "section": section_num
            }
    R = session.get(url=URL, params=PARAMS)
    return R.json()

def format_page_title(num, session):
    # Formats the explain xkcd wiki page title based on comic number
    if id == 259: # JSON doesn't have the é
        return "259:_Clichéd_Exchanges"
    elif id == 404: # 404 doesn't exist
        return "404:_Not_Found"
    else:
        title = get_comic(num, session)['title'].replace(" ", "_")
        return f"{num}:_{title}"

def get_sections(page, session):
    # Gets the sections on the explain xkcd page for a comic
    URL = "https://www.explainxkcd.com/wiki/api.php"
    PARAMS = {
        "action": "parse",
        "format": "json",
        "page": page,
        "prop": "sections",
    }
    R = session.get(url=URL, params=PARAMS)
    return R.json()['parse']['sections']

def remove_str_start(str, removal):
    # Removes substring (and everything before it) from str if found
    index = str.upper().find(removal.upper())
    if index != -1:
        str = str[index + len(removal):]
    return str

def remove_str_end(str, removal):
    # Removes substring (and everything after it) from str if found
    index = str.upper().find(removal.upper())
    if index != -1:
        str = str[:index]
    return str