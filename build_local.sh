docker build -t dart-server .
docker run -it --rm -p 8080:3000 --name myserver dart-server