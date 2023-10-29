if [ $# -ne 1 ]; then
    echo "Usage: $0 <SEARCH_DIR>"
    exit 1
fi

SEARCH_DIR=$1

find $SEARCH_DIR -type f -name "hibernate.properties" -exec sed -i "s/hibernate.connection.password=.*/hibernate.connection.password=\${PG_PASSWORD}/" {} +
find $SEARCH_DIR -type f -name "hibernatetest.properties" -exec sed -i "s/hibernate.connection.password=.*/hibernate.connection.password=\${PG_PASSWORD}/" {} +