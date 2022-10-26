#!/bin/bash
cd /usr/share/nginx/html
git pull origin master
yarn run build
 mv warehouse warehouse-publish  && mv warehouse1 warehouse


