#!/bin/bash
git add .;git commit -m "update";\
GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD);\
git push origin "$GIT_BRANCH";\
git push origin-gitlab "$GIT_BRANCH"
