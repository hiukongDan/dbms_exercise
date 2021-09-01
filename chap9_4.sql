-- 9.4.1
-- a)
DECLARE PROCEDURE CalculateStudioNetWorth(
	IN nameStudio CHAR(50),
	OUT netWorth  INTEGER
)

DECLARE Not_Found CONDITION FOR SQLSTATE "02000";
DECLARE Too_Many  CONDITION FOR SQLSTATE "21000";

BEGIN
	SET netWorth = (
		SELECT netWorth
		FROM MovieExec, Studio
		WHERE Studio = nameStudio AND Studio.presC# = MovieExec.cert#;
	);
END;

-- b)
DECLARE FUNCTION GetPersonInfo(
	name CHAR(20),
	address CHAR(50)
) RETURNS INTEGER

DECLARE Not_Found CONDITION FOR SQLSTATE "02000";
DECLARE Too_Many  CONDITION FOR SQLSTATE "21000";

DECLARE isStar BOOLEAN;
DECLARE isExec BOOLEAN;

BEGIN
	IF EXISTS (SELECT name FROM MovieStar WHERE MovieStar.name = name AND
	MovieStar.address = address) THEN
		SET isStar = True;
	ELSE
		SET isStar = False;
	END IF;
	IF EXISTS (SELECT name FROM MovieExec WHERE MovieExec.name = name AND
	MovieExec.address = address) THEN
		SET isExec = True;
	ELSE
		SET isExec = False;
	END IF;
	
	IF isStar AND isExec THEN
		RETURN 3;				-- both
	ELSEIF isStar THEN
		RETURN 1;				-- star
	ELSEIF isExec THEN
		RETURN 2;				-- executive
	ELSE
		RETURN 4;				-- neither
	END IF;
	
END;

-- c)
CREATE PROCEDURE TwoLongestMovie(
	IN studioName	CHAR(20),
	OUT firstMovie	CHAR(20),
	OUT secondMovie CHAR(20)
)
DECLARE Not_Found CONDITION FOR SQLSTATE "02000";
DECLARE Too_Many  CONDITION FOR SQLSTATE "21000";
DECLARE movieCursor CURSOR FOR
	SELECT title FROM Movies WHERE Movies.studioName = studioName ORDER BY length DESC;

BEGIN
	SET firstMovie = NULL;
	SET secondMovie = NULL;
	OPEN movieCursor;
	FETCH movieCursor INTO firstMovie;
	IF Not_Found THEN
		firstMovie = NULL;
	END IF;
	
	FETCH movieCursor INTO secondMovie;
	IF Not_Found THEN
		secondMovie = NULL;
	END IF;
	
	CLOSE movieCursor;
END;


-- d)
CREATE PROCEDURE EarlistYearMoreThen120Min(
	IN starName		CHAR(20),
	OUT title  		CHAR(20),
	OUT year		INTEGER
)
DECLARE Not_Found CONDITION FOR SQLSTATE "02000";
DECLARE Too_Many  CONDITION FOR SQLSTATE "21000";
DECLARE movieCursor CURSOR FOR
	SELECT title, year FROM Movies, StarsIn WHERE StarsIn.starName = starName AND
	Movies.length > 120 ORDER BY Movies.year ASC;

BEGIN
	OPEN movieCursor;
	FETCH movieCursor INTO title, year;
	IF Not_Found THEN SET year = 0 END IF;
	CLOSE movieCursor;
END;


-- e)
CREATE PROCEDURE FindUniqueStar(
	IN address	CHAR(255),
	OUT starName	CHAR(50)
)
DECLARE Not_Found CONDITION FOR SQLSTATE "02000";
DECLARE Too_Many  CONFITION FOR SQLSTATE "21000";
	
BEGIN
	SELECT name INTO starname
	FROM MovieStar WHERE MovieStar.address = address;
	IF Not_Found OR Too_Many THEN starName = NULL END IF;	-- Can I assign NULL to char()??
END;


-- f)
CREATE PROCEDURE DeleteMovie(
	IN starName		CHAR(50)
)
DECLARE Not_Found CONDITION FOR SQLSTATE "02000";
DECLARE Too_Many  CONFITION FOR SQLSTATE "21000";

BEGIN
	DELETE FROM Movies WHERE (title, year) IN 
	(SELECT movieTitle, movieYear FROM StarsIn WHERE StarsIn.starName = starName);
	DELETE FROM StarsIn WHERE StarsIn.starName = starName;
	DELETE FROM MovieStar WHERE MovieStar.name = starName;
END;


-- 9.4.2
-- a)
CREATE FUNCTION ClosestPrice(
	price INTEGER
) RETURNS INTEGER
DECLARE Not_Found CONDITION FOR SQLSTATE "02000";
DECLARE Too_Many CONDITION FOR SQLSTATE "21000";
DECLARE diff INTEGER;
DECLARE closestPrice INTEGER;
DECLARE priceIn INTEGER;
DECLARE modelIn INTEGER;
DECLARE priceCursor CURSOR FOR
	SELECT model, price FROM PC;

BEGIN
	DECLARE EXIT HANDLER FOR Not_Found
		RETURN -1;
		
	OPEN priceCursor;
	FETCH priceCursor INTO priceIn, modelIn;
	IF Not_Found THEN RETURN -1 END IF;
	IF priceIn > price THEN SET diff = priceIn - price ELSE SET diff = price - priceIn END IF;
	SET closestPrice = priceIn;
	priceLoop: LOOP
		FETCH priceCursor INTO priceIn, modelIn;
		IF Not_Found THEN RETURN closestPrice END IF;
		IF priceIn > price AND diff > priceIn-price THEN
			SET diff = priceIn - price;
			SET closestPrice = priceIn;
		ELSEIF priceIn <= price AND diff > price-priceIn THEN
			SET diff = price - priceIn;
			SET closestPrice = priceIn;
		END IF;
END;


-- b)
CREATE FUNCTION PriceOfRandom(
	IN maker INTEGER,
	IN model INTEGER,
) RETURN INTEGER

DECLARE Not_Found CONDITION FOR SQLSTATE "02000";
DECLARE Too_Many  CONDITION FOR SQLSTATE "21000";
DECLARE price INTEGER;

BEGIN
	SELECT PC.price INTO price FROM PC, Product WHERE PC.model = Product.model AND
	Product.model = model AND Product.maker = maker;
	IF NOT (Not_Found OR Too_Many) THEN RETURN price END IF;
	SELECT Laptop.price INTO price FROM Laptop, Product WHERE Laptop.model = Product.model AND
	Product.model = model AND Product.maker = maker;
	IF NOT (Not_Found OR Too_Many) THEN RETURN price END IF;
	SELECT Printer.price INTO price FROM Printer, Product WHERE Printer.model = Product.model AND
	Product.model = model AND Product.maker = maker;
	IF NOT (Not_Found OR Too_Many) THEN RETURN price END IF;
	RETURN -1;
END;


-- c)
CREATE PROCEDURE InsertPC(
	IN model INTEGER,
	IN speed INTEGER,
	IN ram   INTEGER,
	IN hd    INTEGER,
	IN price INTEGER
)
DECLARE Not_Found CONDITION FOR SQLSTATE "02000";
DECLARE Too_Many  CONDITION FOR SQLSTATE "21000";
DECLARE Duplicate CONDITION FOR SQLSTATE "23000";

BEGIN
	insertLoop: LOOP
		INSERT INTO PC(model, speed, ram, hd, price)
		VALUES(model, speed, ram, hd, price);
		IF Duplicate THEN SET model = model + 1 ELSE LEAVE insertLoop END IF;
	END LOOP;
END;


-- d)
CREATE PROCEDURE SellingCount(
	IN price INTEGER,
	OUT PCCount INTEGER,
	OUT LaptopCount INTEGER,
	OUT PrinterCount INTEGER
)
DECLARE Not_Found CONDITION FOR SQLSTATE "02000";

BEGIN
	SET PCCount = (SELECT COUNT(DISTINCT model) FROM PC WHERE PC.price > price);
	IF Not_Found THEN SET PCCount = 0 END IF;
	SET LaptopCount = (SELECT COUNT(DISTINCT model) FROM Laptop WHERE Laptop.price > price);
	IF Not_Fount THEN SET LaptopCount = 0 END IF;
	SET LaptopCount = (SELECT COUNT(DISTINCT model) FROM Printer WHERE Printer.price > price);
	IF Not_Fount THEN SET PrinterCount = 0 END IF;
END;



-- 9.4.3
-- a)
CREATE FUNCTION FindFirepower(
	classIn CHAR(20),
) RETURN INTEGER

DECLARE Not_Found CONDITION FOR SQLSTATE "02000";
DECLARE firePower INTEGER;

BEGIN
	SET firePower = 0;
	SELECT numGuns * bore * bore * bore
	INTO firePower
	FROM Classes WHERE Classes.class = classIn;
END;


-- b)
CREATE PROCEDURE TheDual(
	IN nameBattle CHAR(30),
	OUT country_1 CHAR(20),
	OUT country_2 CHAR(20)
)
DECLARE Not_Found CONDITION FOR SQLSTATE "02000";
DECLARE countryCursor CURSOR FOR
	SELECT DISTINCT country FROM Outcomes, Ships, Classes
	WHERE Outcomes.battle = nameBattle AND Outcomes.ship = Ships.name AND
	Ships.class = Classes.class;

BEGIN
	SET country_1 = NULL;
	SET country_2 = NULL;
	IF 2 = (SELECT COUNT(DISTINCT country) FROM Outcomes, Ships, Classes
	WHERE Outcomes.battle = nameBattle AND Outcomes.ship = Ships.name AND
	Ships.class = Classes.class) THEN
		OPEN countryCursor;
		FETCH countryCursor INTO country_1;
		FETCH countryCursor INTO country_2;
		CLOSE countryCursor;
	END IF;
END;


-- c)
CREATE PROCEDURE AddShip(
	IN class	 	CHAR(20),
	IN type			CHAR(20),
	IN country		CHAR(20),
	IN numGuns		INTEGER,
	IN bore			INTEGER,
	IN displacement	INTEGER
)
DECLARE Not_Found CONDITION FOR SQLSTATE "02000";
DECLARE Too_Many  CONDITION FOR SQLSTATE "21000";

BEGIN
	INSERT INTO Classes
	VALUES(class, type, country, numGuns, bore, displacement);
	INSERT INTO Ships
	VALUES(class, class, NULL);
END;


-- d)
CREATE PROCEDURE ShipLaunchDate(
	IN ship 	CHAR(20),
)

DECLARE Not_Found CONDITION FOR SQLSTATE "02000";
DECLARE battleName  CHAR(50);
DECLARE battleCursor CURSOR FOR
	SELECT Battles.name FROM Outcomes, Battles, Ships
	WHERE Outcomes.ship = Ships.name AND Battles.name = Outcomes.ship AND
	Ships.name = ship AND Battles.date < Ships.launched;

BEGIN
	OPEN battleCursor;
	FETCH battleCursor INTO battleName;
	IF NOT Not_Found THEN UPDATE Ships SET launched = 0 WHERE Ships.name = ship; END IF;
	
	CLOSE battleCursor;
END;