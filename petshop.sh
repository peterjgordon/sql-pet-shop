#!/bin/bash

if [ $# == 0 ]
then
echo
echo "Pet Shop Management Interface"
echo "Usage: $0"
echo "  --view [pet/keeper/pet_keeper/species] : show a table"
echo
echo "  --add pet     : register a new pet"
echo "  --add keeper  : register a new keeper"
echo "  --add species : register a new species"
echo
echo "  --keeper : add a keeper to a pet"
echo "  --neuter : change the neuter status of a pet"
echo "  --price  : change the value of a pet"
echo "  --death  : set the death date of a pet"
echo
exit -1
fi

printf "USE petshop;\n" > changes.sql
view_table=pet

case $1 in
	--view)
		if [ ! $# -lt 2 ]
		then
			view_table=$2
		fi
		echo "Showing the $view_table table.";
		echo
		# the table is shown at the end, see after the 'case'
		;;
	--add)
		if [ $# -lt 2 ]
		then
			echo "Please specify the record type to add."
			exit -1
		fi
		case $2 in
			pet)
				echo ": What is the animal's name?"
				read pet_name
				echo ": How much is the animal worth?"
				read pet_price
				echo ": What gender is the animal?"
				read pet_gender
				case $pet_gender in
					male|m|Male|M)
						pet_gender="'m'"
						;;
					female|f|Female|F)
						pet_gender="'f'"
						;;
					*)
						pet_gender=null
						;;
				esac
				echo ": Is the animal neutered?"
				read pet_neuter
				case $pet_neuter in
					yes|y|Yes|Y|1|true|True)
						pet_neuter=1
						;;
					*)
						pet_neuter=0
						;;
				esac
				echo ": What is the animal's date of birth?"
				echo ": Format: yyyy-mm-dd"
				read pet_birth
				echo ": What is the animal's date of death?"
				echo ": [leave blank if still alive]"
				echo ": Format: yyyy-mm-dd"
				read pet_death
				if [ ! $pet_death ]
				then
					pet_death=null
				else
					pet_death="'$pet_death'"
				fi
				echo ": What is the animal's species?"
				echo ": This is case sensitive."
				read pet_species
				printf "INSERT INTO pet(name,price,sex,neuter,birth,death,speciesID) VALUES('$pet_name', $pet_price, $pet_gender, $pet_neuter, '$pet_birth', $pet_death, (SELECT id FROM species WHERE name = '$pet_species'));\n" >> changes.sql
				;;
			keeper)
				echo ": What is the keeper's name?"
				read keeper_name
				printf "INSERT INTO keeper(name) VALUES('$keeper_name');\n" >> changes.sql
				view_table=keeper
				;;
			species)
				echo ": What is the species name?"
				read species_name
				printf "INSERT INTO species(name) VALUES('$species_name');\n" >> changes.sql
				view_table=species
				;;
			*)
				echo "'$2' is an invalid record type."
				exit -1
				;;
		esac
		;;
	--keeper)
		echo ": What is the pet's name?"
		read pet_name
		echo ": What is the keeper's name?"
		read keeper_name
		printf "INSERT INTO pet_keeper VALUES((SELECT id FROM pet WHERE name = '$pet_name'), (SELECT id FROM keeper WHERE name = '$keeper_name'));\n" >> changes.sql
		view_table=pet_keeper
		;;
	--neuter)
		echo ": What is the pet's name?"
		read pet_name
		echo ": Is the pet neutered?"
		read pet_neuter
		case $pet_neuter in
			yes|y|Yes|Y|1|true|True)
				pet_neuter=1
				;;
			*)
				pet_neuter=0
				;;
		esac
		printf "UPDATE pet SET neuter = $pet_neuter WHERE name = '$pet_name';\n" >> changes.sql
		;;
	--price)
		echo ": Whats is the pet's name?"
		read pet_name
		echo ": How much is the pet worth?"
		read pet_price
		printf "UPDATE pet SET price = $pet_price WHERE name = '$pet_name';\n" >> changes.sql
		;;
	--death)
		echo ": What is the pet's name?"
		read pet_name
		echo ": What is the date of death?"
		echo ": [leave blank if still alive]"
		echo ": Format: yyyy-mm-dd"
		read pet_death
		if [ ! $pet_death ]
		then
			pet_death=null
		else
			pet_death="'$pet_death'"
		fi
		printf "UPDATE pet SET death = $pet_death WHERE name = '$pet_name';\n" >> changes.sql
		;;
	*)
		echo "'$1' is an invalid flag."
		exit -1;
		;;
esac

# Show table values
printf "SELECT * FROM $view_table;" >> changes.sql

# Commit changes to database
echo "Your changes will now be committed to the database."
mysql -uroot -p < changes.sql
