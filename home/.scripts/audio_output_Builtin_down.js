function run(input, parameters) {
    const current = Application.currentApplication()
    current.includeStandardAdditions = true
    current.doShellScript("/opt/homebrew/bin/SwitchAudioSource -t output -u BuiltInSpeakerDevice")
    current.setVolume(null, { outputVolume: 30 })
    return input;
}