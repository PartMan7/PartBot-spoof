#!/usr/bin/env bash

set -e

GIT_BRANCH="$(git name-rev --name-only HEAD)"

case $1 in
  public)
    echo Publishing to public repo...

    if [[ "$GIT_BRANCH" == secrets ]]
    then
      echo On secrets branch - aborting
      exit 1
    fi

    git fetch public main
    if git log public/main..@ --format='format:%s' | grep -Pq 'secrets?:'
    then
      echo Found a commit with "'secrets'" in the name\; failing publish...
      exit 1
    fi
    git rebase FETCH_HEAD
    git push public main
  ;;

  secrets)
    echo Publishing to SECRET repo!

    if [[ "$GIT_BRANCH" != secrets ]]
    then
      echo Not on secrets branch - aborting
      exit 1
    fi

    git fetch public main
    git rebase public/main
    git fetch secret main
    git rebase public/main secret/main
    git rebase secret/main secrets
    if git log secret/main..@ --format='format:%s' | grep -vPq 'secrets?:'
    then
      echo Found a commit without "'secrets'" in the name\; failing publish... \(all commits must include the word "'secrets'"\)
      exit 1
    fi
    git push secret secrets:main --force # Lease won't work here because we already updated the HEAD earlier
  ;;

  *)
    echo "No match found for $1"
    exit 1
  ;;
esac
