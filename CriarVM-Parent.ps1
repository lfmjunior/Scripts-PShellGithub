<# Instruções:
1) Criar manualmente, instalar, configurar e atualizar a VM que será o modelo
2) Nela, abra o CMD como administrador, depois cole o seguinte comando: c:\windows\system32\Sysprep\sysprep.exe

Fonte: https://www.youtube.com/watch?v=XAV9DxSBmmE
#>

[void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[void][System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")


# Estrutura e posicionamento do Formulário
#
$Form1 = New-Object System.Windows.Forms.Form
$Form1.ClientSize = New-Object System.Drawing.Size(407, 390)
$Form1.Text = "Criar nova Máquina Virtual"
$Form1.topmost = $true
$Form1.StartPosition = "CenterScreen"

# Texto COOPERATI
#
$lblcooperati = New-Object System.Windows.Forms.Label
$lblcooperati.Location = New-Object System.Drawing.Size(25,200) 
$lblcooperati.Size = New-Object System.Drawing.Size(350,40) 
$lblcooperati.Text = "Script para criação de máquinas virtuais com base em modelo.   Visite o nosso site: http://www.cooperati.com.br."
$Form1.Controls.Add($lblcooperati)

# Etiqueta e caixa de texto para solicitação do nome da VM
#
$lblNomeVM = New-Object System.Windows.Forms.Label
$lblNomeVM.Location = New-Object System.Drawing.Size(25,20) 
$lblNomeVM.Size = New-Object System.Drawing.Size(280,20) 
$lblNomeVM.Text = "Nome da VM:"
$Form1.Controls.Add($lblNomeVM)

$txtNomeVM = New-Object System.Windows.Forms.TextBox
$txtNomeVM.Location = New-Object System.Drawing.Size(25,40)
$txtNomeVM.Size = New-Object System.Drawing.Size(260,20)
$Form1.Controls.Add($txtNomeVM)

# Etiqueta, Consulta o sistema para listar os comutadores virtuais existentes
# e preenchimento da ComboBox1
#
$lblVmSwitch = New-Object System.Windows.Forms.Label
$lblVmSwitch.Location = New-Object System.Drawing.Size(25,70) 
$lblVmSwitch.Size = New-Object System.Drawing.Size(280,20) 
$lblVmSwitch.Text = "Selecione o Switch Virtual:"
$Form1.Controls.Add($lblVmSwitch)

$VMSwitches = Get-VMSwitch
$comboBox1 = New-Object System.Windows.Forms.ComboBox
$comboBox1.Location = New-Object System.Drawing.Point(25, 90)
$comboBox1.Size = New-Object System.Drawing.Size(350, 310)
foreach($VMSwitch in $VMSwitches)
{
  $comboBox1.Items.add($VMSwitch.Name)
}
$Form1.Controls.Add($comboBox1)

# Etiqueta, listagem dos Sistemas Operacionais
# e preenchimento da ComboBox2
#
$lblListaSO = New-Object System.Windows.Forms.Label
$lblListaSO.Location = New-Object System.Drawing.Size(25,120) 
$lblListaSO.Size = New-Object System.Drawing.Size(280,20) 
$lblListaSO.Text = "Selecione o Sistema Operacional:"
$Form1.Controls.Add($lblListaSO)


#Define os locais de armazenamento de acordo com os arquivos caminho-modelo.txt e caminho-vms.txt
#Os arquivos devem estar no mesmo nível de diretório do script

# Usando arquivos para os caminhos (usar se for mais de um):
#
#$caminhovm = Get-Content "D:\Maquinas Virtuais\caminho-vms.txt"
#$caminhomodelo = Get-Content "D:\Maquinas Virtuais\caminho-modelo.txt"

# Declarando diretamente o camhinho
#
$caminhovm = "F:\VMs-Hyper-V\"
$caminhomodelo = "F:\VMs-Hyper-V\Modelos VHDX"
$txtlistaso = Get-ChildItem -Path $caminhomodelo

$comboBox2 = New-Object System.Windows.Forms.ComboBox
$comboBox2.Location = New-Object System.Drawing.Point(25, 140)
$comboBox2.Size = New-Object System.Drawing.Size(350, 310)

foreach ($txtlistaso in $txtlistaso) 

{

      
      if ($txtlistaso.Attributes -ne "Directory")

      {

             $comboBox2.Items.add($txtlistaso)
      }

}

#foreach($txtSO in $txtListaSO)
#{
#  $comboBox2.Items.add($txtSO)
#}

$Form1.Controls.Add($comboBox2)

# Botão que cria a VM e exibe a etiqueta com a confirmação da criação da VM
#
$Button = New-Object System.Windows.Forms.Button
$Button.Location = New-Object System.Drawing.Point(25, 350)
$Button.Size = New-Object System.Drawing.Size(98, 23)
$Button.Text = "Criar VM"
$Button.add_Click({
                    $lblResultado.Text="Máquina Virtual " + $txtNomeVM.Text + " criada com sucesso."
                    $nomedoparent = $comboBox2.Text
                    $nomedavm = $txtNomeVM.Text
                    New-VHD -ParentPath "$caminhomodelo\$nomedoparent" -Path "$caminhovm\$nomedavm\$nomedavm.vhdx"
                    New-VM -Path $caminhovm -VHDPath "$caminhovm\$nomedavm\$nomedavm.vhdx" -Generation 2 -MemoryStartupBytes 2Gb -Name $nomedavm -SwitchName $comboBox1.Text | Set-VMMemory -DynamicMemoryEnabled $false
                    Get-VM $nomedavm | Set-VMProcessor -count 2
                    })
$Form1.Controls.Add($Button)

$lblResultado = New-Object System.Windows.Forms.Label
$lblResultado.Location = New-Object System.Drawing.Point(25, 225)
$lblResultado.Size = New-Object System.Drawing.Size(450, 150)
$lblResultado.Text = ""
$Form1.Controls.Add($lblResultado)

[void]$form1.showdialog()