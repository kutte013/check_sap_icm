# Check SAP-ICM

This plugin check the icm availability!

First: You must activate the sicf-service /sap/public/ping!
       
# Manpage <<< check_sap_icm >>>


### Usage:
	check_sap_icm.pl -host < HOSTNAME > -port < NR > -t <TIMEOUT>
			
### Optionen:
	
	-host: HOSTNAME
	
	-port: HTTP-PORT
	
	-t: < TIMEOUT >
	    Plugintimeout
	    
	-debug
	    Debug Output
	   
	  
	Help:
	    To use this plugin you must activate the sicf-service /sap/public/ping
	    You need the following perl-modules: LWP::UserAgent, Getopt::Long
	
	Version: check_sap_icm.pl -v
	
	Help: check_sap_icm.pl -h

			
	



