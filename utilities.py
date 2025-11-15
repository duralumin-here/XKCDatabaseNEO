import sys
import sqlite3
from collections import namedtuple

def handler(conn):
    # Defines a handler to save before exiting when execution is stopped
    def handler(sig, frame):
        print("Saving and exiting...")
        conn.commit()
        sys.exit(0)
    return handler