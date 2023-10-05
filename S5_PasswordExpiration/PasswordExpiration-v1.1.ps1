#Author: Luke Leveque
#Date: 8/29/2023
#V1.1
#Description: Program will take a CSV file path and based on user entries for User column location and # of users,
#             will run the "net user [username] /domain" on all provided users and provide a list of users who have 
#             passwords that have expired or will expire in less than a month


$PATH = Read-Host -Prompt "File Path" #Take user input for the file path
                                                                      #If quotes are present it still works after
                                                                      #some errors pop up
$PATH.Replace('"','') #Allows for direct copy-paste of file path

if(!$PATH) #If the user doesn't specifify a file, take the default CSV file as long as it is in the same folder
{
    $PATH = Join-Path $PSScriptRoot "\PasswordExpirationDefault.csv"
    $UserNameCol = 1 #Sets default column with the user ID
}

$Users = Import-CSV -Path $PATH
$CurDate = Get-Date

$ExpiredPasswords = @()

$loopNum = 1 #var to format the output
Foreach($User in $Users.Users)
{
    Write-Output("------------------------------------------------------------------------")
    Write-Output("Attempting to check user: {0} - {1}" -f $loopNum, $User)
    $loopNum++
    $CurResult = Invoke-Command {net user $User /domain} #Run the command with captured value and store it

    $line = $CurResult -match "Password expires"
    $line2 = $line.Substring(29)
    $ExpiresDate = [DateTime]$line2 

    if( ($ExpiresDate -lt $CurDate) -or ($ExpiresDate.Subtract([TimeSpan]::FromDays(30)) -lt $CurDate) )
    {
        $ExpiredPasswords += "------------------------------------------------------------------------"
        $ExpiredPasswords += Write-Output $User ($CurResult -match "Password Expires")
        $ExpiredPasswords += "------------------------------------------------------------------------"
    }
}
Write-Output("`nList of Users with Expired or Nearly Expired Passwords:")
$ExpiredPasswords