# Init script for site provisioner

# import the config to keep it DRY
. config.sh;

echo "Commencing setup of $NEWSITENAME"

# Make a database, if we don't already have one
echo "Creating database (if it's not already there)"
mysql -u root --password=root -e "CREATE DATABASE IF NOT EXISTS $NEWDBNAME"
mysql -u root --password=root -e "GRANT ALL PRIVILEGES ON $NEWDBNAME.* TO wp@localhost IDENTIFIED BY 'wp';"

# Download WordPress
if [ ! -d htdocs ]
then
	echo "Installing WordPress for $NEWSITENAME using WP CLI"
	mkdir htdocs
	cd htdocs
	wp core download 
	wp core config --dbname="$NEWDBNAME" --dbuser=wp --dbpass=wp --dbhost="localhost"
	wp core install --url="$NEWSITENAME.dev" --title="$NEWSITENAME" --admin_user=admin --admin_password=password --admin_email=demo@example.com
	cd ..
fi

# The Vagrant site setup script will restart Nginx for us

echo "$NEWSITENAME now installed";
