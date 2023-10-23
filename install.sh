sudo apt update -y
# install required services
sudo apt install -y gnupg curl
sudo apt install -y git
sudo apt install -y openjdk-11-jdk
sudo apt install -y zip unzip
# install postgres
sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
sudo apt update -y
sudo apt install -y postgresql-14 
sudo apt install -y redis
sudo apt install -y tomcat9
curl -fsSL https://pgp.mongodb.com/server-7.0.asc | \
   sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg \
   --dearmor
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list
sudo apt update -y
sudo apt-get install -y mongodb-org
#install gradle
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk install gradle 7.3.3
# running required services
sudo systemctl daemon-reload
sudo systemctl start mongod
sudo systemctl start postgresql
sudo systemctl start redis
sudo systemctl start tomcat9
# launch services on startup
sudo systemctl enable mongod
sudo systemctl enable postgresql
sudo systemctl enable redis-server
sudo systemctl enable tomcat9
