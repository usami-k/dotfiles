android_sdk="$HOME/Library/Android/sdk"
if [ -d $android_sdk ]; then
	path=($path $android_sdk/platform-tools $android_sdk/tools)
fi
