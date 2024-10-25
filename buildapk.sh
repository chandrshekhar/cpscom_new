
# # flutter clean
# # flutter pub get
# # flutter build apk --release


# # Step 1: Clean and fetch dependencies
# flutter clean
# flutter pub get

# # Step 2: Extract the version from pubspec.yaml
# VERSION=$(grep 'version:' pubspec.yaml | sed 's/version: //' | cut -d "+" -f1)

# # Step 3: Build the APK in release mode
# flutter build apk --release

# # Step 4: Rename the APK with app name and version
# APK_PATH="build/app/outputs/flutter-apk/app-release.apk"
# NEW_APK_NAME="Kidkruz Driver v$VERSION.apk"

# # Check if the APK exists and rename it
# if [ -f "$APK_PATH" ]; then
#     mv "$APK_PATH" "build/app/outputs/flutter-apk/$NEW_APK_NAME"
#     echo "APK has been renamed to $NEW_APK_NAME"
# else
#     echo "APK build failed or APK file not found!"
# fi



#!/bin/bash

# Set variables
# APP_NAME="Kidkruz Driver"
# APK_OUTPUT_DIR="build/app/outputs/flutter-apk"
# LOG_FILE="build_logs.txt"

# # Function to log messages
# log_message() {
#     echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a $LOG_FILE
# }

# # Step 1: Clean and fetch dependencies
# log_message "Starting Flutter clean and fetching dependencies..."
# if flutter clean && flutter pub get; then
#     log_message "Successfully cleaned and fetched dependencies."
# else
#     log_message "Failed during flutter clean or pub get."
#     exit 1
# fi

# # Step 2: Extract the version from pubspec.yaml
# log_message "Extracting version from pubspec.yaml..."
# VERSION=$(grep 'version:' pubspec.yaml | sed 's/version: //' | cut -d "+" -f1)

# if [[ -z "$VERSION" ]]; then
#     log_message "Failed to extract version from pubspec.yaml. Exiting."
#     exit 1
# else
#     log_message "Version extracted: $VERSION"
# fi

# # Step 3: Build the APK in release mode
# log_message "Building APK in release mode..."
# if flutter build apk --release; then
#     log_message "APK build successful."
# else
#     log_message "APK build failed. Exiting."
#     exit 1
# fi

# # Step 4: Rename the APK with app name and version
# APK_PATH="$APK_OUTPUT_DIR/app-release.apk"
# NEW_APK_NAME="${APP_NAME}_v${VERSION}.apk"

# log_message "Renaming APK..."
# if [ -f "$APK_PATH" ]; then
#     mv "$APK_PATH" "$APK_OUTPUT_DIR/$NEW_APK_NAME"
#     if [ $? -eq 0 ]; then
#         log_message "APK has been renamed to $NEW_APK_NAME"
#     else
#         log_message "Failed to rename APK."
#         exit 1
#     fi
# else
#     log_message "APK file not found at $APK_PATH. Exiting."
#     exit 1
# fi

# log_message "Build and rename process completed successfully."
#!/bin/bash

# Set variables
APP_NAME="CPSCOM"
APK_OUTPUT_DIR="build/app/outputs/flutter-apk"
LOG_FILE="build_logs.txt"
NOTIFY_EMAIL="skazhar525@gmail.com"
START_TIME=$(date +%s)

# Function to log messages
log_message() {
    local MSG_TYPE=$1
    shift
    echo "$(date '+%Y-%m-%d %H:%M:%S') - [$MSG_TYPE] $*" | tee -a $LOG_FILE
}


# Function to calculate time taken
time_taken() {
    END_TIME=$(date +%s)
    DIFF=$((END_TIME - START_TIME))
    echo "$(($DIFF / 60)) minutes and $(($DIFF % 60)) seconds"
}

# Function to clean up old APKs
cleanup_old_apks() {
    log_message "INFO" "Cleaning up old APKs..."
    find "$APK_OUTPUT_DIR" -name "*.apk" -type f -mtime +30 -exec rm {} \;
    log_message "INFO" "Old APKs cleaned."
}

# Step 1: Clean and fetch dependencies
log_message "INFO" "Starting Flutter clean and fetching dependencies..."
if flutter clean && flutter pub get; then
    log_message "INFO" "Successfully cleaned and fetched dependencies."
else
    log_message "ERROR" "Failed during flutter clean or pub get."
    send_email "APK Build Failed" "Flutter clean or pub get failed. Check logs."
    exit 1
fi

# Step 2: Extract the version from pubspec.yaml
log_message "INFO" "Extracting version from pubspec.yaml..."
VERSION=$(grep 'version:' pubspec.yaml | sed 's/version: //' | cut -d "+" -f1)

if [[ -z "$VERSION" ]]; then
    log_message "ERROR" "Failed to extract version from pubspec.yaml."
    send_email "APK Build Failed" "Version extraction failed. Check pubspec.yaml."
    exit 1
else
    log_message "INFO" "Version extracted: $VERSION"
fi

# Step 3: Build the APK in release mode
log_message "INFO" "Building APK in release mode..."
if flutter build apk --release; then
    log_message "INFO" "APK build successful."
else
    log_message "ERROR" "APK build failed."
    send_email "APK Build Failed" "APK build failed during flutter build apk. Check logs."
    exit 1
fi

# Step 4: Rename the APK with app name and version
APK_PATH="$APK_OUTPUT_DIR/app-release.apk"
NEW_APK_NAME="${APP_NAME}_v${VERSION}.apk"

log_message "INFO" "Renaming APK..."
if [ -f "$APK_PATH" ]; then
    mv "$APK_PATH" "$APK_OUTPUT_DIR/$NEW_APK_NAME"
    if [ $? -eq 0 ]; then
        log_message "INFO" "APK renamed to $NEW_APK_NAME"
    else
        log_message "ERROR" "Failed to rename APK."
        send_email "APK Build Failed" "APK rename failed. Check logs."
        exit 1
    fi
else
    log_message "ERROR" "APK file not found at $APK_PATH."
    send_email "APK Build Failed" "APK file not found after build. Check logs."
    exit 1
fi

# Step 5: Cleanup old APKs
cleanup_old_apks

# Step 6: Send success notification
send_email "APK Build Success" "APK build successful! APK: $NEW_APK_NAME"

# Step 7: Log the total time taken
TOTAL_TIME=$(time_taken)
log_message "INFO" "Total time taken: $TOTAL_TIME"
