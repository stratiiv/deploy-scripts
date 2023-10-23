if [ -f .env ]; then
	source .env
else
	echo "Error: .env file not found."
	exit 1
fi

sudo -u postgres psql -c "CREATE USER $PG_USER WITH PASSWORD '$PG_PASSWORD'"
sudo -u postgres psql -c "CREATE DATABASE $DB_NAME WITH OWNER $PG_USER"
sudo -u postgres echo "$DB_HOST:$DB_PORT:$DB_NAME:$PG_USER:$PG_PASSWORD" > "/var/lib/postgresql/.pgpass"
chmod 600 "/var/lib/postgresql/.pgpass"
# restore from dump
sudo -u postgres psql -U "$DB_USER" -h "$DB_HOST" -d "$DB_NAME" -f "$DUMP_FILE"
