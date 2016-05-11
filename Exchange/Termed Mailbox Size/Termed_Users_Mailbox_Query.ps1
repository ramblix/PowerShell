#Other Variables
$var1= " "
$var2= " "
[string]$var3= " "
$var4= " "
[int]$errcounter= 0
[int]$counter = 0

$searchResults = New-Item -type file "Termed_users_mailboxsize.csv" -Force

#CSV Inputs
#$samacccount = $_.samaccountname
#$displayname = $_.displayname
#$database= $_.database

$users = (get-content "c:\IT\termed_users.txt") 

foreach ($_ in $users)
{
try{ 
    $var1= " "
    $var2= " "
    $var3= " "
    $var4= " "

    $MBX = get-mailboxstatistics $_ | select displayname,{$_.totalitemsize.value.tomb()}
    
    if($MBX -eq $null){ 
      $var1 = $_
      $var3 = "Mailbox DNE"
      $errcounter++

      Add-Content $searchResults "$var1,$var3"
     
    }
    
    else{
    $var1= $mbx.displayname 
    $var2= {$mbx.totalitemsize.value.tomb()}
    #$var3= $mbx.totaldeleteditemcount
    #$var4= $mbx.totalitemsize

    Add-Content $searchResults "$var1,$var2"
    $counter++
    }

   
 }
catch{

  $var1 = $_
  $var3 = "Mailbox DNE"

  $errcounter++

  Add-Content $searchResults "$var1,$var3"


 }
 finally{ write-host -ForegroundColor Yellow "User $_ is Complete"}

  
}

write-host -ForegroundColor Green "The Process is Now Complete, Thank You"
  Write-Host -ForegroundColor Cyan  "Results: $counter Mailboxes Found, $errcounter Mailboxes Missing in MFRM"