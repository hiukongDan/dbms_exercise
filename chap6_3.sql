6.3.1
a)
SELECT Product.maker
FROM Product
WHERE Product.model IN (
		SELECT PC.model
		FROM PC
		WHERE PC.speed >= 3;
		);

SELECT Product.maker
FROM Product, (
		SELECT PC.model
		FROM PC
		WHERE PC.speed >= 3;
		) B
WHERE Product.model = B.model;

b)
SELECT A.model
FROM Printer A
WHERE A.price >= ALL (
		SELECT B.price
		FROM Printer B
		);
		
c)
SELECT A.model
FROM Laptop A
WHERE A.price =< ALL (
		SELECT B.price
		FROM PC B
		);
		
d)
SELECT A.model
FROM ((SELECT model, price FROM PC) UNION (SELECT model, price FROM Laptop)
	UNION (SELECT model, price FROM Printer)) A
WHERE A.price >= ALL ((SELECT price FROM PC) UNION
			(SELECT price FROM Laptop) UNION
			(SELECT price FROM Printer));

e)
SELECT A.maker
FROM Product A, Printer B
WHERE A.model = B.model AND B.price <= ALL 
	(SELECT price FROM Printer WHERE color='true');
	
f)
SELECT A.maker
FROM Product A, PC B, PC C
WHERE A.model = B.model AND
	B.speed >= ALL (SELECT speed FROM PC) AND
	C.ram <= ALL (SELECT ram FROM PC) AND B.model = C.model;

6.3.2
a)
SELECT A.country
FROM Classes A
WHERE A.numGuns >= ALL (SELECT numGuns FROM Classes);

b)
SELECT Classes.class
FROM Classes, Ships
WHERE Classes.class = Ships.class AND class.name IN(
		SELECT ship
		FROM Outcomes
		WHERE Outcomes.result = 'sunk'
		);
		
c)
SELECT Ships.name
FROM Ships
WHERE Ships.class IN (
		SELECT class
		FROM Classes
		WHERE Classes.bore = 16
		);
		
d)
SELECT Outcomes.battle
FROM Outcomes
WHERE Outcomes.ship IN (
		SELECT name
		FROM Ships
		WHERE Ships.class = 'Kongo'
		);
		
e)
SELECT A.name
FROM Ships A, Classes B
WHERE A.class = B.class AND
		B.numGuns >= ALL (
			SELECT numGuns
			FROM Classes
			WHERE Classes.bore = B.bore
			);
			
6.3.3
SELECT title
FROM Movies Old
WHERE year < ANY
	(SELECT year
	FROM Movies
	WHERE title = Old.title
	);
	
SELECT A.title
FROM Movies A, Movies B
WHERE A.year < B.year AND A.title = B.title;

6.3.4
SELECT L
FROM R1 NATURAL JOIN (
	SELECT *
	FROM R2 NATURAL JOIN (
			SELECT *
			FROM R3 NATURAL JOIN (
					-- and so on..
					)
			)
	);
	
6.3.5
a)
SELECT name, address
FROM MovieStar NATURAL JOIN MovieExec
WHERE gender = 'F' AND netWorth > 10000000;

b)
SELECT A.name, A.address
FROM MovieStar A
WHERE A.address NOT IN (SELECT address FROM MovieExec WHERE MovieExec.name = A.name);

6.3.6
s IN R 			<=> 	s = ANY R
EXISTS R 		<=>		-- it must return a boolean value ???
NOT EXISTS R 	<=>		NULL <> ANY R					  ???

6.3.7
a)
pair each tuple of Studio and MovieExec together

b)
natural join starsin and moviestar plus any unmatched tuple will be filled with NULL in 
the corresponding cells

c)
same with b) but using name and starName as the same attributes in the two relations

6.3.8
(SELECT maker, model, type, Concat(speed, " ", ram, " ", hd, " ", rd, " ", price)
FROM Product NATURAL RIGHT OUTER JOIN PC ON Product.model = PC.model)
UNION
(SELECT maker, model, type, Concat(speed," ",ram," ",hd," ",screen," ",price)
FROM Product NATURAL RIGHT OUTER JOIN Laptop ON Product.model = Laptop.model)
UNION
(SELECT maker, model, Product.type, Concat(color," ",Printer.type," ",price)
FROM Product NATURAL RIGHT OUTER JOIN Printer ON Product.model = Printer.model);

6.3.9
SELECT *
FROM Classes NATURAL RIGHT OUTER JOIN Ships ON Classes.class = Ships.class;

6.3.10
SELECT *
FROM Classes NATURAL FULL OUTER JOIN Ships ON Classes.class = Ships.class;

6.3.11
a) R CROSS JOIN S
SELECT *
FROM R, S;

b) R NATURAL JOIN S;
SELECT *
FROM R, S
WHERE R.x = S.x [AND ...];

c) R JOIN S ON C;, where C is a SQL CONDITION
SELECT *
FROM R, S
WHERE C;