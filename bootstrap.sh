#!/bin/bash
set -e

PROJECT_SRC=${APP_PATH:-"/var/app/src"}
PROJECT_SCR=${SCRIPT_PATH:-"/var/app/scripts"}

PROJECT_BRANCH=${BRANCH:-master}

echo ""
if [ -z "$GIT" ]
then
  echo "\$GIT not found"
  exit 1;
fi

if [ ! -d "$PROJECT_SRC" ] || [ -z "$(ls -A -- ${PROJECT_SRC})" ]; then
  echo "Creating app folder at ${PROJECT_SRC}..."
  mkdir -p $PROJECT_SRC

  echo "Cloing app from ${GIT} and branch ${PROJECT_BRANCH}"
  git clone --single-branch --branch $PROJECT_BRANCH $GIT $PROJECT_SRC
else
  cd $PROJECT_SRC
  
  echo "Removing any modification"
  git checkout .

  echo "Doing checkout to ${PROJECT_BRANCH}"
  git checkout $PROJECT_BRANCH

  echo "Updating branch"
  git pull origin $PROJECT_BRANCH
fi
echo ""
echo "Entering project folder"
cd $PROJECT_SRC
echo `ls -l`
echo ""
echo "Starting build and run"
if [ -d ${PROJECT_SCR} ]; then
  if [ -z "$(ls -A -- ${PROJECT_SCR})" ]; then
    echo "Installing deps"
    npm install  
  else
    echo "Running custom scripts"
    for f in $PROJECT_SCR/*.sh; do  
      echo "Running $f..."
      bash "${PROJECT_SCR}/${f}" -H 
    done
  fi
else
  echo "Installing deps"
  npm install  
fi

if [ ! -z "$SEQUELIZE_CONFIG" ]; then
  echo '{' > config/config.json
  echo '  "'$SEQUELIZE_ENV'": {' >> config/config.json
  echo '  "username": "'$SEQUELIZE_USER'",' >> config/config.json
  echo '  "password": "'$SEQUELIZE_PASS'",' >> config/config.json
  echo '  "database": "'$SEQUELIZE_DB'",' >> config/config.json
  echo '  "host": "'$SEQUELIZE_HOST'",' >> config/config.json
  echo '  "dialect": "'$SEQUELIZE_DIALECT'"' >> config/config.json
  echo '  }' >> config/config.json
  echo '}' >> config/config.json
fi

echo "Starting App"
npm start