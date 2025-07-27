#!/bin/bash

echo "Creating release keystore for Team SONA ChatApp..."

keytool -genkeypair -v \
  -keystore ~/teamsona-chatapp-release.keystore \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -alias teamsona-chatapp \
  -dname "CN=Team SONA ChatApp, OU=Development, O=Team SONA, L=Seoul, ST=Seoul, C=KR" \
  -storepass teamsona123456 \
  -keypass teamsona123456

echo "Keystore created successfully at ~/teamsona-chatapp-release.keystore"
echo "Please keep this keystore file safe - you'll need it for all future updates!"