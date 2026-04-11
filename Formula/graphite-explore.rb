class GraphiteExplore < Formula
  desc "Interactive web visualization for Graphite static analysis graphs"
  homepage "https://github.com/johnsonlee/graphite"
  version "1.0.0-rc5"
  url "https://github.com/johnsonlee/graphite/releases/download/v#{version}/graphite-explore.jar"
  sha256 "c84d775360dab143adeb64e774f338ff4962ea04a034322b1a28b0b8e424fabf"
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
