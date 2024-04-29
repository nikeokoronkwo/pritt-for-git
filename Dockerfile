# Start with a base image
FROM dart:stable AS build

# Get dependencies
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y ruby-full nodejs npm 

# Golang will require extra steps
RUN rm -rf /usr/local/go && tar -C /usr/local -xzf go1.22.2.linux-amd64.tar.gz

RUN echo "export PATH=$PATH:/usr/local/go/bin" >> ~/.bashrc

RUN source ~/.bashrc

# Move to pritt app dir
WORKDIR /pritt-app

# Get Yarn - Recommended
RUN npm install --global yarn

# Copy code
COPY . .
RUN ./tool/build -o .

# Until path export is ready
WORKDIR /pritt-app/build

EXPOSE 8080

CMD ["./bin/pritt", "-p", "8080"]

LABEL maintainer="Nike Okoronkwo"
LABEL version="1.0"
LABEL description="Pritt Server: Git Analysis on your machine"