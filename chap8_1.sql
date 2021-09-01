8.1.1
a)
CREATE VIEW RichExec AS
	SELECT name, address, cert#, netWorth
	FROM MovieExec
	WHERE netWorth >= 10000000;

b)
CREATE VIEW StudioPress AS
	SELECT MovieExec.name, MovieExec.address, MovieExec.cert#
	FROM MovieExec, Studio
	WHERE MovieExec.cert# = Studio.presC#;
	
c)
CREATE VIEW ExecutiveStar AS
	SELECT A.name, A.address, A.gender, A.birthdate, B.cert#
	FROM MovieStar AS A, MovieExec AS B
	WHERE A.name = B.name;


8.1.2
a)
SELECT name
FROM ExecutiveStar
WHERE gender = 'F';

b)
SELECT A.name
FROM RichExec A, StudioPress B
WHERE A.name = B.name;

c)SELECT A.name
FROM StudioPress A, RichExec B, ExecutiveStar C
WHERE A.name = B.name AND B.name = C.name B.netWorth >= 50000000;


