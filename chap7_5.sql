7.5.1
CREATE TRIGGER AvgNetWorthTriggerOnDeletion
AFTER DELETE ON MovieExec
REFERENCING
	OLD TABLE AS oldTable
	NEW TABLE AS newTable
FOR EACH STATEMENT
WHEN (500000 > (SELECT AVG(netWorth) FROM newTable))
START
	DELETE FROM MovieExec
	WHERE (name, address, cert#, netWorth) IN newTable;
	INSERT INTO MovieExec
		(SELECT * FROM oldExec);
END;

CREATE TRIGGER AvgNetWorthTriggerOnInsert
AFTER INSERT ON MovieExec
REFERENCING
	OLD TABLE AS oldTable
	NEW TABLE AS newTable
FOR EACH STATEMENT
WHEN (500000 > (SELECT AVG(netWorth) FROM newTable))
START
	DELETE FROM MovieExec
	WHERE (name, address, cert#, netWorth) IN newTable;
	INSERT INTO MovieExec
		(SELECT * FROM oldTable);
END;


7.5.2
a)
CREATE TRIGGER PriceOfPCTrigger
AFTER UPDATE OF price ON PC
REFERENCING
	OLD ROW AS oldRow
	NEW ROW AS newRow
	NEW TABLE AS newTable
FOR EACH ROW
WHEN (newRow.price > ANY (SELECT price FROM newTable WHERE newTable.speed = newRow.speed))
	UPDATE PC
	SET price = newRow.price
	WHERE price < newRow.price AND speed = newRow.speed;

b)
CREATE TRIGGER PrinterModelTrigger
AFTER INSERT ON Printer
REFERENCING
	NEW ROW AS newRow
FOR EACH ROW
WHEN (newRow.model NOT IN (SELECT model FROM Product))
	DELETE FROM Printer
	WHERE Printer.model = newRow.model;

c)
CREATE TRIGGER LaptopPriceTriggerOnUpdate
AFTER UPDATE OF price ON Laptop
REFERENCING
	OLD TABLE AS oldTable
	NEW TABLE AS newTable
FOR EACH STATEMENT
WHEN (1500 < ANY (SELECT AVG(price) FROM Laptop NATURAL JOIN Product GROUP BY maker))
BEGIN
	DELETE FROM Laptop
	WHERE (model, speed, ram, hd, screen, price) IN newTable;
	INSERT INTO Laptop
		(SELECT * FROM OldTable);
END;

CREATE TRIGGER LaptopPriceTriggerOnDelete
AFTER DELETE OF price ON Laptop
REFERENCING
	OLD TABLE AS oldTable
	NEW TABLE AS newTable
FOR EACH STATEMENT
WHEN (1500 < ANY (SELECT AVG(price) FROM Laptop NATURAL JOIN Product GROUP BY maker))
BEGIN
	DELETE FROM Laptop
	WHERE (model, speed, ram, hd, screen, price) IN newTable;
	INSERT INTO Laptop
		(SELECT * FROM OldTable);
END;

CREATE TRIGGER LaptopPriceTriggerOnInsert
AFTER INSERT OF price ON Laptop
REFERENCING
	OLD TABLE AS oldTable
	NEW TABLE AS newTable
FOR EACH STATEMENT
WHEN (1500 < ANY (SELECT AVG(price) FROM Laptop NATURAL JOIN Product GROUP BY maker))
BEGIN
	DELETE FROM Laptop
	WHERE (model, speed, ram, hd, screen, price) IN newTable;
	INSERT INTO Laptop
		(SELECT * FROM OldTable);
END;

d)
CREATE TRIGGER PCRamHdTrigger
AFTER UPDATE OF ram, hd ON PC
REFERENCING
	OLD ROW AS oldRow
	NEW ROW AS newRow
FOR EACH ROW
WHEN (newRow.hd * 100 < newRow.ram)
	UPDATE PC
	SET ram = oldRow.ram, hd = oldRow.hd
	WHERE model = newRow.model;

e)
CREATE TRIGGER PCInsertTrigger
BEFORE INSERT ON PC
REFERENCING
	NEW ROW AS newRow
	OLD TABLE AS oldTable
	NEW TABLE AS newTable
FOR EACH STATEMENT
WHEN (newPC.model = ANY(SELECT model FROM oldTable UNION SELECT model FROM Laptop UNION
SELECT model FROM Printer))
BEGIN:
	DELETE FROM PC
	WHERE (model, speed, ram, hd, price) IN newTable;
	INSERT INTO PC
		(SELECT * FROM oldTable);
END;


7.5.3
a)
CREATE TRIGGER ClassInsertTrigger
AFTER INSERT ON Classes
REFERENCING
	NEW ROW AS newRow
FOR EACH ROW
	INSERT INTO Ships VALUES(newRow.class, newRow.class, NULL);
	
b)
CREATE TRIGGER DisplacementTrigger
BEFORE INSERT ON Classes
REFERENCING
	NEW ROW AS newRow
	NEW TABLE AS newTable
FOR EACH ROW
WHEN (newRow.displacement > 35000)
	UPDATE newTable
	SET displacement = 35000
	WHERE class = newRow.class;
	
c)
CREATE TRIGGER OutcomesTrigger
AFTER INSERT ON Outcomes
REFERENCING
	NEW ROW AS newRow
	OLD TABLE AS oldTable
	NEW TABLE AS newTable
FOR EACH ROW
WHEN (newRow.ship NOT IN (SELECT name FROM Ships) OR 
newRow.battle NOT IN (SELECT name FROM Battles))
BEGIN:
	INSERT INTO Ships(name, class, launched)
	VALUES(newRow.ship, NULL, NULL)
	WHERE NOT EXISTS(SELECT name FROM Ships WHERE Ships.name = newRow.ship);
	INSERT INTO Battles(name, date)
	VALUES(newRow.battle, NULL)
	WHERE NOT EXISTS(SELECT name FROM Battles WHERE Battles.name = newRow.battle);
END;

d)
CREATE TRIGGER ShipInsertTrigger
AFTER INSERT ON Ships
REFERENCING
	NEW ROW AS newRow
	OLD TABLE AS oldTable
	NEW TABLE AS newTable
FOR EACH ROW
WHEN (20 > (SELECT COUNT(name) FROM Classes NATURAL JOIN newTable GROUP BY country))
BEGIN:
	DELETE FROM Ships
	WHERE (name, class, launched) IN newTable;
	INSERT INTO Ships
		(SELECT * FROM oldTable);
END;

CREATE TRIGGER UpdateClassOnShipTrigger
AFTER UPDATE OF class ON Ships
REFERENCING
	OLD ROW AS oldRow
	NEW ROW AS newRow
	OLD TABLE AS oldTable
	NEW TABLE AS newTable
FOR EACH ROW
WHEN (20 > (SELECT COUNT(name) FROM Classes NATURAL JOIN newTable Group By country))
BEGIN:
	DELETE FROM Ships
	WHERE (name, class, launched) IN newTable;
	INSERT INTO Ships
		(SELECT * FROM oldTable);
END;

e)
CREATE TRIGGER OutcomesViolationUpdateTrigger
AFTER UPDATE ON Outcomes
REFERENCING
	OLD ROW AS oldRow
	NEW ROW AS newRow
	OLD TABLE AS oldTable
	NEW TABLE AS newTable
FOR EACH ROW
WHEN (SELECT A.date FROM Battles NATURAL JOIN newTable ON Battles.name = newTable.battle AS A,
Battles NATURAL JOIN newTable ON Battles.name = newTable.battle AS B WHERE A.result = 'sunk' AND
A.ship = B.ship AND A.date < B.date)
BEGIN:
	DELETE FROM Outcomes
	WHERE (ship, battle, result) IN newTable;
	INSERT INTO Outcomes
		(SELECT * FROM oldTable);
END;

CREATE TRIGGER BattleViolationUpdateTrigger
AFTER UPDATE ON Battles
REFERENCING
	OLD TABLE AS oldTable
	NEW TABLE AS newTable
FOR EACH ROW
WHEN (SELECT A.date FROM Outcomes NATURAL JOIN newTable ON Outcomes.name = newTable.battle AS A,
Outcomes NATURAL JOIN newTable ON Outcomes.name = newTable.battle AS B WHERE A.result = 'sunk' AND
A.ship = B.ship AND A.date < B.date)
BEGIN:
	DELETE FROM Battles
	WHERE (name, date) IN newTable;
	INSERT INTO Battles
		(SELECT * FROM oldTable);
END;

CREATE TRIGGER BattleViolationInsertTrigger
AFTER INSERT ON Battles
REFERENCING
	OLD TABLE AS oldTable
	NEW TABLE AS newTable
FOR EACH ROW
WHEN (SELECT A.date FROM Outcomes NATURAL JOIN newTable ON Outcomes.name = newTable.battle AS A,
Outcomes NATURAL JOIN newTable ON Outcomes.name = newTable.battle AS B WHERE A.result = 'sunk' AND
A.ship = B.ship AND A.date < B.date)
BEGIN:
	DELETE FROM Battles
	WHERE (name, date) IN newTable;
	INSERT INTO Battles
		(SELECT * FROM oldTable);
END;


7.5.4
a)
CREATE TRIGGER StarsInInsertTrigger
AFTER INSERT ON StarsIn
REFERENCING
	NEW ROW AS newRow
FOR EACH ROW
WHEN (newRow.starName NOT IN (SELECT name FROM MovieStar))
	INSERT INTO MovieStar(name, address, gender, birthdate)
	VALUES(newRow.starName, NULL, NULL, NULL);
	
CREATE TRIGGER StarsInUpdateTrigger
AFTER UPDATE ON StarsIn
REFERENCING
	NEW ROW AS newRow
FOR EACH ROW
WHEN (newRow.starName NOT IN (SELECT name FROM MovieStar))
	INSERT INTO MovieStar(name, address, gender, birthdate)
	VALUES(newRow.starName, NULL, NULL, NULL);


b)
CREATE TRIGGER PresidentOnUpdateTrigger
AFTER UPDATE ON MovieExec
REFERENCING
	NEW ROW AS newRow
FOR EACH ROW
WHEN (newRow.cert# NOT IN (SELECT presC# FROM Studio) AND
newRow.cert# NOT IN (SELECT producerC# FROM Movies))
BEGIN:
	INSERT INTO Studio
	VALUES(NULL, NULL, newRow.cert#);
	INSERT INTO Movies
	VALUES(NULL, NULL, NULL, NULL, NULL, newRow.cert#);
END;

CREATE TRIGGER PresidentOnInsertTrigger
AFTER INSERT ON MovieExec
REFERENCING
	NEW ROW AS newRow
FOR EACH ROW
WHEN (newRow.cert# NOT IN (SELECT presC# FROM Studio) AND
newRow.cert# NOT IN (SELECT producerC# FROM Movies))
BEGIN:
	INSERT INTO Studio
	VALUES(NULL, NULL, newRow.cert#);
	INSERT INTO Movies
	VALUES(NULL, NULL, NULL, NULL, NULL, newRow.cert#);
END;

c)
CREATE TRIGGER GenderInMovieUpdateTrigger
AFTER UPDATE ON StarsIn
REFERENCING
	NEW ROW AS newRow
	OLD TABLE AS oldTable
	NEW TABLE AS newTable
FOR EACH ROW
WHEN ((SELECT gender FROM MovieStar WHERE MovieStar.name = newRow.starName) <> ANY(
SELECT gender FROM MovieStar, newTable WHERE MovieStar.name = newTable.starName AND
newTable.movieTitle = newRow.movieTitle AND newTable.movieYear = newRow.movieYear))
BEGIN:
	DELETE FROM StarsIn
	WHERE (movieTitle, movieYear, starName) IN newTable;
	INSERT INTO StarsIn
	(SELECT * FROM oldTable);
END;

CREATE TRIGGER GenderInMovieInsertTrigger
AFTER INSERT ON StarsIn
REFERENCING
	NEW ROW AS newRow
	OLD TABLE AS oldTable
	NEW TABLE AS newTable
FOR EACH ROW
WHEN ((SELECT gender FROM MovieStar WHERE MovieStar.name = newRow.starName) <> ANY(
SELECT gender FROM MovieStar, newTable WHERE MovieStar.name = newTable.starName AND
newTable.movieTitle = newRow.movieTitle AND newTable.movieYear = newRow.movieYear))
BEGIN:
	DELETE FROM StarsIn
	WHERE (movieTitle, movieYear, starName) IN newTable;
	INSERT INTO StarsIn
	(SELECT * FROM oldTable);
END;

d)
CREATE TRIGGER MovieNumberUpdateTrigger
BEFORE UPDATE ON Movies
REFERENCING
	NEW ROW AS newRow
	OLD TABLE AS oldTable
	NEW TABLE AS newTable
FOR EACH ROW
WHEN (100 > (SELECT COUNT(title) FROM newTable GROUP BY studioName, year))
BEGIN:
	UPDATE newTable
	SET studioName = newRow.studioName || '#';
	INSERT INTO Studio
	VALUES(newRow.studioName || '#', NULL, newRow.producerC#)
END;

CREATE TRIGGER MovieNumberInsertTrigger
BEFORE INSERT ON Movies
REFERENCING
	NEW ROW AS newRow
	OLD TABLE AS oldTable
	NEW TABLE AS newTable
FOR EACH ROW
WHEN (100 > (SELECT COUNT(title) FROM newTable GROUP BY studioName, year))
BEGIN:
	UPDATE newTable
	SET studioName = newRow.studioName || '#';
	INSERT INTO Studio
	VALUES(newRow.studioName || '#', NULL, newRow.producerC#)
END;

e)
CREATE TRIGGER AvgMovieLengthPerYearUpdateTrigger
AFTER UPDATE ON Movies
REFERENCING
	OLD ROW AS oldRow
	NEW ROW AS newRow
	OLD TABLE AS oldTable
	NEW TABLE AS newTable
FOR EACH ROW
WHEN (120 > (SELECT AVG(length) FROM newTable GROUP BY year))
	UPDATE Movies
	SET length = 120
	WHERE title = newRow.title AND year = newRow.year;

CREATE TRIGGER AvgMovieLengthPerYearInsertTrigger
AFTER INSERT ON Movies
REFERENCING
	NEW ROW AS newRow
	OLD TABLE AS oldTable
	NEW TABLE AS newTable
FOR EACH ROW
WHEN (120 > (SELECT AVG(length) FROM newTable GROUP BY year))
	UPDATE Movies
	SET length = 120
	WHERE title = newRow.title AND year = newRow.year;