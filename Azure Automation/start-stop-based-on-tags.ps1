#Conexion hacia la subscripcion de Azure mediante AzureRunasAccount
$Conn = Get-AutomationConnection -Name AzureRunAsConnection
Add-AzureRMAccount -ServicePrincipal -Tenant $Conn.TenantID -ApplicationId $Conn.ApplicationID -CertificateThumbprint $Conn.CertificateThumbprint     

   
   #Set variables
   $tagName = "Apagar"
   $tagValue = "9-18"

 
   #Shutdown machines
   $taggedResources = Find-AzureRmResource -TagName $tagName -TagValue $tagValue 
 
   $targetVms = $taggedResources | Where-Object{$_.ResourceType -eq "Microsoft.Compute/virtualMachines"} | select resourcegroupname, name | Get-AzureRmVM -status
 
   ForEach ($vm in $targetVms)
    {
        $currentpowerstatus = $vm |select -ExpandProperty Statuses | Where-Object{ $_.Code -match "PowerState" } | select Code, DisplayStatus
        Write-Verbose $currentpowerstatus
        Write-Output "Stopping $($vm.Name)"; 
        Stop-AzureRmVm -Name $vm.Name -ResourceGroupName $vm.ResourceGroupName -Force;
    }
