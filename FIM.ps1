
Write-Host ""
Write-Host "what would you like to do?"
Write-Host "A) Collect new Baseline?"
Write-Host "B) Begin monitoring files with saved Baseline?"

$response = Read-Host -Prompt "Please enter 'A' or 'B'"
Write-Host ""

Function calculate-file-hash($filepath) {
        $filehash = Get-FileHash -Path $filepath -Algorithm SHA512
        return $filehash
}

Function Erase-Baseline-If-Already-Exists() {
        $baselineExists=test-path -Path .\baseline.txt

        if ($baselineExists) {
        # Delete it
        Remove-Item -Path .\baseline.txt
        }
}

if ($response -eq "A".ToUpper()) {
        #Delete baseline.txt if it already exists
        Erase-Baseline-If-Already-Exists

        # Calaculate Hash from the target files and store in baseline.txt
        #collect all files in the target folder
        $files = Get-ChildItem -Path .\Files


        #For each file, calculate the hash, and write to baseline.txt
        foreach ($f in $files)  {
               $hash = calculate-file-hash $f.FullName
               "$($hash.Path)|$($hash.Hash)" | Out-File -FilePath .\baseline.txt -Append
        }
        }

elseif ($response -eq "B".ToUpper()) {

        $FileHashDictionary = @{}

        # Load File|hash from baseline.txt and store them in a dictionary
        $FilePathsandHashes = Get-Content -Path .\baseline.txt
       
       
        foreach ($f in $FilePathsandHashes){ 
             $FileHashDictionary.add($f.Split("|")[0],$f.Split("|")[1]) 
          }

        # Begin (continously) monitoring files with saved Baseline
        while ($true){
            Start-Sleep -Seconds 1

             $files = Get-ChildItem -Path .\Files
             
                 #For each file, calculate the hash, and write to baseline.txt
        foreach ($f in $files)  {
               $hash = calculate-file-hash $f.FullName
               #"$($hash.Path)|$($hash.Hash)" | Out-File -FilePath .\baseline.txt -Append
                # Notify if a new file has been created
               if ($FileHashDictionary[$hash.path] -eq $null) {
                    # A new file has been created!
                    write-host "$($hash.Path) has been created!" -ForegroundColor Green
                    }
                   else{

                    #Notify if a new file has been change
                    if ($FileHashDictionary[$hash.path] -eq $hash.Hash) {
                        # The File has not changed
                    }
                    else{
                        # File file has been compromised!, notify the user
                        write-host "$($hash.Path) has changed!!!" -ForegroundColor Red
                        }
            
               }
          }  foreach ($key in $FileHashDictionary.Keys){
            $baselineFileStillExists = Test-Path -Path $key
            if (-Not $baselineFileStillExists) {
            # One of the baseline files must have been deleted, notify the user
            write-host "$($key) has been deleted!" -ForegroundColor Yellow
            }
         }
       
            
      }
 }      
