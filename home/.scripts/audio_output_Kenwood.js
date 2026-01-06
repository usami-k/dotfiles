function run(input, parameters) {
    const current = Application.currentApplication()
    current.includeStandardAdditions = true
    current.doShellScript("/opt/homebrew/bin/SwitchAudioSource -t output -s 'KENWOOD KH-M700'")
    current.setVolume(null, { outputVolume: 75 })
    return input;
}
