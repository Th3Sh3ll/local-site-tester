Import-Module WebAdministration
$local_sites = Get-Website
foreach ($site in $local_sites) {
    $bindings = $site.Bindings.Collection
    foreach ($binding in $bindings) {
        $site_name = $binding.bindingInformation.Split(":")[2]
        if (!$site_name) {
            $site_name = $binding.bindingInformation.Split(":")[0] + ":" + $binding.bindingInformation.Split(":")[1]
        }
        $test_site_url = "$($binding.protocol)://$($site_name)"
        Write-Host "`n$test_site_url"
        try{
            $test = Invoke-WebRequest -Uri $test_site_url -ErrorAction stop
            Write-Host "Status $($test.StatusDescription)" -ForegroundColor Green
        } catch {
            $site_error = $error[0].Exception
            Write-Output "Status:" $site_error
        }
    }
}