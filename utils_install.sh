#!/bin/zsh

set -e

install_java() {
    JAVA_VERSION=17
    # Get latest Temurin Java version code
    echo "Fetching the latest Temurin Java version..."
    LATEST_JSON=$(curl -s https://api.adoptium.net/v3/assets/latest/${JAVA_VERSION}/hotspot)
    LATEST_VERSION=$(echo "$LATEST_JSON" | grep -oP '"openjdk_version": "\K[^"]+' | sort -u | head -1)
    LATEST_PACKAGE_URL=$(echo "$LATEST_JSON" | grep -oP '"link": "\K[^"]+' | grep "jdk_x64_linux")

    if [ -z "$LATEST_PACKAGE_URL" ]; then
        echo "Failed to fetch the latest version of Temurin Java."
        exit 1
    fi

    JAVA_PACKAGE=$(basename "$LATEST_PACKAGE_URL")

    echo "Downloading Temurin Java version $LATEST_VERSION..."
    wget -q --show-progress "$LATEST_PACKAGE_URL"

    echo "Extracting Temurin Java..."
    tar -xzf "$JAVA_PACKAGE"
    
    JAVA_DIR=$(tar -tf "$JAVA_PACKAGE" | head -1 | cut -d/ -f1)

    sudo mv "$JAVA_DIR" /usr/local/
    rm "$JAVA_PACKAGE"

    echo "Setting environment variables..."
    echo "export JAVA_HOME=/usr/local/$JAVA_DIR" | sudo tee -a ~/.zshrc
    echo "export PATH=\$JAVA_HOME/bin:\$PATH" | sudo tee -a ~/.zshrc

    exec zsh

    echo "Temurin Java installed successfully."
    java -version
}

case "$1" in
    java)
        install_java
        ;;
    *)
        echo "Usage: $0 {java}"
        exit 1
esac
