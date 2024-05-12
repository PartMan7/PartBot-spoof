#!/usr/bin/env bash

set -e

GIT_BRANCH="$(git name-rev --name-only HEAD)"
PUBLIC_REPO="https://github.com/PartMan7/PartBot-spoof.git"
SECRET_REPO="https://github.com/PartMan7/PartBot-secrets.git"

case $1 in
  public)
    echo Publishing to public repo...

    if [[ "$GIT_BRANCH" == secrets ]]
    then
      echo On secrets branch - aborting
      exit 1
    fi

    git fetch $PUBLIC_REPO main
    if git log FETCH_HEAD..@ --format='format:%s' | grep -Pq 'secrets?:'
    then
      echo Found a commit with "'secrets'" in the name\; failing publish...
      exit 1
    fi
    git rebase FETCH_HEAD
    git push $PUBLIC_REPO main
  ;;

  secrets)
    echo Publishing to SECRET repo!

    if [[ "$GIT_BRANCH" != secrets ]]
    then
      echo Not on secrets branch - aborting
      exit 1
    fi

    git fetch $SECRET_REPO main
    git rebase FETCH_HEAD
    if git log FETCH_HEAD..@ --format='format:%s' | grep -vPq 'secrets?:'
    then
      echo Found a commit without "'secrets'" in the name\; failing publish... \(all commits must include the word "'secrets'"\)
      exit 1
    fi
    git fetch $PUBLIC_REPO main
    git rebase FETCH_HEAD
    git push $SECRET_REPO secrets:main --force # Lease won't work here because we already updated the HEAD earlier
  ;;
esac
