# Example prefilling build env vars in Docker

## Usage

```sh
docker build -t prefill-example .

docker run -it --rm -p 8080:80 -e APP_NAME="New App Name" prefill-example

docker run -it --rm -p 8080:80 -e MY_VAR="My Value" prefill-example
```
