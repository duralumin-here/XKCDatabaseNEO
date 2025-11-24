import sqlite3
import signal
import requests
import concurrent.futures
import os
from pathlib import Path

import sql
import data

# ========== Main functions ==========

def fill_metadata(database, table):
    # Fills in the specified data for all comics not already filled in the table
    conn, cur, session = start_session(database)
    prep_table(table, cur, conn)
    ids = get_metadata_missing(table, cur)
    if not ids or len(ids) == 0:
        print("Nothing to fill.")
        return
    with concurrent.futures.ThreadPoolExecutor(max_workers=10) as executor:
        futures = {executor.submit(get_and_store_metadata, id, session, database, table): id for id in ids}
        retries = []
        for future in concurrent.futures.as_completed(futures):
            result = future.result()
            if result is not None: # Function returns comic ID when it fails
                retries.append(result) 
    fails = []
    # Retry more slowly if any are missed
    for retry in retries:
        fails.append(get_and_store_metadata(retry, session, database, table))
    if not fails:
        print("Success! The requested data was filled for all comics.")
    else:
        print(f"The requested data was not filled for the following comics: {fails}")

def get_all_comic_imgs(database, table):
    conn, cur, session = start_session(database)
    rows = sql.get_tuple_from_columns(table, "ComicID", "ImgLink", cur)
    if not rows:
        print("No data found in table.")
        return
    conn.close()
    Path("comic_images").mkdir(parents=True, exist_ok=True)
    with concurrent.futures.ThreadPoolExecutor(max_workers=10) as executor:
        futures = {executor.submit(get_and_save_image, id, url, session): (id, url) for id, url in rows}
        retries = []
        for future in concurrent.futures.as_completed(futures):
            result = future.result()
            if result is not None:
                retries.append(result)
    if not retries:
        print("All images saved successfully.")
        return
    # Retry failed downloads
    fails = []
    for retry in retries:
        fails.append(get_and_save_image(retry[0], retry[1], session))
    if len(fails):
        print("All images saved successfully.")
        return
    print("The following comics were not saved:")
    for fail in fails:
        print(fail)

# ========== Helper functions ==========

def start_session(database):
    # Returns SQLite connection, a cursor to it, and a request session
    conn = sqlite3.connect(database)
    cur = conn.cursor()
    session = requests.Session()
    return conn, cur, session

def prep_table_metadata(table, cur, conn):
    # Creates and prepares the metadata table
    sql.make_table(cur, table)
    sql.add_columns(sql.get_metadata_columns(), table, cur)
    conn.commit()

def prep_table(table, cur, conn):
    # Creates and prepares the entire table
    sql.make_table(cur, table)
    sql.add_columns(sql.get_metadata_columns(), table, cur)
    sql.add_columns(sql.get_transcript_columns(), table, cur)
    conn.commit()

def get_metadata_params(id, session):
    # Fetches and returns JSON from xkcd in most circumstances
    if id == 259: # The JSON doesn't properly include the "é"s
        return (259, "Clichéd Exchanges", "2007-05-09", "https://imgs.xkcd.com/comics/cliched_exchanges.png", "It's like they say, you gotta fight fire with clichés.")
    elif id == 404: # True to its name, 404 doesn't technically exist
        return (404, "Not Found", "2008-04-01", "", "")
    else:
        comic = data.get_comic(id, session)
        return (id, comic['title'], format_date(comic), comic['img'], comic['alt'])

def format_date(comic):
    # Returns the formated date from an xkcd comic
    return f"{int(comic['year']):04d}-{int(comic['month']):02d}-{int(comic['day']):02d}"

def get_metadata_missing(table, cur):
    # Returns a list of each ComicID in the table that hasn't been added by metadata
    last_posted = data.latest_comic()['num']
    missing = []
    for id in range(1, last_posted + 1):
        if not cur.execute(f"SELECT Title FROM {table} WHERE ComicID = ?", (id,)).fetchone():
            missing.append(id)
    return missing

def get_and_store_metadata(id, session, database, table):
    # Retrives and stores metadata in for a comic based on its id
    conn = sqlite3.connect(database)
    cur = conn.cursor()
    print("Fetching information for xkcd " + str(id) + "...")
    try:
        params = get_metadata_params(id, session)
        statement = sql.get_metadata_statement(table)
        cur.execute(statement, params)
        conn.commit()
    except Exception as e:
        print(f"An error occurred while processing Comic {id}: {e}")
        return id
    finally:
        conn.close()

def get_and_save_image(id, url, session):
    # Retrives and stores image for a comic
    url = id_img_check(id, url) # Checks comic id for special cases
    if (not id) or (not url):
        print(f"Missing information in ID {id} and/or url {url}. Skipping.")
        return None
    print(f"Attempting to save {str(id)} as image...")
    try:
        # comic_images\id-filename
        filename = url.rsplit('/', 1)[-1]
        image_path = os.path.join("comic_images", f"{int(id):04d}-{filename}")
        response = session.get(url)
        if response.status_code == 200:
            file = open(image_path, "wb")
            file.write(response.content)
            file.close()
            return None
        else:
            print('Failed to retrieve the image:', response.status_code)
            return id, url
    except Exception as e:
        print(f"An error occurred while trying to save xkcd {id}: {e}")
        return id, url

def id_img_check(id, url):
    if id == 404: # 404 comic doesn't exist
        return "https://www.explainxkcd.com/wiki/images/9/92/not_found.png"
    elif id == 1608: # Interactive comic
        return "https://www.explainxkcd.com/wiki/images/4/41/hoverboard.png"
    elif id == 1663: # Interactive comic
        return "https://www.explainxkcd.com/wiki/images/c/ce/garden.png"
    else:
        return url