if [ -e "$(which dnvm.sh)" ]; then
    source dnvm.sh
    export MONO_MANAGED_WATCHER=disabled
fi
