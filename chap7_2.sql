7.2.1
a)
year INT CHECK(year >= 1915)

b)
length INT CHECK (length >= 60 AND length <=250)

c)
name CHAR(10) CHECK (name IN ('Disney', 'Fox', 'MGM', 'Paramount'))

7.2.2
a)
speed FLOAT CHECK(speed >= 2.0)

b)
type CHAR(10) CHECK (type IN ('laser', 'ink-jet', 'bubble-jet'))

c)
type CHAR(10) CHECK (type IN ('PC', 'laptop', 'printer'))

d)
IN Product
model INT CHECK (model IN (SELECT model FROM PC UNION SELECT model FROM Laptop UNION
							SELECT model FROM Printer))
IN PC, Laptop, Printer
model INT CHECK (model IN (SELECT model FROM Product))


7.2.3
a)
-- IN StarsIn
CHECK (movieYear >= (SELECT birthdate FROM MovieStar WHERE starName = name));
-- IN MovieStar
CHECK (birthdate <= ALL(SELECT movieYear FROM StarsIn WHERE starName = name));

b)
-- IN Studio
CHECK (address NOT IN (SELECT address FROM Studio A WHERE A.name = name));

c)
-- IN MovieStar
CHECK (name NOT IN (SELECT name FROM MovieExec));
-- IN MovieExec
CHECK (name NOT IN (SELECT name FROM MovieStar));

d)
-- IN Stuio
CHECK (name IN (SELECT studioName FROM Movies));

e)
-- IN Movies
CHECK (producerC# NOT IN (SELECT presC# FROM Studio) OR 
		producerC# = (SELECT presC# FROM Studio WHERE studioName = name));
		
		
7.2.4
a)
CHECK (speed >= 2 OR price <= 600);

b)
CHECK (screen >= 15 OR hd >= 40 OR price < 1000);


7.2.5
a)
CHECK (bore <= 16);

b)
CHECK (numGuns <= 9 OR bore <= 14);

c)
-- IN Outcomes
CHECK ((SELECT date FROM Battles WHERE name = battle) >= (SELECT launched FROM Ships
		WHERE name = ship));

-- IN Ships
CHECK (launched <= ALL (SELECT date FROM Battles NATURAL JOIN Outcomes ON
		Battles.name = Outcomes.Battle WHERE ship = Ships.name));
		

7.2.6
gender IN ('F', 'M') if gender IS NULL then yields UNKNOWN...?

