CODE_REPO="https://github.com/stratiiv/java-schedule-app.git"
APP_DIR="/opt/java-app"
TOMCAT_PATH="/var/lib/tomcat9"

if [ ! -d $APP_DIR ]; then
    mkdir -p $APP_DIR
fi

if systemctl is-active --quiet tomcat9; then
    systemctl stop tomcat9
fi

git clone $CODE_REPO $APP_DIR

cd $APP_DIR

# build the backend
chmod +x gradlew
./gradlew build

# remove the old ROOT app 
rm -rf "$TOMCAT_PATH/webapps/ROOT*"

# copy the new build to Tomcat webapps dir
cp "$APP_DIR/build/libs/class_schedule.war" "$TOMCAT_PATH/webapps/ROOT.war"

systemctl start tomcat9
systemctl enable tomcat9

# start the frontend
cd frontend/
npm install
npm start 

echo "Deployment completed successfully!"