# Load required assemblies
Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase

# XAML definition
[xml]$XAML = @"
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="Windows 11 Configuration" Height="600" Width="800"
    WindowStartupLocation="CenterScreen">
    <Grid>
        <TabControl>
            <TabItem Header="Packages">
                <Grid Margin="10">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="Auto"/>
                        <RowDefinition Height="*"/>
                    </Grid.RowDefinitions>
                    
                    <StackPanel Grid.Row="0" Orientation="Horizontal" Margin="0,0,0,10">
                        <Button Content="Install Selected" Width="100" Margin="0,0,10,0"/>
                        <Button Content="Uninstall Selected" Width="100"/>
                    </StackPanel>
                    
                    <ListView Grid.Row="1">
                        <ListView.View>
                            <GridView>
                                <GridViewColumn Header="Package Name" Width="200"/>
                                <GridViewColumn Header="Description" Width="300"/>
                                <GridViewColumn Header="Status" Width="100"/>
                            </GridView>
                        </ListView.View>
                    </ListView>
                </Grid>
            </TabItem>
        </TabControl>
    </Grid>
</Window>
"@

# Create the Window
$reader = (New-Object System.Xml.XmlNodeReader $XAML)
$Window = [Windows.Markup.XamlReader]::Load($reader)

# Show the Window
$Window.ShowDialog() | Out-Null