#!/bin/bash

echo "Creating release keystore for SONA app..."

keytool -genkeypair -v \
  -keystore ~/sona-app-release.keystore \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -alias sona-app \
  -dname "CN=SONA App, OU=Development, O=SONA, L=Seoul, ST=Seoul, C=KR" \
  -storepass sonaapp123456 \
  -keypass sonaapp123456

echo "Keystore created successfully at ~/sona-app-release.keystore"
echo "Please keep this keystore file safe - you'll need it for all future updates!"