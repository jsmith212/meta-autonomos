# Shared OTA recipes for RAUC + casync delta updates
#
# Required variables (set by importing Justfile):
#   rauc-bundle-dir  - Directory for output bundles
#   rauc-cert        - Path to RAUC signing certificate
#   rauc-key         - Path to RAUC signing key
#   rauc-keyring     - Path to RAUC keyring

# Convert RAUC bundle to casync format for delta updates
[group('ota')]
[script('bash')]
rauc-to-casync bundle:
    mkdir -p {{rauc-bundle-dir}}
    rauc convert \
        --cert={{rauc-cert}} \
        --key={{rauc-key}} \
        --keyring={{rauc-keyring}} \
        {{bundle}} \
        {{rauc-bundle-dir}}/$(basename {{bundle}} .raucb).caibx
    echo "Created casync bundle at {{rauc-bundle-dir}}/$(basename {{bundle}} .raucb).caibx"

# List new chunks between two casync stores (for delta upload)
[group('ota')]
[script('bash')]
casync-diff old-store new-store:
    NEW_CHUNKS=$(comm -23 \
        <(find {{new-store}} -name '*.cacnk' -printf '%f\n' 2>/dev/null | sort) \
        <(find {{old-store}} -name '*.cacnk' -printf '%f\n' 2>/dev/null | sort))
    echo "$NEW_CHUNKS"
    COUNT=$(echo "$NEW_CHUNKS" | grep -c . || true)
    # Calculate size of new chunks
    SIZE=0
    for chunk in $NEW_CHUNKS; do
        prefix="${chunk:0:4}"
        if [ -f "{{new-store}}/$prefix/$chunk" ]; then
            SIZE=$((SIZE + $(stat -c%s "{{new-store}}/$prefix/$chunk")))
        fi
    done
    SIZE_MB=$((SIZE / 1024 / 1024))
    # Output stats to stderr so they don't break pipelines
    echo "" >&2
    echo "Delta: $COUNT chunks, ${SIZE_MB}MB" >&2

# Package delta update: new chunks + bundle manifest into a tarball
# Extract on device with: tar -xf update.tar.gz -C /data
[group('ota')]
[script('bash')]
casync-package-delta old-store new-store bundle output="update.tar.gz":
    STAGING=$(mktemp -d)
    trap "rm -rf $STAGING" EXIT

    # Find new chunks
    NEW_CHUNKS=$(comm -23 \
        <(find {{new-store}} -name '*.cacnk' -printf '%f\n' 2>/dev/null | sort) \
        <(find {{old-store}} -name '*.cacnk' -printf '%f\n' 2>/dev/null | sort))

    # Stage chunks in updates.castr/
    mkdir -p "$STAGING/updates.castr"
    COUNT=0
    SIZE=0
    for chunk in $NEW_CHUNKS; do
        prefix="${chunk:0:4}"
        mkdir -p "$STAGING/updates.castr/$prefix"
        cp "{{new-store}}/$prefix/$chunk" "$STAGING/updates.castr/$prefix/"
        SIZE=$((SIZE + $(stat -c%s "{{new-store}}/$prefix/$chunk")))
        COUNT=$((COUNT + 1))
    done

    # Stage bundle manifest in rauc/
    mkdir -p "$STAGING/rauc"
    cp "{{bundle}}" "$STAGING/rauc/"

    # Create tarball
    tar -czf "{{output}}" -C "$STAGING" updates.castr rauc

    SIZE_MB=$((SIZE / 1024 / 1024))
    TARBALL_SIZE=$(du -h "{{output}}" | cut -f1)
    echo "Packaged $COUNT chunks (${SIZE_MB}MB) + bundle manifest"
    echo "Created {{output}} ($TARBALL_SIZE)"
    echo "Deploy with: tar -xf {{output}} -C /data"

# Package full update: all chunks + bundle manifest into a tarball
# Use for initial loading or development when no base version exists
# Extract on device with: tar -xf update.tar.gz -C /data
[group('ota')]
[script('bash')]
casync-package store bundle output="update.tar.gz":
    STAGING=$(mktemp -d)
    trap "rm -rf $STAGING" EXIT

    # Stage all chunks in updates.castr/
    mkdir -p "$STAGING/updates.castr"
    COUNT=0
    SIZE=0
    for chunk in $(find {{store}} -name '*.cacnk' 2>/dev/null); do
        prefix=$(basename $(dirname $chunk))
        mkdir -p "$STAGING/updates.castr/$prefix"
        cp "$chunk" "$STAGING/updates.castr/$prefix/"
        SIZE=$((SIZE + $(stat -c%s "$chunk")))
        COUNT=$((COUNT + 1))
    done

    # Stage bundle manifest in rauc/
    mkdir -p "$STAGING/rauc"
    cp "{{bundle}}" "$STAGING/rauc/"

    # Create tarball
    tar -czf "{{output}}" -C "$STAGING" updates.castr rauc

    SIZE_MB=$((SIZE / 1024 / 1024))
    TARBALL_SIZE=$(du -h "{{output}}" | cut -f1)
    echo "Packaged $COUNT chunks (${SIZE_MB}MB) + bundle manifest"
    echo "Created {{output}} ($TARBALL_SIZE)"
    echo "Deploy with: tar -xf {{output}} -C /data"

# Show casync chunk store statistics
[group('ota')]
[script('bash')]
casync-stats store:
    CHUNKS=$(find {{store}} -name '*.cacnk' 2>/dev/null | wc -l)
    SIZE=$(du -sh {{store}} 2>/dev/null | cut -f1)
    echo "Chunks: $CHUNKS"
    echo "Size: $SIZE"
