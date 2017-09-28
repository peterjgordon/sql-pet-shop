#!/bin/bash

if [ $# == 0 ]
then
echo
echo "Pet Shop Management Interface"
echo "Usage: $0"
echo "  --create  : run this if the database hasn't been created yet"
echo "  --upgrade : keep existing data from v1 and upgrade to v2"
echo
echo "  --view [pet/keeper/pet_keeper/species] : show a table"
echo "  --query [number] : run the specified query (1-17)"
echo
echo "  --add pet     : register a new pet"
echo "  --add keeper  : register a new keeper"
echo "  --add species : register a new species"
echo
echo "  --del pet     : delete a pet"
echo "  --del keeper  : delete a keeper"
echo "  --del species : delete a species"
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
	--create)
		echo "The database will be created."
		echo "WARNING! Existing data will be deleted."
		cat create.sql >> changes.sql
		cat upgrade-v2.sql >> changes.sql
		;;
	--upgrade)
		echo "The database will be upgraded from v1 to v2."
		echo "Existing data will be saved."
		cat upgrade-v2.sql >> changes.sql
		;;
	--view)
		if [ ! $# -lt 2 ]
		then
			view_table=$2
		fi
		echo "Showing the $view_table table.";
		echo
		# the table is shown at the end, see after the 'case'
		;;
	--query)
		if [ $# -lt 2 ]
		then
			echo "Please specify a query to run (1-17)."
			exit -1
		fi
		# Append 0 (e.g. 01) if it hasn't been supplied
		file=$2
		if [ -f queries/query0$file.sql ]
		then
			file=0$file
		fi
		cat queries/query$file.sql >> changes.sql
		unset view_table
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
	--del)
		if [ $# -lt 2 ]
		then
			echo "Usage: $0 --del <pet/keeper/species>"
			exit -1
		fi
		echo ": Enter the $2 name."
		read name
		if [ $2 == pet ]
		then
			col=PetID
		fi
		if [ $2 == keeper ]
		then
			col=KeeperID
		fi

		if [ $col ]
		then
			printf "DELETE FROM pet_keeper WHERE $col = (SELECT id FROM $2 WHERE name = '$name');\n" >> changes.sql
		fi
		printf "DELETE FROM $2 WHERE name = '$name';\n" >> changes.sql
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
if [ $view_table ]
then
	printf "SELECT * FROM $view_table;" >> changes.sql
fi

# Commit changes to database
echo
echo "Your changes will now be committed to the database."
echo
mysql -uroot -p < changes.sql
