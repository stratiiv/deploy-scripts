APP_DIR=/root/projects/java-app
mkdir $APP_DIR
git clone https://github.com/Vitaliy-Kost/java-app.git $APP_DIR
cd $APP_DIR
gradle build -x test
systemctl stop tomcat9
rm -rf /var/lib/tomcat9/webapps/ROOT
rm -rf /var/lib/tomcat9/webapps/ROOT.war
cp $APP_DIR/build/libs/class_schedule.war /var/lib/tomcat9/webapps/ROOT.war
systemctl start tomcat9