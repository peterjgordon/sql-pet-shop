use petshop 
SELECT name, (select count(*) from pet_keeper WHERE keeper.id = pet_keeper.keeperID) AS NumberOfPets from keeper;
