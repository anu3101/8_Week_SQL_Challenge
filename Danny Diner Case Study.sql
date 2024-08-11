CREATE TABLE sales (
  "customer_id" VARCHAR(1),
  "order_date" DATE,
  "product_id" INTEGER
);

INSERT INTO sales
  ("customer_id", "order_date", "product_id")
VALUES
  ('A', '2021-01-01', '1'),
  ('A', '2021-01-01', '2'),
  ('A', '2021-01-07', '2'),
  ('A', '2021-01-10', '3'),
  ('A', '2021-01-11', '3'),
  ('A', '2021-01-11', '3'),
  ('B', '2021-01-01', '2'),
  ('B', '2021-01-02', '2'),
  ('B', '2021-01-04', '1'),
  ('B', '2021-01-11', '1'),
  ('B', '2021-01-16', '3'),
  ('B', '2021-02-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-07', '3');
 

CREATE TABLE menu (
  "product_id" INTEGER,
  "product_name" VARCHAR(5),
  "price" INTEGER
);

INSERT INTO menu
  ("product_id", "product_name", "price")
VALUES
  ('1', 'sushi', '10'),
  ('2', 'curry', '15'),
  ('3', 'ramen', '12');
  

CREATE TABLE members (
  "customer_id" VARCHAR(1),
  "join_date" DATE
);

INSERT INTO members
  ("customer_id", "join_date")
VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09');


--What is the total amount each customer spent at the restaurant?

SELECT s.customer_id, SUM(m.price) AS total_spent
FROM sales s
JOIN menu m ON s.product_id = m.product_id
GROUP BY s.customer_id
ORDER BY s.customer_id;


--How many days has each customer visited the restaurant?

SELECT customer_id, COUNT(DISTINCT order_date) AS visit_days
FROM sales
GROUP BY customer_id
ORDER BY customer_id;
	
--What was the first item from the menu purchased by each customer?

SELECT DISTINCT s.customer_id, s.order_date AS first_visit, m.product_name
FROM sales s
JOIN menu m ON s.product_id = m.product_id
WHERE (s.customer_id, s.order_date) IN (
    SELECT customer_id, MIN(order_date)
    FROM sales
    GROUP BY customer_id
)
ORDER BY s.customer_id;

--What is the most purchased item on the menu and how many times was it purchased by all customers?

SELECT m.product_name, COUNT(s.product_id) AS purchase_count
FROM sales s
JOIN menu m ON s.product_id = m.product_id
GROUP BY m.product_name
ORDER BY purchase_count DESC
LIMIT 1;

--Which item was the most popular for each customer?

SELECT s.customer_id, m.product_name, COUNT(s.product_id) AS purchase_count
FROM sales s
JOIN menu m ON s.product_id = m.product_id
GROUP BY s.customer_id, m.product_name
ORDER BY s.customer_id, purchase_count DESC;

--Which item was purchased first by the customer after they became a member?

SELECT s.customer_id, MAX(s.order_date) AS last_purchase_before_join, m.product_name
FROM sales s
JOIN members mem ON s.customer_id = mem.customer_id
JOIN menu m ON s.product_id = m.product_id
WHERE s.order_date < mem.join_date
GROUP BY s.customer_id, m.product_name
HAVING MAX(s.order_date) = s.order_date
ORDER BY s.customer_id;

