class GraphiteExplore < Formula
  desc "Interactive web visualization for Graphite static analysis graphs"
  homepage "https://github.com/johnsonlee/graphite"
  url "https://github.com/johnsonlee/graphite/releases/download/v2.0.0/graphite-explore.jar"
  version "2.0.0"
  sha256 "b370745c5fea4036ab3cfda99c1bfdf541bf767ff9d3f28f72dc434945cbd031"
  license "Apache-2.0"

  depends_on "openjdk@17"

  def install
    libexec.install "graphite-explore.jar"
    (bin/"graphite-explore").write <<~EOS
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
      exec "#{formula_opt_bin("openjdk@17")}/java" $AGENT_ARGS -jar "#{libexec}/graphite-explore.jar" "${PASSTHROUGH_ARGS[@]}"
    EOS
  end

  test do
    assert_match "Usage", shell_output("#{bin}/graphite-explore --help")
  end
end
