mkcd() {
    if [[ -z "$1" ]]; then
        echo "Usage: mkcd <directory>"
        return 1
    fi

    mkdir -p "$1" && cd "$1"
}

reload() {
    echo "RELOADING ~/.zshrc..."
    
    if source ~/.zshrc; then
        echo "✅ Reload complete."
    else
        echo "❌ Reload failed."
        return 1
    fi
}
