use petshop
SELECT name, price FROM  pet WHERE EXISTS(SELECT * FROM pet_keeper WHERE pet.ID = pet_keeper.petID) AND neuter = 0;
 
