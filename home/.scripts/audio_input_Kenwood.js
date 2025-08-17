function run(input, parameters) {
    const current = Application.currentApplication()
    current.includeStandardAdditions = true
    current.doShellScript("/opt/homebrew/bin/SwitchAudioSource -t input -n 'KENWOOD KH-M700'")
    current.setVolume(null, { inputVolume: 100 })
    return input;
}