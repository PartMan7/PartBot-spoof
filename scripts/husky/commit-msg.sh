#!/usr/bin/env bash

GIT_BRANCH="$(git name-rev --name-only HEAD)"

SECRETS_COMMIT_PATTERN="^secrets?: "
COMMIT_MSG="$(cat $1)"

if [[ "$GIT_BRANCH" == secrets ]]
then
  if [[ "$COMMIT_MSG" =~ $SECRETS_COMMIT_PATTERN ]]
  then
    echo "'$COMMIT_MSG'" did not match "'$SECRETS_COMMIT_PATTERN'"
    exit 1
  fi
elif [[ "$COMMIT_MSG" =~ $SECRETS_COMMIT_PATTERN ]]
then
  echo "'$COMMIT_MSG'" matched "'$SECRETS_COMMIT_PATTERN'" despite not being on the secrets branch\!
  exit 1
fi
