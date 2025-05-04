#!/bin/bash

# Exit on any failure
set -e

# === CONFIGURATION ===
APP_ID="1:356458991379:android:e94dc708040e2fb3cfd4e6"            # Replace with your actual app ID from Firebase
APK_PATH="../build/app/outputs/flutter-apk/app-release.apk"
TESTERS="gs033288@gmail.com"          # Comma-separated list of tester emails
RELEASE_NOTES="New release for testing"  # Customize or make dynamic

# === BUILD APK ===
echo "🔧 Building release APK..."
./gradlew assembleRelease



# === UPLOAD TO FIREBASE APP DISTRIBUTION ===
echo "📤 Uploading APK to Firebase App Distribution..."
firebase appdistribution:distribute "$APK_PATH" \
  --app "$APP_ID" \
  --testers "$TESTERS" \
  --release-notes "$RELEASE_NOTES"

echo "✅ APK successfully uploaded to Firebase App Distribution!"
