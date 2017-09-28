use petshop
SELECT name, COUNT(name) AS NumberOfPets FROM pet GROUP BY name;
