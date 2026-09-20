-- Week 3 Assessment
-- Name: HARISH S

-- =============================================================================
--                                  SECTION A
-- =============================================================================

-- A1. Answer: b 
-- A3. Answer: c 
-- A4. Answer: b
-- A5. Answer: b
-- A6. Answer: b
-- A7. Answer: b
-- A8. Answer: b

-- =============================================================================
--                                  SECTION B
-- =============================================================================

-- B1. 
-- Answer: The query return 25 rows because every book has a valid author_id matching an author in the author table. so, the INNER JOIN return the all 25 books.

-- B2.
-- Answer: The query return 1 row = James Clear.
 --        Because the LEFT JOIN keeps every author. The condition b.book_id IS NULL select authors who do not have a matching book.

-- B3. 
-- Answer: The query return the 3 rows.
--         author                               mentor
--         Preeti Shenoy                        Chetan Bhagat
--         Alex Michaelides                     Yuval Harari
--         Malcolm Gladwell                     Yuval Harari
-- This is a self-join because the author table is joined with itself. only authors whose mentor_id is NOT NULL match the another author.

-- B4.
-- Answer: The query return the 5 rows.
--       1: Chetan Bhagat   
--          Amish Tripathi   
--          Ruskin Bond     
--          Preeti Shenoy     
--          Devdutt Pattanaik
--       2: Amish Tripathi             
--          Devdutt Pattanaik                 
-- UNION combines both result sets and remove duplicate names.so, final result contains 5 rows.

-- B5.
-- Answer: The query return 12.
--         Because the subquery frist calculate the average price of all books and then find which book price is greater than average price.

-- B6.
-- Answer: The query return 15 rows. The subquery checks atleast one matching sale exists. NOT EXISTS keeps only books with no corresponding record in the sales table.

-- B7.
-- Answer: The query return one row.
--        title                            total_qty
--        Atomic Habits                     30

-- B8.
-- Answer: The query return the 4 rows.
-- title                       price                   rank_in_genre
-- Talking to Strangers        549.00                  1                    
-- Outliers                    449.00                  2                            
-- Blink                       399.00                  3                            
-- Rich Dad Poor Dad           299.00                  4
                         
-- =============================================================================
--                                  SECTION B
-- =============================================================================                         

-- C1.  
-- Answer:
SELECT 
	b.title,
    a.name AS author_name
FROM books AS b
INNER JOIN authors AS a ON b.author_id = a.author_id;

-- C2. 
-- Answer:
SELECT
	a.name AS author_name,
    b.title,
    b.genre,
    b.price
FROM authors AS a
LEFT JOIN books AS b
	ON a.author_id = b.author_id;
    
-- C3.  
-- Answer:
SELECT
	b.genre,
    SUM(s.quantity * b.price) AS total_revenue
FROM sales AS s
INNER JOIN books AS b
	ON s.book_id = b.book_id
GROUP BY b.genre
ORDER BY total_revenue DESC;

-- C4. 
-- Answer:
SELECT
	s.city,
    SUM(s.quantity * b.price) AS total_revenue
FROM sales AS s
INNER JOIN books AS b
	ON s.book_id = b.book_id
GROUP BY s.city
ORDER BY total_revenue DESC
LIMIT 1;

-- C5. 
-- Answer:
SELECT
	b.title,
    a.name AS author_name
FROM authors AS a
RIGHT JOIN books AS b
	ON a.author_id = b.author_id;
    
-- Explanation: The result count matches the INNER JOIN count because every book has valid matching author. The RIGHT JOIN also returns all 25 books, with no unmatched book rows.

-- C6.  
-- Answer:
SELECT
	a.author_id,
    a.name AS author_name,
    b.book_id,
    b.title
FROM authors AS a
LEFT JOIN books AS b
	ON a.author_id = b.author_id
UNION
SELECT
	a.author_id,
    a.name AS author_name,
    b.book_id,
    b.title
FROM authors AS a
RIGHT JOIN books AS b
	ON a.author_id = b.author_id;
    
-- C7. 
-- Answer:
SELECT
	a.name AS author,
    m.name AS mentor
FROM authors AS a
INNER JOIN authors AS m
	ON a.mentor_id = m.author_id;
    
-- C8. 
-- Answer:
SELECT
	c.city,
    t.customer_type
FROM (
	SELECT DISTINCT city
    FROM sales
) AS c
CROSS JOIN (
	SELECT DISTINCT customer_type
    FROM sales
) AS t
ORDER BY
	c.city,
    t.customer_type;
    
-- C9. 
-- Answer:
SELECT name FROM authors
WHERE country = 'India'
UNION
SELECT name FROM authors
WHERE born_year > 1970;

-- C10. 
-- Answer:
SELECT 
	b.book_id,
    b.title,
    b.genre
FROM books AS b
LEFT JOIN sales AS s
	ON b.book_id = s.book_id
WHERE s.sale_id IS NULL;

-- C11. 
-- Answer:
SELECT title, price FROM books
WHERE price > (
	SELECT AVG(price)
    FROM books
);

-- C12.
-- Answer:
SELECT * FROM sales
WHERE book_id IN(
	SELECT book_id
	FROM books
    WHERE genre IN ('History', 'Mythology')
);

-- C13.
-- Answer:
SELECT title, price FROM books
WHERE price > ALL (
	SELECT price 
    FROM books
    WHERE genre = 'Function'
);

-- C14.
-- Answer:
SELECT
	b.title,
    b.genre,
    b.price
FROM books AS b
WHERE b.price > (
	SELECT AVG(b2.price)
    FROM books AS b2
    WHERE b2.genre = b.genre
);

-- C15.
-- Answer:
SELECT
	a.author_id,
    a.name
fROM authors AS a
WHERE EXISTS (
	SELECT 1
    FROM books AS b
    WHERE b.author_id = a.author_id
		AND b.published_year > 2018
);

-- C16.
-- Answer:
SELECT
	a.author_id,
    a.name
FROM authors AS a
WHERE NOT EXISTS (
	SELECT 1
    FROM books AS b
    WHERE b.author_id = a.author_id
		AND b.genre = 'Business'
);

-- C17.
-- Answer:
SELECT * FROM sales
WHERE book_id IN (
	SELECT b.book_id FROM books AS b
    INNER JOIN authors AS a
		ON b.author_id = a.author_id
	WHERE a.country = 'India'
);

-- C18.
-- Answer:
SELECT 
	title,
    genre,
    price,
    AVG(price) OVER (
		PARTITION BY genre
	) AS genre_avg_price
FROM books
ORDER BY
	genre,
    title;
    
-- C19.
-- Answer:
WITH ranked_books AS (
	SELECT
		book_id,
        title,
        genre,
        price,
        ROW_NUMBER() OVER (
			PARTITION BY genre
            ORDER BY price DESC, book_id
		) AS row_num
	FROM books
)
SELECT
	book_id,
    title,
    genre,
    price
FROM ranked_books
WHERE row_num <= 2
ORDER BY
	genre,
    price DESC;
    
-- C20.
-- Answer:
SELECT
	sale_id,
    book_id,
    sale_date,
    quantity,
    LAG(quantity) OVER (
		ORDER BY sale_date
	) AS previous_quantity
FROM sales
WHERE book_id = 115
ORDER BY sale_date;

-- C21.
-- Answer:
SELECT
	sale_id,
    sale_date,
    book_id,
    quantity,
    SUM(quantity) OVER (
		ORDER BY sale_date, sale_id
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
	) AS runnung_total_quatity
FROM sales
ORDER BY sale_date, sale_id;

-- C22.
-- Answer:
WITH book_sales AS (
	SELECT 
		book_id,
        SUM(quantity) AS total_quantity
	FROM sales
    GROUP BY book_id
)
SELECT
	b.book_id,
    b.title,
    COALESCE(bs.total_quantity,0) AS total_quantity
FROM books AS b
LEFT JOIN book_sales AS bs
	ON b.book_id = bs.book_id
ORDER BY b.book_id;

-- C23.
-- Answer:
WITH genre_revenue AS (
	SELECT
		b.genre,
        SUM(s.quantity * b.price) AS total_revenue
	FROM sales AS s
    INNER JOIN books AS b
		ON s.book_id = b.book_id
	GROUP BY b.genre
),
ranked_genres AS (
	SELECT
		genre,
        total_revenue,
        RANK() OVER(
			ORDER BY total_revenue DESC
		) AS revenue_rank
	FROM genre_revenue
)
SELECT 
	genre,
    total_revenue,
    revenue_rank
FROM ranked_genres
ORDER BY revenue_rank;

-- C24.
-- Answer:
WITH book_quantity AS(
	SELECT 
		b.book_id,
        b.title,
        b.genre,
        b.author_id,
        COALESCE(SUM(s.quantity),0) AS total_quantity
	FROM books AS b
    LEFT JOIN sales AS s
		ON b.book_id = s.book_id
	GROUP BY
		b.book_id,
        b.title,
        b.genre,
        b.author_id
),
ranked_books AS(
	SELECT
		book_id,
        title,
        genre,
        author_id,
        total_quantity,
        ROW_NUMBER() OVER(
			PARTITION BY genre
            ORDER BY total_quantity DESC, book_id
		) AS book_rank
	FROM book_quantity
),
genre_revenue AS(
	SELECT
		b.genre,
        SUM(s.quantity * b.price) AS genre_total_revenue
	FROM sales AS s
    INNER JOIN books AS b
		ON s.book_id = b.book_id
	GROUP BY b.genre
)
SELECT
	rb.genre,
    rb.title AS top_selling_book,
    a.name AS author_name,
    rb.total_quantity,
    gr.genre_total_revenue
FROM ranked_books AS rb
INNER JOIN authors AS a
	ON rb.author_id = a.author_id
INNER JOIN genre_revenue AS gr
	ON rb.genre = gr.genre
WHERE rb.book_rank = 1
ORDER BY
	gr.genre_total_revenue DESC;
        
