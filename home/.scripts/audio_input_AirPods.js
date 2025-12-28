function run(input, parameters) {
    const current = Application.currentApplication()
    current.includeStandardAdditions = true
    current.doShellScript("/opt/homebrew/bin/SwitchAudioSource -t input -s 'USAMI Kosuke AirPods Pro 2'")
    current.setVolume(null, { inputVolume: 100 })
    return input;
}