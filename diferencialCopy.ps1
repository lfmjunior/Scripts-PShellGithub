<#
$s1 = ("{0:yyyy-MM-dd}-arquivos-alterados-diariamente" -f (Get-Date))
cd E:\origem\
mkdir F:\destino\$s1 -Force
robocopy E:\origem F:\destino\$s1 /sec /e /maxage:1 /zb /r:3 /w:30 /v /eta /log:F:\destino\$s1\log_robocopy_externo.log
#>

$pathSource = "E:\Comics\"
$pathDestination = "E:\HQ's\"
# copiando os arquivos e sub-diretórios no modo backup, mantendo as informações dos arquivos e pastas
# robocopy $pathSource $pathDestination /E /ZB /COPYALL /V /R:0 /W:0

# cópia diferencial (copia apenas não alerados!)
robocopy $pathSource $pathDestination /E /COPYALL /NFL /NDL /NS /NC /NJH /NJS /R:0 /W:0

# Fonte: https://conzatech.com/utilizando-powershell-em-file-server/
# https://dicasdobolivar.blogspot.com/2018/07/backup-incremental-e-diferencial-via.html