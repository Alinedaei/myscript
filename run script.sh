#!/bin/bash
sudo mkdir -p /usr/runscript
cd runscript/
touch  runscript.sh

sudo tee /usr/runscript/runscript.sh<<EOF
#!/bin/bash
echo `date`
hostname
find / -type f -name "dropper"
find / -type f -name "paylood"
EOF

toche anssible-run.yml
sudo tee /usr/runscript/anssible-run.yml<<EOF
---
  - name: Playbook
    hosts: all
    become: yes
    become_user: root
    tasks:
      - name: run runscript.sh
        script: /usr/runscript/runscript.sh
EOF


sudo tee crontab -e<<EOF
 
00 12 * * * ansible-playbook/usr/runscript/anssible-run.yml > /var/log/customlog.txt

EOF
echo `this  is complate`

