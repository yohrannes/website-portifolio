#!/bin/bash

# This script is used to push my project for github and gitlab simultaneously. To to this, i do this steps:
# 1 - Import my projet from github to gitlab.
# 2 - Autenticate my local public key with my gitlab account.
# 3 - git remote add gitlab git@gitlab.com:yohrannes/website-portifolio.git

read -p "Commit comment:" coment

push-main () {
	git add .
	git commit -m "${coment}"
	echo "${coment}"
	git push origin main
	git push gitlab main
}

push-main
