_:
''
  #!/usr/bin/env bash
  ZJ_SESSIONS=$(zellij list-sessions --no-formatting)
  NO_SESSIONS=$(echo "$ZJ_SESSIONS" | wc -l)

  if [ "$NO_SESSIONS" -ge 2 ]; then
  zellij attach --force-run-commands \
  "$(echo "$ZJ_SESSIONS" | sed 's/|/ /' | awk '{print $1}' | sk)"
  else
  zellij attach -c
  fi
''
