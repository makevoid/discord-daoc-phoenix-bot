set -xe

HOST=188.166.44.103

ssh root@$HOST "cd /root/discord-rp-bot && pm2 logs"
