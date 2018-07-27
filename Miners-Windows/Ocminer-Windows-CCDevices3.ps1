$Path = ".\Bin\ocminer-Windows-CCDevices3-Algo\ccminer.exe"
$Uri = "https://github.com/ocminer/suprminer/releases/download/1.5/suprminer-1.5.7z"
$Build = "Linux"

if($CCDevices3 -ne ''){$Devices = $CCDevices3}
if($GPUDevices3 -ne ''){$Devices = $GPUDevices3}

$Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName

#Algorithms:
#x17
#X16r
#X16s

$Commands = [PSCustomObject]@{
    #"X16r" = ''
    #"X16s" = ''
    "X17" = ''
}


$Commands | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name | ForEach-Object {
  if($Algorithm -eq "$($Pools.(Get-Algorithm($_)).Algorithm)")
   {
    [PSCustomObject]@{
    MinerName = "ccminer"
    Type = "NVIDIA3"
    Path = $Path
    Devices = $Devices
    DeviceCall = "ccminer"
    Arguments = "-a $_ -o stratum+tcp://$($Pools.(Get-Algorithm($_)).Host):$($Pools.(Get-Algorithm($_)).Port) -b 0.0.0.0:4070 -u $($Pools.(Get-Algorithm($_)).User3) -p $($Pools.(Get-Algorithm($_)).Pass3) $($Commands.$_)"
    HashRates = [PSCustomObject]@{(Get-Algorithm($_)) = $Stats."$($Name)_$(Get-Algorithm($_))_HashRate".Day}
    Selected = [PSCustomObject]@{(Get-Algorithm($_)) = ""}
    Port = 4070
    API = "Ccminer"
    Wrap = $false
    URI = $Uri
    BUILD = $Build
    }
  }
}

$Pools.PSObject.Properties.Value | Where-Object {$Commands."$($_.Algorithm)" -ne $null} | ForEach {
  if("$($_.Coin)" -eq "Yes")
     {
    [PSCustomObject]@{
     MinerName = "ccminer"
     Type = "NVIDIA3"
     Path = $Path
     Devices = $Devices
     DeviceCall = "ccminer"
     Arguments = "-a $($_.Algorithm) -o stratum+tcp://$($_.Host):$($_.Port) -b 0.0.0.0:4070 -u $($_.User3) -p $($_.Pass3) $($Commands.$($_.Algorithm))"
     HashRates = [PSCustomObject]@{$_.Symbol = $Stats."$($Name)_$($_.Symbol)_HashRate".Day}
     API = "Ccminer"
     Selected = [PSCustomObject]@{$($_.Algorithm) = ""}
     Port = 4070
     Wrap = $false
     URI = $Uri
     BUILD = $Build
     }
    }
   }
