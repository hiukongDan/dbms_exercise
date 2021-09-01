// 9.3.1
// a)
#define AddMultiples(s) ((s)>1?"s":"")

void ApproximatePriceShip(){
	float priceIn, speed;
	int makerIn, modelIn;
	EXEC SQL BEGIN DECLARE SECTION;
		float price;
		int maker;
		int model;
		float speed;
		char SQLSTATE[6];
	EXEC SQL END DECLARE SECTION;
	
	std::cout<<"Enter your approximated price: ";
	std::cin>>priceIn;
	
	EXEC SQL DECLARE priceCursor CURSOR FOR
		SELECT maker, model, speed, price FROM PC, Product WHERE PC.model = Product.model;
	EXEC SQL OPEN priceCursor;
	
	priceIn = 999.0f;
	makerIn = -1;
	while(1){
		EXEC SQL FETCH FROM priceCursor INTO :maker, :model, :speed, :price;
		if(!strcmp(SQLSTATE, "02000")) break;
		if(abs(:price) < :priceIn){
			makerIn = :maker;
			modelIn = :model;
			speedIn = :speed;
			priceIn = :price;
		}
	}
	EXEC SQL CLOSE priceCursor;
	
	printf("maker: %d, model: %d, speed: %f\n", makerIn, modelIn, speedIn);
}


// b)
void AcceptableLaptop(){
	EXEC SQL BEGIN DECLARE SECTION;
		int model;
		float speed;
		int ram;
		int hd;
		float screen;
		float price;
		int maker;
		char SQLSTATE[6];
	EXEC SQL END DECLARE SECTION;
	std::cout<<"Enter minimum speed, ram, hard disk size and screen size you accept: ";
	std::cin>>speed>>ram>>hd>>screen;
	
	EXEC SQL DECLARE laptopCursor CURSOR FOR
		SELECT maker, model, speed, ram, hd, screen, price FROM Laptop, Product
		WHERE Laptop.model = Product.model AND speed>=:speed AND ram>=:ram AND hd>=:hd AND
		screen >= :screen;
	EXEC SQL OPEN laptopCursor;
	while(1){
		EXEC SQL FETCH laptopCursor INTO :maker, :model, :speed, :ram, :hd, :screen, :price;
		if(!strcmp(SQLSTATE, "02000")) break;
		printf("maker: %d, model: %d, speed: $f, ram: %d, hd: %d, screen: %f, price: %f", 
			:maker, :model, :price);
	}
	EXEC SQL CLOSE laptopCursor;
}


// c)
void PrintAllProduct(){
	EXEC SQL BEGIN DECLARE SECTION;
		int userMaker;
		int model;
		float speed;
		int ram;
		int hd;
		float price;
		float screen;
		bool color;
		char type[10];
		char SQLSTATE[6];
	EXEC SQL END DECLARE SECTION;
	
	std::cout<<"Enter maker number:";
	std::cin>>userMaker;
	
	EXEC SQL DECLARE pcCursor CURSOR FOR
		SELECT model, speed, ram, hd, price FROM Product, PC
		WHERE Product.model = PC.model AND Product.maker = :userMaker;
	EXEC SQL OPEN pcCursor;
	while(1){
		EXEC SQL FETCH pcCursor INTO :model, :speed, :ram, :hd, :price;
		if(!strcmp(SQLSTATE, "02000")) break;
		printf("maker: %d, type: pc, speed: %f, ram: %d, hd: %d, price: %f\n", 
			:userMaker, :speed, :ram, :hd, :price);
	}
	EXEC SQL CLOSE pcCursor;
	
	EXEC SQL DECLARE laptopCursor CURSOR FOR
		SELECT model, speed, ram, hd, screen, price FROM Product, Laptop
		WHERE Product.model = Laptop.model AND Product.maker = :userMaker;
	EXEC SQL OPEN laptopCursor;
	while(1){
		EXEC SQL FETCH laptopCursor INTO :model, :speed, :ram, :hd, :screen, :price;
		if(!strcmp(SQLSTATE, "02000")) break;
		printf("maker: %d, type: laptop, speed: %f, ram: %d, hd: %d, screen: %f, price: %f\n", 
			:userMaker, :speed, :ram, :hd, :screen, :price);
	}
	EXEC SQL CLOSE laptopCursor;
	
	EXEC SQL DECLARE printerCursor CURSOR FOR
		SELECT model, color, type, price FROM Product, Printer
		WHERE Product.model = Printer.model AND Product.maker = :userMaker;
	EXEC SQL OPEN printerCursor;
	while(1){
		EXEC SQL FETCH printerCursor INTO :model, :color, :type, :price;
		if(!strcmp(SQLSTATE, "02000")) break;
		printf("maker: %d, type: printer, color: %d, type: %s, price: %f\n", 
			:userMaker, :color, :type, :price);
	}
	EXEC SQL CLOSE printerCursor;
}

// d)
void BudgetCalc(){
	EXEC SQL BEGIN DECLARE SECTION;
		int budget;
		int totalCost;
		float speed;
		int modelPC;
		int modelPrinter;
		char SQLSTATE[6];
	EXEC SQL END DECLARE SECTION;
	
	std::cout<<"Enter your budget: ";
	std::cin>>budget;
	std::cout<<"Enter minimum speed: ";
	std::cin>>speed;
	
	EXEC SQL CREATE budgetCursor CURSOR FOR
		SELECT A.model, B.model, MIN(A.price+B.price) FROM PC AS A, Printer AS B
		WHERE A.price+B.price <= :budget AND A.speed >= :speed AND B.color = True;
	EXEC SQL OPEN budgetCursor;
	bool isColor = false;
	EXEC SQL FETCH budgetCursor INTO :modelPC, :modelPrinter, :totalCost;
	if(strcmp(SQLSTATE, "02000")){ // have one tuple
		isColor = true;
		printf("Found color printer, PC model: %d, printer model: %d\n", :modelPC, :modelPrinter)
	}
	EXEC SQL CLOSE budgetCursor;
	
	if(!isColor){
		EXEC SQL CREATE budgetNoColorCursor CURSOR FOR
			SELECT A.model, B.model, MIN(A.price+B.price) FROM PC AS A, Printer AS B
			WHERE A.price+B.price <= :budget AND A.speed >= :speed AND B.color = False;
		EXEC SQL OPEN budgetNoColorCursor;
		EXEC SQL FETCH budgetNoColorCursor INTO :modelPC, :modelPrinter, :totalCost;
		if(strcmp(SQLSTATE, "02000")){ // have one tuple
			printf("PC model: %d, printer model: %d\n", :modelPC, :modelPrinter)
		}
		else {
			std::cout<<"No available plan\n"<<std::endl;
		}
		EXEC SQL CLOSE budgetNoColorCursor;
	}
}


// e)
void NewOrNoPC(){
	EXEC SQL BEGIN DECLARE SECTION;
		int maker;
		int model;
		float speed;
		int ram;
		int hd;
		float price;
		char SQLSTATE[6];
	EXEC SQL END DECLARE SECTION;
	
	std::cout<<"Enter manufacturer, model number, speed, RAM, hard-disk size and price:";
	std::cin>>maker>>model>>speed>>ram>>hd>>price;
	
	EXEC SQL SELECT maker INTO :maker
			FROM Product
			WHERE Product.model = :model;
	if(strcmp(SQLSTATE, "02000")){
		std::cout<<"Model: "<<model<<" exists!\n";
	}
	else{
		EXEC SQL INSERT INTO Product(maker, model, type)
		VALUES(:maker, :model, "pc");
		EXEC SQL INSERT INTO PC(model, speed, ram, hd, price)
		VALUES(:model, :speed, :ram, :hd, :price);
	}
}


// 9.3.2
// a)
void LargestFirepower(){
	EXEC SQL BEGIN DECLARE SECTION;
		char class[20];
		int firepower;
		char SQLSTATE[6];
	EXEC SQL END DECLARE SECTION;
	
	EXEC SQL SELECT class, MAX(numGuns*bore*bore*bore)
		INTO :class, :firepower
		FROM Classes;
	if(!strcmp(SQLSTATE, "02000")){
		std::cout<<"Class not found\n"<<std::endl;
		return;
	}
	std::cout<<"Class "<<class<<" has the greatest firepower "<<firepower<<std::endl;
}


// b)
void ShipResult(){
	EXEC SQL BEGIN DECLARE SECTION;
		char country[20];
		char battle[20];
		int count;
		char SQLSTATE[6];
	EXEC SQL END DECLARE SECTION;
	
	std::cout<<"Enter battle name: ";
	std::cin>>battle;
	
	EXEC SQL DECLARE shipSunkCursor CURSOR FOR
		SELECT country, MAX(COUNT(DISTINCT Outcomes.ship))
		FROM Battles, Outcomes
		WHERE result = "sunk" AND Outcomes.battle = Battles.name AND Outcomes.battle = :battle
		GROUP BY country;
	
	EXEC SQL OPEN shipSunkCursor;
	while(1){
		EXEC SQL FETCH shipSunkCursor INTO :country, :count;
		if(!strcmp(SQLSTATE, "02000")) break;
		std::cout<<country<<" suffered casualties with "<<
			count<<" ship"<<(count>1?"s":""<<" sunk.\n";
	}
	EXEC SQL CLOSE shipSunkCursor;
	
	EXEC SQL DECLARE shipDamagedCursor CURSOR FOR
		SELECT country, MAX(COUNT(DISTINCT Outcomes.ship))
		FROM Battles, Outcomes
		WHERE result = "damaged" AND Outcomes.battle = Battles.name AND Outcomes.battle = :battle
		GROUP BY country;
		
	EXEC SQL OPEN shipDamagedCursor;
	while(1){
		EXEC SQL FETCH shipDamagedCursor INTO :country, :count;
		if(!strcmp(SQLSTATE, "02000")) break;
		std::cout<<countr<<" suffered casualites with "<<
			count<<" ship"<<AddMultiples(count)<<" damaged.\n";
	}
	EXEC SQL CLOSE shipDamagedCursor;
}


// c)
void ShipClassInput(){
	EXEC SQL BEGIN DECLARE SECTION;
		char name[20];
		char class[20];
		char type[3];
		char country[20];
		int numGuns;
		int bore;
		int displacement;
		char date[20];
		char SQLSTATE[6];
	EXEC SQL END DECLARE SECTION;
	std::cout<<"Enter ship class: ";
	std::cin>>>class;
	std::cout<<"Enter type(bc/bb): ";
	std::cin>>type;
	std::cout<<"Enter country: ";
	std::cin>>country;
	std::cout<<"Enter number of guns: ";
	std::cin>>numGuns;
	std::cout<<"Enter bore: "
	std::cin>>bore;
	std::cout<<"Enter displacement: ";
	std::cin>>displacement;
	
	EXEC SQL SELECT class FROM Classes WHERE class = :class;
	if(!strcmp(SQLSTATE, "02000")){
		EXEC SQL INSERT INTO Classes
		VALUES(:class, :type, :country, :numGuns, :bore, :displacement);
	}
	
	strcpy(name, class);
	while(1){
		std::cout<<"Enter launched date: "
		std::cin>>date;
		if(!strcmp(date, "q")) break;
		EXEC SQL INSERT INTO Ships
		VALUES(:name, :class, :date);
		std::cout<<"Enter ship name: ";
		std::cin>>name;
		if(!strcmp(date, "q")) break;
	}
}


// d)
void RepairShipLaunchedDate(){
	char ch;
	EXEC SQL BEGIN DECLARE SECTION;
		char ship[20];
		char battle[20];
		char date[20];
		char SQLSTATE[6];
	EXEC SQL END DECLARE SECTION;
	EXEC SQL DECLARE shipCursor INSENSITIVE CURSOR FOR
		SELECT DISTINCT Ships.name, Battles.name
		FROM Ships, Battles, Outcomes
		WHERE Ships.name = Outcomes.ship AND Battles.name = Outcomes.battle AND
			Ships.launched > Battles.date;
	
	EXEC SQL OPEN shipCursor;
	while(1){
		EXEC SQL FETCH shipCursor INTO :ship, :battle;
		if(!strcmp(SQLSTATE, "02000")) break;
		std::cout<<"The date of the launching of ship "<<ship<<" or the date of the battle "<<
			battle<<" is incorrect\nEnter 1 for changing ship's launching date\nEnter 2 for "<<
			"changing date of the battle\n> ";
		std::cin>>ch;
		if(ch == '1'){
			std::cout<<"Enter date: ";
			std::cin>>date;
			// maybe using something liked string2date function here
			EXEC SQL UPDATE Ships SET date = date WHERE name = :ship;
		}
		else if(ch == '2'){
			std::cout<<"Enter date: ";
			std::cin>>date;
			// maybe using something liked string2date function here
			EXEC SQL UPDATE Battles SET date = date WHERE name = :battle;
		}
	}
	EXEC SQL CLOSE shipCursor;
	
	// What if there still are problems after trying to repair?
	// Loop to start and check again
}