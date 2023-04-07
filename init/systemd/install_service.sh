#!/bin/bash

# Install the qemuvm service onto the system

cp qemuvm\@.service /etc/systemd/system
systemctl daemon-reload
