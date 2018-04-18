$AutomationAcctname= Contoso17
$vmwindows = Get-azurermvm | where { ($_.OSProfile.windowsConfiguration -ne $null)}
$vmlinux = Get-azurermvm | where { ($_.OSProfile.LinuxConfiguration -ne $null)}
$nodeconfiguration

if ($_.OSProfile.windowsConfiguration -ne $null)
{

Register-AzureRmAutomationDscNode -AutomationAccountName $AutomationAcctname -AzureVMName $vm -ResourceGroupName $rgname -NodeConfigurationName $nodeconfiguration

}

else
{Register-AzureRmAutomationDscNode -AutomationAccountName $AutomationAcctname -AzureVMName $vm -ResourceGroupName $rgname -NodeConfigurationName $nodeconfiguration

}



