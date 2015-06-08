#!/usr/bin/perl



## Copyright (c) 20014 Kai Knoepfel
##
## This program is free software; you can redistribute it and/or
## modify it under the terms of the GNU General Public License
## as published by the Free Software Foundation; either version 2
## of the License, or (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program; if not, write to the Free Software
## Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.



use LWP::UserAgent;
use Getopt::Long;



#
# Dont change anything below these lines ...
#


GetOptions(
    "v"         => \$ver,
    "version"   => \$ver,
    "h"         => \$help,
    "help"      => \$help,			
    "host=s"	=> \$host,			# monitored-system
    "port=i"	=> \$port,			# icm-port
    "debug"		=> \$debug,			# debugging
    "t=i"       => \$timec,			# timeout of the check
    "time=i" 	=> \$timec,			# timeout of the check
	);





version();
help();
timeout();




# timeout routine
$SIG{ALRM} = \&plugin_timeout;
eval {
		alarm ($timeout);
        };





if ( $host eq undef || $port eq undef || $timec eq undef)
        {
        print "Please use -h or -help to use the script with correct syntax!!\n";
        }
else
        {
		my $ua = new LWP::UserAgent;
		$ua->agent('Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)');

		my $system_date = `date '+%Y-%m-%d'`;

		my $response = $ua->post("http://$host:$port/sap/public/ping");
		my $content = $response->content; 
		
		if ( $debug == 1 )
			{
			print "$content\n";
			}
	
		my $login_ok = grep /erfolgreich|available/, $content;
		my $login_maint = grep /Maintenance/, $content;
		my $login_error = grep /Can't connect/, $content;

		
		if ( $login_ok == "1" )
			{
			print "OK - ICM on $host available!\n";
			exit 0;
			}
		elsif ( $login_maint == "1" )
			{
			print "WARNING - ICM on $host are in Maintenance-Mode!\n";
			exit 1;
			}
		elsif ( $login_error == "1" )
			{
			print "CRITICAL - ICM on $host not available!\n";
			exit 2;
			}
		else 
			{
			print "UNKNOWN - An error occurred!\n";
			print "$content\n";
			exit 3;
			}
		}

	
	
	



	
sub help{
	if ( $help == "1" ) 
			{
			print "\n";
			print "Usage:\n";
			print "	check_sap_icm.pl -host <HOSTNAME> -port <HTTP-PORT>\n";
			print "\n";
			print "Optionen:\n";
			print "\n";
			print "	-host: HOSTNAME\n";
			print "\n";
			print "	-port: ICM-Port\n";
			print "\n";
			print "	-debug -> For debug output.\n";
			print "\n";
			print "	-t -> For debug output.\n";
			print "\n";
			
			print "Help:\n";
			print "\n";
			print "	To use this plugin you must activate the sicf-service /sap/public/ping\n";
			print "	You need the following perl-modules: LWP::UserAgent, Getopt::Long\n";
			print "\n";
			}
		}
	
	
	
	
	
sub version{
	if ( $ver == "1" )
			{
				print "\n";
				print "Version: \n";
				print "0.1 -> add Getopt::Long\n";
				print "\n";
				print "For changes, ideas or bugs please contact kutte013\@gmail.com\n";
				print "\n";
				exit 0;
			}
		}	
		
		
		
sub timeout{
	if ( $timec != $conf{timedef} )
		{
			$timeout = $timec;
		}
	else
		{ 
			$timeout = $conf{timedef};
		}
	}