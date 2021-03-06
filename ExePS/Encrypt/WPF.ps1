param([string]$dir);
################################################
## Start
################################################

####Check PS Version
$psVersion = $PSVersionTable.PSVersion

if($psVersion.Major -lt 3){
    Add-Type –AssemblyName System.Windows.Forms
    $message = @"
Your System is not meeting the requirements of the Application. 
Installing .Net Framework 4.5 and Windows Management Framework 3.0.
"@
    [System.Windows.Forms.MessageBox]::Show($message , "Information")
    EXIT
}

####Load Forms for Warning Popups
try{
    [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null
} catch {
    write-host "Couldn't load System.Windows.Forms! Check PowerShell Version." -ForegroundColor Red
}

####Get script location
#$scriptpath = $MyInvocation.MyCommand.Path
#$dir = Split-Path $scriptpath


####Path for WPF Form Image Source
$injectPath = $dir+"\"

################################################
## WPF Form
################################################

$inputXML = @"
<Window x:Class="WpfApplication7.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:WpfApplication7"
        mc:Ignorable="d"
        Title="MainWindow" Height="350" Width="525">
    <Grid>
        <Button x:Name="button_Ping" HorizontalAlignment="Left" Margin="219.771,178.096,0,0" VerticalAlignment="Top" Width="75" >
            <TextBlock x:Name="textBlock" TextWrapping="Wrap" Text="Ping"/>
        </Button>
        <TextBox x:Name="textBox_Ping" HorizontalAlignment="Left" Height="23" Margin="46.001,121.54,0,0" TextWrapping="Wrap" Text="google.com" VerticalAlignment="Top" Width="434.754"/>

    </Grid>
</Window>

"@ 

####Make XAML formed in Visual Studio readable
$inputXML = $inputXML -replace 'mc:Ignorable="d"','' -replace "x:N",'N'  -replace '^<Win.*', '<Window'
 
[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
[xml]$XAML = $inputXML
####Read XAML
 
$reader=(New-Object System.Xml.XmlNodeReader $xaml)
try{$Form=[Windows.Markup.XamlReader]::Load( $reader )}
catch{Write-Host "Unable to load Windows.Markup.XamlReader. Double-check syntax and ensure .net is installed."}
 
################################################
## Store Form Objects In PowerShell
################################################
 
$xaml.SelectNodes("//*[@Name]") | %{Set-Variable -Name "WPF$($_.Name)" -Value $Form.FindName($_.Name)}



################################################
## Functions
################################################

####Warning Dialog Function
function warningPopup($message){
    [String]$Button="OK"
    $Button = [System.Windows.MessageBoxButton]::$Button
    [System.Windows.MessageBox]::Show($message,"Result", $Button)
}


################################################
## Event Handlers
################################################

$WPFbutton_Ping.Add_Click({
    $message = (ping.exe -n 1 $WPFtextBox_Ping.Text)
    warningPopup -message $message
})

################################################
## Show Form
################################################
$Form.ShowDialog() | out-null          
