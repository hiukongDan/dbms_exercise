6.6.1
a)
SET TRANSACTION READ ONLY;
START TRANSACTION;
SELECT PC.model, PC.price
FROM PC
WHERE PC.speed = speed, PC.ram = ram
COMMIT;

b)
SET TRANSACTION READ WRITE
	ISOLATION LEVEL SERIALIZABLE;
START TRANSACTION;
DELETE FROM Product
WHERE Product.model = model;
DELETE FROM PC
WHERE PC.model = model;
COMMIT;

c)
START TRANSACTION;
UPDATE PC
SET PC.price = PC.price - 100
WHERE PC.model = model;
COMMIT;

d)
START TRANSACTION;
SELECT A.model
FROM (PC NATURAL JOIN Product) AS A
WHERE A.maker = maker AND A.model = model, AND A.speed = speed AND 
	A.ram = ram AND A.hd = hd AND A.price = price
COMMIT;

# if has this tuple
# then print error msg
START TRANSACTION;
DELETE FROM Product WHERE Product.model = model;
DELETE FROM PC WHERE PC.model = model;
COMMIT;

# else
START TRANSACTION;
INSERT INTO Product VALUES(maker, model, 'PC');
INSERT INTO PC VALUES(model, speed ,ram, hd, price);
COMMIT;


6.6.2
a) no
b) in deletion there may be a query...
c) same
d) check if there is such tuple
   no tuple checked				insert from another place
   insert this tuple            violates
   

6.6.3
a) same behavior
b) check tuple					delete tuple
   found deleted, rollback		commit, deleted
   not delete
c) decrease by 100				check value
   commit						decrease by 100 (total by 200)
								commit
d) not found					not found
   insert						insert


6.6.4
...