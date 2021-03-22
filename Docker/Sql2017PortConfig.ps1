function SetPort($instance, $port)
{
    # fetch the WMI object that contains TCP settings; filter for the 'IPAll' setting only
    # note that the 'ComputerManagement14' corresponds to SQL Server 2017
    $settings = Get-WmiObject `
        -Namespace root/Microsoft/SqlServer/ComputerManagement14 `
        -Class ServerNetworkProtocolProperty `
        -Filter "InstanceName='$instance' and IPAddressName='IPAll' and PropertyType=1 and ProtocolName='Tcp'"

    # there are two settings in a list: TcpPort and TcpDynamicPorts
    foreach ($setting in $settings)
    {
        if ($setting -ne $null)
        {
            # set the static TCP port and at the same time clear any dynamic ports
            if ($setting.PropertyName -eq "TcpPort")
            {
                $setting.SetStringValue($port)
            }
            elseif ($setting.PropertyName -eq "TcpDynamicPorts")
            {
                $setting.SetStringValue("")
            }
        }
    }
}