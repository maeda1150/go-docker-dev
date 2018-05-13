## How to build

```
$ docker login
$ docker build --tag masaki1111/golang-vim-dev:latest .
$ docker push masaki1111/golang-vim-dev:latest
$ docker tag masaki1111/golang-vim-dev:latest masaki1111/golang-vim-dev:{{x.x.x}}
$ docker push masaki1111/golang-vim-dev:{{x.x.x}}
```
