import requests
import re

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

# ========== Getting specific transcript text  ==========

def get_tr_txt(num, session):
    # Gets the text of the transcript for an xkcd comic
    try:
        data = get_transcript_page(num, session)
        if not data:
            return "Transcript not found"
        return str(data['parse']['wikitext'])
    except:
        return "Transcript not found"

def get_all_from_tr_txt(data_str):
    transcript = get_transcript_from_tr_txt(data_str)
    lines = transcript.split("\n")
    speech = []
    description = []
    on_screen = []
    # It looks scary, but it just looks for names of one or more words followed by a colon,
    # whitespace, and character. It can contain dashes, parentheticals/bracketed statements, and an honorific.
    speech_search = r"^(?:(?:[\w-]{1,4}\.\s)?[\w-]+(\s[\w-]+)*)\s?(?:(?:\[|\)).+\s*(?:\]|\)))?:\s\S"
    for line in lines:
        if len(line) == 0 or line.isspace():
            continue
        elif line.upper().startswith("MY HOBBY"):
            on_screen.append(line)
        elif line.startswith("["):
            line = line.replace("[", "")
            line = line.replace("]", "")
            description.append(line)
        elif re.match(speech_search, line):
            speech.append(line)
        else:
            on_screen.append(line)
    # TODO: Check if things are empty and don't try to edit them; also just generally tidy all this
    for list in [speech, description, on_screen]:
        list = list_check(list)
        
    return '\n'.join(speech), '\n'.join(on_screen), '\n'.join(description)

def list_check(list):
    if len(list) == 0:
            return list
    if list[-1].count("\"") % 2 != 0:
        list[-1] = list[-1].removesuffix("\"")
    elif list[-1].count("\'") % 2 != 0:
        list[-1] = list[-1].removesuffix("'")
    return list

def get_categories_from_tr_txt(data_str):
    # Formats the categories of a comic given its transcript section
    categories = remove_str_start(data_str, "{{Comic discussion}}")
    if not categories:
        return None
    categories = categories.replace("[[Category:", "")
    categories = categories.replace("]]", ",")
    categories = categories.replace("\\n","")
    categories = categories.replace("\n","")
    categories = categories.strip("\'} ,\"")
    return categories.split(",")

def get_transcript_from_tr_txt(data_str):
    # Neatens up the given transcript section of a comic
    data_str = remove_str_start(data_str, "==Transcript==")
    data_str = remove_str_end(data_str, "{{Comic discussion}}")
    for newline in ["\\n:", "\n:", "\\n#", "\n#", "\\n"]:
        data_str = data_str.replace(newline, "\n")
    data_str = data_str.replace("\\'", "'")
    data_str = data_str.replace(" &ndash;", "–")
    data_str = data_str.strip("\n} ")
    # This removes HTML tags from the transcript unless they're part of the comic (thanks Randall...)
    regex_html_tags = r"((?!<nowiki>.*?)(<[^>]+>)(?!.*?</nowiki>))|(<[^>]+>(?=.*<nowiki>))|(<[^>]*nowiki[^>]*>)"
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