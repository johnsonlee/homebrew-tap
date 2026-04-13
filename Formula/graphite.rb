class Graphite < Formula
  desc "Query and inspect Graphite static analysis graphs"
  homepage "https://github.com/johnsonlee/graphite"
  version "1.0.0-rc13"
  url "https://github.com/johnsonlee/graphite/releases/download/v#{version}/graphite-query.jar"
  sha256 "50c7924734ad888fe98dbed4c0ea8683ae5854d59bcb15a556a26fa770eac4c3"
  license "Apache-2.0"

  depends_on "openjdk@17"

  def install
    libexec.install "graphite-query.jar"
    (bin/"graphite").write <<~EOS
      #!/bin/bash
      export JAVA_TOOL_OPTIONS="${JAVA_TOOL_OPTIONS:-${JAVA_OPTS:--Xmx8g}}"
      AGENT_ARGS=""
      PASSTHROUGH_ARGS=()
      for arg in "$@"; do
        if [ "$arg" = "--profile" ]; then
          PROFILE_OUT="${GRAPHITE_PROFILE:-profile.html}"
          AP_LIB=""
          ASPROF="$(which asprof 2>/dev/null)"
          if [ -n "$ASPROF" ]; then
            AP_DIR="$(dirname "$ASPROF")/../lib"
            for ext in dylib so; do
              [ -f "$AP_DIR/libasyncProfiler.$ext" ] && AP_LIB="$AP_DIR/libasyncProfiler.$ext" && break
            done
          fi
          if [ -n "$AP_LIB" ]; then
            AGENT_ARGS="-agentpath:$AP_LIB=start,event=cpu,file=$PROFILE_OUT"
          else
            echo "async-profiler not found. Install: brew install async-profiler" >&2
            exit 1
          fi
        else
          PASSTHROUGH_ARGS+=("$arg")
        fi
      done
      exec "#{Formula["openjdk@17"].opt_bin}/java" $AGENT_ARGS -jar "#{libexec}/graphite-query.jar" "${PASSTHROUGH_ARGS[@]}"
    EOS
  end

  test do
    assert_match "Usage", shell_output("#{bin}/graphite --help")
  end
end
