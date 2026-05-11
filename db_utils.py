"""
Utility functions for Daunt Books database operations.
Handles connections, queries, and error management.
"""
import sqlite3
from config import DB_FILE


def get_connection():
    """Establish and return a database connection."""
    try:
        conn = sqlite3.connect(DB_FILE)
        conn.row_factory = sqlite3.Row
        return conn
    except sqlite3.Error as e:
        print(f"Error connecting to database: {e}")
        return None


def execute_query(query, params=None, fetch_results=True):
    """
    Execute a SQL query with error handling and parameterised inputs.
    Returns list of dicts for SELECT, row count for UPDATE/INSERT.
    """
    conn = None
    cursor = None
    try:
        conn = get_connection()
        if conn is None:
            return None
        cursor = conn.cursor()
        if params:
            cursor.execute(query, params)
        else:
            cursor.execute(query)
        if fetch_results:
            return [dict(row) for row in cursor.fetchall()]
        else:
            conn.commit()
            return cursor.rowcount
    except sqlite3.Error as e:
        print(f"Database error: {e}")
        return None
    finally:
        if cursor:
            cursor.close()
        if conn:
            conn.close()
