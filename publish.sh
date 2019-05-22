set -xe

HOST=188.166.44.103

ssh root@$HOST  "cd /root/discord-rp-bot && git stash && git pull origin master && git stash apply && pm2 restart all"
