6.5.1
a)
INSERT INTO PC(model, speed, ram, hd, price)
VALUES(1000, 3.2, 1024,180, 2499);
INSERT INTO Product(maker, model, type)
VALUES('C', 1000, 'PC');

b)
INSERT INTO Laptop(model, speed, ram, hd, screen, price)
SELECT DISTINCT A.model+1100, A.speed, A.ram, A.hd, 17, A.price+500
FROM PC A;
INSERT INTO Product(maker, model, type)
SELECT DISTINCT A.maker, A.model+1100, 'Laptop'
FROM (Product NATURAL JOIN PC) A;

c)
DELETE FROM PC
WHERE  hd < 100;

d)
DELETE FROM Laptop
WHERE model IN 
	(
	(SELECT model FROM Product)EXCEPT
	(SELECT model FROM Product NATURAL JOIN Printer)
	);

e)
UPDATE Product
SET model = 'A'
WHERE model = 'B';

f)
UPDATE PC
SET ram = 2*ram, hd = hd+60

g)
UPDATE Laptop
SET screen = screen + 1, price = price - 100
WHERE model IN 
	(
	SELECT model FROM Product NATURAL JOIN Laptop WHERE maker = 'B'
	);
	

6.5.2
a)
INSERT INTO Classes(class, type, country, numGuns, bore, displacement)
VALUES('Nelson', 'bb', 'Britain', 9, 16, 34000);
INSERT INTO Ships(name, class, launched)
VALUES('Nelson', 'Nelson', 1927);
INSERT INTO Ships(name, class, launched)
VALUES('Rodney', 'Nelson', 1927);

b)
INSERT INTO Classes(class, type, country, numGuns, bore, displacement)
VALUES('Vittorio Veneto', 'bb', 'Italy', 9, 15, 41000);
INSERT INTO Ships(name, class, launched)
VALUES('Vittorio Veneto', 'Vittorio Veneto', 1940);
INSERT INTO Ships
VALUES('Italia', 'Vittorio Veneto', 1940);
INSERT INTO Ships
VALUE('Roma', 'Vittorio Veneto', 1942);

c)
DELETE FROM Ships
WHERE name IN
	(
	SELECT ship
	FROM Outcomes
	WHERE result = 'sunk'
	);
	
d)
UPDATE Classes
SET bore = bore * 2.5, displacement = displacement / 1.1;

e)
DELETE FROM Classes
WHERE class IN
	{
	SELECT class
	FROM Classes NATURAL JOIN Ships
	GROUP BY class
	HAVING COUNT(name) < 3
	};
