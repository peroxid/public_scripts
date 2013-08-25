#!/usr/bin/perl
##########################################################################
##		                                                    							  
##  Collect information from a list of machines                        	  
##  *******************************************                          
##									                                                      
##  Copyright (C) 2010  Patrick Hirt (patrick.hirt/at/gmail/dot/com)	    
##									                                                      
##  This program is distributed in the hope that it will be useful,       
##  but WITHOUT ANY WARRANTY; without even the implied warranty of        
##  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.                  
##                                                                        
##  License: I don't care, as long as its useful to you, I'm happy.       
##									                                                      
##########################################################################

use strict;
use warnings;

# **************************************************************************
#   Configure program here                                                  
# 	Command to send to the machine.                                         
# 	The resulting string of this command                                    
# 	will be displayed per hostname (if any)                                 
# **************************************************************************
my $command = "grep 50001 /etc/passwd";

# **************************************************************************
# 	Machines to check, seperate with a whitespace                           
# **************************************************************************
my @serverlist = qw(server1 server2 server3);

# **************************************************************************
#   SSH command used to connect to the machines,                            
#   in most cases does not need to be modified                              
# **************************************************************************
my $sshcmd = "ssh -q -o " . "\"Batchmode yes\" " . "-o " . "\"ConnectTimeout 5\" " . "-l root ";


# **************************************************************************
# Don't modify program below here (unless necessary)                        
# **************************************************************************
# Declare some stuff
my $sshreturn;
my %output;
my $k;
my $v;
my $count = 0;
my $pointcount = 0;
my $percentage;
my $p1 = 0;
my $p2 = 0;
my $p3 = 0;
my $total = @serverlist;

# Inform the use we're about to start working
print("Collecting information...\n");
# Iterate server list
foreach(@serverlist) {
	$count++;
	$pointcount++;
	if($pointcount == 3){
		print(".");
		$pointcount = 0;
	}
	$percentage = (100 / $total) * $count;
	if($percentage > 18 and $percentage < 22 and $p1 == 0){
		print(" 20% ");
		$p1 = 1;
	}
	if($percentage > 48 and $percentage < 52 and $p2 == 0){
		print(" 50% ");
		$p2 = 1;
	}
	if($percentage > 78 and $percentage < 82 and $p3 == 0){
		print(" 80% ");
		$p3 = 1;
	}
	$sshreturn = `$sshcmd $_ "$command" 2>/dev/null`;
	unless(!defined($sshreturn) or $sshreturn eq ''){
		$output{"$_"} = "$sshreturn";
	}
	undef($sshreturn);
}
print("\n\nDone!\n");
print "\n";


# **************************************************************************
# If you like, you can change the output here.                              
# ************************************************************************** 
foreach $k (sort(keys(%output))){
	$v = $output{"$k"};
	print("$k:\n$v");
}
exit(0);
