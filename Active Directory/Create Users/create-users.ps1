$Users = Import-Csv -Delimiter "," -Path "C:\scripts\wave1.csv"            
foreach ($User in $Users)            
{            
           
    $SAM = $User.SAM              
    $Description = $User.Description            
    $Password = $User.Password            
    New-ADUser -SamAccountName $User  -Description "$Description" -AccountPassword (ConvertTo-SecureString $Password -AsPlainText -Force) -Enabled $true -Path "OU=Non-Privileged Accounts,OU=Accounts,DC=MFRM,DC=com" -ChangePasswordAtLogon $false –PasswordNeverExpires $true            
}