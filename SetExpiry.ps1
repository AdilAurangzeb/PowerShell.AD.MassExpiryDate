$date = Get-Date -format dd-MM-yyy-HHmmss
Start-Transcript -path “$date.log”

#Import Module
Import-Module ActiveDirectory

# Import users
$users = Get-Content -Path '.\users.txt'

$problemUsers = @()
$count = 0
$totalUsers = $users.Length
$expiryDate = Read-Host "The expiration date should be the day after they've left.`nIf you enter 5 Aug, it will show up as expiring end of 4 Aug on AD. `n`nEnter Expiry date in the format dd/mm/yyyy"

foreach($user in $users) 
{
    # Progress Bar
    $count = $count + 1
    $progress = [int](($count / $totalUsers) * 100)

    try
    {
        Set-ADAccountExpiration -Identity $user -DateTime $expiryDate
    }
    catch
    {
        $problemUsers = $problemUsers + $user
        Write-Output "Error editing date for:" $user
    }

    Write-Progress -Activity "Search in progress" -Status "$progress% Complete:" -PercentComplete $progress
}

$problemUsers | Out-File ".\problem-users.txt"
Write-Output "Script has completed"

Stop-Transcript