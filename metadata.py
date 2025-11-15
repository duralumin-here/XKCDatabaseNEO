import sqlite3
import signal
import requests
import concurrent.futures

import sql
import data
import utilities

# ========== Main functions ==========

def fill_metadata_fast(database, table):
    # Retrieves the metadata for xkcd comics past the most recently stored (uses concurrent threading)
    conn, cur, session = start_session(database)
    prep_table_metadata(table, cur, conn)
    # Only attempt to fill the ones not saved yet
    last_saved = sql.get_largest("ComicID", cur, table)
    conn.close()
    last_posted = data.latest_comic()['num']
    # Checks if the most recent comic number is actually a number
    if type(last_posted) != type(1):
        print("Error retrieving most recent xkcd comic: number not an integer")
        return
    print(f"Last saved comic: {last_saved}   |   Last posted comic: {last_posted}")
    with concurrent.futures.ThreadPoolExecutor(max_workers=10) as executor:
        retries = {executor.submit(get_and_store_metadata, id, session, database, table): id for id in range(last_saved + 1, last_posted + 1)}
    # Retry more slowly if any are missed
    for retry in retries:
        get_and_store_metadata(retry, session, database, table)

def fill_metadata_missing(database, table):
    # Retrieves the metadata for xkcd comics missing in the database
    _, cur, session = start_session(database)
    ids = get_metadata_missing(table, cur)
    if len(ids) == 0:
        print("All comics have metadata.")
        return
    elif len(ids) < 50:
        for id in ids:
            get_and_store_metadata(id, session, database, table)
    else:
        with concurrent.futures.ThreadPoolExecutor(max_workers=10) as executor:
            retries = {executor.submit(get_and_store_metadata, id, session, database, table): id for id in ids}
        # Retry more slowly if any are missed
        for retry in retries:
            get_and_store_metadata(retry, session, database, table)

def fill_metadata_slow(database, table):
    # Retrieves the metadata for xkcd comics past the most recently stored (no concurrent threading)
    signal.signal(signal.SIGINT, utilities.handler(conn)) # Save before exiting if execution stops
    conn, cur, session = start_session(database)
    prep_table_metadata(table, cur, conn)
    # Only attempt to fill the ones not saved yet
    last_saved = sql.get_largest("ComicID", cur, table)
    last_posted = data.latest_comic()['num']
    # Checks if the most recent comic number is actually a number
    if type(last_posted) != type(1):
        print("Error retrieving most recent xkcd comic: number not an integer")
        return
    print(f"Last saved comic: {last_saved}   |   Last posted comic: {last_posted}")
    for id in range(last_saved + 1, last_posted + 1):
        print("Fetching information for xkcd " + str(id) + "...")
        try:
            params = get_metadata_params(id, session)
            statement = sql.get_metadata_statement(table)
            cur.execute(statement, params)
        except Exception as e:
            print(f"An error occurred while processing Comic {id}: {e}")
            break
    conn.commit()

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

def get_metadata_params(id, session):
    # Fetches and returns JSON from xkcd in most circumstances
    if id == 259: # The JSON doesn't properly include the "é"s
        return (259, "Clichéd Exchanges", "2007-05-09", "https://imgs.xkcd.com/comics/cliched_exchanges.png", "It's like they say, you gotta fight fire with clichés.")
    elif id == 404: # True to its name, 404 doesn't technically exist
        return (404, "Not Found", "2008-04-01", "", "")
    else:
        comic = data.get_comic(id, session)
        return (id, comic['title'], format_date(comic), comic['img'], comic['alt'])

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
        conn.close()
    except Exception as e:
        print(f"An error occurred while processing Comic {id}: {e}")
        return id

def format_date(comic):
    # Returns the formated date from an already retrieved xkcd comic
    return f"{int(comic['year']):04d}-{int(comic['month']):02d}-{int(comic['day']):02d}"