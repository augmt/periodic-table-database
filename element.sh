#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ATOMIC_NUMBER=$1
    ELEMENT=$($PSQL "
      SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius
      FROM elements
        INNER JOIN properties USING(atomic_number)
        INNER JOIN types USING(type_id)
      WHERE atomic_number = $ATOMIC_NUMBER
    ")
  elif [[ $1 =~ ^[A-Z][a-z]?$ ]]
  then
    SYMBOL=$1
    ELEMENT=$($PSQL "
      SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius
      FROM elements
        INNER JOIN properties USING(atomic_number)
        INNER JOIN types USING(type_id)
      WHERE symbol = '$SYMBOL'
    ")
  else
    NAME=$1
    ELEMENT=$($PSQL "
      SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius
      FROM elements
        INNER JOIN properties USING(atomic_number)
        INNER JOIN types USING(type_id)
      WHERE name = '$NAME'
    ")
  fi
  if [[ -z $ELEMENT ]]
  then
    echo "I could not find that element in the database."
  else
    echo "$ELEMENT" | while IFS="|" read ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  fi
fi
