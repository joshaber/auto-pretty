#!/bin/sh

if [ -z "$TRAVIS_PULL_REQUEST" ]; then
    echo "Not a pull request"
    exit 0
fi

# Setup our deploy key
openssl aes-256-cbc -K $encrypted_16a3d0995174_key -iv $encrypted_16a3d0995174_iv -in deploy_rsa.enc -out /tmp/deploy_rsa -d

eval "$(ssh-agent -s)"
chmod 600 /tmp/deploy_rsa
ssh-add /tmp/deploy_rsa

# Setup git
git config user.email "travis@travis-ci.com"
git config user.name "Travis CI"

# Travis starts us on a detached HEAD but we need to be on a branch to push.
git checkout -b "prettier-"$TRAVIS_PULL_REQUEST_BRANCH

npm run prettify
git add .
git commit -m "[ci skip] Prettier"

git push "git@github.com:"$TRAVIS_PULL_REQUEST_SLUG".git" HEAD:$TRAVIS_PULL_REQUEST_BRANCH
