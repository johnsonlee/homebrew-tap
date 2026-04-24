class Graphite < Formula
  desc "Query and inspect Graphite static analysis graphs"
  homepage "https://github.com/johnsonlee/graphite"
  version "1.2.0-alpha.1"
  url "https://github.com/johnsonlee/graphite/releases/download/v#{version}/graphite-query.jar"
  sha256 "b168f8c0305233e7cc482ce807f6dbe05eee5f389c35b1cca836db5a478bc7cc"
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
