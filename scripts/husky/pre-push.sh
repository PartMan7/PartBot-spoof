#!/usr/bin/env bash

if [[ "$SCRIPTED_GIT_PUSH" != publish ]]
then
  echo Use "'npm publish-public/publish-secret'!"
  exit 1
fi
