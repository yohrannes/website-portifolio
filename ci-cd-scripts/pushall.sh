#!/bin/bash

read -p "Commit comment:" coment

push-main () {
	git add .
	git commit -m "${coment}"
	echo "${coment}"
	git push origin main
	git push gitlab main
}

push-main
