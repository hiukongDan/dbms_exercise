7.1.1
a)
FOREIGN KEY Movies(producerC#) REFERENCES MovieExec(cert#);

b)
FOREIGN KEY Movies(producerC#) REFERENCES MovieExec(cert#) SET NULL;

c)
FOREIGN KEY Movies(producerC#) REFERENCES MovieExec(cert#)
	ON DELETE SET NULL
	ON UPDATE SET NULL;
	
d)
FOREIGN KEY StarsIn(movieTitle, movieYear) REFERENCES Movies(title, year) DEFAULT;

e)
FOREIGN KEY StarsIn(starName) REFERENCES MovieStar(name) CASCADE;


7.1.2
FOREIGN KEY Movies(title, year) REFERENCES StarsIn(movieTitle, movieYear);


7.1.3
CREATE TABLE Product(
maker	CHAR(20),
model 	INT,
type	CHAR(10),
PRIMARY KEY (maker, model),
);

CREATE TABLE PC(
model   INT,
speed	INT,
ram		INT,
hd		INT,
price 	FLOAT,
PRIMARY KEY (model),
FOREIGN KEY PC(model) REFERENCES Product(model)
);

CREATE TABLE Laptop(
model		INT,
speed		INT,
ram			INT,
screen		FLOAT,
price		FLOAT,
PRIMARY KEY (modeL),
FOREIGN KEY Laptop(model) REFERENCES Product(modeL)
);

CREATE TABLE Printer(
model		INT,
color		BOOL,
type		CHAR(10),
price		FLOAT,
PRIMARY KEY(model),
FOREIGN KEY Printer(model) REFERENCES Product(model),
);

7.1.4
CREATE TABLE Classes(
class			CHAR(20),
type			CHAR(2),
country			CHAR(20),
numGuns			INT,
bore			FLOAT,
displacement 	INT,
PRIMARY KEY(class),
);

CREATE TABLE Ships(
name			CHAR(20),
class			CHAR(20),
launched		DATE,
PRIMARY KEY(name, class),
FOREIGN KEY Ships(class) REFERENCES Classes(class),
);

CREATE TABLE Battles(
name			CHAR(20),
date			DATE,
PRIMARY KEY(name),
);

CREATE TABLE Outcomes(
ship			CHAR(20),
battle			CHAR(20),
result			CHAR(10),
PRIMARY KEY(ship, battle),
FOREIGN KEY Outcomes(battle) REFERENCES Battles(name),
FOREIGN KEY Outcomes(ship) REFERENCES Ships(name),
);


7.1.5
a)
CREATE TABLE Ships(
name			CHAR(20),
class			CHAR(20),
launched		DATE,
PRIMARY KEY(name, class),
FOREIGN KEY Ships(class) REFERENCES Classes(class) SET NULL,
);

b)
CREATE TABLE Outcomes(
ship			CHAR(20),
battle			CHAR(20),
result			CHAR(10),
PRIMARY KEY(ship, battle),
FOREIGN KEY Outcomes(battle) REFERENCES Battles(name) SET NULL,
);

c)
CREATE TABLE Outcomes(
ship			CHAR(20),
battle			CHAR(20),
result			CHAR(10),
PRIMARY KEY(ship, battle),
FOREIGN KEY Outcomes(battle) REFERENCES Battles(name) SET NULL,
FOREIGN KEY Outcomes(ship) REFERENCES Ships(name) SET NULL,
);