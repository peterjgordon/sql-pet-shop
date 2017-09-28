use petshop
SELECT name, price FROM  pet WHERE NOT EXISTS(SELECT * FROM pet_keeper WHERE pet.ID = pet_keeper.petID);
 
