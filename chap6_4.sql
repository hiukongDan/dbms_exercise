6.4.1
a)
SELECT DISTINCT model
FROM PC
WHERE speed >= 3;

b)
SELECT DISTINCT Product.model
FROM Product, Laptop
WHERE Product.model = Laptop.model AND Laptop.hd >= 100;

c)
SELECT DISTINCT A.model, A.price
FROM ((SELECT model, price FROM PC) UNION (SELECT model, price FROM Laptop)
		UNION (SELECT model, price FROM Printer)) A
WHERE A.model IN (
		SELECT model
		FROM Product
		GROUP BY maker
		HAVING maker = 'B'
		);

d)
SELECT model
FROM Printer
GROUP BY color
HAVING color = True AND type = 'Laser';

e)
(SELECT DISTINCT Product.maker
FROM Product NATURAL JOIN Laptop ON model)
EXCEPT
(SELECT DISTINCT Product.maker
FROM Product NATURAL JOIN PC ON model);

f)
SELECT DISTINCT A.hd
FROM PC A, PC B
WHERE A.hd = B.hd AND A.model <> B.model;

g)
SELECT distinct A.model, B.model
FROM PC A, PC B
WHERE A.model < B.model AND A.speed = B.speed AND A.ram = B.ram;

h)
SELECT A.maker
FROM Product NATURAL JOIN (SELECT model, price FROM PC UNION SELECT model, price FROM Laptop) A
WHERE A.speed >= 2.8
GROUP BY A.maker
HAVING COUNT(A.model) >= 2;

i)
SELECT DISTINCT B.maker
FROM Product NATURAL JOIN (SELECT model, speed FROM PC 
				UNION SELECT model, price FROM Laptop) B
WHERE B.speed = (SELECT MAX(A.speed) 
				FROM Product NATURAL JOIN (SELECT model, speed FROM PC 
							UNION SELECT model, price FROM Laptop) A);
							
j)
SELECT DISTINCT A.maker
FROM (Product NATURAL JOIN PC) A
GROUP BY A.maker
HAVING COUNT(DISTINCT A.speed) >= 3;

k)
SELECT DISTINCT A.maker
FROM (Product NATURAL JOIN PC) A
GROUP BY A.maker
HAVING COUNT(DISTINCT A.model) = 3;

6.4.2
a)
SELECT DISTINCT Classes.class, Classes.country
FROM Classes
WHERE Classes.bore >= 16;

b)
SELECT DISTINCT name
FROM Ships
WHERE Ships.launched < 1921;

c)
SELECT DISTINCT ship
FROM Outcomes
WHERE Outcomes.result = 'sunk' AND Outcomes.battle = 'denmark Strait';

d)
SELECT DISTINCT class
FROM Classes
WHERE displacement > 35000;

e)
SELECT DISTINCT A.name, A.displacement, A.numGuns
FROM (Classes NATURAL OUTER FULL JOIN Ships ON class) A
WHERE A.name IN (SELECT ship FROM Outcomes WHERE Outcomes.battle = 'Guadalcanal');

f)
SELECT DISTINCT A.class
FROM Classes A
WHERE A.class IN ((SELECT name FROM Ships) UNION (SELECT ship FROM Outcomes));

g)
SELECT class
FROM Ships
GROUP BY class
HAVING COUNT(DISTINCT Ships.name) = 1;

h)
SELECT A.country
FROM Classes A
GROUP BY country
HAVING COUNT(DISTINCT A.type) = 2;

i)
SELECT DISTINCT A.ship
FROM (Ships NATURAL JOIN Battles ON Ships.battle = Battles.name) AS A, 
	 (Ships NATURAL JOIN Battles ON Ships.battle = Battles.name) AS B
WHERE A.ship = B.ship AND A.result = 'damaged' AND A.date < B.date;

6.4.3
a)
SELECT DISTINCT A.maker
FROM (PC NATURAL JOIN Product ON PC.model = Product.model) AS A
GROUP BY A.maker
HAVING MAX(A.speed) >= 3;

b)
SELECT DISTINCT model
FROM Printer
WHERE Printer.price = (SELECT MAX(price) FROM Printer); 

c)
SELECT DISTINCT Laptop.model
FROM Laptop
WHERE Laptop.speed < ALL (SELECT speed FROM PC);

d)
SELECT DISTINCT A.model
FROM ((SELECT model, price FROM PC) UNION (SELECT model, price FROM Laptop) UNION 
	(SELECT model, price FROM Printer)) AS A
WHERE A.price = (SELECT MAX(price) FROM ((SELECT MAX(price) FROM PC) UNION 
				(SELECT MAX(price) FROM Laptop) UNION (SELECT MAX(price) FROM Printer)));

e)
SELECT DISTINCT A.maker
FROM (Maker NATURAL JOIN Printer ON Maker.model = Printer.model) AS A
WHERE A.color = True AND A.price = (SELECT MAX(price) FROM Printer WHERE color = True);

f)
SELECT DISTINCT A.maker
FROM (Product NATURAL JOIN PC ON Product.model = PC.model) AS A
WHERE A.model IN
(SELECT DISTINCT model
FROM PC
WHERE PC.ram = (SELECT MIN(ram) FROM PC))
AND A.speed >= ALL
(SELECT DISTINCT speed
FROM PC
WHERE PC.ram = (SELECT MIN(ram) FROM PC));

6.4.4
a)
SELECT DISTINCT Classes.country
FROM Classes
WHERE Classes.numGuns = (SELECT MAX(numGuns) FROM Classes);

b)
SELECT DISTINCT A.class
FROM (Classes NATURAL JOIN Ships ON Classes.class = Ships.class) AS A
WHERE A.name IN (SELECT ship FROM Outcomes WHERE result = 'sunk');

c)
SELECT DISTINCT Ships.name
FROM Ships, Classes
WHERE Ships.class = Classes.class AND Classes.bore = 16;

d)
SELECT DISTINCT Outcomes.battle
FROM Outcomes, (Ships NATURAL JOIN Classes ON Ships.class = Classes.class) AS A
WHERE A.class = 'Kongo' AND A.ship = Outcomes.ship;

e)
SELECT A.class, MAX(A.numGuns)
FROM Classes AS A
GROUP BY A.bore;

6.4.5
it indeed may produce duplications, where subquery 
may returns more items contianing 'Harrison Ford';

6.4.6
a)
SELECT AVG(speed)
FROM PC;

b)
SELECT AVG(A.speed)
FROM (SELECT speed FROM Laptop WHERE price > 1000) AS A;

c)
SELECT AVG(A.price)
FROM (SELECT * FROM Product NATURAL JOIN PC ON Product.model = PC.model 
	WHERE maker='A') AS A;
	
d)
SELECT AVG(A.price)
FROM ((SELECT model, price FROM Product NATURAL JOIN PC ON Product.model = PC.model
	WHERE maker = 'D') UNION (SELECT model, price FROM Product NATURAL JOIN Laptop
	ON Product.model = Laptop.model WHERE maker = 'D')) AS A;
	
e)
SELECT speed, AVG(price)
FROM PC
GROUP BY speed;

f)
SELECT maker, AVG(screen)
FROM Product NATURAL JOIN Laptop
GROUP BY maker;

g)
SELECT maker
FROM Product NATURAL JOIN PC
GROUP BY maker
HAVING COUNT(DISTINCT model) >= 3;

h)
SELECT maker, MAX(price)
FROM Product NATURAL JOIN PC
GROUP BY maker;

i)
SELECT speed, AVG(price)
FROM PC
GROUP BY speed
HAVING speed > 2;

j)
SELECT maker, AVG(hd)
FROM Product NATURAL JOIN PC
GROUP BY maker
HAVING maker IN (SELECT maker FROM Product NATURAL JOIN Printer);

6.4.7
a)
SELECT COUNT(classes)
FROM Product
WHERE type = 'bb';

b)
SELECT AVG(numGuns)
FROM Product
WHERE type = 'bb';

c)
SELECT AVG(numGuns)
FROM Product NATURAL JOIN Ships
WHERE type = 'bb';

d)
SELECT class, MIN(launched)
FROM Product NATURAL JOIN Ships
GROUP BY class;

e)
SELECT A.class, COUNT(A.name)
FROM ((Product NATURAL JOIN Ships) NATURAL JOIN ON name = ship) AS A
WHERE A.result = 'sunk'
GROUP BY A.class;

f)
SELECT A.class
FROM ((Product NATURAL JOIN Ships) NATURAL JOIN ON name = ship) AS A
WHERE A.result = 'sunk'
GROUP BY A.class
HAVING COUNT(DISTINCT A.name) >= 3;

g)
SELECT country, AVG(bore * bore * bore / 2)
FROM Product NATURAL JOIN Ships
GROUP BY country;

6.4.8
SELECT MIN(year)
FROM StarsIn
GROUP BY starName
HAVING COUNT(title) >= 3;

6.4.9
Sigma C1(R2 > 2 something like that), C2 (Gamma R1, R2, R3 (TABLE))