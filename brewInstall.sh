#!/bin/bash

# Function to check if Rosetta 2 is installed
function check_rosetta() {
    if /usr/bin/pgrep oahd &> /dev/null; then
        echo "Rosetta 2 is already installed."
        return 0
    else
        echo "Rosetta 2 is not installed."
        return 1
    fi
}

# Function to check if Xcode Command Line Tools are installed
function check_xcode_cli() {
    if xcode-select --print-path &> /dev/null; then
        echo "Xcode Command Line Tools are already installed."
        return 0
    else
        echo "Xcode Command Line Tools are not installed."
        return 1
    fi
}

# Function to check if Homebrew is installed
function check_homebrew() {
    if command -v brew &> /dev/null; then
        echo "Homebrew is already installed."
        return 0
    else
        echo "Homebrew is not installed."
        return 1
    fi
}

# Main function
function main() {
    # Install Rosetta 2 if not installed
    if ! check_rosetta; then
        echo "Installing Rosetta 2..."
        /usr/sbin/softwareupdate --install-rosetta --agree-to-license
        echo "Rosetta 2 installed."
    fi

    # Install Xcode Command Line Tools if not installed
    if ! check_xcode_cli; then
        echo "Installing Xcode Command Line Tools..."
        # Install Xcode Command Line Tools using softwareupdate to avoid the popup
        touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
        softwareupdate -i -a --verbose
        rm /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress

        # Wait for Xcode Command Line Tools to be installed
        until xcode-select --print-path &> /dev/null; do
            echo "Waiting for Xcode Command Line Tools to be installed..."
            sleep 5
        done

        echo "Xcode Command Line Tools installed."
    fi

    # Install Homebrew if not installed
    if ! check_homebrew; then
        echo "Installing Homebrew..."
        NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # Add Homebrew to PATH
        echo "Adding Homebrew to PATH..."
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.bash_profile
        eval "$(/opt/homebrew/bin/brew shellenv)"
        source ~/.bash_profile
    fi

    # Verify Homebrew installation
    echo "Verifying Homebrew installation..."
    brew --version

    echo "Homebrew installation complete."
}

# Run the main function
main
