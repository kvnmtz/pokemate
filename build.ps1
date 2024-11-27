$appName = 'pokemate'

if (Test-Path output) {
    Remove-Item output -Recurse -Force
}
[void](New-Item output -ItemType Directory)

Set-Location frontend

if (!$env:CI) {
    # Setup

    flutter pub get
    if ($LastExitCode -ne 0) {
        Write-Error "Command failed, aborting script"
        exit 1
    }

    Write-Output `n

    # Code generation

    dart run build_runner build --delete-conflicting-outputs
    if ($LastExitCode -ne 0) {
        Write-Error "Command failed, aborting script"
        exit 1
    }

    Write-Output `n

    # Code analyzing

    flutter analyze
    if ($LastExitCode -ne 0) {
        Write-Error "Command failed, aborting script"
        exit 1
    }

    Write-Output `n

    # Unit tests

    #flutter test
    #if ($LastExitCode -ne 0) {
    #    Write-Error "Command failed, aborting script (exit code $LastExitCode)"
    #    exit 1
    #}
    #
    #Write-Output `n
}

# Read version from pubspec.yaml
$version = (Get-Content pubspec.yaml | Where-Object { $_ -match '^version:\s' }) -replace '^version:\s*', ''

# Build for all supported platforms
# (Define version as compile-time environment variable)

Write-Output "Building for web..."
flutter build web --dart-define VERSION=$version
Write-Output `n
if ($LastExitCode -ne 0) {
    Write-Error "Command failed, aborting script"
    exit 1
}

Write-Output "Building for android..."
flutter build apk --dart-define VERSION=$version
Write-Output `n
if ($LastExitCode -ne 0) {
    Write-Error "Command failed, aborting script"
    exit 1
}

Write-Output "Building for windows..."
flutter build windows --dart-define VERSION=$version
Write-Output `n
if ($LastExitCode -ne 0) {
    Write-Error "Command failed, aborting script"
    exit 1
}

Set-Location ..

Write-Output "Copying builds to /output"

[void](New-Item -Path "output/web" -ItemType Directory)
[void](New-Item -Path "output/web/frontend" -ItemType Directory)
Copy-Item -Path "backend/*" -Destination "output/web" -Recurse
Move-Item -Path "frontend/build/web/*" -Destination "output/web/frontend"
Compress-Archive -Path "output/web/*" -DestinationPath "output/$appName-web.zip"
Remove-Item -Path "output/web" -Recurse -Force

Copy-Item -Path "frontend/build/app/outputs/flutter-apk/app-release.apk" -Destination "output/$appName-android.apk"

Compress-Archive -Path "frontend/build/windows/x64/runner/Release/*" -DestinationPath "output/$appName-windows.zip"

Write-Output "Finished"