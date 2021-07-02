# Creating a Lamp stack

LAMP stands for Linux, Apache, MySQL, and PHP. Together, they provide a proven set of software for delivering high-performance web applications. Each component contributes essential capabilities to the stack. LAMP has a classic layered architecture, with Linux at the lowest level. The next layer is Apache and MySQL, followed by PHP. Although PHP is nominally at the top or presentation layer, the PHP component sits inside Apache.

- "sudo apt-get update -y && sudo apt-get upgrade -y"

This command will update and upgrade apt package. This package contains all the commands of linux

- "sudo apt-get install apache2 apache2-doc apache2-mpm-prefork apache2-utils libexpat1 ssl-cert -y"

This command will install apache web server. Web servers are used to serve Web pages requested by client computers. Clients commonly request and view Web sites using Web browser software such as Firefox, Opera, Chromium, or Internet Explorer.

- "sudo apt-get install libapache2-mod-php7.0 php7.0 php7.0-common php7.0-curl php7.0-dev php7.0-gd php-pear php7.0-mcrypt php7.0-mysql -y"

This command will install php and the requirements for Lamp server. PHP is a server scripting language, and a powerful tool for making dynamic and interactive Web pages. PHP is easy and powerful language. It is powerful enough to be at the core of the biggest blogging system on the web (WordPress)!. It is deep to run any big plateform and easy also.

- "sudo apt-get install mysql-server mysql-client -y"

This command is going to install mysql server client. MySQL is the world's most popular open-source database. Despite its powerful features, MySQL is simple to set up and easy to use.

echo -e "\n\nPermissions for /var/www\n"
sudo chown -R www-data:www-data /var/www
echo -e "\n\n Permissions have been set\n"

echo -e "\n\nEnabling Modules\n"
sudo a2enmod rewrite
sudo phpenmod mcrypt

echo -e "\n\nRestarting Apache\n"
sudo service apache2 restart

echo -e "\n\nLAMP Installation Completed"

exit 0
