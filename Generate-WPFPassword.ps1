# Generate-WPFPassword.ps1 
Add-Type –assemblyName PresentationFramework, PresentationCore, WindowsBase
 
[xml]$XAML = @'  
<Window 
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" 
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" 
    Title="Générateur de mots de passe - version WPF" Height="395"  
Width="475"> 
    <Grid> 
        <Label Height="28" Margin="72,22,113,0" Name="label1"  
VerticalAlignment="Top">Bienvenue dans le générateur de mots de  
passe</Label> 
        <Label Height="28" Margin="55,93,168,0" Name="label2"  
VerticalAlignment="Top">Le mot de passe doit être composé avec</Label> 
        <CheckBox Height="16" HorizontalAlignment="Right"  
Margin="0,71,20,0" Name="checkBox1" VerticalAlignment="Top"  
Width="120" IsChecked="True">Chiffres</CheckBox> 
        <CheckBox Height="16" HorizontalAlignment="Right"  
Margin="0,137,20,0" Name="checkBox4" VerticalAlignment="Top"  
Width="120">Autres</CheckBox> 
        <CheckBox Height="16" HorizontalAlignment="Right"  
Margin="0,115,20,0" Name="checkBox3" VerticalAlignment="Top" Width="120"  
IsChecked="True">Majuscules</CheckBox> 
        <CheckBox Height="16" HorizontalAlignment="Right"  
Margin="0,93,20,0" Name="checkBox2" VerticalAlignment="Top"  
Width="120">Minuscules</CheckBox> 
        <Label Height="28" HorizontalAlignment="Left" Margin="64,0,0,149" 
Name="label3" VerticalAlignment="Bottom" Width="149">Nombre  
de caractères</Label> 
        <Label Height="28" HorizontalAlignment="Left" Margin="64,0,0,110"  
Name="label4" VerticalAlignment="Bottom" Width="149">Mot de passe</Label> 
        <Label Height="28" Margin="0,0,221,76" Name="label5"  
VerticalAlignment="Bottom" HorizontalAlignment="Right"  
Width="168">Complexité du mot de passe</Label> 
        <TextBox Height="23" HorizontalAlignment="Right" Text="10"
Margin="0,0,149,152" Name="textBox1" VerticalAlignment="Bottom" Width="66" /> 
        <TextBox Height="23" HorizontalAlignment="Right"  
Margin="0,0,37,113" Name="textBox2" VerticalAlignment="Bottom" Width="178" /> 
        <ProgressBar Height="20" HorizontalAlignment="Right"  
Margin="0,0,37,78" Name="progressBar1" VerticalAlignment="Bottom"  
Width="178" /> 
        <Button Height="23" HorizontalAlignment="Left" Margin="75,0,0,37"  
Name="button1" VerticalAlignment="Bottom" Width="114">Générer</Button> 
        <Button Height="23" HorizontalAlignment="Right" Margin="0,0,37,37"  
Name="button2" VerticalAlignment="Bottom" Width="114">Quitter</Button> 
    </Grid> 
</Window> 
'@  
 
$reader=New-Object System.Xml.XmlNodeReader $xaml 
$Form=[Windows.Markup.XamlReader]::Load($reader)  
 
# Attention: les noms d'objets recherchés sont sensibles à la casse 
$textBox_Nb_caracteres = $form.FindName('textBox1')        
$textBox_resultat = $form.FindName('textBox2') 
$checkBox_chiffres = $form.FindName('checkBox1') 
$checkBox_minuscules = $form.FindName('checkBox2') 
$checkBox_majuscules = $form.FindName('checkBox3') 
$checkBox_autres = $form.FindName('checkBox4') 
$btnGenerer = $form.FindName('button1')  
$btnQuitter = $form.FindName('button2') 
$progressBar =  $form.FindName('progressBar1') 
 
$btnGenerer.add_click({  
   [int]$len = $textBox_Nb_caracteres.get_text() 
   $textBox_resultat.Text = '' 
   $complex = 0 
   $progressBar.Value = 0  
   [string]$chars = '' 
 
   if ($checkBox_chiffres.isChecked) 
        {$chars += '0123456789';$complex += 1} 
   if ($checkBox_majuscules.isChecked)  
        {$chars += 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';$complex += 1} 
   if ($checkBox_minuscules.isChecked)  
        {$chars += 'abcdefghijklmnopqrstuvwxyz';$complex += 1} 
   if ($checkBox_autres.isChecked)  
        {$chars += '_!@#$%';$complex += 1} 
 
   if($chars -ne ''){ 
      $bytes = New-Object System.Byte[] $len  
      $rnd = New-Object System.Security.Cryptography.RNGCryptoServiceProvider 
      $rnd.GetBytes($bytes) 
      $result = '' 
      for( $i=0; $i -lt $len; $i++ ) 
      { 
         $result += $chars[ $bytes[$i] % $chars.Length ]  
      }  
      $complex *= $(2.57*$len) 
      if($complex -gt 100){ $complex = 100 } 
      $progressBar.Value = $complex 
      $textBox_resultat.Text = $result  
   } 
 
}) # fin du bloc du bouton "Générer" 
 
$btnQuitter.add_click({  $Form.close()  })  
 
$Form.ShowDialog() | Out-Null
