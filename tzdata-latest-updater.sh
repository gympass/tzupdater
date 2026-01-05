#!/usr/bin/env bash

URL="https://www.iana.org/time-zones/repository/tzdata-latest.tar.gz"
LOCAL_FILE="tzdata-latest.tar.gz"
TEMP_FILE="/tmp/tzdata-latest.tar.gz"

get_version_from_tarfile() {
    local tarfile="$1"
    local temp_dir="/tmp/tzdata_extract_$$"
    local version=""

    if [ ! -f "$tarfile" ]; then
        echo "N/A"
        return 1
    fi

    mkdir -p "$temp_dir"

    if tar -xzf "$tarfile" -C "$temp_dir" 2>/dev/null; then
        if [ -f "$temp_dir/version" ]; then
            version=$(cat "$temp_dir/version" 2>/dev/null | tr -d '\n\r' | xargs)
        else
            version="N/A"
        fi
    else
        version="N/A"
    fi

    rm -rf "$temp_dir"

    echo "$version"
}

download_initial_file() {
    echo "Downloading initial file"
    wget --quiet -O "$LOCAL_FILE" "$URL"
    if [ $? -eq 0 ]; then
        NEW_VERSION=$(get_version_from_tarfile "$LOCAL_FILE")
        echo "New initial file with version: $NEW_VERSION"
    else
        echo "Error downloading initial file"
        exit 1
    fi
    exit 0
}

handle_identical_files() {
    echo "File already on the latest version"
    CURRENT_VERSION=$(get_version_from_tarfile "$LOCAL_FILE")
    echo "Current version: $CURRENT_VERSION"
    rm "$TEMP_FILE"
}

update_file() {
    OLD_VERSION=$(get_version_from_tarfile "$LOCAL_FILE")
    NEW_VERSION=$(get_version_from_tarfile "$TEMP_FILE")
    echo "Old version: $OLD_VERSION"
    echo "New version:     $NEW_VERSION"
    echo "Updating local file"

    mv "$TEMP_FILE" "$LOCAL_FILE"

    if [ $? -eq 0 ]; then
        echo "File updated: $LOCAL_FILE"
    else
        echo "Error moving the new file"
        exit 1
    fi
}

if [ ! -f "$LOCAL_FILE" ]; then
    download_initial_file
fi

wget --quiet -O "$TEMP_FILE" "$URL"

if [ $? -ne 0 ]; then
    echo "Failed to download the file"
    exit 1
fi

LOCAL_MD5=$(md5sum "$LOCAL_FILE" | cut -d' ' -f1)
TEMP_MD5=$(md5sum "$TEMP_FILE" | cut -d' ' -f1)
if [ "$LOCAL_MD5" = "$TEMP_MD5" ]; then
    handle_identical_files
else
    update_file
fi
