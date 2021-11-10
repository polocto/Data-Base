-- ------------------------------------------------------
-- NOTE: DO NOT REMOVE OR ALTER ANY LINE FROM THIS SCRIPT
-- ------------------------------------------------------
select
  'Query 00' as '';
-- Show execution context
select
  current_date(),
  current_time(),
  user(),
  database();
-- Conform to standard group by constructs
  -- Write the SQL queries that return the information below:
  -- Ecrire les requêtes SQL retournant les informations ci-dessous:
select
  'Query 01' as '';
--! The countries of residence the supplier had to ship products to in 2014
  --! Les pays de résidence où le fournisseur a dû envoyer des produits en 2014
SELECT
  DISTINCT c.residence
FROM
  orders o
  INNER JOIN customers c ON c.cid = o.cid
WHERE
  YEAR(o.odate) = 2014
  AND c.residence != "NULL";
select
  'Query 02' as '';
--! For each known country of origin, its name, the number of products from that country, their lowest price, their highest price
  --! Pour chaque pays d'orgine connu, son nom, le nombre de produits de ce pays, leur plus bas prix, leur plus haut prix
SELECT
  p.origin,
  COUNT(*) AS numberOfProduct,
  MIN(p.price) AS MinPrice,
  MAX(p.price) AS maxPrice
FROM
  products p
GROUP BY
  p.origin;
select
  'Query 03' as '';
--! The customers who ordered in 2014 all the products (at least) that the customers named 'Smith' ordered in 2013
  --! Les clients ayant commandé en 2014 tous les produits (au moins) commandés par les clients nommés 'Smith' en 2013
SELECT
  DISTINCT *
FROM
  customers NATURAL
  JOIN orders
WHERE
  YEAR(odate) = 2014
  AND pid IN (
    SELECT
      DISTINCT pid
    FROM
      orders NATURAL
      JOIN customers
    WHERE
      cname = 'Smith'
      AND YEAR(odate) = 2013
  )
GROUP BY
  cid
HAVING
  COUNT(pid) >= (
    SELECT
      COUNT(DISTINCT pid)
    FROM
      orders NATURAL
      JOIN customers
    WHERE
      cname = 'Smith'
      AND YEAR(odate) = 2013
  );
select
  'Query 04' as '';
--! For each customer and each product, the customer's name, the product's name, the total amount ordered by the customer for that product,
  --! sorted by customer name (alphabetical order), then by total amount ordered (highest value first), then by product id (ascending order)
  --! Par client et par produit, le nom du client, le nom du produit, le montant total de ce produit commandé par le client,
  --! trié par nom de client (ordre alphabétique), puis par montant total commandé (plus grance valeur d'abord), puis par id de produit (croissant)
SELECT
  DISTINCT c.cname,
  p.pname,
  o.quantity * p.price AS price
FROM
  customers AS c NATURAL
  JOIN orders AS o NATURAL
  JOIN products AS p
GROUP BY
  cid,
  pid
ORDER BY
  cname,
  price DESC,
  pid;
select
  'Query 05' as '';
--! The customers who only ordered products originating from their country
  --! Les clients n'ayant commandé que des produits provenant de leur pays
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
select
  'Query 06' as '';
--! The customers who ordered only products originating from foreign countries
  --! Les clients n'ayant commandé que des produits provenant de pays étrangers
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
select
  'Query 07' as '';
--! The difference between 'USA' residents' per-order average quantity and 'France' residents' (USA - France)
  --! La différence entre quantité moyenne par commande des clients résidant aux 'USA' et celle des clients résidant en 'France' (USA - France)
SELECT
  (
    SELECT
      AVG(quantity)
    FROM(
        SELECT
          quantity
        FROM
          orders NATURAL
          JOIN customers
        WHERE
          residence = "USA"
      ) q1
  ) - (
    SELECT
      AVG(quantity)
    FROM(
        SELECT
          DISTINCT quantity
        FROM
          orders NATURAL
          JOIN customers
        WHERE
          residence = 'France'
      ) q2
  );
select
  'Query 08' as '';
--! The products ordered throughout 2014, i.e. ordered each month of that year
  --! Les produits commandés tout au long de 2014, i.e. commandés chaque mois de cette année
SELECT
  products.*
FROM
  products NATURAL
  JOIN (
    SELECT
      pid,
      COUNT(DISTINCT MONTH(odate)) AS months
    FROM
      orders
    WHERE
      YEAR(odate) = 2014
    GROUP BY
      pid
  ) tabmonths
WHERE
  months = 12;
select
  'Query 09' as '';
--! The customers who ordered all the products that cost less than $5
  --! Les clients ayant commandé tous les produits de moins de $5
SELECT
  c.*
FROM
  customers c
  INNER JOIN orders o ON c.cid = o.cid
  INNER JOIN products p ON o.pid = p.pid
WHERE
  p.price < 5
GROUP BY
  c.cid
HAVING
  COUNT(DISTINCT p.pid) = (
    SELECT
      COUNT(DISTINCT products.pid)
    FROM
      products
    WHERE
      products.price < 5
  );
select
  'Query 10' as '';
--! The customers who ordered the greatest number of common products. Display 3 columns: cname1, cname2, number of common products, with cname1 < cname2
  --! Les clients ayant commandé le grand nombre de produits commums. Afficher 3 colonnes : cname1, cname2, nombre de produits communs, avec cname1 < cname2
SELECT
  cname1,
  cname2,
  COUNT(tab1.pid) AS numberOfProducts
FROM(
    SELECT
      DISTINCT o.pid,
      c.cname AS cname1
    FROM
      customers c NATURAL
      JOIN orders o
  ) tab1
  INNER JOIN (
    SELECT
      DISTINCT o.pid,
      c.cname AS cname2
    FROM
      customers c NATURAL
      JOIN orders o
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
          COUNT(tab1.pid) AS m
        FROM(
            SELECT
              DISTINCT o.pid,
              c.cname AS cname1
            FROM
              customers c NATURAL
              JOIN orders o
          ) tab1
          INNER JOIN (
            SELECT
              DISTINCT o.pid,
              c.cname AS cname2
            FROM
              customers c NATURAL
              JOIN orders o
          ) tab2 ON tab1.pid = tab2.pid
          AND tab1.cname1 < tab2.cname2
        GROUP BY
          tab1.cname1,
          tab2.cname2
      ) q
  );
select
  'Query 11' as '';
--! The customers who ordered the largest number of products
  --! Les clients ayant commandé le plus grand nombre de produits
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
select
  'Query 12' as '';
--! The products ordered by all the customers living in 'France'
  --! Les produits commandés par tous les clients vivant en 'France'
SELECT
  DISTINCT p.*
FROM
  customers c
  INNER JOIN orders o ON c.cid = o.cid
  INNER JOIN products p ON o.pid = p.pid
WHERE
  c.residence = "FRANCE";
select
  'Query 13' as '';
--! The customers who live in the same country customers named 'Smith' live in (customers 'Smith' not shown in the result)
  --! Les clients résidant dans les mêmes pays que les clients nommés 'Smith' (en excluant les Smith de la liste affichée)
SELECT
  c.cname
FROM
  customers c
WHERE
  c.residence IN (
    SELECT
      c.residence
    FROM
      customers c
    WHERE
      c.cname = "Smith"
  )
  AND c.cname != "Smith";
select
  'Query 14' as '';
--! The customers who ordered the largest total amount in 2014
  --! Les clients ayant commandé pour le plus grand montant total sur 2014
SELECT
  c.*
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
select
  'Query 15' as '';
--! The products with the largest per-order average amount
  --! Les produits dont le montant moyen par commande est le plus élevé
SELECT
  table1.pid,
  table1.pname,
  table1.price,
  table1.origin
FROM
  (
    SELECT
      price * quantity AS total,
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
          AVG(total) AS m,
          pid,
          pname
        FROM
          (
            SELECT
              price * quantity AS total,
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
select
  'Query 16' as '';
--! The products ordered by the customers living in 'USA'
  --! Les produits commandés par les clients résidant aux 'USA'
SELECT
  DISTINCT p.*
FROM
  customers c NATURAL
  JOIN orders o NATURAL
  JOIN products p
WHERE
  c.residence = "USA";
select
  'Query 17' as '';
--! The pairs of customers who ordered the same product en 2014, and that product. Display 3 columns: cname1, cname2, pname, with cname1 < cname2
  --! Les paires de client ayant commandé le même produit en 2014, et ce produit. Afficher 3 colonnes : cname1, cname2, pname, avec cname1 < cname2
SELECT
  cname1,
  cname2,
  pname
FROM
  (
    SELECT
      DISTINCT cname AS cname1,
      pid,
      pname
    FROM
      customers NATURAL
      JOIN orders NATURAL
      JOIN products
    WHERE
      YEAR(odate) = 2014
  ) table1
  INNER JOIN (
    SELECT
      DISTINCT cname AS cname2,
      pid
    FROM
      customers NATURAL
      JOIN orders NATURAL
      JOIN products
    WHERE
      YEAR(odate) = 2014
  ) table2 ON table1.pid = table2.pid
  AND table1.cname1 < table2.cname2;
select
  'Query 18' as '';
--! The products whose price is greater than all products from 'India'
  --! Les produits plus chers que tous les produits d'origine 'India'
SELECT
  p.*
FROM
  products p
WHERE
  p.price > (
    SELECT
      MAX(p.price)
    FROM
      customers c NATURAL
      JOIN orders o NATURAL
      JOIN products p
    WHERE
      p.origin = "India"
  );
select
  'Query 19' as '';
--! The products ordered by the smallest number of customers (products never ordered are excluded)
  --! Les produits commandés par le plus petit nombre de clients (les produits jamais commandés sont exclus)
SELECT
  p.*
FROM
  customers c NATURAL
  JOIN orders o NATURAL
  JOIN products p
GROUP BY
  p.pid
HAVING
  COUNT(DISTINCT cid) = (
    SELECT
      MIN(m)
    FROM(
        SELECT
          COUNT(DISTINCT cid) AS m
        FROM
          customers c NATURAL
          JOIN orders o NATURAL
          JOIN products p
        GROUP BY
          p.pid
      ) q
  );
select
  'Query 20' as '';
--! For all countries listed in tables products or customers, including unknown countries: the name of the country, the number of customers living in this country, the number of products originating from that country
  --! Pour chaque pays listé dans les tables products ou customers, y compris les pays inconnus : le nom du pays, le nombre de clients résidant dans ce pays, le nombre de produits provenant de ce pays
SELECT
  country,
  MAX(numberCID) AS "Number of resident",
  MAX(numberPID) AS "Number of product"
FROM
  (
    (
      SELECT
        origin AS country,
        0 AS numberCID,
        COUNT(DISTINCT pid) AS numberPID
      FROM
        products
      GROUP BY
        origin
    )
    UNION
      (
        SELECT
          residence,
          COUNT(DISTINCT cid),
          0
        FROM
          customers
        GROUP BY
          residence
      )
  ) t
GROUP BY
  country;