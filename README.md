# SQL Pet Shop

The original file comes from [this repository](https://github.com/Spencerooni/mysql/blob/master/pet.sql).
The data must be normalised into 3NF.

## Usage

You can apply the script using this command:

```
mysql -u root -p < pet.sql
```

## Changes from original

* A pet can have multiple owners
* New column for checking if neutered - assume existing pets aren't neutered
* Price - the value of the animals
* Existing data must be preserved



