function run(input, parameters) {
    const current = Application.currentApplication()
    current.includeStandardAdditions = true
    current.doShellScript("/opt/homebrew/bin/SwitchAudioSource -t output -s 'USAMI Kosuke AirPods Pro 2'")
    current.setVolume(null, { outputVolume: 60 })
    return input;
}