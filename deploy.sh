APP_DIR="/opt/java-app"

if [ ! -d "$APP_DIR" ]; then
    mkdir -p "$APP_DIR"
fi

if systemctl is-active --quiet tomcat9; then
    systemctl stop tomcat9
fi

git clone https://github.com/stratiiv/java-schedule-app.git "$APP_DIR"

cd "$APP_DIR"

# build the application
gradle build -x test

# remove the old ROOT app 
rm -rf /var/lib/tomcat9/webapps/ROOT
rm -rf /var/lib/tomcat9/webapps/ROOT.war

# copy the new build to tomcat webapps dir
cp "$APP_DIR/build/libs/class_schedule.war" "/var/lib/tomcat9/webapps/ROOT.war"

systemctl start tomcat9
