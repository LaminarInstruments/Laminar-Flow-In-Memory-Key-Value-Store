#!/bin/bash

# CQDAM Free Edition Installer
# Copyright (c) 2025 Laminar Instruments Inc.
# All Rights Reserved

set -e

PRODUCT_NAME="CQDAM Free Edition"
VERSION="1.0"
COMPANY="Laminar Instruments Inc."
YEAR="2025"

echo "=================================================="
echo "     _       LAMINAR INSTRUMENTS"
echo "    | |"      
echo "    | |      High-Performance Data Systems"
echo "    | |___   Created by Darreck Lamar Bender II"
echo "    |_____|  $PRODUCT_NAME v$VERSION"
echo "             Powered by Congruent Quantum Data Architecture Method"
echo "             $COMPANY - $YEAR"
echo "=================================================="
echo ""

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    INSTALL_DIR="/usr/local/bin"
    CONFIG_DIR="/etc/cqdam"
    echo "Installing system-wide to $INSTALL_DIR"
else
    INSTALL_DIR="$HOME/.local/bin"
    CONFIG_DIR="$HOME/.config/cqdam"
    echo "Installing to user directory $INSTALL_DIR"
    mkdir -p "$INSTALL_DIR"
fi

# Create config directory
mkdir -p "$CONFIG_DIR"

# Copy binary
echo "Installing CQDAM Free binary..."
cp cqdam_free "$INSTALL_DIR/"
chmod +x "$INSTALL_DIR/cqdam_free"

# Copy configuration files
if [ -f "cqdam.conf" ]; then
    echo "Installing configuration..."
    cp cqdam.conf "$CONFIG_DIR/"
fi

echo ""
echo "=================================================="
echo " Installation Complete"
echo "=================================================="
echo ""
echo "Quick Start:"
echo "  1. Start server: $INSTALL_DIR/cqdam_free 6379"
echo "  2. Test: cqdam-cli PING"
echo "  3. Performance: 2.5x faster than traditional solutions"
echo "  4. Commands: GET, SET, INCR, DEL, EXISTS (use uppercase)"
echo ""
echo "Documentation: See README.md"
echo "Support: darreck@laminarinstruments.com"
echo ""
echo "Upgrade to Enterprise for enhanced performance!"
echo "Visit: https://laminarinstruments.com/enterprise"
echo ""