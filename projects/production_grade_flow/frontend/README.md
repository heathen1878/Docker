# React Front End

Built from

```shell
npx create-react-app frontend
```

## Docker

Container is built from an enviroment specific dockerfile...

## Docker Compose

Docker compose is used to ensure the container starts with the custom parameters such as ports, volumes etc.

`docker compose up`

## Multi-stage Docker build

See [dockerfile](./dockerfile)

`docker build -t frontend:latest .`

`docker run -p 80:80 frontend`

[result](http://localhost)