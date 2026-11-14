# Waybar module: pending flake-update PR and how many packages it changes.
# No args prints the bar JSON, "open" opens the PR/run/workflow, "run" starts the workflow.
repo="oliverst8/nix-config"
branch="auto/flake-update"
workflow_file="flake-update.yml"
api="https://api.github.com/repos/$repo"
prs_url="${FLAKE_UPDATE_PRS_URL:-$api/pulls?state=open&head=${repo%%/*}:$branch}"
runs_url="${FLAKE_UPDATE_RUNS_URL:-$api/actions/workflows/$workflow_file/runs?per_page=5}"
workflow="https://github.com/$repo/actions/workflows/$workflow_file"
cache="${XDG_CACHE_HOME:-$HOME/.cache}/flake-update-status.json"
# Touched by "run": covers the seconds before GitHub lists the new run
marker="$cache.triggered"

refresh_bar() { pkill -RTMIN+9 waybar || true; }

token=""
if command -v gh > /dev/null; then token=$(gh auth token 2> /dev/null) || token=""; fi

case "${1:-}" in
  open)
    url=$(jq -r '.url // empty' "$cache" 2> /dev/null || true)
    exec xdg-open "${url:-$workflow}"
    ;;
  run)
    if [ -z "$token" ]; then exec xdg-open "$workflow"; fi
    if [ "$(jq -r '.class // empty' "$cache" 2> /dev/null || true)" = running ]; then
      notify-send "Flake update" "A run is already in progress"
      exit 0
    fi
    if err=$(gh workflow run "$workflow_file" -R "$repo" 2>&1); then
      mkdir -p "$(dirname "$marker")"
      touch "$marker"
      notify-send "Flake update" "Workflow started"
    else
      notify-send -u critical "Flake update" "Could not start the workflow: $err"
    fi
    refresh_bar
    exit 0
    ;;
esac

# Token dodges the anonymous rate limit; fall back to anonymous if it is rejected
get() {
  local out
  if [ -n "$token" ] && out=$(curl -fsS --max-time 10 -H "Authorization: Bearer $token" "$1" 2> /dev/null); then
    printf '%s' "$out"
  else
    curl -fsS --max-time 10 "$1" 2> /dev/null
  fi
}

if ! prs=$(get "$prs_url" | jq -ce 'arrays'); then
  # Offline or rate limited: show the last known state
  if [ -s "$cache" ]; then
    jq -c '.class = "stale" | .tooltip += "\n<i>Could not reach GitHub, last known state</i>"' "$cache"
  else
    echo '{"text":""}'
  fi
  exit 0
fi
runs=$(get "$runs_url" | jq -ce '.workflow_runs | arrays') || runs='[]'

since=0
if [ -e "$marker" ]; then
  since=$(stat -c %Y "$marker")
  if [ $(($(date +%s) - since)) -ge 120 ]; then
    rm -f "$marker"
    since=0
  fi
fi

out=$(jq -c --arg host "$(uname -n)" --arg workflow "$workflow" --argjson runs "$runs" --argjson since "$since" \
  --argjson can_run "$([ -n "$token" ] && echo true || echo false)" '
  def clock: fromdateiso8601 | strflocaltime("%a %H:%M");
  .[0] as $pr
  | ((try ($pr.body // "" | capture("<!-- flake-update-meta: (?<m>\\{.*?\\}) -->").m | fromjson) catch null) // null) as $meta
  | ($meta.hosts // {}) as $hosts
  | ($hosts[$host] // ($hosts | to_entries | max_by(.value.changed // 0) | .value)) as $h
  | (if $pr then ($h.changed // "?") else 0 end) as $count
  | ($pr != null and ($pr.draft or ($h != null and $h.passed == false))) as $failing
  | (first($runs[] | select(.status != "completed"))
      // (if $since > 0 and ($runs | any(.created_at | fromdateiso8601 >= $since - 30) | not)
          then {html_url: $workflow} else null end)) as $active
  | (if $pr then
      [ "<b>\($pr.title | @html)</b>" ]
      + ($hosts | to_entries | map(
          "\(.key): \(.value.changed // "?") packages"
          + (if .value.kernel then " (incl. kernel)" else "" end)
          + (if .value.passed then "" else " · build failed" end)))
      + (if $pr.draft then [ "Draft: no lock has built on every host yet" ] else [] end)
    else
      [ "No pending flake update" ]
      + (if $active == null and $runs[0] then
          [ "Last run: \($runs[0].conclusion // "?"), \($runs[0].created_at | clock)" ] else [] end)
    end) as $info
  | if $active then {
      text: " \($count)",
      tooltip: ($info + [
        "Workflow running" + (if $active.created_at then " since \($active.created_at | clock)" else "" end),
        "Click to open the run" ] | join("\n")),
      class: "running",
      url: $active.html_url
    } else {
      text: "󰚰 \($count)\(if $failing then " " else "" end)",
      tooltip: ($info + [
        (if $pr then "Click to open the pull request" else "Click to open the workflow" end),
        (if $can_run then "Right-click to run the workflow" else empty end) ] | join("\n")),
      class: (if $pr == null then "empty" elif $failing then "failing" else "pending" end),
      url: ($pr.html_url // $workflow)
    } end' <<< "$prs")

mkdir -p "$(dirname "$cache")"
printf '%s\n' "$out" > "$cache"
printf '%s\n' "$out"

# Poll every minute while a run is active; the lock keeps it to one timer
if [ "$(jq -r .class <<< "$out")" = running ]; then
  setsid -f flock -n "$cache.lock" sh -c 'sleep 60; pkill -RTMIN+9 waybar' > /dev/null 2>&1 || true
fi
