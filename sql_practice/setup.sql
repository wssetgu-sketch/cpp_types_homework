-- === ЧАСТЬ 0: БАЗОВАЯ СТРУКТУРА ===

DROP TABLE IF EXISTS book_genres;
DROP TABLE IF EXISTS library_staff;
DROP TABLE IF EXISTS books;
DROP TABLE IF EXISTS authors;
DROP TABLE IF EXISTS publishers;
DROP TABLE IF EXISTS genres;
DROP TABLE IF EXISTS readers;
DROP TABLE IF EXISTS book_loans;

-- Таблица авторов
CREATE TABLE authors (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    full_name VARCHAR(100) NOT NULL,
    country VARCHAR(50)
);

-- Таблица издательств
CREATE TABLE publishers (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(100) NOT NULL,
    city VARCHAR(50),
    founded_year INTEGER
);

-- Таблица книг (сразу с publisher_id)
CREATE TABLE books (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title VARCHAR(100) NOT NULL,
    author_id INTEGER,
    publisher_id INTEGER,
    FOREIGN KEY (author_id) REFERENCES authors(id),
    FOREIGN KEY (publisher_id) REFERENCES publishers(id)
);

-- Таблица жанров
CREATE TABLE genres (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT
);

-- Промежуточная таблица книги-жанры
CREATE TABLE book_genres (
    book_id INTEGER,
    genre_id INTEGER,
    PRIMARY KEY (book_id, genre_id),
    FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE,
    FOREIGN KEY (genre_id) REFERENCES genres(id) ON DELETE CASCADE
);

-- Таблица сотрудников
CREATE TABLE library_staff (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    position VARCHAR(50),
    manager_id INTEGER,
    FOREIGN KEY (manager_id) REFERENCES library_staff(id)
);

-- Таблицы для доп. заданий
CREATE TABLE readers (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(100)
);

CREATE TABLE book_loans (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    book_id INTEGER,
    reader_id INTEGER,
    loan_date DATE
);

-- === ЧАСТЬ 1: ЗАПОЛНЕНИЕ ДАННЫМИ ===

-- Авторы
INSERT INTO authors (full_name, country) VALUES 
('Лев Толстой', 'Россия'),
('Федор Достоевский', 'Россия'),
('Джордж Оруэлл', 'Великобритания'),
('Агата Кристи', 'Великобритания'),
('Джоан Роулинг', 'Великобритания');

-- Издательства
INSERT INTO publishers (name, city, founded_year) VALUES
('Эксмо', 'Москва', 1991),
('АСТ', 'Москва', 1990),
('Росмэн', 'Москва', 1992),
('Просвещение', 'Москва', 1930);

-- Книги (связываем с авторами и издательствами)
INSERT INTO books (id, title, author_id, publisher_id) VALUES 
(1, 'Война и мир', 1, 1),
(2, 'Анна Каренина', 1, 1),
(3, 'Преступление и наказание', 2, 1),
(4, 'Братья Карамазовы', 2, 1),
(5, 'Гарри Поттер', 5, 2),
(6, '1984', 3, 2),
(7, 'Убийство в Восточном экспрессе', 4, 3),
(8, 'Скотный двор', 3, 4);

-- Жанры
INSERT INTO genres (name, description) VALUES
('Роман', 'Большое повествовательное произведение'),
('Детектив', 'Произведение о расследовании преступлений'),
('Фантастика', 'Произведения о вымышленных мирах и технологиях'),
('Классика', 'Произведения, признанные классическими'),
('Приключения', 'Произведения о путешествиях и приключениях'),
('Драма', 'Произведения с серьезным сюжетом');

-- Связи книги-жанры
INSERT INTO book_genres (book_id, genre_id) VALUES
(1, 1), (1, 4), -- Война и мир
(2, 1), (2, 4), -- Анна Каренина
(3, 1), (3, 4), -- Преступление и наказание
(4, 1), (4, 4), -- Братья Карамазовы
(5, 3), (5, 5), -- Гарри Поттер
(6, 3), (6, 1), -- 1984
(7, 2),         -- Восточный экспресс
(8, 3), (8, 1); -- Скотный двор

-- Сотрудники
INSERT INTO library_staff (first_name, last_name, position, manager_id) VALUES
('Ольга', 'Иванова', 'Директор', NULL),
('Сергей', 'Петров', 'Заведующий отделом', 1),
('Анна', 'Сидорова', 'Библиотекарь', 2),
('Дмитрий', 'Козлов', 'Библиотекарь', 2),
('Екатерина', 'Николаева', 'Администратор', 1);

-- Читатели и выдача
INSERT INTO readers (name) VALUES ('Иван Иванов'), ('Петр Петров');
INSERT INTO book_loans (book_id, reader_id, loan_date) VALUES (1, 1, '2023-01-01'), (6, 2, '2023-02-01');