function run(input, parameters) {
    const current = Application.currentApplication()
    current.includeStandardAdditions = true
    current.doShellScript("/opt/homebrew/bin/SwitchAudioSource -t input -u 'ATR2100x-USB Microphone'")
    current.setVolume(null, { inputVolume: 100 })
    return input;
}