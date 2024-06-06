##script
# Ensure the script is run as an administrator
if (![System.Security.Principal.WindowsIdentity]::GetCurrent().Groups -match 'S-1-5-32-544') {
    Start-Process powershell -ArgumentList ('-File', $MyInvocation.MyCommand.Path) -Verb RunAs
    exit
}

Add-Type -AssemblyName PresentationFramework

# XAML for the WPF window
$XAML = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" 
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Ashesh Development Installer" Height="450" Width="800" Background="Black">
    <Window.Resources>
        <Style TargetType="TextBlock">
            <Setter Property="Foreground" Value="White"/>
            <Setter Property="FontFamily" Value="Segoe UI"/>
        </Style>
        <Style TargetType="CheckBox">
            <Setter Property="Foreground" Value="White"/>
            <Setter Property="FontFamily" Value="Segoe UI"/>
        </Style>
        <Style TargetType="Button">
            <Setter Property="FontFamily" Value="Segoe UI"/>
        </Style>
    </Window.Resources>
    <Grid Margin="10">
        <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="*"/>
            <RowDefinition Height="Auto"/>
        </Grid.RowDefinitions>
        <TextBlock Text="Ashesh Development" FontSize="40" HorizontalAlignment="Center" Margin="0,20,0,20"/>
        <StackPanel Grid.Row="1">
            <CheckBox Name="DeveloperTools" Content="Developer Tools (Unity Hub, Visual Studio, Git, GitHub Desktop, Plastic SCM Cloud)" Margin="10"/>
            <CheckBox Name="GeneralSoftware" Content="General Software (Python, Visual Studio Code, VSCode Insiders, PyCharm, Ruby, Notepad++)" Margin="10"/>
            <CheckBox Name="Communications" Content="Communications (Slack, Discord, Guilded, Telegram)" Margin="10"/>
            <CheckBox Name="Browsers" Content="Browsers (Google Chrome, Mozilla Firefox, Firefox ESR)" Margin="10"/>
            <CheckBox Name="Utilities" Content="Utilities (Windows Terminal, 7-Zip, JDownloader2, Tixati, Awesun Aweray)" Margin="10"/>
            <CheckBox Name="OfficeAndSecurity" Content="Office and Security (Office 365 Insider, Kaspersky Premium, fxSound)" Margin="10"/>
        </StackPanel>
        <Button Name="InstallButton" Content="Install" Width="100" Height="30" HorizontalAlignment="Center" VerticalAlignment="Bottom" Grid.Row="2" Margin="0,20,0,20"/>
    </Grid>
</Window>
"@

# Parse the XAML
$reader = (New-Object System.Xml.XmlNodeReader $XAML)
$window = [Windows.Markup.XamlReader]::Load($reader)

# Define the installation actions
$scriptBlock = {
    param ($DeveloperTools, $GeneralSoftware, $Communications, $Browsers, $Utilities, $OfficeAndSecurity)
    
    # Dummy installation process (replace with actual installation logic)
    if ($DeveloperTools) { Write-Output "Installing Developer Tools..." }
    if ($GeneralSoftware) { Write-Output "Installing General Software..." }
    if ($Communications) { Write-Output "Installing Communications..." }
    if ($Browsers) { Write-Output "Installing Browsers..." }
    if ($Utilities) { Write-Output "Installing Utilities..." }
    if ($OfficeAndSecurity) { Write-Output "Installing Office and Security..." }

    Write-Output "Installation complete!"
}

# Assign event handler to the Install button
$window.FindName("InstallButton").Add_Click({
    $DeveloperTools = $window.FindName("DeveloperTools").IsChecked
    $GeneralSoftware = $window.FindName("GeneralSoftware").IsChecked
    $Communications = $window.FindName("Communications").IsChecked
    $Browsers = $window.FindName("Browsers").IsChecked
    $Utilities = $window.FindName("Utilities").IsChecked
    $OfficeAndSecurity = $window.FindName("OfficeAndSecurity").IsChecked

    $scriptBlock.Invoke($DeveloperTools, $GeneralSoftware, $Communications, $Browsers, $Utilities, $OfficeAndSecurity)

    $window.Close()
})

# Show the WPF window
$window.ShowDialog() | Out-Null
