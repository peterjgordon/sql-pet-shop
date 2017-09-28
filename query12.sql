use petshop
SELECT name from keeper WHERE NOT EXISTS(SELECT id FROM pet_keeper WHERE pet_keeper.keeperID = keeper.id);
