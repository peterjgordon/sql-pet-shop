CREATE DATABASE IF NOT EXISTS pet-shop;
DROP TABLE IF EXISTS (species,pet,pet_keeper,keeper);

CREATE TABLE species (
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(20) NOT NULL
);
insert into species values('Dog');
insert into species values('Cat');
insert into species values('Snake');
insert into species values('Bird');
insert into species values('Hamster');
insert into species values('Giraffe');

CREATE TABLE pet (
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(20),
	sex CHAR(1),
	birth DATE,
	death DATE,
	speciesID INT NOT NULL FOREIGN KEY REFERENCES species(id)
);
insert into pet values('Fluffy', 'f', '1993-02-04', null, 2);
insert into pet values('Claws', 'm', '1994-03-17', null, 2);
insert into pet values('Buffy', 'f', '1989-05-13', null, 1);
insert into pet values('Fang', 'm', '1990-08-27', null, 1);
insert into pet values('Bowser', 'm', '1979-08-31', '1995-07-29', 1);
insert into pet values('Chirpy', null, '1997-12-09', null, 4);
insert into pet values('Whistler', null, '1997-12-09', null, 4);
insert into pet values('Slim', 'm', '1996-04-29', null, 3);
insert into pet values('Puffball', 'f', '1999-03-30', null, 5);

CREATE TABLE pet_keeper (
	petID INT NOT NULL FOREIGN KEY REFERENCES pet(id),
	keeperID INT NOT NULL FOREIGN KEY REFERENCES keeper(id),
	PRIMARY KEY(petID, keeperID)
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

CREATE TABLE keeper (
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(20) NOT NULL
);
insert into keeper values('Harold');
insert into keeper values('Gwen');
insert into keeper values('Benny');
insert into keeper values('Diane');