#Author: Luke Leveque
#Date: 3/14/2023
#V1.2
#Description: Program will take a CSV file path and based on user entries for User column location and # of users,
#             will run the "net user [username] /domain" on all provided users and provide a list of users who are 
#             marked as INACTIVE


$PATH = Read-Host -Prompt "File Path" #Take user input for the file path
                                                                      #If quotes are present it still works after
                                                                      #some errors pop up
$PATH.Replace('"','') #Allows for direct copy-paste of file path

if(!$PATH) #If the user doesn't specifify a file, take the default CSV file as long as it is in the same folder
{
    $PATH = Join-Path $PSScriptRoot "\InactiveUsersDefault.csv"
    $UserNameCol = 1 #Sets default column with the user ID
}

$Users = Import-CSV -Path $PATH


$InactiveUsers = @()

$loopNum = 1 #var to format the output
Foreach($User in $Users.Users)
{
    Write-Output("------------------------------------------------------------------------")
    Write-Output("Attempting to check user: {0} - {1}" -f $loopNum, $User)
    $loopNum++
    $CurResult = Invoke-Command {net user $User /domain} #Run the command with captured value and store it
    if($CurResult -match "INACTIVE")
    {
        $InactiveUsers += Write-Output $User
    }
}
Write-Output("`nList of Inactive Users:")
$InactiveUsers