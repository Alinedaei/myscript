#!/bin/bash
mkdir /usr/local/jwt
cd /usr/local/jwt
touch findjwt.yml
sudo tee findjwt.yml<<EOF
---
  - name: Playbook
    hosts: all
    become: yes
    tasks:
      - name: run script
        script: /usr/local/jwt/findjwt.sh
EOF
toch findjwt.sh
sudo tee findjwt.sh<<EOF
#!/bin/bash
echo "date"
echo "hostname"
python3 -m pip show djangorestframework_simplejwt

EOF

sudo ansible-playbook findjwt.yml
