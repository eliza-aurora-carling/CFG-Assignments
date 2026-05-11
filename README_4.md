# Daunt Books library API

A borrowing system for Daunt Books bookshop, 84 Marylebone High Street, London.

## Scenario
Members can browse the curated collection, borrow books, and check shelf availability by genre. This simulates the real experience at the real bookshop in Marylebone.

## requirements
pip install flask requests

## Setup
1. Open `daunt_books_api.py` in Google Colab or any Python environment
2. Run the file - it creates the SQLite database automatically
3. The Flask server starts on port 5000
4. The simulation runs automatically showing a full customer journey

## API Endpoints
| Method | Endpoint | Description |
|--------|----------|----------------|
| GET | /books | List all books with availability |
| POST | /borrow | Borrow a book (body: book_id, borrower_name) |
| GET | /available?genre=Fiction | Available books, optional genre filter |

## Files
- daunt_books_api.py - Main application with API and client simulation
- config.py - Database configuration
- db_utils.py - Database utility functions with error handling
- daunt_books.db - SQLite database (auto-created)
