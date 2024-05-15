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
            <Setter Property="FontFamily" Value="Dutom Che"/>
        </Style>
        <Style TargetType="CheckBox">
            <Setter Property="Foreground" Value="White"/>
            <Setter Property="FontFamily" Value="Dutom Che"/>
        </Style>
        <Style TargetType="Button">
            <Setter Property="FontFamily" Value="Dutom Che"/>
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

# Create a PowerShell script block for installation functions
$scriptBlock = {
    param (
        $DeveloperTools, $GeneralSoftware, $Communications, $Browsers, $Utilities, $OfficeAndSecurity
    )

    function Install-DeveloperTools {
        Write-Output "Downloading and installing Developer Tools..."
        Invoke-WebRequest -Uri $unityHubUrl -OutFile "$env:TEMP\UnityHubSetup.exe"
        Start-Process -FilePath "$env:TEMP\UnityHubSetup.exe" -ArgumentList "/S" -Wait

        Invoke-WebRequest -Uri $visualStudioUrl -OutFile "$env:TEMP\vs_community.exe"
        Start-Process -FilePath "$env:TEMP\vs_community.exe" -ArgumentList "--add Microsoft.VisualStudio.Workload.ManagedDesktop --includeRecommended --passive --norestart" -Wait

        Invoke-WebRequest -Uri $gitUrl -OutFile "$env:TEMP\GitSetup.exe"
        Start-Process -FilePath "$env:TEMP\GitSetup.exe" -ArgumentList "/SILENT" -Wait

        Invoke-WebRequest -Uri $githubDesktopUrl -OutFile "$env:TEMP\GitHubDesktopSetup.exe"
        Start-Process -FilePath "$env:TEMP\GitHubDesktopSetup.exe" -ArgumentList "/S" -Wait

        Invoke-WebRequest -Uri $plasticSCMUrl -OutFile "$env:TEMP\PlasticSCMSetup.exe"
        Start-Process -FilePath "$env:TEMP\PlasticSCMSetup.exe" -ArgumentList "/S" -Wait
    }

    function Install-GeneralSoftware {
        Write-Output "Downloading and installing General Software..."
        Invoke-WebRequest -Uri $pythonUrl -OutFile "$env:TEMP\PythonSetup.exe"
        Start-Process -FilePath "$env:TEMP\PythonSetup.exe" -ArgumentList "/quiet InstallAllUsers=1 PrependPath=1" -Wait

        Invoke-WebRequest -Uri $vsCodeUrl -OutFile "$env:TEMP\VSCodeSetup.exe"
        Start-Process -FilePath "$env:TEMP\VSCodeSetup.exe" -ArgumentList "/verysilent" -Wait

        Invoke-WebRequest -Uri $vsCodeInsidersUrl -OutFile "$env:TEMP\VSCodeInsidersSetup.exe"
        Start-Process -FilePath "$env:TEMP\VSCodeInsidersSetup.exe" -ArgumentList "/verysilent" -Wait

        Invoke-WebRequest -Uri $pyCharmUrl -OutFile "$env:TEMP\PyCharmSetup.exe"
        Start-Process -FilePath "$env:TEMP\PyCharmSetup.exe" -ArgumentList "/S" -Wait

        Invoke-WebRequest -Uri $rubyUrl -OutFile "$env:TEMP\RubyInstaller.exe"
        Start-Process -FilePath "$env:TEMP\RubyInstaller.exe" -ArgumentList "/verysilent" -Wait

        Invoke-WebRequest -Uri $notepadPlusPlusUrl -OutFile "$env:TEMP\NotepadPlusPlusSetup.exe"
        Start-Process -FilePath "$env:TEMP\NotepadPlusPlusSetup.exe" -ArgumentList "/S" -Wait
    }

    function Install-Communications {
        Write-Output "Downloading and installing Communications..."
        $slackUrl = "https://downloads.slack-edge.com/releases/windows/4.27.154/prod/x64/SlackSetup.exe"
        Invoke-WebRequest -Uri $slackUrl -OutFile "$env:TEMP\SlackSetup.exe"
        Start-Process -FilePath "$env:TEMP\SlackSetup.exe" -ArgumentList "/S" -Wait

        $discordUrl = "https://discord.com/api/download?platform=win"
        Invoke-WebRequest -Uri $discordUrl -OutFile "$env:TEMP\DiscordSetup.exe"
        Start-Process -FilePath "$env:TEMP\DiscordSetup.exe" -ArgumentList "/S" -Wait

        $guildedUrl = "https://www.guilded.gg/downloads/GuildedSetup.exe"
        Invoke-WebRequest -Uri $guildedUrl -OutFile "$env:TEMP\GuildedSetup.exe"
        Start-Process -FilePath "$env:TEMP\GuildedSetup.exe" -ArgumentList "/S" -Wait

        $telegramUrl = "https://telegram.org/dl/desktop/win"
        Invoke-WebRequest -Uri $telegramUrl -OutFile "$env:TEMP\TelegramSetup.exe"
        Start-Process -FilePath "$env:TEMP\TelegramSetup.exe" -ArgumentList "/S" -Wait
    }

    function Install-Browsers {
        Write-Output "Downloading and installing Browsers..."
        $chromeUrl = "https://dl.google.com/chrome/install/latest/chrome_installer.exe"
        Invoke-WebRequest -Uri $chromeUrl -OutFile "$env:TEMP\ChromeSetup.exe"
        Start-Process -FilePath "$env:TEMP\ChromeSetup.exe" -ArgumentList "/silent /install" -Wait

        $firefoxUrl = "https://download.mozilla.org/?product=firefox-latest&os=win&lang=en-US"
        Invoke-WebRequest -Uri $firefoxUrl -OutFile "$env:TEMP\FirefoxSetup.exe"
        Start-Process -FilePath "$env:TEMP\FirefoxSetup.exe" -ArgumentList "/S" -Wait

        $firefoxEsrUrl = "https://download.mozilla.org/?product=firefox-esr-latest&os=win&lang=en-US"
        Invoke-WebRequest -Uri $firefoxEsrUrl -OutFile "$env:TEMP\FirefoxEsrSetup.exe"
        Start-Process -FilePath "$env:TEMP\FirefoxEsrSetup.exe" -ArgumentList "/S" -Wait
    }

    function Install-Utilities {
        Write-Output "Downloading and installing Utilities..."
        $windowsTerminalUrl = "https://github.com/microsoft/terminal/releases/download/v1.15.2874.0/Microsoft.WindowsTerminal_1.15.2874.0_8wekyb3d8bbwe.msixbundle"
        Invoke-WebRequest -Uri $windowsTerminalUrl -OutFile "$env:TEMP\WindowsTerminal.msixbundle"
        Add-AppxPackage -Path "$env:TEMP\WindowsTerminal.msixbundle"

        $sevenZipUrl = "https://www.7-zip.org/a/7z1900-x64.msi"
        Invoke-WebRequest -Uri $sevenZipUrl -OutFile "$env:TEMP\7ZipSetup.msi"
        Start-Process -FilePath "msiexec.exe" -ArgumentList "/i $env:TEMP\7ZipSetup.msi /qn" -Wait

        $jdownloaderUrl = "http://installer.jdownloader.org/JDownloader2Setup.exe"
        Invoke-WebRequest -Uri $jdownloaderUrl -OutFile "$env:TEMP\JDownloader2Setup.exe"
        Start-Process -FilePath "$env:TEMP\JDownloader2Setup.exe" -ArgumentList "/S" -Wait

        $tixatiUrl = "https://download2.tixati.com/download/tixati-2.89-1.win64-install.exe"
        Invoke-WebRequest -Uri $tixatiUrl -OutFile "$env:TEMP\TixatiSetup.exe"
        Start-Process -FilePath "$env:TEMP\TixatiSetup.exe" -ArgumentList "/S" -Wait

        $awesunUrl = "https://download.aweray.com/AwerayRemote_setup.exe"
        Invoke-WebRequest -Uri $awesunUrl -OutFile "$env:TEMP\AwesunSetup.exe"
        Start-Process -FilePath "$env:TEMP\AwesunSetup.exe" -ArgumentList "/S" -Wait
    }

    function Install-OfficeAndSecurity {
        Write-Output "Downloading and installing Office and Security..."
        $office365Url = "https://go.microsoft.com/fwlink/p/?linkid=2124703"
        Invoke-WebRequest -Uri $office365Url -OutFile "$env:TEMP\Office365Setup.exe"
        Start-Process -FilePath "$env:TEMP\Office365Setup.exe" -ArgumentList "/S" -Wait

        $kasperskyUrl = "https://www.kaspersky.com/downloads/thank-you/antivirus-downloads"
        Invoke-WebRequest -Uri $kasperskyUrl -OutFile "$env:TEMP\KasperskySetup.exe"
        Start-Process -FilePath "$env:TEMP\KasperskySetup.exe" -ArgumentList "/S" -Wait

        $fxSoundUrl = "https://www.fxsound.com/installers/fxsound_setup.exe"
        Invoke-WebRequest -Uri $fxSoundUrl -OutFile "$env:TEMP\fxSoundSetup.exe"
        Start-Process -FilePath "$env:TEMP\fxSoundSetup.exe" -ArgumentList "/S" -Wait
    }

    # Main script
    $unityHubUrl = "https://public-cdn.cloud.unity3d.com/hub/prod/UnityHubSetup.exe"
    $visualStudioUrl = "https://aka.ms/vs/17/release/vs_community.exe"
    $gitUrl = "https://github.com/git-for-windows/git/releases/download/v2.40.0.windows.1/Git-2.40.0-64-bit.exe"
    $githubDesktopUrl = "https://central.github.com/deployments/desktop/desktop/latest/win32"
    $plasticSCMUrl = "https://www.plasticscm.com/download/11.0.16.7438/plasticscm_installer_11.0.16.7438.exe"
    $pythonUrl = "https://www.python.org/ftp/python/3.10.5/python-3.10.5-amd64.exe"
    $vsCodeUrl = "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-user"
    $vsCodeInsidersUrl = "https://update.code.visualstudio.com/latest/win32-x64/insider"
    $pyCharmUrl = "https://download.jetbrains.com/python/pycharm-community-2022.1.4.exe"
    $rubyUrl = "https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-3.1.2-1/rubyinstaller-devkit-3.1.2-1-x64.exe"
    $notepadPlusPlusUrl = "https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v8.4.2/npp.8.4.2.Installer.x64.exe"
    $windowsTerminalUrl = "https://github.com/microsoft/terminal/releases/download/v1.15.2874.0/Microsoft.WindowsTerminal_1.15.2874.0_8wekyb3d8bbwe.msixbundle"

    if ($DeveloperTools) { Install-DeveloperTools }
    if ($GeneralSoftware) { Install-GeneralSoftware }
    if ($Communications) { Install-Communications }
    if ($Browsers) { Install-Browsers }
    if ($Utilities) { Install-Utilities }
    if ($OfficeAndSecurity) { Install-OfficeAndSecurity }

    Write-Output "Cleaning up..."
    Remove-Item "$env:TEMP\UnityHubSetup.exe" -ErrorAction SilentlyContinue
    Remove-Item "$env:TEMP\vs_community.exe" -ErrorAction SilentlyContinue
    Remove-Item "$env:TEMP\GitSetup.exe" -ErrorAction SilentlyContinue
    Remove-Item "$env:TEMP\GitHubDesktopSetup.exe" -ErrorAction SilentlyContinue
    Remove-Item "$env:TEMP\PlasticSCMSetup.exe" -ErrorAction SilentlyContinue
    Remove-Item "$env:TEMP\PythonSetup.exe" -ErrorAction SilentlyContinue
    Remove-Item "$env:TEMP\VSCodeSetup.exe" -ErrorAction SilentlyContinue
    Remove-Item "$env:TEMP\VSCodeInsidersSetup.exe" -ErrorAction SilentlyContinue
    Remove-Item "$env:TEMP\PyCharmSetup.exe" -ErrorAction SilentlyContinue
    Remove-Item "$env:TEMP\RubyInstaller.exe" -ErrorAction SilentlyContinue
    Remove-Item "$env:TEMP\NotepadPlusPlusSetup.exe" -ErrorAction SilentlyContinue
    Remove-Item "$env:TEMP\SlackSetup.exe" -ErrorAction SilentlyContinue
    Remove-Item "$env:TEMP\DiscordSetup.exe" -ErrorAction SilentlyContinue
    Remove-Item "$env:TEMP\GuildedSetup.exe" -ErrorAction SilentlyContinue
    Remove-Item "$env:TEMP\TelegramSetup.exe" -ErrorAction SilentlyContinue
    Remove-Item "$env:TEMP\ChromeSetup.exe" -ErrorAction SilentlyContinue
    Remove-Item "$env:TEMP\FirefoxSetup.exe" -ErrorAction SilentlyContinue
    Remove-Item "$env:TEMP\FirefoxEsrSetup.exe" -ErrorAction SilentlyContinue
    Remove-Item "$env:TEMP\WindowsTerminal.msixbundle" -ErrorAction SilentlyContinue
    Remove-Item "$env:TEMP\7ZipSetup.msi" -ErrorAction SilentlyContinue
    Remove-Item "$env:TEMP\JDownloader2Setup.exe" -ErrorAction SilentlyContinue
    Remove-Item "$env:TEMP\TixatiSetup.exe" -ErrorAction SilentlyContinue
    Remove-Item "$env:TEMP\AwesunSetup.exe" -ErrorAction SilentlyContinue
    Remove-Item "$env:TEMP\Office365Setup.exe" -ErrorAction SilentlyContinue
    Remove-Item "$env:TEMP\KasperskySetup.exe" -ErrorAction SilentlyContinue
    Remove-Item "$env:TEMP\fxSoundSetup.exe" -ErrorAction SilentlyContinue

    Write-Output "Installation complete!"
}

# Parse the XAML
$reader = (New-Object System.Xml.XmlNodeReader $XAML)
$window = [Windows.Markup.XamlReader]::Load($reader)

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
$window.ShowDialog()
