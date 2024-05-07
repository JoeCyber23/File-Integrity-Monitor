



Write-Host "what would you like to do?"
Write-Host "A) Collect new Baseline?"
Write-Host "B) Begin monitoring files with saved Baaseline?"

$response = Read-Host -Prompt "Please enter 'A' or 'B'"

if ($response -eq "A".ToUpper()) {
    # Calaculate Hash from the target files and store in baseline.txt
    Write-Host "Calculate Hashes, make new baseline.txt" -ForegroundColor Cyan
}
elseif ($response -eq "B".ToUpper()) {
        # Begin monitoring files with saved Baseline
        Write-Host "Read existing baseline.txt, start monitoring files." -ForegroundColor Yellow

}