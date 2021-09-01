6.2.1
a)
SELECT name
FROM StarsIn, MovieStar
WHERE StarsIn.movieTitle = 'Titanic' AND StarsIn.starName = MovieStar.name AND
	MovieStar.gender = 'male'
ORDER BY ASC;
	
b)
SELECT StarsIn.starName
FROM Movies, StarsIn
WHERE Movies.studioName = 'MGM' AND Movies.year = 1995 AND Movies.year = StarsIn.movieYear
	AND Movies.title = StarIn.movieTitle
ORDER BY ASC;

c)
SELECT MovieExec.name
FROM MovieExec, Studio
WHERE MovieExec.cert# = Studio.presC# AND Studio.name = 'MGM'
ORDER BY ASC;

d)
SELECT A.title
FROM Movies AS A, Movies AS B
WHERE A.length > B.length AND B.title = 'Gone With the Wind'
ORDER BY ASC;

e)
SELECT A.name
FROM MovieExec AS A, MovieExec AS B
WHERE A.netWorth > B.netWorth AND B.name = 'Merv Griffin'
ORDER BY ASC;

6.2.2
a)
SELECT Product.maker, Laptop.speed
FROM Product, Laptop
WHERE Product.model = Laptop.model AND Laptop.hd >= 30
ORDER BY ASC;

b)
(
SELECT Product.model AS model, PC.price as price
FROM Product, PC
WHERE Product.maker = 'B' AND Product.model = PC.model;
)
UNION
(
SELECT Product.model AS model, Laptop.price as price
FROM Product, Laptop
WHERE Product.maker = 'B' AND Product.model = Laptop.model;
)
UNION
(
SELECT Product.model AS model, Printer.price as price
FROM Product, Printer
WHERE Product.maker = 'B' AND Product.model = Printer.model;
)

c)
(
SELECT Product.maker AS maker
FROM Product, Laptop
WHERE Product.model = Laptop.model;
)
EXCEPT
(
SELECT Product.maker AS maker
FROM Product, PC
WHERE Product.model = PC.model;
)

d)
SELECT A.hd
FROM PC AS A, PC AS B
WHERE A.model <> B.model AND A.hd < B.hd
ORDER BY ASC;

e)
SELECT A.model, B.model
FROM PC A, PC B
WHERE A.speed = B.speed AND A.ram = B.ram AND A.model < B.model
ORDER BY ASC;

f)
SELECT A.maker
FROM
Product AS A, Product AS B,
((SELECT model, speed FROM PC)
UNION
(SELECT model, speed FROM Laptop)) AS C
WHERE A.model = C.model AND B.model = C.model AND A.maker = B.maker AND A.model < B.model;

6.2.3
a)
SELECT Ships.name
FROM Classes, Ships
WHERE Classes.class = Ships.class AND Classes.displacement > 35000
ORDER BY ASC;

b)
SELECT Ships.name, Classes.displacement, Classes.numGuns
FROM Classes, Ships, Outcomes
WHERE Outcomes.battle = 'Guadalcanal' AND Outcomes.ship = Ships.name
	AND Ships.class = Classes.class
ORDER BY ASC;

c)
(SELECT name FROM Ships) UNION (SELECT ship FROM Outcomes);

d)
SELECT A.country
FROM Classes A, Classes B
WHERE A.country = B.country AND A.type = 'bc' AND B.type = 'bb'
ORDER BY ASC;

e)
SELECT A.ship
FROM Outcomes A, Outcomes B
WHERE A.ship = B.ship AND A.result = 'damaged' AND A.battle <> B.battle;

f)
SELECT A.country
FROM Classes A1, Classes A2, Classes A3, 
	Ships B1, Ships B2, Ships B3, 
	Outcomes C1, Outcomes C2, Outcomes C3
WHERE (C1.battle = C2.battle AND C2.battle = C3.battle) AND
	(C1.ship <> C2.ship AND C2.ship <> C3.ship) AND 
	(C1.ship = B1.name AND B1.class = A1.class) AND
	(C2.ship = B2.name AND B2.class = A2.class) AND
	(C3.ship = B3.name AND B3.class = A3.class) AND
	(A1.country = A2.country AND A2.country = A3.country)
ORDER BY ASC;

6.2.4
SELECT R1.x, R2.x, R3.y [...]
FROM A R1, A R2, B R3, C R4 [...]
WHERE R1.x = R2.x [AND ...];

6.2.5
SELECT x, y, z [...]
FROM
(
SELECT x, y, z [...]
FROM R1, R2, R3, R4 [...]
WHERE R1.x = R2.x AND R2.y = R3.y [AND ...]
)
WHERE x < y [AND ...];

