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

```
cd ..
docker build -f dockvine_env/Dockerfile-complete . -t dockvine
```
