PG_HOME="/var/lib/postgresql"
DUMP_PATH="$PG_HOME/dumps"
ENV_FILE=".env"

# load shell variables
if [ -f $ENV_FILE ]; then
    source $ENV_FILE
else
    echo "Error: $ENV_FILE file not found."
    exit 1
fi

if [ ! -d $DUMP_PATH ]; then
    mkdir -p $DUMP_PATH
fi

# error handling function
check_error() {
    if [ $? -ne 0 ]; then
        echo "Error: $1"
        exit 1
    fi
}

echo "Starting and enabling services..."
services=("postgresql" "mongod" "redis-server")
systemctl daemon-reload
for service in "${services[@]}"; do
    systemctl start $service
    systemctl enable $service
    check_error "Failed to start and enable $service."
done

# setting up PostgreSQL DB
echo "Creating PostgreSQL user, databases, and .pgpass file..."
sudo -u postgres psql -c "CREATE USER $PG_USER WITH PASSWORD '$PG_PASSWORD'"
sudo -u postgres psql -c "CREATE DATABASE $DB_NAME WITH OWNER $PG_USER"
sudo -u postgres psql -c "CREATE DATABASE ${DB_NAME}_test WITH OWNER $PG_USER" # db for tests
echo "$DB_HOST:$DB_PORT:$DB_NAME:$PG_USER:$PG_PASSWORD" | \
    sudo -u postgres bash -c 'cat > /var/lib/postgresql/.pgpass'
chmod 0600 $PG_HOME/.pgpass

echo "Copying dump file..."
cp "$DUMP_FILE" "$DUMP_PATH/$DUMP_FILE"
check_error "Failed to copy the dump file."

# dump restore
echo "Restoring the database from the dump file..."
sudo -u postgres psql -U "$PG_USER" -h "$DB_HOST" -d "$DB_NAME" -f "$DUMP_PATH/$DUMP_FILE"
check_error "Failed to restore the database."

echo "Setup and configuration completed successfully."
