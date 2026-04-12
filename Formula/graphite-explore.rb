class GraphiteExplore < Formula
  desc "Interactive web visualization for Graphite static analysis graphs"
  homepage "https://github.com/johnsonlee/graphite"
  version "1.0.0-rc8"
  url "https://github.com/johnsonlee/graphite/releases/download/v#{version}/graphite-explore.jar"
  sha256 "886f3ff2a7d4afea77c17c9b26255c91e2925026861284073fe0737d113c9841"
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
