use petshop
SELECT name 
FROM pet 
WHERE pet.ID IN
	(SELECT keeper.id 
		FROM keeper
	 	INNER JOIN pet_keeper ON pet_keeper.keeperID = keeper.id 
		WHERE keeper.name like "John Smith") 
