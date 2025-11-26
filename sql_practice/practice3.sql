-- 1.1. Найти все книги и их жанры
SELECT b.title,
       g.name AS genre
FROM books b
JOIN book_genres bg ON b.id = bg.book_id
JOIN genres g ON bg.genre_id = g.id
ORDER BY b.title, g.name;

-- 1.2. Найти книги, которые относятся к нескольким жанрам
SELECT b.title,
       COUNT(bg.genre_id) AS genre_count
FROM books b
JOIN book_genres bg ON b.id = bg.book_id
GROUP BY b.id, b.title
HAVING COUNT(bg.genre_id) > 1;

-- 1.3. Найти все детективы и их авторов
SELECT b.title,
       a.full_name AS author
FROM books b
JOIN book_genres bg ON b.id = bg.book_id
JOIN genres g ON bg.genre_id = g.id
JOIN authors a ON b.author_id = a.id
WHERE g.name = 'Детектив';

-- 2.1. Книги с указанием издательства
SELECT b.title,
       p.name AS publisher,
       p.city
FROM books b
JOIN publishers p ON b.publisher_id = p.id;

-- 2.2. Количество книг по издательствам
SELECT p.name AS publisher,
       COUNT(b.id) AS book_count
FROM publishers p
LEFT JOIN books b ON p.id = b.publisher_id
GROUP BY p.id, p.name
ORDER BY book_count DESC;

-- 2.3. Издательства, выпустившие книги российских авторов
SELECT DISTINCT p.name
FROM publishers p
JOIN books b ON p.id = b.publisher_id
JOIN authors a ON b.author_id = a.id
WHERE a.country = 'Россия';

-- 3.1. Сотрудники и их менеджеры (самоссылка)
SELECT 
    s.first_name || ' ' || s.last_name AS employee_name,
    s.position AS employee_position,
    m.first_name || ' ' || m.last_name AS manager_name
FROM library_staff s
LEFT JOIN library_staff m ON s.manager_id = m.id
ORDER BY s.last_name;

-- 3.2. Сотрудники, у которых есть подчинённые
SELECT DISTINCT
       m.first_name || ' ' || m.last_name AS manager,
       m.position
FROM library_staff m
JOIN library_staff s ON s.manager_id = m.id;

-- 3.3. Сотрудники без начальника (верхний уровень)
SELECT first_name || ' ' || last_name AS employee,
       position
FROM library_staff
WHERE manager_id IS NULL;

-- 4.1. Найти книги, которые были выданы хотя бы раз (используя IN)
SELECT b.title
FROM books b
WHERE b.id IN (
    SELECT DISTINCT book_id
    FROM book_loans
);

-- 4.2. Найти книги, которые были выданы хотя бы раз (используя EXISTS)
SELECT b.title
FROM books b
WHERE EXISTS (
    SELECT 1
    FROM book_loans bl
    WHERE bl.book_id = b.id
);

-- 4.3. Найти авторов, чьи книги были выданы
SELECT DISTINCT a.full_name
FROM authors a
JOIN books b ON a.id = b.author_id
WHERE b.id IN (
    SELECT book_id
    FROM book_loans
);

-- 5.1. Найти авторов, которые писали и Романы, и Фантастику (INTERSECT)
SELECT a.full_name
FROM authors a
JOIN books b ON a.id = b.author_id
JOIN book_genres bg ON b.id = bg.book_id
JOIN genres g ON bg.genre_id = g.id
WHERE g.name = 'Роман'

INTERSECT

SELECT a.full_name
FROM authors a
JOIN books b ON a.id = b.author_id
JOIN book_genres bg ON b.id = bg.book_id
JOIN genres g ON bg.genre_id = g.id
WHERE g.name = 'Фантастика';

-- 5.2. Все уникальные должности сотрудников и позиция читателя (UNION)
SELECT DISTINCT position AS role
FROM library_staff

UNION

SELECT 'Читатель' AS role;

-- 6. Рекурсивный запрос для построения полной иерархии сотрудников
WITH RECURSIVE staff_hierarchy AS (
    -- базовый уровень: директор (у кого нет менеджера)
    SELECT id, first_name, last_name, position, manager_id, 0 AS level
    FROM library_staff
    WHERE manager_id IS NULL

    UNION ALL

    -- подчинённые
    SELECT s.id,
           s.first_name,
           s.last_name,
           s.position,
           s.manager_id,
           sh.level + 1
    FROM library_staff s
    JOIN staff_hierarchy sh ON s.manager_id = sh.id
)
SELECT 
    printf('%.*s%s', level * 4, ' ', first_name || ' ' || last_name) AS employee,
    position,
    level
FROM staff_hierarchy
ORDER BY level, last_name;

