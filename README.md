# dockvine_env
```sh
# Clone this repository alongside the other 4 repositories.
cd /path/to/dockvine-repositories
git clone git@bitbucket.org:dockvine/dockvine_env.git
docker-compose up
```

One image will be created containing an Apache 2.4 instance already configured to serve 4 virtual hosts (wx, corp, api, toolbar).

Two containers will be started, one from the above image, and one from a MySQL image (already configured).


## Complete Image

### Building Image
```
# clone from docker branch with all submodules
mkdir docker-2020-06 && cd docker-2020-06
git clone --recurse-submodules git@bitbucket.org:boomtony/dockvine_env.git -b docker-2020-06
cd dockvine_env
docker build -f dockvine_env/Dockerfile-complete . -t dockvine
```

## RUNNING Image

```
# will listen locally on 8080 e.g. http://127.0.0.1:8080
# see TESTING cmds
docker run -d -v`pwd`/log:/var/log/ -p80:80  dockvine  --name=dockvine
```

## TESTING

```
curl -v -H"Host:toolbar-local.dockvine.com" http://cloud9-env1.tonymet.com:8080/widget/
curl -v -H"Host:wix-local.dockvine.com" http://cloud9-env1.tonymet.com:8080/widget/
curl -v -H"Host:www-local.dockvine.com" http://cloud9-env1.tonymet.com:8080/widget/
```
