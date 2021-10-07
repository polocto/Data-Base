# Data-Base

## Query 1

```sql
 SELECT
  DISTINCT c.residence
FROM
  orders o
  INNER JOIN customers c ON c.cid = o.cid
WHERE
  YEAR(o.odate) = 2014
  AND c.residence != "NULL";
```

---

## Query 2

```sql
SELECT
  p.origin,
  COUNT(*) AS numberOfProduct,
  MIN(p.price) AS MinPrice,
  MAX(p.price) AS maxPrice,
FROM
  products p
GROUP BY
  p.origin;
```

---

## Query 3

> The customers who ordered in 2014 all the products (at least) that the customers named 'Smith' ordered in 2013

```SQL
SELECT DISTINCT *
FROM customers NATURAL JOIN orders
WHERE YEAR(odate) = 2014 AND pid IN
(
    SELECT DISTINCT pid
    FROM orders NATURAL JOIN customers
    WHERE cname='Smith' AND YEAR(odate) = 2013
) GROUP BY cid
HAVING COUNT(pid) >= (SELECT COUNT(DISTINCT pid) FROM orders NATURAL JOIN customers WHERE cname='Smith' AND YEAR(odate) = 2013)
```

---

## Query 4

> For each customer and each product, the customer's name, the product's name, the total amount ordered by the customer for that product, sorted by customer name (alphabetical order), then by total amount ordered (highest value first), then by product id (ascending order)

```sql
SELECT * FROM customers
NATURAL JOIN orders NATURAL JOIN products
GROUP BY pid, cid
ORDER BY cname, price DESC, pid
```

---

## Query 5

```sql
SELECT
  DISTINCT c.*
FROM
  customers c
  INNER JOIN orders o ON c.cid = o.cid
  INNER JOIN products p ON o.pid = p.pid
WHERE
  p.origin = c.residence
  AND NOT c.cid = ANY(
    SELECT
      DISTINCT c.cid
    FROM
      customers c
      INNER JOIN orders o ON c.cid = o.cid
      INNER JOIN products p ON o.pid = p.pid
    WHERE
      p.origin != c.residence
  );
```

---

## Query 6

```sql
SELECT
  DISTINCT c.*
FROM
  customers c
  INNER JOIN orders o ON c.cid = o.cid
  INNER JOIN products p ON o.pid = p.pid
WHERE
  p.origin != c.residence
  AND NOT c.cid = ANY(
    SELECT
      DISTINCT c.cid
    FROM
      customers c
      INNER JOIN orders o ON c.cid = o.cid
      INNER JOIN products p ON o.pid = p.pid
    WHERE
      p.origin = c.residence
  );
```

---

## Query 7

> The difference between 'USA' residents' per-order average quantity and 'France' residents' (USA - France)

```sql
SELECT (
        SELECT AVG(quantity)
        FROM(
                SELECT quantity
                FROM orders
                NATURAL JOIN customers
                WHERE residence = "USA"
        )q1
)
-
(
        SELECT AVG(quantity)
        FROM(
                SELECT DISTINCT quantity
                FROM orders
                NATURAL JOIN customers
                WHERE residence = 'France'
        )q2
)
```

---

## Query 8

> The products ordered throughout 2014, i.e. ordered each month of that year

```sql
SELECT products.*
FROM products
NATURAL JOIN
(
    SELECT pid, COUNT(DISTINCT MONTH(odate)) as months
    FROM orders
    WHERE YEAR(odate)=2014
    GROUP BY pid
) tabmonths
WHERE
months =12
```

---

## Query 9

```sql
SELECT
  c.*
FROM
  customers c
  INNER JOIN orders o ON c.cid = o.cid
  INNER JOIN products p ON o.pid = p.pid
WHERE
  p.price < 5
group by
  c.cid
having
  count(distinct p.pid) = (
    SELECT
      count(distinct products.pid)
    FROM
      products
    WHERE
      products.price < 5
  );
```

---

## Query 10

```sql
SELECT
  cname1,
  cname2,
  COUNT(tab1.pname) as numberOfProducts
FROM(
    SELECT
      DISTINCT p.pname,
      p.pid,
      c.cname as cname1
    FROM
      customers c NATURAL
      JOIN orders o NATURAL
      JOIN products p
  ) tab1
  INNER JOIN (
    SELECT
      DISTINCT p.pname,
      p.pid,
      c.cname as cname2
    FROM
      customers c NATURAL
      JOIN orders o NATURAL
      JOIN products p
  ) tab2 ON tab1.pid = tab2.pid
  AND tab1.cname1 < tab2.cname2
GROUP BY
  tab1.cname1,
  tab2.cname2
HAVING
  numberOfProducts = (
    SELECT
      MAX(m)
    FROM
      (
        SELECT
          cname1,
          cname2,
          COUNT(tab1.pname) as m
        FROM(
            SELECT
              DISTINCT p.pname,
              p.pid,
              c.cname as cname1
            FROM
              customers c NATURAL
              JOIN orders o NATURAL
              JOIN products p
          ) tab1
          INNER JOIN (
            SELECT
              DISTINCT p.pname,
              p.pid,
              c.cname as cname2
            FROM
              customers c NATURAL
              JOIN orders o NATURAL
              JOIN products p
          ) tab2 ON tab1.pid = tab2.pid
          AND tab1.cname1 < tab2.cname2
        GROUP BY
          tab1.cname1,
          tab2.cname2
      ) q
  );
```

---

## Query 11

```sql
SELECT
  c.*
FROM
  customers c NATURAL
  JOIN orders o NATURAL
  JOIN products p
GROUP BY
  c.cid
HAVING
  SUM(o.quantity) = (
    SELECT
      MAX(m)
    FROM(
        SELECT
          c.*,
          SUM(o.quantity) AS m
        FROM
          customers c NATURAL
          JOIN orders o NATURAL
          JOIN products p
        GROUP BY
          c.cid
      ) q
  );
```

---

## Query 12

```sql
SELECT
  p.*
FROM
  customers c
  INNER JOIN orders o ON c.cid = o.cid
  INNER JOIN products p ON o.pid = p.pid
WHERE
  c.residence = "FRANCE";
```

---

## Query 13

```sql
SELECT
  c.cname
FROM
  customers c
WHERE
  (
    SELECT
      c.residence
    FROM
      customers c
    WHERE
      c.cname = "Smith"
  ) = c.residence
  AND c.cname != "Smith";
```

---

## Query 14

```sql
SELECT
  c.*,
  SUM(p.price * o.quantity)
FROM
  customers c NATURAL
  JOIN orders o NATURAL
  JOIN products p
WHERE
  YEAR(o.odate) = 2014
GROUP BY
  c.cid
HAVING
  SUM(p.price * o.quantity) = (
    SELECT
      MAX(m)
    FROM(
        SELECT
          SUM(p.price * o.quantity) AS m
        FROM
          customers c NATURAL
          JOIN orders o NATURAL
          JOIN products p
        WHERE
          YEAR(o.odate) = 2014
        GROUP BY
          c.cid
      ) q
  );


```

---

## Query 15

```sql
SELECT
  table1.pid,
  table1.pname,
  table1.price,
  table1.origin
FROM
  (
    SELECT
      price * quantity as total,
      products.*
    FROM
      products NATURAL
      JOIN orders
  ) table1
GROUP BY
  pid
HAVING
  AVG(total) = (
    SELECT
      MAX(m)
    FROM
      (
        SELECT
          AVG(total) as m,
          pid,
          pname
        FROM
          (
            SELECT
              price * quantity as total,
              pid,
              pname
            FROM
              products NATURAL
              JOIN orders
          ) table1
        GROUP BY
          pid
      ) q
  );
```

---

## Query 16

```sql
SELECT
  DISTINCT p.*
FROM
  customers c NATURAL
  JOIN orders o NATURAL
  JOIN products p
WHERE
  c.residence = "USA";
```

---

## Query 17

> The pairs of customers who ordered the same product en 2014, and that product. Display 3 columns: cname1, cname2, pname, with cname1 < cname2

```sql
SELECT cname1, cname2, pname

FROM

(
        SELECT cname as cname1, pid, pname
        FROM customers
        NATURAL JOIN orders
        NATURAL JOIN products
        WHERE YEAR(odate)=2014
        ORDER BY cname
        )table1

INNER JOIN

(
        SELECT cname as cname2, pid
        FROM customers
        NATURAL JOIN orders
        NATURAL JOIN products
        WHERE YEAR(odate)=2014
        ORDER BY cname
        )table2

ON table1.pid = table2.pid AND table1.cname1 < table2.cname2

ORDER BY cname1, cname2
```

---

## Query 18

```sql

  SELECT p.* FROM products p WHERE p.price > (SELECT
  DISTINCT p.price
FROM
  customers c NATURAL
  JOIN orders o NATURAL
  JOIN products p
WHERE
  p.origin = "India"
HAVING
  p.price = (
    SELECT
      MAX(m)
    FROM
      (
        SELECT
          p.price AS m
        FROM
          customers c NATURAL
          JOIN orders o NATURAL
          JOIN products p
        WHERE
          p.origin  = "India"
      ) q
  ));

```

---

## Query 19

```sql
SELECT
  p.*
FROM
  customers c NATURAL
  JOIN orders o NATURAL
  JOIN products p
GROUP BY
  p.pid
HAVING
  SUM(o.quantity) = (
    SELECT
      MIN(m)
    FROM(
        SELECT
          p.*,
          SUM(o.quantity) AS m
        FROM
          customers c NATURAL
          JOIN orders o NATURAL
          JOIN products p
        GROUP BY
          p.pid
      ) q
  );
```

---

## Query 20

```sql
SELECT
  *
FROM
  (
    SELECT
      DISTINCT country,
      COUNT(customers.cid) as resident
    FROM
      (
        SELECT
          DISTINCT country
        FROM
          (
            SELECT
              residence as country
            FROM
              customers
          ) residenceCountry
        UNION
          (
            SELECT
              origin as country
            FROM
              products
          )
      ) FULL
      JOIN customers ON country = customers.residence
    GROUP BY
      country
  ) tab1
  LEFT JOIN (
    SELECT
      DISTINCT country,
      COUNT(products.pid) as product
    FROM
      (
        SELECT
          DISTINCT country
        FROM
          (
            SELECT
              residence as country
            FROM
              customers
          ) residenceCountry
        UNION
          (
            SELECT
              origin as country
            FROM
              products
          )
      ) FULL
      JOIN products ON country = origin
    GROUP BY
      country
  ) tab2 USING(country)
UNION
SELECT
  country, resident, product
FROM
  (
    SELECT
      DISTINCT country,
      COUNT(customers.cid) as resident
    FROM
      (
        SELECT
          DISTINCT country
        FROM
          (
            SELECT
              residence as country
            FROM
              customers
          ) residenceCountry
        UNION
          (
            SELECT
              origin as country
            FROM
              products
          )
      ) FULL
      JOIN customers ON country = customers.residence
    GROUP BY
      country
  ) tab1
  RIGHT JOIN (
    SELECT
      DISTINCT country,
      COUNT(products.pid) as product
    FROM
      (
        SELECT
          DISTINCT country
        FROM
          (
            SELECT
              residence as country
            FROM
              customers
          ) residenceCountry
        UNION
          (
            SELECT
              origin as country
            FROM
              products
          )
      ) FULL
      JOIN products ON country = origin
    GROUP BY
      country
  ) tab2 USING(country);
```
