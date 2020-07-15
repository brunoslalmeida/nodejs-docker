![CI](https://github.com/brunoslalmeida/nodejs-docker/workflows/CI/badge.svg)
[![DockerPulls](https://img.shields.io/docker/pulls/aquelatecnologia/host-nodejs.svg)](https://registry.hub.docker.com/u/aquelatecnologia/host-nodejs/)
[![DockerStars](https://img.shields.io/docker/stars/aquelatecnologia/host-nodejs.svg)](https://registry.hub.docker.com/u/aquelatecnologia/host-nodejs/)

# Usage

To use this docker container you should this execute this command:

`$ docker run -d -e GIT=http[s]://[GIT_PATH]/.git aquelatecnologia/host-nodejs`

then run a `docker logs [CONTAINER_ID]` to see if it is all ok.

## Connect to Docker

As it's not possible to dinamically expose ports from the container I choose to expose 8081. If you need to change this for any reason you can both fork this project or just map you local port to the 8081 like this.

`-p [LOCAL_PORT]:8081`

If you use sockfile to connect to your NodeJS, you can map a volume to the file or folder and just forget about the 8081 port.

`-v [LOCAL_PATH]:/var/app/src/[PATH_TO_SOCKFILE]`

## Run step

By default the bootstrap script will only run on pre-run command:

`$ npm install`

If you need to run yours custom scripts at pre-run phase all you have to do is to map a script folder and name your scripts in order of exectuion (internally the bootstrap will run each *.sh file inside this script folder, so to run in the correct order is recommended that once you run ls commands the files are ordered correclty).

`-v [YOUR_SCITPS_PATH]:/var/app/scripts/`

### ATTENTION

* All scripts run from the APP_PATH context/folder. So is not needed to add path or context to them.

* The `$ npm install` command is not called if you define your custom scripts, this have to handled by your scripts.

After all this steps the bootstrap will run `$ npm start` to run your app.

## GIT

To define you git remote repository all you have to do is add a EVN for that

`-e GIT=http[s]://[GIT_PATH]/.git`

### Password protected git

In case you have a password protected git add username and password to the GIT variable.

`-e GIT=https://[USER]:[PASS]@[GIT_PATH]/.git`

Do not forget to encode you user and password if any of them hase special caracters.

### SSH Key protected git

In case you have a ssh key protected git share with the container you ssh GIT keys and config file

`-v [YOUR_SSH_PATH]:~/.ssh/`

### Changing Default Branch

By default the Bootstrap script will use *master* as it default branch. If you need to change that, just add a ENV for this.

`-e BRANCH=[YOUR_BRANCH]`

## Custom PATHS

If for any case you need to change the defaul path for the app or the scripts folder you can do that by adding a ENV for thoses.

### App folder (default: /var/app/src)

`-e APP_PATH=[YOUR_APP_PATH]`

### Scripts folder (default: /var/app/scripts)

`-e SCRIPT_PATH=[YOUR_SCRIPT_PATH]`
