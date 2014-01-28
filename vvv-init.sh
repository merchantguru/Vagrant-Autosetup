# Init script for site provisioner

# import the config to keep it DRY
# . config.sh;

echo "Commencing setup of sandbox"

# Make a database, if we don't already have one
echo "Creating database (if it's not already there)"
mysql -u root --password=root -e "CREATE DATABASE IF NOT EXISTS sandbox"
mysql -u root --password=root -e "GRANT ALL PRIVILEGES ON sandbox.* TO wp@localhost IDENTIFIED BY 'wp';"

# Download WordPress
if [ ! -d htdocs ]
then
	echo "Installing WordPress for sandbox using WP CLI"
	mkdir htdocs
	cd htdocs
	wp core download --allow-root
	wp core config --dbname="sandbox" --dbuser=wp --dbpass=wp --dbhost="localhost" --allow-root
	wp core install --url=sandbox.dev --title="sandbox.dev" --admin_user=admin --admin_password=password --admin_email=demo@example.com --allow-root
	cd ..
fi

# The Vagrant site setup script will restart Nginx for us

echo "sandbox now installed";
