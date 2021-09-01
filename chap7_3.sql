7.3.1
a)
ALTER TABLE Movie ADD CONSTRAINT primaryKeys
PRIMARY KEY(title, year);

b)
ALTER TABLE Movie ADD CONSTRAINT producerKey
FOREIGN KEY Movie(producerC#) REFERENCES MovieExec(cert#);

c)
ALTER TABLE Movie ADD CONSTRAINT lengthConstraint
CHECK (length >= 60 AND length <= 250);

d)
ALTER TABLE Movie ADD CONSTRAINT starUnique
CHECK (studioName <> (SELECT name FROM Studio NATURAL JOIN Movie ON
	Studio.presC# = Movie.producerC#)) ON UPDATE SET NULL;

e)
ALTER TABLE Studio ADD CONSTRAINT studioUnique
CHECK (address NOT IN (SELECT address FROM Studio WHERE name <> Studio.name));


7.3.2
a)
ALTER TABLE Classes ADD CONSTRAINT primaryKeys
PRIMARY KEY(class, country);

b)
ALTER TABLE Battles ADD CONSTRAINT shipForeignKey
FOREIGN KEY Battles(name) REFERENCES Ships(name);

c)
ALTER TABLE Outcomes ADD CONSTRAINT shipForeignKey
FOREIGN KEY Outcomes(ship) REFERENCES Ships(name);

d)
ALTER TABLE Classes ADD CONSTRAINT gunNumsConstaints
CHECK (numGuns <= 14);

e)
ALTER TABLE Ships ADD CONSTRAINT launchedDate
CHECK (launched <= ALL (SELECT date FROM Battles NATURAL JOIN Outcomes ON
	Battles.name = Outcomes.battle WHERE Outcomes.ship = Ships.name));
	
