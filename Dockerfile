# Start with a base image
FROM dart:stable AS build

WORKDIR /usr/local/pritt

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y 

# Copy code
COPY . .
RUN ./tool/build -o .

EXPOSE 8080

CMD ["pritt", "-p", "8080"]

LABEL maintainer="Nike Okoronkwo"
LABEL version="1.0"
LABEL description="Pritt Server: Git Analysis on your machine"