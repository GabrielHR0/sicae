#!/usr/bin/env bash
set -euo pipefail

# Force the Listen gem to use polling (helps file changes to be detected when using
# bind mounts from Windows/OSX hosts where inotify events may not arrive).
export LISTEN_FORCE_POLLING=1

# Normalize Windows line endings in bin/ scripts (useful when mounting host files)
if [ -d /rails/bin ]; then
  find /rails/bin -type f -exec sed -i 's/\r$//' {} + || true
fi

# Ensure gems are installed for development
if ! bundle check >/dev/null 2>&1; then
  echo "Installing missing gems..."
  bundle install --jobs=4 --retry=3
fi

# Remove stale server PID (leftover from previous runs on host mounts)
if [ -f /rails/tmp/pids/server.pid ]; then
  echo "Removing stale PID file /rails/tmp/pids/server.pid"
  rm -f /rails/tmp/pids/server.pid || true
fi

exec "$@"
