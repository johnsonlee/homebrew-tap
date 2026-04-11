class GraphiteExplore < Formula
  desc "Interactive web visualization for Graphite static analysis graphs"
  homepage "https://github.com/johnsonlee/graphite"
  version "0.1.0-rc6"
  url "https://github.com/johnsonlee/graphite/releases/download/v#{version}/graphite-explore.jar"
  sha256 "dc2c7e0332ad94a305919f9e399ff6e72ce6de2fbd9699c87b86ae2fb7240d88"
  license "Apache-2.0"

  depends_on "openjdk@17"

  def install
    libexec.install "graphite-explore.jar"
    (bin/"graphite-explore").write <<~EOS
      #!/bin/bash
      exec "#{Formula["openjdk@17"].opt_bin}/java" ${GRAPHITE_OPTS:--Xmx8g} -jar "#{libexec}/graphite-explore.jar" "$@"
    EOS
  end

  test do
    assert_match "Usage", shell_output("#{bin}/graphite-explore --help")
  end
end
