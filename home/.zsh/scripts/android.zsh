android_sdk="/Applications/Android Studio.app/sdk"
if [ -d $android_sdk ]; then
	path=($path $android_sdk/platform-tools $android_sdk/tools)
fi
