$date = Get-Date -format dd-MM-yyy-HHmmss
Start-Transcript -path “$date.log”

#Import Module
Import-Module ActiveDirectory

# Import users
$users = Get-Content -Path '.\users.txt'

$problemUsers = @()
$count = 0
$totalUsers = $users.Length


foreach($user in $users) 
{
    # Progress Bar
    $count = $count + 1
    $progress = [int](($count / $totalUsers) * 100)

    try
    {
        $expiryDate = get-aduser -identity $user -properties AccountExpirationDate | select AccountExpirationDate -expandproperty AccountExpirationDate
        Write-Host $user "expires on: " $expiryDate
    }
    catch
    {
        $problemUsers = $problemUsers + $user
        Write-Output "Error with the following user(s):" $user
    }

    Write-Progress -Activity "Search in progress" -Status "$progress% Complete:" -PercentComplete $progress
}

$problemUsers | Out-File ".\problem-users.txt"
Write-Output "Script has completed"

Stop-Transcript