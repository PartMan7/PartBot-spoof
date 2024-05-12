#!/usr/bin/env bash

GIT_BRANCH="$(git name-rev --name-only HEAD)"
PUBLIC_REPO="https://github.com/PartMan7/PartBot-spoof.git"
SECRET_REPO="https://github.com/PartMan7/PartBot-secrets.git"

case $1 in
  public)
    echo Publishing to public repo...

    git fetch $PUBLIC_REPO $GIT_BRANCH
    if git log FETCH_HEAD..@ --format='format:%s' | grep -Pq 'secrets?:'
    then
      echo Found a commit with "'secrets'" in the name\; failing publish...
      exit 1
    fi
    git rebase FETCH_HEAD
    git push $PUBLIC_REPO $GIT_BRANCH
  ;;

  secrets)
    echo Publishing to SECRET repo!

    git fetch $SECRET_REPO $GIT_BRANCH
    git rebase FETCH_HEAD
    if git log FETCH_HEAD..@ --format='format:%s' | grep -vPq 'secrets?:'
    then
      echo Found a commit without "'secrets'" in the name\; failing publish... \(all commits must include the word "'secrets'"\)
    fi
    git fetch $PUBLIC_REPO $GIT_BRANCH
    git rebase FETCH_HEAD
    git push $SECRET_REPO $GIT_BRANCH --force-with-lease
  ;;
esac
