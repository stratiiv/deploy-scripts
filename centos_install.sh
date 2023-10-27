yum install -y epel-release
yum install -y ca-certificates curl gnupg
mkdir -p /etc/yum/keys


echo -e "[pgdg]\nname=PostgreSQL PGDG\nbaseurl=https://download.postgresql.org/pub/repos/yum/reporpms/EL-\$releasever-\$basearch\nenabled=1\ngpgcheck=1\ngpgkey=file:///etc/yum/keys/postgresql-archive-keyring.gpg" > /etc/yum.repos.d/pgdg.repo
curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor -o /etc/yum/keys/postgresql-archive-keyring.gpg

echo -e "[mongodb-org-7.0]\nname=MongoDB Repository\nbaseurl=https://repo.mongodb.org/yum/redhat/7/mongodb-org/7.0/x86_64/\ngpgcheck=1\ngpgkey=file:///etc/yum/keys/mongodb-server-7.0.gpg" > /etc/yum.repos.d/mongodb-org-7.0.repo
curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | gpg --dearmor -o /etc/yum/keys/mongodb-server-7.0.gpg

curl -sL https://rpm.nodesource.com/gpgkey/nodesource.gpg -o /etc/pki/rpm-gpg/nodesource.gpg
NODE_MAJOR=20
echo -e "[nodesource]\nname=Node.js Packages for Enterprise Linux 8 - \$basearch\nbaseurl=https://rpm.nodesource.com/pub_20.x/el/8/\$basearch\ngpgcheck=1\ngenpgcheck=1\ngpgkey=file:///etc/pki/rpm-gpg/nodesource.gpg" > /etc/yum.repos.d/nodesource.repo

yum update -y
yum install -y git java-11-openjdk zip unzip redis tomcat postgresql14 mongodb-org nodejs
