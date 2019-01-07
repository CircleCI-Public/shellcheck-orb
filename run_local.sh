#!/bin/bash

rm -rf local
mkdir -p local/orbs

cat << EOL > local/config.yml
version: 2.1

orbs:
  diag: circleci/diagnostic-orb@volatile

executors:
  default:
    docker:
      - image: circleci/python

jobs:
  build:
    executor: default
    steps:
      - run: echo lol

workflows:
  my-workflow:
    jobs:
      - build:
          pre-steps:
            - diag/sample-test-data:
                upload: true
          post-steps:
            - diag/post-steps
EOL

circleci config pack orb > local/orbs/diag.yml || exit
circleci config pack local > packed.yml || exit
circleci config process packed.yml > processed.yml || exit
circleci build -c processed.yml
