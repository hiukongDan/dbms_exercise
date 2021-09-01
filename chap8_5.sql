8.5.1
a) supposed we update Movie, year 1999 INTO 2001 and title 'Titanic' INTO 'Star Wars'
UPDATE MovieProd
SET year = 2001, title = 'Star Wars', name = (SELECT name FROM MovieExec WHERE movieYear = 2001
	AND movieTitle = 'Star Wars')
WHERE year = 1999 AND title = 'Titanic';


b) supposed we update MovieExec, producer# 100 with 200
Update MovieProd
SET name = (SELECT name FROM MovieExec WHERE producer# = 200)
WHERE (year, title) IN (SELECT year, title FROM Movies WHERE cert# = 200);


8.5.2
1) type change from 'pc' to others -> delete tuple from NewPC
2) model delete or udpate on speed, ram, hd, price  -> do the same



8.5.3
1) change on displacement		-> update and recalculate
2) add more ships or delete ships	-> insert/delete tuples
3) change on country		-> change country


8.5.4
...