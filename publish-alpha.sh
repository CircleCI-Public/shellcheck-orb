#!/bin/bash

circleci config pack src > orb.yml
circleci orb publish orb.yml circleci/shellcheck@dev:alpha
rm -rf orb.yml
