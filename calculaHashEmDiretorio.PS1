param($diretorio)

$ErrorActionPreference = "Stop"

# comand precedence para que as funções criadas no script passem para este (atual) 
. .\ShaFileV2.ps1

# obter todos os arquivos da pasta
$arquivos = Get-ChildItem $diretorio -File

foreach ($item in $arquivos.FullName) {
   $hashItem = Get-FileSHA1 $item
   Write-Host "O Hash SHA1 do arquivo $item : $hashItem !"
}