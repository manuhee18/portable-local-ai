# Lanza un programa en segundo plano, sin ventana, guardando su salida en un log.
# Uso: lanzar-oculto.ps1 <exe> <log> [argumentos...]
param([string]$Exe, [string]$Log, [Parameter(ValueFromRemainingArguments = $true)][string[]]$Args)
New-Item -ItemType Directory -Force -Path (Split-Path $Log) | Out-Null
$p = @{
    FilePath               = $Exe
    WindowStyle            = 'Hidden'
    RedirectStandardOutput = "$Log.out"
    RedirectStandardError  = $Log
}
if ($Args) { $p.ArgumentList = $Args }
Start-Process @p
