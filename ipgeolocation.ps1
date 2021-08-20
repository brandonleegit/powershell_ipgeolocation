##Variables

$ip = get-nettcpconnection | where-object {$_.LocalPort -like "3389" -and $_.LocalAddress -ne "::" -and $_.LocalAddress -ne "0.0.0.0"} | select-object -expandproperty RemoteAddress
$access_key = "?access_key=<yourkeygoes here>"
$region = Invoke-RestMethod -Uri "http://api.ipstack.com/$ip$access_key" | select -expandproperty region_code

##Email Alert variables

$SMTPServer = "<your mail server>"
$SMTPPort = "587"
$Username = "<your username"
$Password = "<password>"
$to_email = "<recipient email>"
$to_page = "<page email""

##Checking IP and Email alert

Invoke-RestMethod -Uri "http://api.ipstack.com/$ip$access_key" | out-file alldetails.txt


if ($region -eq "<custom region>") {

$message = New-Object System.Net.Mail.MailMessage
$message.subject = "$ip has connected"
$message.body = (Get-Content alldetails.txt) -join "`n" 
$message.to.add($to_email)
$message.from = $username

$smtp = New-Object System.Net.Mail.SmtpClient($SMTPServer, $SMTPPort);
$smtp.EnableSSL = $true
$smtp.Credentials = New-Object System.Net.NetworkCredential($Username, $Password);

$smtp.send($message)
write-host "Mail Sent"

}

if ($region -ne "<custom region>") {



$message = New-Object System.Net.Mail.MailMessage
$message.subject = "$ip has connected"
$message.body = (Get-Content alldetails.txt) -join "`n"
$message.to.add("$to_page,$to_email")
$message.from = $username

$smtp = New-Object System.Net.Mail.SmtpClient($SMTPServer, $SMTPPort);
$smtp.EnableSSL = $true
$smtp.Credentials = New-Object System.Net.NetworkCredential($Username, $Password);

$smtp.send($message)
write-host "Mail Sent"

}