# SQL Pet Shop

The original file comes from [this repository](https://github.com/Spencerooni/mysql/blob/master/pet.sql).
The data must be normalised into 3NF.

## Usage

The frontend script can be used to perform most actions on the database.
You can view the usage by typing this command from the console:

```
./petshop.sh
```

You can apply the script using this command:

```
mysql -u root -p < create.sql
mysql -u root -p < upgrade-v2.sql
```
