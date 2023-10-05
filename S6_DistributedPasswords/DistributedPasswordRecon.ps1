#Author: Luke Leveque
#Date: 9/11/2023
#V1.1
#Description: Program will take a CSV file path and will return users if they meet any of the following criteria:
              #Password has expired
              #Account is in the inactive group
              #Users with "conditional access failure = true" in the past month



#Run this once per session - sign in with credentials used for Azure and Microsoft Defender (e.g aad_XXX@cardmail...)
#Connect-AzureAD

$PATH = Read-Host -Prompt "File Path" #Take user input for the file path
                                                                      #If quotes are present it still works after
                                                                      #some errors pop up
$PATH.Replace('"','') #Allows for direct copy-paste of file path

if(!$PATH) #If the user doesn't specifify a file, take the default CSV file as long as it is in the same folder
{
    $PATH = Join-Path $PSScriptRoot "\DistributedPasswordDefault.csv"
}

$Users = Import-CSV -Path $PATH #Defines the list of users from the csv

#Get the date for the past month and format
$PastMonthDate = (Get-Date).AddDays(-60);
$PastMonthDate = Get-Date($PastMonthDate) -format yyyy-MM-dd

$ExpiredPasswords = @() #Create the array to store users with expired passwords

$InactiveUsers = @() #Create the array to store users found in the inactive group
$GroupName = "AD_UL-INACTIVE" #Save the name of the inactive group to search in

$ErrorUsers = @() #Create the array to store users who generate an error during the running of the program

$ConAccessHash = @{} #Create the hash to store the [user][user's conditional access failure reports]


#Formatting
$ExpiredPasswords += "-----------------------Expired Passwords----------------------`n"
$InactiveUsers +=    "------------------------Inactive Users------------------------`n"
$ErrorUsers +=       "--------------------------Error Users-------------------------"
$ErrorUsers +=       "*                 Note: Users in this list may               *"
$ErrorUsers +=       "*               appear here if the account may               *"
$ErrorUsers +=       "*                     already be disabled                    *`n"

$loopNum = 1 #var to format the output
Foreach($User in $Users.Users) #For each user, try the following code
{
    
    Write-Output("------------------------------------------------------------------------")
    Write-Output("Attempting to check user: {0} - {1}" -f $loopNum, $User)
    $loopNum++
    Try
    {
        #Get the information on the current user
        $CurUser = Get-ADUser -Identity $User -Properties PasswordExpired #Gets the Password Expired Property for the user
        $CurUserGroups = Get-ADPrincipalGroupMembership -Identity $User #Gets groups the User is in
    
        #Add users who have expired passwords to the Expired Passwords list
        if ($CurUser.PasswordExpired)
        {
            $ExpiredPasswords += Write-Output $User
        }
    
        #Add users who are in the inactive group to the InactiveUsers list
        if ($GroupName -in $CurUserGroups.name)
        {
            $InactiveUsers += Write-Output $User
        }
        
        #Add conditional access failures 
        $ConAccessArray = @() #Intitialize/clear array of conditional access failures for each user
        #Get the conditional access failures:
            #If: userPrincipleName starts with the user
                #store the logs in the past month that where ConditionalAccessStatus == failure
                #Store the: Date of log, UserDisplayName, UserPrincipleName, ConditionalAccessStatus, IPAddress, DeviceOS, Location
        $ConAccessArray += Get-AzureADAuditSignInLogs -Filter "startsWith(userPrincipalName, '$User')" | 
            Where-Object {($_.createdDateTime -gt $PastMonthDate) -and ($_.ConditionalAccessStatus -eq 'Failure')} |
            select createdDateTime, userDisplayName, userPrincipalName, ConditionalAccessStatus, ipAddress, 
                @{Name = 'DeviceOS'; Expression = {$_.DeviceDetail.OperatingSystem}},@{Name = 'Location'; Expression = {$_.Location.City}}
        #If the array of conditional access reports has any values, store the user and the array of reports into the hash
        if($ConAccessArray.Count -gt 0)
        {
        $ConAccessHash.Add($User,$ConAccessArray)
        }
    }
    catch
    {
        $ErrorUsers += Write-Output $User
    }
    
}
#formatting
$ExpiredPasswords += "`n--------------------------------------------------------------"
$InactiveUsers +=    "`n--------------------------------------------------------------"
$ErrorUsers +=       "`n--------------------------------------------------------------"


$InactiveUsers #Output the inactive users list

$ExpiredPasswords #Output the users with expired passwords

#Output the users who had any conditional access failures in the past month from the hash
Write-Output ("---------------Conditional Access Failure Users---------------`n")
$ConAccessHash.Keys
Write-Output ("`n--------------------------------------------------------------")

$ErrorUsers #Output the users who generated an error during the program




#Gets the date of when the password expires
#   Get-ADUser -Identity $User -Properties msDS-UserPasswordExpiryTimeComputed |
#     select {[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}

# Get-ADUser -Identity $User -Properties PasswordLastSet