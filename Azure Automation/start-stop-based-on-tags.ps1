    #Set variables
    $tagName = "Environment"
    $tagValue = "Demo"
    $Shutdown = $true
 
    #Login
    Login-AzureRmAccount
 
    #Shutdown machines
    $taggedResources = Find-AzureRmResource -TagName $tagName -TagValue $tagValue 
 
    $targetVms = $taggedResources | Where-Object{$_.ResourceType -eq "Microsoft.Compute/virtualMachines"} | select resourcegroupname, name | Get-AzureRmVM -status
 
    ForEach ($vm in $targetVms)
    {
        $currentpowerstatus = $vm |select -ExpandProperty Statuses | Where-Object{ $_.Code -match "PowerState" } | select Code, DisplayStatus
        Write-Verbose $currentpowerstatus
 
        if($Shutdown -and $currentpowerstatus -eq "PowerState/running"){
    Write-Output "Stopping $($vm.Name)"; 
    Stop-AzureRmVm -Name $vm.Name -ResourceGroupName $vm.ResourceGroupName -Force;
}
elseif($Shutdown -eq $false -and $currentpowerstatus -ne "PowerState/running"){
    Write-Output "Starting $($vm.Name)"; 
    Start-AzureRmVm -Name $vm.Name -ResourceGroupName $vm.ResourceGroupName;
}
        else {
            Write-Output "VM $($vm.Name) is already in desired state : $($currentpowerstatus.DisplayStatus)";
        }
    }
