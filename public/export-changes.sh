#!/bin/sh

git archive --format=zip HEAD `git diff HEAD^ HEAD --name-only` > ~/Desktop/uliheckmann.com.zip
