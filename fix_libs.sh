#!/bin/bash
# Create directory structure just in case it doesn't exist (clean build removed it)
mkdir -p /Users/hak/projectshelio/Helio/HelioKeyboard/target/aarch64-apple-darwin/release/

# Copy the fresh release build to where Xcode expects it
cp /Users/hak/projectshelio/Helio/HelioKeyboard/target/release/libhelio_keyboard.a /Users/hak/projectshelio/Helio/HelioKeyboard/target/aarch64-apple-darwin/release/libhelio_keyboard.a
cp /Users/hak/projectshelio/Helio/HelioKeyboard/target/release/libhelio_keyboard.a /Users/hak/projectshelio/Helio/Helio/libhelio_keyboard.a

echo "✅ Library files synchronized."
