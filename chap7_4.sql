7.4.1
a)
CREATE ASSERTION PCMaker
CHECK (NOT EXISTS((SELECT maker FROM Product, PC WHERE Product.model = PC.model) INTERSECT
	(SELECT maker FROM Product, Laptop WHERE Product.model = Laptop.model)));
	
b)
CREATE ASSERTION LaptopSpeed
CHECK (EXISTS
	SELECT speed FROM Product NATURAL JOIN PC AS A) WHERE speed <= ANY
	(SELECT speed FROM Product NATURAL JOIN Laptop AS B WHERE A.maker = B.maker);
	
c)
CREATE ASSERTION PCLaptop
CHECK (EXISTS
	SELECT PC.model FROM PC, Laptop WHERE PC.ram >= Laptop.ram OR PC.price < Laptop.price);
	
d)
CREATE ASSERTION TypeCheck
CHECK (EXISTS
	SELECT model FROM Product WHERE type = NULL OR
	(type = 'pc' AND model = (SELECT model FROM PC WHERE model = PC.model)) OR
	(type = 'laptop' AND model = (SELECT model FROM Laptop WHERE model = Laptop.model)) OR
	(type = 'printer' AND model = (SELECT model FROM Printer WHERE model = Printer.model)));
	

7.4.2
a)
CREATE ASSERTION ShipCount
CHECK (2 <= 
	SELECT COUNT(Ships.name) FROM Ships GROUP BY class);
	
b)
CREATE ASSERTION ShipTypeCheck
CHECK (NOT EXISTS
	(SELECT country FROM Classes WHERE type = 'bb') INTERSECT
	(SELECT country FROM Classes WHERE type = 'bc'));
	
c)
CREATE ASSERTION ShipSunkCheck
CHECK (NOT EXISTS
	(SELECT battle FROM Ships, Classes, Outcomes WHERE Ships.class = Classes.class AND
	Outcomes.ship = Ships.name AND Classes.gunNums >= 9) INTERSECT
	(SELECT battle FROM Ships, Classes, Outcomes WHERE Ships.class = Classes.class AND
	Outcomes.ship = Ships.name AND Outcomesresult = 'sunk' AND Ships.numGuns < 9));
	
d)
CREATE ASSERTION LauchedDateCheck
CHECK (NOT EXISTS
	(SELECT A.name FROM Ship A, Ship B WHERE A.class = B.class AND A.launched < B.launched
	AND B.class = B.name));
	
e)
CREATE ASSERTION ClassNameShipCheck
CHECK (NOT EXISTS
	(SELECT class FROM Classes WHERE class NOT IN (SELECT class FROM Ships)));
	

7.4.3
-- IN MovieExec
ALTER TABLE MovieExec CREATE CONSTRAINT execCheck
CHECK (netWorth < 10000000 OR cert# IN (SELECT presC# FROM Studio));

-- IN Studio
ALTER TABLE Studio CREATE CONSTRAINT stuioNetworthCheck
CHECK (presC# IN (SELECT cert# FROM MovieExec WHERE netWorth >= 10000000));