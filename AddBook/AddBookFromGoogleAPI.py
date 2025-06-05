import requests
import pyodbc
import re
import time


DB_CONFIG = {
    'server': 'AMIALI_GHADIRI\\AAMONEY',
    'database': 'BookWormDB',
    'trusted_connection': 'yes'
}


SEARCH_QUERIES = [
    "تاریخ", "رمان", "فلسفه", "شعر", "ایران", "علم", "روانشناسی", "هنر", "معماری",
    "اقتصاد", "مدیریت", "کامپیوتر", "سعدی", "حافظ", "مولوی", "فردوسی", "داستان کوتاه",
    "کودک و نوجوان", "سیاست", "حقوق", "پزشکی", "نجوم", "فیزیک", "شیمی", "جامعه شناسی",
    "تهران", "اصفهان", "شیراز", "عرفان", "اساطیر", "کوروش", "هخامنشیان", "صفویه",
    "قاجار", "انقلاب مشروطه", "جنگ جهانی", "سینما", "موسیقی", "نقاشی", "عکاسی",
    "ورزش", "آشپزی", "سفرنامه", "طبیعت", "محیط زیست", "گلستان", "بوستان", "شاهنامه",
    "مثنوی معنوی", "رباعیات خیام"
]


def get_db_connection():
    try:
        conn_str = (
            f"DRIVER={{ODBC Driver 17 for SQL Server}};"
            f"SERVER={DB_CONFIG['server']};"
            f"DATABASE={DB_CONFIG['database']};"
            "Trusted_Connection=yes;"
        )
        conn = pyodbc.connect(conn_str)
        print("Successfully connected to the database.")
        return conn
    except Exception as e:
        print(f"Error connecting to database: {e}")
        return None


def get_or_create_author(cursor, author_name):
    if not author_name: return None
    parts = author_name.split()
    first_name = " ".join(parts[:-1]) if len(parts) > 1 else ''
    last_name = parts[-1] if parts else ''
    cursor.execute("SELECT AuthorID FROM Book.Author WHERE FirstName = ? AND Lastname = ?", (first_name, last_name))
    row = cursor.fetchone()
    if row: return row.AuthorID
    try:
        cursor.execute("INSERT INTO Book.Author (FirstName, Lastname) VALUES (?, ?); SELECT SCOPE_IDENTITY();",
                       (first_name, last_name))
        author_id = cursor.fetchone()[0]
        print(f"  -> Created new author: '{author_name}' with ID: {author_id}")
        return author_id
    except Exception as e:
        print(f"  -> Error creating author '{author_name}': {e}")
        return None


def get_or_create_publisher(cursor, publisher_name):
    if not publisher_name: return None
    cursor.execute("SELECT PublisherID FROM Book.Publisher WHERE Title = ?", (publisher_name,))
    row = cursor.fetchone()
    if row: return row.PublisherID
    try:
        cursor.execute("INSERT INTO Book.Publisher (Title) VALUES (?); SELECT SCOPE_IDENTITY();", (publisher_name,))
        publisher_id = cursor.fetchone()[0]
        print(f"  -> Created new publisher: '{publisher_name}' with ID: {publisher_id}")
        return publisher_id
    except Exception as e:
        print(f"  -> Error creating publisher '{publisher_name}': {e}")
        return None


def get_or_create_language(cursor, lang_code):
    if not lang_code: return None
    cursor.execute("SELECT LanguageID FROM Book.Language WHERE ISOCode = ?", (lang_code,))
    row = cursor.fetchone()
    if row: return row.LanguageID
    try:
        cursor.execute("INSERT INTO Book.Language (Title, ISOCode) VALUES (?, ?); SELECT SCOPE_IDENTITY();",
                       (lang_code, lang_code))
        lang_id = cursor.fetchone()[0]
        print(f"  -> Created new language: '{lang_code}' with ID: {lang_id}")
        return lang_id
    except Exception as e:
        print(f"  -> Error creating language '{lang_code}': {e}")
        return None


def get_or_create_genre(cursor, genre_name):
    if not genre_name: return None
    cursor.execute("SELECT GenreID FROM Book.Genre WHERE Title = ?", (genre_name,))
    row = cursor.fetchone()
    if row: return row.GenreID
    try:
        cursor.execute("INSERT INTO Book.Genre (Title) VALUES (?); SELECT SCOPE_IDENTITY();", (genre_name,))
        genre_id = cursor.fetchone()[0]
        print(f"  -> Created new genre: '{genre_name}' with ID: {genre_id}")
        return genre_id
    except pyodbc.IntegrityError:
        cursor.execute("SELECT GenreID FROM Book.Genre WHERE Title = ?", (genre_name,))
        row = cursor.fetchone()
        if row: return row.GenreID
    except Exception as e:
        print(f"  -> Error creating genre '{genre_name}': {e}")
        return None


def process_and_insert_books(cursor, books_data):
    book_counter = 0
    for i, item in enumerate(books_data.get('items', [])):
        volume_info = item.get('volumeInfo', {})
        title = volume_info.get('title')
        if not title: continue

        print(f"\nProcessing book: {title}")
        isbn = None
        for identifier in volume_info.get('industryIdentifiers', []):
            if identifier.get('type') == 'ISBN_13':
                isbn = identifier.get('identifier')
                break
            elif identifier.get('type') == 'ISBN_10':
                isbn = identifier.get('identifier')

        if isbn:
            cursor.execute("SELECT BookID FROM Book.Book WHERE ISBN = ?", (isbn,))
            if cursor.fetchone():
                print(f"  -> Book with ISBN {isbn} already exists. Skipping.")
                continue

        author_id = get_or_create_author(cursor, volume_info.get('authors', [None])[0])
        publisher_id = get_or_create_publisher(cursor, volume_info.get('publisher'))
        language_id = get_or_create_language(cursor, volume_info.get('language'))
        genre_ids = [get_or_create_genre(cursor, genre_name) for genre_name in volume_info.get('categories', [])[:3] if
                     genre_name]

        published_year = None
        published_date = volume_info.get('publishedDate')
        if published_date:
            match = re.search(r'\d{4}', published_date)
            if match: published_year = int(match.group(0))

        try:
            sql_insert = """
                         INSERT INTO Book.Book (Title, AuthorID, PublisherID, GenreID1, GenreID2, GenreID3,
                                                Description, PublishedYear, LanguageID, PageCount, ISBN)
                         VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
                         """
            params = (title, author_id, publisher_id,
                      genre_ids[0] if len(genre_ids) > 0 else None,
                      genre_ids[1] if len(genre_ids) > 1 else None,
                      genre_ids[2] if len(genre_ids) > 2 else None,
                      volume_info.get('description'), published_year,
                      language_id, volume_info.get('pageCount'), isbn)
            cursor.execute(sql_insert, params)
            print(f"Successfully inserted book: '{title}'")
            book_counter += 1
        except Exception as e:
            print(f"ERROR inserting book '{title}': {e}")
    return book_counter


def main():
    conn = get_db_connection()
    if not conn:
        return

    total_inserted_books = 0
    cursor = conn.cursor()

    try:
        for query in SEARCH_QUERIES:
            print(f"\n{'=' * 50}\n🔎 Searching for keyword: '{query}'\n{'=' * 50}")

            api_params = {'q': query, 'startIndex': 0, 'maxResults': 20}

            try:
                response = requests.get("https://www.googleapis.com/books/v1/volumes", params=api_params)
                response.raise_for_status()
                books_data = response.json()
                print(f"API call successful. Found {len(books_data.get('items', []))} items for this keyword.")

                inserted_count = process_and_insert_books(cursor, books_data)
                total_inserted_books += inserted_count

                conn.commit()
                print(f"✔️ Batch for '{query}' committed. Inserted {inserted_count} new books.")

            except requests.exceptions.RequestException as e:
                print(f"Error calling Google Books API for query '{query}': {e}")

            print("----------------------------------------------------")
            print("Waiting for 1 second before next request...")
            time.sleep(1)

        print(f"\n\nProcess finished! Total new books inserted across all keywords: {total_inserted_books}")

    except Exception as e:
        print(f"\nAn critical error occurred during database operations. Rolling back changes. Error: {e}")
        conn.rollback()
    finally:
        cursor.close()
        conn.close()
        print("Database connection closed.")


if __name__ == '__main__':
    main()