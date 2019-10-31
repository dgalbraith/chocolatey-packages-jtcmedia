﻿$ErrorActionPreference = 'Stop';

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://s3.amazonaws.com/aws-cli/AWSCLI32PY3-1.16.270.msi'
$checksum   = 'f1ca86b95d32c0418f7ea71b29efd0c00de4c7219051dfc03e74331c429c0941'
$url64      = 'https://s3.amazonaws.com/aws-cli/AWSCLI64PY3-1.16.270.msi'
$checksum64 = '5f86b41cfb34d1698d6dd5f5aa2949a096e96e0340fc471ea1805ed70ea51cd6'
 
$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'MSI'
  url           = $url
  url64bit      = $url64
  softwareName  = 'AWS Command Line Interface*'
  checksum      = $checksum
  checksumType  = 'sha256'
  checksum64    = $checksum64
  checksumType64= 'sha256'
  silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
