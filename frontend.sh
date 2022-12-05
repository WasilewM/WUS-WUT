#!/bin/sh

az vm run-command invoke --command-id RunShellScript \
                         --name wus-lab1-frontend \
                         --resource-group wus-lab1-rg \
                         --scripts '
sudo apt update;
sudo apt upgrade -y;
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash;

export NVM_DIR="$HOME/.nvm";
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh";
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion";

nvm install 16;
git clone https://github.com/spring-petclinic/spring-petclinic-angular;
cd spring-petclinic-angular;
npm install;
npm install -g angular-http-server;
npm run build -- --prod;
nohup npx angular-http-server --path ./dist -p 8000 > angular.out 2> angular.err &'