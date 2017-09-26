# Takes database in v1 format and translates it to v2

USE petshop;
ALTER TABLE pet ADD COLUMN neuter BIT NOT NULL AFTER sex;
ALTER TABLE pet ADD COLUMN price FLOAT(7,2) NOT NULL AFTER name;
