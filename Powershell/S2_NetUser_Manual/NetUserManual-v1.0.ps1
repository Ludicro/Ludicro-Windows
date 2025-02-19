#Author: Luke Leveque
#Date: 2/13/2023
#V1.0
#Description: Program will take a list IDs and run the "net user [username] /domain on them

[int]$UsersNum = Read-Host -Prompt "Input the number of users you want to check" #Determine number of users to check
$UserList = New-Object string[] $UsersNum


#Go through loop, filling in the users
For($i = 0; $i -lt $UsersNum; $i++)
{
    $UserInput = Read-Host -Prompt "Enter UofL ID"
    $UserList[$i] = $UserInput
}



$loopNum = 1 #var to format the output
For($i = 0; $i -lt $UsersNum; $i++)
{
    Write-Output("------------------------------------------------------------------------")
    Write-Output("Attempting to check user: {0}" -f $loopNum)
    $loopNum++
    $CurUser = $UserList[$i]
    Write-Output ($CurUser)
    Invoke-Command {net user $CurUser /domain} #Run the command with current user
    Write-Output("------------------------------------------------------------------------")
    pause
}

