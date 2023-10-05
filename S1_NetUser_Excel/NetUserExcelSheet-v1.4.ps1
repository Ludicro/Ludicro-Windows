#Author: Luke Leveque
#Date: 3/14/2023
#V1.4
#Description: Program will take a CSV file path and based on user entries for User column location and # of users,
#             will run the "net user [username] /domain" on all provided users


$PATH = Read-Host -Prompt "File Path" #Take user input for the file path
                                                                      #If quotes are present it still works after
                                                                      #some errors pop up
$PATH.Replace('"','') #Allows for direct copy-paste of file path

if(!$PATH) #If the user doesn't specifify a file, take the default CSV file as long as it is in the same folder
{
    $PATH = Join-Path $PSScriptRoot "\NetStatUsersDefault.csv"
    $UserNameCol = 1 #Sets default column with the user ID
}
else
{
    [int]$UserNameCol = Read-Host -Prompt "Input the column with the UofL ID" #Take column with user ID
}


$Users = Import-CSV -Path $PATH


$loopNum = 1 #var to format the output
Foreach($User in $Users.Users)
{
    Write-Output("------------------------------------------------------------------------")
    Write-Output("Attempting to check user: {0} - {1}" -f $loopNum, $User)
    $loopNum++
    Invoke-Command {net user $User /domain} #Run the command with captured value
    Write-Output("------------------------------------------------------------------------")
    pause
}

