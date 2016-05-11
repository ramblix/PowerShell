#Other Variables
$var1= " "
$var2= " "
$var3= " "
$var4= " "
[int]$errcounter= 0
[int]$counter = 0

$searchResults = New-Item -type file "Mailbox_Sizes_01.csv" -Force

#CSV Inputs
#$samacccount = $_.samaccountname
#$displayname = $_.displayname
#$database= $_.database

$users = (get-content "c:\IT\Names.txt") 

foreach ($_ in $users)
{
try{ 
    $var1= " "
    $var2= " "
    $var3= " "
    $var4= " "

    $MBX = get-mailboxstatistics $_ | select displayname,itemcount,totaldeleteditemsize,totalitemsize
    
    if($MBX -eq $null){ 
      $var1 = $_
      $var3 = "SamAccount DNE"
      $errcounter++
     
    }
    
    else{
    $var1= $mbx.displayname 
    $var2= $mbx.itemcount
    $var3= $mbx.totaldeleteditemsize
    $var4= $mbx.totalitemsize

   
    $counter++
    }

    Add-Content $searchResults "$var1,$var2,$var3,$var4"
 }
catch{

  $var1 = $_
  $var3 = "SamAccount DNE"

  $errcounter++

  Add-Content $searchResults "$var1,$var2,$var3,$var4"


 }
 finally{ write-host -ForegroundColor Yellow "User $_ is Complete"}

  
}

write-host -ForegroundColor Green "The Process is Now Complete, Thank You"
  Write-Host -ForegroundColor Cyan  "Results: $counter Accounts Found, $errcounter Accounts Missing in MFRM"