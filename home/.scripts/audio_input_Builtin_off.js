function run(input, parameters) {
    const current = Application.currentApplication()
    current.includeStandardAdditions = true
    current.doShellScript("/opt/homebrew/bin/SwitchAudioSource -t input -u BuiltInMicrophoneDevice")
    current.setVolume(null, { inputVolume: 0 })
    return input;
}