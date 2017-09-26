CREATE DATABASE IF NOT EXISTS petshop;
USE petshop;
DROP TABLE IF EXISTS pet_keeper,pet,keeper,species;

CREATE TABLE species (
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(20) NOT NULL
);
insert into species(name) values('Dog');
insert into species(name) values('Cat');
insert into species(name) values('Snake');
insert into species(name) values('Bird');
insert into species(name) values('Hamster');
insert into species(name) values('Giraffe');

CREATE TABLE pet (
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(20),
	sex CHAR(1),
	birth DATE,
	death DATE,
	speciesID INT NOT NULL,
	FOREIGN KEY (speciesID) REFERENCES species(id)
);
insert into pet(name,sex,birth,death,speciesID) values('Fluffy', 'f', '1993-02-04', null, 2);
insert into pet(name,sex,birth,death,speciesID) values('Claws', 'm', '1994-03-17', null, 2);
insert into pet(name,sex,birth,death,speciesID) values('Buffy', 'f', '1989-05-13', null, 1);
insert into pet(name,sex,birth,death,speciesID) values('Fang', 'm', '1990-08-27', null, 1);
insert into pet(name,sex,birth,death,speciesID) values('Bowser', 'm', '1979-08-31', '1995-07-29', 1);
insert into pet(name,sex,birth,death,speciesID) values('Chirpy', null, '1997-12-09', null, 4);
insert into pet(name,sex,birth,death,speciesID) values('Whistler', null, '1997-12-09', null, 4);
insert into pet(name,sex,birth,death,speciesID) values('Slim', 'm', '1996-04-29', null, 3);
insert into pet(name,sex,birth,death,speciesID) values('Puffball', 'f', '1999-03-30', null, 5);

CREATE TABLE keeper (
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(20) NOT NULL
);
insert into keeper(name) values('Harold');
insert into keeper(name) values('Gwen');
insert into keeper(name) values('Benny');
insert into keeper(name) values('Diane');

CREATE TABLE pet_keeper (
	petID INT NOT NULL,
	keeperID INT NOT NULL,
	PRIMARY KEY(petID, keeperID),
	FOREIGN KEY (petID) REFERENCES pet(id),
	FOREIGN KEY (keeperID) REFERENCES keeper(id)
);
insert into pet_keeper values(1,1);
insert into pet_keeper values(2,2);
insert into pet_keeper values(3,1);
insert into pet_keeper values(4,3);
insert into pet_keeper values(5,4);
insert into pet_keeper values(6,2);
insert into pet_keeper values(7,2);
insert into pet_keeper values(8,3);
insert into pet_keeper values(9,4);
