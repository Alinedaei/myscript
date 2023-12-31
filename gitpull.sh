 #!/bin/bash
sudo  ssh-keygen -C http://azuredevops/Modiseh/modiseh_warehouseDashboard
sudo  cat  /root/.ssh/id_rsa.pub
#sshkey copy to security --->add ssh public-key and seve 
#first make file and folder
sudo mkdir /usr/share/nginx/modisehprv
sudo cd /usr/share/nginx/modisehprv
git clone ssh://azuredevops:22/Modiseh/modiseh_warehouseDashboard/_git/modiseh_warehouseDashboard
sudo touch modisehprv.sh

#make new configfile nginx
touch /etc/nginx/conf.d/modisehprv.conf
sudo tee modisehprv.conf <<EOF
server {
    listen 8081 ssl;
    root  /usr/share/nginx/modisehprv/modiseh_warehouseDashboard;

    server_name  prvwh2.modiseh.com;
    #ssl_certificate /home/admin/prvw.modiseh.com/fullchain1.pem; # managed by Certbot
    #ssl_certificate_key /home/admin/prvw.modiseh.com/privkey1.pem; # managed by Certbot
   ssl_certificate /root/modiseh.crt; # managed by Certbot
    ssl_certificate_key /root/modiseh.key; # managed by Certbot

   more_set_headers 'Access-Control-Allow-Origin: *';

   more_set_headers 'Access-Control-Allow-Credentials: false';
   more_set_headers 'Access-Control-Allow-Headers: *';
    #error_page 497 301 =307 https://$host:$server_port$request_uri;
    location / {
     if ($request_method = 'OPTIONS') {
                # Tell client that this pre-flight info is valid for 20 days
                add_header 'Access-Control-Max-Age' -1;
                add_header 'Content-Type' 'text/plain charset=UTF-8';
                add_header 'Content-Length' 0;
                return 204;
        }
    add_header 'Access-Control-Allow-Origin' "*";
    add_header 'Access-Control-Allow-Credentials' "false";
    add_header 'Access-Control-Allow-Headers' "*";
    proxy_pass http://172.20.16.150:8080;
    proxy_set_header X-Real-IP  $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto https;
    proxy_set_header X-Forwarded-Port 443;
    proxy_set_header Host $host;
    proxy_set_header "Access-Control-Allow-Origin" "*";
    }
}

EOF

sudo nginx -t
sudo nginx -s reload

sudo tee /usr/share/nginx/modisehprv/modisehprv.sh <<EOF
#!/bin/bash
cd /usr/share/nginx/modisehprv/modiseh_warehouseDashboard
git pull origin master
yarn run build
 mv warehouse warehouse-publish  && mv warehouse1 warehouse

EOF
sudo sh modisehprv.sh

echo "this is complate"



