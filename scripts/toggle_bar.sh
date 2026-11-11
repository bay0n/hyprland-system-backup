#!/bin/bash

# Waybar handles SIGUSR1 as a visibility toggle.
pkill -SIGUSR1 waybar
