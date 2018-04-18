## Instructions to enable SAC on the VM 
#1 . Create the enablesac.ps1 and save it into a local drive
#2 . upload the file using the commands 
#3 . Fill the variables, and be aware that the process will be executed in all of the machines in the RG


# This configuration will enable SAC in the next reboot

# enablesac.ps1 content (Be sure to include the double quotes "" "")

#invoke-expression "bcdedit /ems ""{current}"" on"
#invoke-expression "bcdedit /emssettings EMSPORT:1 EMSBAUDRATE:115200"

# This will enable Windows boot loader prompt in the serial console
#invoke-expression "bcdedit /set ""{bootmgr}"" displaybootmenu yes"
#invoke-expression "bcdedit /set ""{bootmgr}"" timeout 45"
#invoke-expression "bcdedit /set ""{bootmgr}"" bootems yes"


## Login to Azure
Login-AzureRmAccount

$newstgname = "scriptdownload"
$stgrg = "SDR-Identity-Lab" ### RG to create the Storage Account
$sku = "Standard_LRS"
$stglocation = "East US"

### step 1
###### This is only to upload the file to an storage account ##########  NOTE : The Storage account should be in the same resource group as the VM
New-AzureRmStorageAccount -Name $newstgname -ResourceGroupName $stgrg -SkuName $sku -Location $stglocation
Set-AzureRmCurrentStorageAccount -StorageAccountName 'scriptdownload' -ResourceGroupName 'SDR-Identity-LAB'
New-AzureStorageContainer -name 'scripts'
Set-AzureStorageBlobContent -File '.\OneDrive - Microsoft\Documents\Azure\Scripts Powershell\Enable SAC on Windows\enablesac.ps1' -container 'scripts'


### Step 2
$vm_resourcegroup = "SDR-Identity-Lab"   ### Complete with the VM Resource Group
$vm_name = Get-AzureRmVM -ResourceGroupName $vm_resourcegroup | where { ($_.OSProfile.windowsConfiguration -ne $null) }
$containername = "scripts"    ### Complete with the container name created in the step 1
$file = "enablesac.ps1"       ## Do not modify if you are using the default name of the script
$stgname = "scriptdownload"   ## Add the Storage Account Name

Set-AzureRmCurrentStorageAccount -StorageAccountName $stgname -ResourceGroupName $vm_resourcegroup


foreach ($vm in $vm_name)
    {
$vmname = $vm.Name
$vmlocation = $vm.Location
Write-Output "SAC is being enabled on $vmname"  
### Run CSE on VM
Set-AzureRmVMCustomScriptExtension -Name 'CustomScriptExtension' `
-ContainerName $containername `
-FileName $file `
-StorageAccountName $stgname `
-ResourceGroupName $vm_resourcegroup `
-VMName $vmname `
-Run $file `
-Location $vmlocation

Remove-AzureRmVMCustomScriptExtension -Name 'CustomScriptExtension' -ResourceGroupName $vm_resourcegroup -VMName $vmname -force
}


