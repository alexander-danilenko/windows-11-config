# Load required assemblies
Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase

# XAML definition
[xml]$XAML = @"
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="Hello World" Height="200" Width="300"
    WindowStartupLocation="CenterScreen">
    <Grid>
        <TextBlock 
            Text="Hello World!" 
            HorizontalAlignment="Center" 
            VerticalAlignment="Center"
            FontSize="24"
            FontWeight="Bold"/>
    </Grid>
</Window>
"@

# Create the Window
$reader = (New-Object System.Xml.XmlNodeReader $XAML)
$Window = [Windows.Markup.XamlReader]::Load($reader)

# Show the Window
$Window.ShowDialog() | Out-Null