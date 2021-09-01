8.2.1
RichExec


8.2.2
a)
yes

b)
CREATE TRIGGER DisneyComediesInsertTrigger
INSTEAD OF INSERT ON DisneyComedies
REFERENCING
	NEW ROW AS newRow
FOR EACH ROW
INSERT INTO Movies(title, year, length, studioName, genre)
VALUES(newRow.title, newRow.year, newRow.length, 'Disney', 'comedy');

c)
CREATE TRIGGER DisneyComediesLengthUpdateTrigger
INSTEAD OF UPDATE length ON DisneyComedies
REFERENCING
	OLD ROW AS oldRow
	NEW ROW AS newRow
FOR EACH ROW
UPDATE Movies
SET length = newRow.length
WHERE title = newRow.title AND year = newRow.year AND
	studioName = 'Disney' AND genre = 'comedy';
	

8.2.3
a)
nein

b)
CREATE TRIGGER NewPCInsertTrigger
INSTEAD OF INSERT ON NewPC
REFERENCING
	NEW ROW AS newRow
FOR EACH ROW
BEGIN;
	INSERT INTO Product(maker, model, type)
	VALUES (newRow.maker, newRow.model, 'pc');
	INSERT INTO PC(model, speed, ram, hd, price)
	VALUES (newRow.model, newRow.speed, newRow.ram, newRow.hd, newRow.price);
END;

c)
CREATE TRIGGER NewPCPriceUpdateTrigger
INSTEAD OF UPDATE price ON NewPC
REFERENCING
	NEW ROW AS newRow
FOR EACH ROW
BEGIN;
	UPDATE PC
	SET price = newRow.price
	WHERE PC.model = newRow.model;
END;

d)
CREATE TRIGGER NewPCDeleteTrigger
INSTEAD OF DELETE ON NewPC
REFERENCING
	OLD ROW AS oldRow
FOR EACH ROW
BEGIN;
	DELETE FROM Product
	WHERE Product.maker = oldRow.maker AND Product.model = oldRow.model AND Product.type = 'pc';
	DELETE FROM PC
	WHERE PC.model = oldRow.model AND PC.speed = oldRow.speed AND PC.ram = oldRow.speed AND
		PC.hd = oldRow.hd AND PC.price = oldRow.price;
END;


