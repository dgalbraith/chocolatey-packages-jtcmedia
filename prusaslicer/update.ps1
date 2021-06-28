import-module au

$releases = 'https://github.com/prusa3d/PrusaSlicer/releases/latest'

function global:au_SearchReplace {
    @{
        "$($Latest.PackageName).nuspec" = @{
          "(\<releaseNotes\>).*?(\</releaseNotes\>)" = "`${1}$($Latest.ReleaseNotes)`$2"
        }
            
        ".\legal\VERIFICATION.txt" = @{
            "(?i)(\s+x32:).*"           = "`${1} $($Latest.URL32)"
            "(?i)(\s+x64:).*"           = "`${1} $($Latest.URL64)"
            "(?i)(\s+checksum32:).*"    = "`${1} $($Latest.Checksum32)"
            "(?i)(\s+checksum64:).*"    = "`${1} $($Latest.Checksum64)"
            "(?i)(Get-RemoteChecksum).*" = "`${1} $($Latest.URL64)"
        }
    }
}


function global:au_BeforeUpdate { Get-RemoteFiles -Purge }


function global:au_GetLatest {
    $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing
    
    $regex = 'zip$'
    $urls = $download_page.links | ? href -match $regex | select -First 2 -expand href | % { 'https://github.com' + $_ }
        
    $version = ($urls[0] -split '/' | select -Last 1 -Skip 1) -split 'version_' | select -Last 1
    
    @{
        URL32 = $urls[0]
        URL64 = $urls[1]
        Version = $version
        ReleaseNotes = "https://github.com/prusa3d/PrusaSlicer/releases/tag/version_${version}"
    }
}

update -ChecksumFor none
