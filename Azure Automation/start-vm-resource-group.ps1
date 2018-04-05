workflow Start
{ 
#    $day = (Get-Date).DayOfWeek
#    if ($day -eq 'Saturday' -or $day -eq 'Sunday'){
#    exit
#   }  
 
# Grupo de recursos a utilizar
$ResourceGroupName = "RGName";

#Conexion hacia la subscripcion de Azure mediante AzureRunasAccount
$Conn = Get-AutomationConnection -Name AzureRunAsConnection
Add-AzureRMAccount -ServicePrincipal -Tenant $Conn.TenantID -ApplicationId $Conn.ApplicationID -CertificateThumbprint $Conn.CertificateThumbprint     
     
$vms = Get-AzureRmVM -ResourceGroupName $ResourceGroupName; 
     
    Foreach -Parallel ($vm in $vms){ 
            Write-Output "Starting $($vm.Name)";         
            Start-AzureRmVm -Name $vm.Name -ResourceGroupName $ResourceGroupName                      
    } 
}

