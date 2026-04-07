Write-Host "Building PDF for current markdown..." -ForegroundColor Cyan

$inputFile = "Readme.md"
$outputFile = "Doc.pdf"

if (-not (Test-Path $inputFile)) {
    Write-Host "File not found: $inputFile" -ForegroundColor Red
    exit 1
}

if (-not (Get-Command pandoc -ErrorAction SilentlyContinue)) {
    Write-Host "Pandoc is not installed or not in PATH." -ForegroundColor Red
    exit 1
}

Write-Host "Creating $outputFile from $inputFile..." -ForegroundColor Cyan
pandoc $inputFile `
    -o $outputFile `
    --resource-path="." `
    --pdf-engine=xelatex `
    -V geometry:a4paper,margin=1cm `
    -V mainfont="Cambria" `
    -V mathfont="Cambria Math" `
    -V monofont="Consolas" `
    -V pagestyle=empty `
    --from markdown+tex_math_single_backslash+tex_math_dollars-yaml_metadata_block

if ($LASTEXITCODE -eq 0) {
    Write-Host "PDF created successfully: $outputFile" -ForegroundColor Green
    $file = Get-Item $outputFile
    Write-Host "Size: $([math]::Round($file.Length / 1KB, 1)) KB" -ForegroundColor Gray
} else {
    Write-Host "Error creating $outputFile" -ForegroundColor Red
    exit $LASTEXITCODE
}
