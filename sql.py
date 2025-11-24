from collections import namedtuple

# Note: Parameterized queries are used for anything with outside/dynamic data for security.
# Any variables directly used are ones I define myself in the code.

# ========== Getting statements ==========

def get_add_column_statement(table, name, type):
    # Fills in a statement to add specified column to specified table
    return f"""
    ALTER TABLE {table}
    ADD COLUMN {name} {type};
    """

def get_metadata_statement(table):
    # Gets the statement used to insert metadata into the table
    return f"""INSERT INTO {table}
     (
        ComicID,
        Title,
        Date,
        ImgLink,
        AltText
     )
    VALUES (?, ?, ?, ?, ?)
    """

def get_transcript_statement(table, id):
    # Gets the statement used to insert metadata into the table
    return f"""UPDATE {table}
    SET
        Dialogue = ?,
        OnScreenText = ?,
        Description = ?
    WHERE
        ComicID = {id}
    """

def get_metadata_columns():
    # Returns the columns used for metadata (besides ComicID, which is predefined)
    Column = namedtuple('Column', ['name', 'type'])
    return [
        Column(name='Title', type='TEXT'),
        Column(name='Date', type='TEXT'),
        Column(name='ImgLink', type='TEXT'),
        Column(name='AltText', type='TEXT'),
    ]

def get_transcript_columns():
    # Returns the columns used for explain xkcd data (besides ComicID, which is predefined)
    Column = namedtuple('Column', ['name', 'type'])
    return [
        Column(name='Dialogue', type='TEXT'),
        Column(name='OnScreenText', type='TEXT'),
        Column(name='Description', type='TEXT'),
        Column(name='Categories', type='TEXT'),
    ]

# ========== Making things ==========

def make_table(cur, table):
    # Makes the given table in cur's database if it doesn't exist
    statement = f"""
    CREATE TABLE IF NOT EXISTS {table}
    ("ComicID" INTEGER NOT NULL, PRIMARY KEY("ComicID"));
    """
    cur.execute(statement)
    print(f"Table '{table}' created or exists")

def add_columns(columns, table, cur):
    # Adds columns to the specified table
    for column in columns:
        if does_column_exist(column.name, table, cur):
            print(f"Column '{column.name}' exists")
            continue
        else:
            statement = get_add_column_statement(table, column.name, column.type)
            cur.execute(statement)
            print(f"Successfully added column: {column.name}")

# ========== Getting information ==========

def does_column_exist(name, table, cur):
    # Checks if column exists in the given table
    statement = f"""SELECT COUNT(*) 
    AS CNTREC
    FROM pragma_table_info('{table}')
    WHERE name='{name}'
    """
    result = cur.execute(statement)
    # Returns False if 0 such columns found; otherwise True
    return bool(int(result.fetchone()[0]))

def get_largest(para, cur, table):
    # Gets the largest value in the table of the given parameter
    try:
        lastSaved = cur.execute(f"SELECT MAX({para}) FROM {table}").fetchone()
        return int(lastSaved[0])
    except:
        return 0

def get_array_from_column(table, column, cur):
    try:
        cur.execute(f"SELECT {column} FROM {table}")
        values = cur.fetchall()
        return [row[0] for row in values]
    except Exception as e:
        print(f"An error occurred: {e}")
        return None
    
def get_tuple_from_columns(table, column1, column2, cur):
    try:
        cur.execute(f"SELECT {column1}, {column2} FROM {table}")
        values = cur.fetchall()
        return [(row[0], row[1]) for row in values]
    except Exception as e:
        print(f"An error occurred: {e}")
        return None