function run(input, parameters) {
    const current = Application.currentApplication()
    current.includeStandardAdditions = true
    current.doShellScript("/opt/homebrew/bin/SwitchAudioSource -t output -u 'Studio Display'")
    current.setVolume(null, { outputVolume: 50 })
    return input;
}