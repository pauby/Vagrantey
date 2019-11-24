function Set-VagrantConfig {
    <#
    .SYNOPSIS
    Configure different environments for your system
    
    .DESCRIPTION
    Specify the friendly name of the environment, as well as the Path to the Vagrant File for the environment
    
    .PARAMETER Name
    The friendly name for the environment
    
    .PARAMETER Path
    The path to the vagrant file
    
    .EXAMPLE
    Set-VagrantConfig -Name Foo -Path /my/path/to/foo
    
    .NOTES
    Specifying the actual vagrant file is not necessary. The path is simply the path to where the vagrantfile resides on disk
    #>
    
    [cmdletBinding()]
    Param(
        [Parameter(Mandatory,Position=0)]
        [String]
        $Name,

        [Parameter(Mandatory,Position=1)]
        [ValidateScript({Test-Path $_})]
        [String]
        $Path
    )

    begin {

        if (!(Test-Path "$(Split-Path -Parent $PSScriptRoot)\Config\VagrantConfig.json")) {

            $null = New-Item "$(Split-Path -Parent $PSScriptRoot)\Config\VagrantConfig.json"
        }
        else {
            $config = Get-VagrantConfig "$(Split-Path -Parent $PSScriptRoot)\Config\VagrantConfig.json"
        }
    }

    process {
    
        If($config.$name){
            $config.$Name = $Path
        }
        else {

            if($config){
            $config | Add-Member -MemberType NoteProperty -Name $Name -Value $Path
            }

            else{
                $config = [pscustomobject]@{ $Name = $Path}
            }
        }
        $config | ConvertTo-Json | Set-Content "$(Split-Path -Parent $PSScriptRoot)\Config\VagrantConfig.json"
    }
}