# Ludicro-Powershell
List of my Powershell scripts

These are primarily used in my employment at UofL.   

# NetUserExcelSheet
Will take a list of users in a csv file and run them all against the net user command.  
Pre-conditions:  
	- Must be connected to the network your AD is on and able to run the net user command.  
Results:  
Each user will have the results of the net stat command run  

# NetUserManual
Will take a list of users entered by the one running the program and run them all against the net user command.  
Pre-conditions:  
  - Must be connected to the network your AD is on and able to run the net user command.    
Results:  
Each user will have the results of the net stat command run  

# EmailUsers - Firewall
This script was designed to send an email to managers of various firewalls. This script is not working as of right now and development has stopped as the project this was for has been reworked.  

# InactiveUser
***This script is outdated, but if you do not have access to the Active Directory module, this works well***  
This script takes a list of users from a csv and runs them with the net user command. It will then filter to see the list of groups the user is in. If they are in a group with the string "INACTIVE", the user will be added to a list.  

# PasswordExpiration
***This script is outdated, but if you do not have access to the Active Directory module, this works well***  
This script takes a list of users from a csv and runs them with the net user command. It will then filter to see the user's password expiration date. If the password is expired or expires in 30 days, they are added to a list.  

# DistributedPasswordRecon
This script takes a list of users from a csv and will determine the following:  
	- User has an expired password  
	- User is in a group with the string "INACTIVE"  
	- User has login attempts that have conditional access failure within the last month in Azure   
		These will be stored in a hash table, grouped by the user.  
		The list of users with any conditional access failures in the past month will be outputed to the screen. To view more details and see the results, entering the command ```$ConAccessHash.[KeyFromList]```` will give the specifics from that user  
Commented at the bottom of the script is a code snippet that if run, will give the date that a user's password expires.  
Pre-Condition:  
	- Have access to the ActiveDirectory module  
	- Have access to AzureAD module  
	- Have logon credentials to AzureAD  
Usage:  
	Run the Connect-AzureAD command that is commented out once per session and login with your credentials then run the script.  