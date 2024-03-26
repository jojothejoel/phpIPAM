# phpIPAM deployment #
 
## Description of this project ##
The "PHPipam Webpage with MySQL Database" project is designed to create a web application using PHPipam, an IP address management (IPAM) tool, integrated with a MySQL backend database. This application is deployed on Microsoft Azure, utilizing its cloud services for scalability, reliability, and security. Users can efficiently manage IP addresses, subnets, VLANs, and other network-related resources through a user-friendly web interface, all hosted on Azure infrastructure.

## Installation ##
### Prerequisites ###
- Clone the repository [jojothejoel/phpIPAM](https://github.com/jojothejoel/phpIPAM) into a local virtual machine.
- Grant execute permissions to the user.


### Steps ###
1. Step 3: Launch the Automationdeployment.sh after  giving user the right permissions permission
2. Step 4: always follow the instrucitons given
3. After the script has run you can use kubectl commands to see the different ip adresses in your cluster to reach phpmyadmin phpIPAM and also for prometheus and grafana using -n monitoring to access the monitoring namespace 

## Usage ##
Log in to the phpIPAM web interface to install the phpIPAM using your database credentials and in advanced options check the create database and the other options must be also checked 
for the monitoring prometheus has no password nor a login the user just needs the ip address to get into the scrapping tool and grafana we put a default password as admin however upon entering grafana the user will be requested to change their password 
Log in to the phpmyadmin using the users credentials during the script installation
