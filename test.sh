#!/bin/bash

set -e

echo "Running tests"

RECIPES="$*"

# shellcheck disable=SC2010
test -z "$RECIPES" && RECIPES=$(ls recipes/*.sh | grep -v .test.sh)

for recipe in $RECIPES
do
  if test ! -f "$recipe"
  then
    echo "No such file $recipe"
    exit 1
  fi

  recipeFile=${recipe%.*}
  recipeName=${recipeFile##*/}

  echo "Installing recipe $recipeName"
  INTERACTIVE=no bash "$recipe"

  echo "Testing recipe $recipeName"
  # shellcheck source=/dev/null
  . ~/.profile
  bash "recipes/${recipeName}_test.sh"

done
