
# List of keywords to temporarily change
keywords=(
    "animations:enabled"
    "decoration:shadow:enabled"
    "decoration:blur:enabled"
    "general:gaps_in"
    "general:gaps_out"
    "general:border_size"
    "decoration:rounding"
)

# Save current values
declare -A original_values
for key in "${keywords[@]}"; do
    value=$(hyprctl getoption "$key" | grep 'int:' | awk '{print $2}')
    original_values["$key"]=$value
done
# Save current workspace ID
current_ws=$(hyprctl activeworkspace -j | jq -r .id)
# Apply lock-time settings
hyprctl --batch "\
    keyword animations:enabled 0;\
    keyword decoration:shadow:enabled 0;\
    keyword decoration:blur:enabled 0;\
    keyword general:gaps_in 0;\
    keyword general:gaps_out 0;\
    keyword general:border_size 1;\
    keyword decoration:rounding 0"

# Switch to dummy workspace and start ghostty
#hyprctl dispatch workspace 696969

ghostty -e 'sh -c "asciiquarium; exec $SHELL"' &
GHOSTTY_PID=$!

# Run hyprlock and wait for it to finish
hyprlock
# Return to original workspace
hyprctl dispatch workspace "$current_ws"
# Kill ghostty process
kill $GHOSTTY_PID 2>/dev/null

# Restore original settings
restore_batch=""
for key in "${!original_values[@]}"; do
    restore_batch+="keyword $key ${original_values[$key]};"
done

hyprctl --batch "$restore_batch"

