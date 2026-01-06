# Shared device command recipes (SSH-based)
#
# These recipes interact with running devices over SSH.
# All commands assume root@<host> SSH access is configured.

# Show RAUC status on a running device
[group('device')]
rauc-status host:
    ssh root@{{host}} "rauc status"

# Install RAUC bundle on a running device
[group('device')]
[script('bash')]
rauc-install host bundle:
    echo "Copying bundle to device..."
    scp {{bundle}} root@{{host}}:/data/update.raucb
    echo "Installing bundle..."
    ssh root@{{host}} "rauc install /data/update.raucb && rm /data/update.raucb"
    echo "Done. Reboot device to boot into new slot."

# Reboot a device
[group('device')]
reboot host:
    ssh root@{{host}} "reboot"

# Show system status on a running device
[group('device')]
[script('bash')]
status host:
    echo "=== RAUC Status ==="
    ssh root@{{host}} "rauc status" || true
    echo ""
    echo "=== Disk Usage ==="
    ssh root@{{host}} "df -h" || true
    echo ""
    echo "=== Uptime ==="
    ssh root@{{host}} "uptime" || true
