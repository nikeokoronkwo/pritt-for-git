# Start with a base image
FROM dart:stable AS build

SHELL ["/bin/bash", "-c"]

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y wget

# Get ruby
RUN apt-get install -y ruby-full

# Installing node via nvm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

RUN source ~/.nvm/nvm.sh && nvm install 20

# Install golang
RUN wget https://go.dev/dl/go1.22.2.linux-arm64.tar.gz

# Golang will require extra steps
RUN rm -rf /usr/local/go && tar -C /usr/local -xzf go1.22.2.linux-arm64.tar.gz

RUN export PATH=$PATH:/usr/local/go/bin\nexport GOROOT=/usr/local/go && \
    echo "export PATH=$PATH:/usr/local/go/bin\nexport GOROOT=/usr/local/go" >> ~/.bashrc && \
    source ~/.bashrc

# Move to pritt app dir
WORKDIR /pritt-app

# Copy code
COPY . .
RUN ./tools/build -o . --go-path /usr/local/go/bin/go --node-path $HOME/.nvm/versions/node/v20.12.2/bin

EXPOSE 8080

RUN ls build

CMD ["/pritt-app/build/bin/pritt", "-p", "8080"]

LABEL maintainer="Nike Okoronkwo"
LABEL version="1.0"
LABEL description="Pritt Server: Git Analysis on your machine"