# Waybar module: pending flake-update PR and how many packages it changes.
repo="oliverst8/nix-config"
branch="auto/flake-update"
api="${FLAKE_UPDATE_API:-https://api.github.com/repos/$repo/pulls?state=open&head=${repo%%/*}:$branch}"
cache="${XDG_CACHE_HOME:-$HOME/.cache}/flake-update-status.json"

if [ "${1:-}" = open ]; then
  url=$(jq -r '.url // empty' "$cache" 2>/dev/null || true)
  exec xdg-open "${url:-https://github.com/$repo/pulls}"
fi

fetch() {
  curl -fsS --max-time 10 -H "Accept: application/vnd.github+json" "$@" "$api" \
    | jq -e 'if type == "array" then . else error("not a list") end'
}

# Token dodges the anonymous rate limit; fall back to anonymous if it is rejected
prs=""
if command -v gh > /dev/null && token=$(gh auth token 2> /dev/null); then
  prs=$(fetch -H "Authorization: Bearer $token" 2> /dev/null) || prs=""
fi
if [ -z "$prs" ] && ! prs=$(fetch 2> /dev/null); then
  # Offline or rate limited: show the last known state
  if [ -s "$cache" ]; then
    jq -c 'if .text != "" then .class = "stale" | .tooltip += "\n<i>Could not reach GitHub, last known state</i>" else . end' "$cache"
  else
    echo '{"text":""}'
  fi
  exit 0
fi

out=$(jq -c --arg host "$(uname -n)" '
  if length == 0 then {text: ""} else
    .[0] as $pr
    | ((try ($pr.body // "" | capture("<!-- flake-update-meta: (?<m>\\{.*?\\}) -->").m | fromjson) catch null) // null) as $meta
    | ($meta.hosts // {}) as $hosts
    | ($hosts[$host] // ($hosts | to_entries | max_by(.value.changed // 0) | .value)) as $h
    | ($pr.draft or ($h != null and $h.passed == false)) as $failing
    | {
        text: "󰚰 \($h.changed // "?")\(if $failing then " " else "" end)",
        tooltip: (
          [ "<b>\($pr.title | @html)</b>" ]
          + ($hosts | to_entries | map(
              "\(.key): \(.value.changed // "?") packages"
              + (if .value.kernel then " (incl. kernel)" else "" end)
              + (if .value.passed then "" else " · build failed" end)))
          + (if $pr.draft then [ "Draft: no lock has built on every host yet" ] else [] end)
          + [ "Click to open the pull request" ]
          | join("\n")),
        class: (if $failing then "failing" else "pending" end),
        url: $pr.html_url
      }
  end' <<< "$prs")

mkdir -p "$(dirname "$cache")"
printf '%s\n' "$out" > "$cache"
printf '%s\n' "$out"
