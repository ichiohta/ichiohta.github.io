param (
  [string] $ProjectPath = "../INF_TRPRTR",
  [string] $OutputPath = "./INF_TPRTR"
)

$folderPath = [IO.Path]::GetDirectoryName($PSCommandPath)

$projectResolvedPath = [IO.Path]::Combine($folderPath, $ProjectPath)
$projectBuildPath = [IO.Path]::Combine($projectResolvedPath, "dist", "public");
$outputResolvedPath = [IO.Path]::Combine($folderPath, $OutputPath)

function build {
  try {
    Push-Location $projectResolvedPath
    yarn build
  } finally {
    Pop-Location
  }
}

function replicate {
  if (Test-Path $outputResolvedPath) {
    Remove-Item -Recurse $outputResolvedPath
  }

  New-Item -Type Directory $outputResolvedPath | Out-Null

  Get-ChildItem $projectBuildPath |
    ForEach-Object {
      Copy-Item -Recurse $_.FullName $outputResolvedPath
    }
}

build
replicate
git add --all
