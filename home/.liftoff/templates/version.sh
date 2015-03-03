TARGET_PLIST="$TARGET_BUILD_DIR/$INFOPLIST_PATH"
DSYM_PLIST="$DWARF_DSYM_FOLDER_PATH/$DWARF_DSYM_FILE_NAME/Contents/Info.plist"
SETTINGS_PLIST="$TARGET_BUILD_DIR/$CONTENTS_FOLDER_PATH/Settings.bundle/Root.plist"

APP_VERSION=$(/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" "$TARGET_PLIST")
NUMBER_OF_COMMITS=$(/usr/bin/env git rev-list HEAD | wc -l | tr -d ' ')
GIT_DESCRIBE=$(/usr/bin/env git describe --tags --always)

for plist in "$TARGET_PLIST" "$DSYM_PLIST"; do
    if [ -f "$plist" ]; then
        /usr/libexec/PlistBuddy -c "Set :CFBundleVersion $NUMBER_OF_COMMITS" "$plist"
        echo "Set :CFBundleVersion $NUMBER_OF_COMMITS" "$plist"
    fi
done

if [ -f "$SETTINGS_PLIST" ]; then
    /usr/libexec/PlistBuddy -c "Set :PreferenceSpecifiers:0:DefaultValue $APP_VERSION" "$SETTINGS_PLIST"
    echo "Set Version $APP_VERSION" "$SETTINGS_PLIST"
    /usr/libexec/PlistBuddy -c "Set :PreferenceSpecifiers:1:DefaultValue $NUMBER_OF_COMMITS" "$SETTINGS_PLIST"
    echo "Set Revision $NUMBER_OF_COMMITS" "$SETTINGS_PLIST"
    /usr/libexec/PlistBuddy -c "Set :PreferenceSpecifiers:2:DefaultValue $GIT_DESCRIBE" "$SETTINGS_PLIST"
    echo "Set Identifier $GIT_DESCRIBE" "$SETTINGS_PLIST"
fi
