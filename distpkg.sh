#!/usr/bin/bash
# Installes packages on a given list of HPUX servers. Is version-aware. 
# Looks for the pkgs in the /var/software/<hpux version>/SW directory.

PKGLIST="libpcap libicomv gettext bash";
REPOSITORYSRV="server1";
USAGE="		Usage: ./distpkg.sh <serverlistfile>";

# Check whether ssh connection is possible
function checkssh
{
	MIMIMI=0;
	SSHAGENT=$(ps -ef | grep ssh-agent | grep $USER | grep -v grep)
	for i in $TARGETSRV; do
		echo "Testing $i...";
		ssh -q -o "BatchMode=yes" -o "ConnectTimeout=5" -l root $i "echo 2>&1"  \
			&& echo "	OK =D" || echo "	NOK! =(" && MIMIMI=1;
	done
	if [ ! $MIMIMI -eq 0 ] 
	then
		echo "WARNING: At leat one machine could not be reached!";
		echo "Make sure ssh-agent is running, and you distributed";
		echo "your keys to all machines!";
		sleep 1;
	fi
	unset MIMIMI;
}

# The installation routine
function install
{
	for i in $TARGETSRV; do
			# Checking whether dependencies are already met
			for x in $PKGLIST; do
				echo "	Connecting to $i...";
				DEPCHK=$(ssh -q -o "BatchMode=yes" -o "ConnectTimeout=5" -l root $i \
						"swlist -l fileset | grep $x");
				echo "		Checking dependency $x...";
				if [ ! -z $DEPCHK ]; then
					echo "		$x is already installed. Skipping";
				else
					echo "		$x is not installed. Selecting";
					PKGSTOINST="$PKGSTOINST $x";
				fi
			done
			# Performing the actual installation
			echo "	Committing installation";
			if [ -z $(echo $PKGSTOINST | tr -d ' ') ] 
			then
				echo "NOTICE: Nothing to install on $i";
			else
				# Checking HPUX version...
				VERSION=$(ssh -q -o "BatchMode=yes" -o "ConnectTimeout=5" -l root $i \
                                                "uname -r" | cut -b 3-7);
				if [ -z $VERSION ] 
				then
					echo "ERROR: Could not detect OS version on $i. Breaking.";
					exit 1;
				else
					echo "	HPUX Version $VERSION detected.";
				fi
				for y in $PKGSTOINST; do
					ssh -q -o "BatchMode=yes" -o "ConnectTimeout=5" -l root $i \
                                                "swinstall -s $REPOSITORYSRV:/var/software/hpux$VERSION/$y";
					FAILCHK=$(ssh -q -o "BatchMode=yes" -o "ConnectTimeout=5" -l root $i \
                                                "swlist -l fileset | grep $y")
					if [ ! -z $FAILCHK ] 
					then
						echo "		$y installed.";
					else 
						echo "WARNING: Installation of $y failed!";
						echo "Output from swlist (if empty, simply not installed):";
						echo $FAILCHK;
					fi
					unset FAILCHK;
				done
			unset PKGSTOINST;
			unset VERSION;
			fi
	done
}

# Check whether argument is given
if [ -z $1 ] 
then
	echo $USAGE;
	exit 1;
fi
# Check for valid file
if [ ! -f $1 ] 
then
	echo "ERROR: $1 ist not a regular file...";
	exit 1;
else
	TARGETSRV=$(cat $1);	
fi
checkssh;
install;
exit 0;
