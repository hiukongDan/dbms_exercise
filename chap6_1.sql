6.1.1
SELECT A B;
-- same as
Select A as B;

6.1.2
a)
SELECT address
FROM Studio
WHERE name = 'MGM';

b)
SELECT birthdate
FROM MovieStar
WHERE name = 'Sandra Bullock';

c)
SELECT starName
FROM StarsIn
WHERE movieTitle LIKE '%Love%' OR movieYear = 1980;

d)
SELECT name
FROM MovieExec
WHERE netWorth >= 10000000;

e)
SELECT name
FROM MovieStar
WHERE address LIKE '%Malibu%' OR gender = 'male';

6.1.3
a)
SELECT model, speed ,hd
FROM PC
WHERE price < 1000;

b)
SELECT model, speed AS gigahertz, hd as gigabytes
FROM PC
WHERE price < 1000;

c)
SELECT maker
FROM Product
WHERE type = 'Printer';

d)
SELECT model, ram, screen
FROM Laptop
WHERE price > 1500;

e)
SELECT model
FROM Printer
WHERE color = TRUE;

f)
SELECT model, hd
FROM PC
WHERE speed = 3.2 AND price < 2000;

6.1.4
a)
SELECT class, country
FROM Classes
WHERE numGuns >= 10;

b)
SELECT name as shipName
FROM Ships
WHERE launched < 1918;

c)
SELECT ship, battle
FROM Outcomes
WHERE result = 'sunk';

d)
SELECT name
FROM Ships
WHERE name = class;

e)
SELECT name
FROM Ships
WHERE name LIKE 'R%';

f)
SELECT name
FROM Ships
WHERE name LIKE '_% _% _%';

6.1.6
SELECT *
FROM Movies
WHERE length IS NOT NULL;