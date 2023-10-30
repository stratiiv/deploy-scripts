CODE_REPO="https://github.com/stratiiv/java-schedule-app.git"
APP_DIR=/opt/java-app
TOMCAT_PATH=/var/lib/tomcat9
ENV_FILE=".env"

# export environment variables
if [ -f "$ENV_FILE" ]; then
    while IFS= read -r line; do
        export "$line"
    done < "$ENV_FILE"
    echo "Exported environment variables from $ENV_FILE"
else
    echo "Error: $ENV_FILE not found."
    exit 1
fi

if [ ! -d $APP_DIR ]; then
    mkdir -p $APP_DIR
fi

git clone $CODE_REPO $APP_DIR

if [ "$1" == "--refactor" ]; then
    echo "Changing .properties credentials to environment variables..."
    find $APP_DIR -type f -name "hibernate.properties" -exec sed -i "s/hibernate.connection.password=.*/hibernate.connection.password=\${PG_PASSWORD}/" {} +
    find $APP_DIR -type f -name "hibernatetest.properties" -exec sed -i "s/hibernate.connection.password=.*/hibernate.connection.password=\${PG_PASSWORD}/" {} +
fi

if systemctl is-active --quiet tomcat9; then
    systemctl stop tomcat9
fi

cd $APP_DIR

# build the backend
echo "Building the backend..."
chmod +x gradlew
./gradlew build

echo "Removing old app from Tomcat..."
rm -rf $TOMCAT_PATH/webapps/ROOT
rm -rf $TOMCAT_PATH/webapps/ROOT.war

echo "Copying new build..."
cp $APP_DIR/build/libs/class_schedule.war $TOMCAT_PATH/webapps/ROOT.war

echo "Starting Tomcat..."
systemctl start tomcat9
systemctl enable tomcat9

# change react_api_base_url to backend address
find /opt/java-app/frontend -type f -name ".env" -exec sed -i "s|REACT_APP_API_BASE_URL=.*|REACT_APP_API_BASE_URL=$BACKEND_ADDRESS|" {} +

# start the frontend
echo "Starting frontend server..."
cd frontend/
npm install
npm start 

echo "Deployment completed successfully! Source code available at $APP_DIR"
