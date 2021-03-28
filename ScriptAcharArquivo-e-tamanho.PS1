param($tipoDeExportacao)
# Para quando ocorrer o primeiro erro parar a execução:
$ErrorActionPreference = "Stop"

# HashTable → estrutura de dados usada para exibir array com labels (nome da coluna) e expressões (dados que irão aparecer abaixo do Label)
$nameExpr = @{
    Label = "Nome";
    Expression = { $_.Name }
}

$lengthExpr = @{
    Label = "Tamanho";
    Expression = { "{0:N2}KB" -f ($_.Length / 1KB) }
}

<# Formas de criar um array no PowerShell: 
	Simplesmente com uma vírgula: (1,2) e;
	Declarando com @: @(1,2)	
#>
$params = $nameExpr, $lengthExpr

$resultado =
gci -Recurse -File |
    ? Name -like "*1*" |
    select $params

if ($tipoDeExportacao -eq "HTML") {
    $estilos = Get-Content C:\Scripts\styles.css
    $styleTag = "<style> $estilos </style>"
    $tituloPagina = "Relatorio de Scripts em Migracao"
    $tituloBody = "<h1> $tituloPagina </h1>"

    $resultado | 
        ConvertTo-Html -Head $styleTag -Title $tituloPagina -Body $tituloBody | 
        Out-File C:\Scripts\relatorio.html
} elseif ($tipoDeExportacao -eq "JSON") {
    $resultado | 
        ConvertTo-JSON |
        Out-File C:\Scripts\relatorio.json
} elseif ($tipoDeExportacao -eq "CSV") {
    $resultado | 
        ConvertTo-CSV -NoTypeInformation |
        Out-File C:\Scripts\relatorio.csv
}