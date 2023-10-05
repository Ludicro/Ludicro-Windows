#Author: Luke Leveque
#V1.0
#Description: Program will send an email to a list of users. Currently doesn't work for my purposes.

$EmailFrom = 'SenderEmail'
$EmailTo = 'RecieverEmail'

$EmailSubject = 'PowerShell Email Test'
$EmailBody = "This is a test"

$SMTPServer = 'Server'

Send-MailMessage -From "Sender <$EmailFrom>" -To "Recipient <$EmailTo>" -Subject "PowerShell Email" -Body "This is a test email" -SmtpServer "$SMTPServer"