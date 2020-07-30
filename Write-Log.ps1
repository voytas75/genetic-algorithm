function Write-Log {
    param([string]$logstring)
    [string]$Logfile = "$env:TEMP\GA.log"
    Write-Debug -Message "Append ""$logstring"" to log file: ""$logfile"""
    Add-Content $logfile -Value $logstring
}
