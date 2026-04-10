class Graphite < Formula
  desc "Query and inspect Graphite static analysis graphs"
  homepage "https://github.com/johnsonlee/graphite"
  version "0.1.0-rc3"
  url "https://github.com/johnsonlee/graphite/releases/download/v#{version}/graphite-query.jar"
  sha256 "f982b1fe61021ea5e0e2135327df48f3f1d60ad89dbe814868a57d7c4216b58a"
  license "Apache-2.0"

  depends_on "openjdk@17"

  def install
    libexec.install "graphite-query.jar"
    (bin/"graphite").write <<~EOS
      #!/bin/bash
      exec "#{Formula["openjdk@17"].opt_bin}/java" ${GRAPHITE_OPTS:--Xmx8g} -jar "#{libexec}/graphite-query.jar" "$@"
    EOS
  end

  test do
    assert_match "Usage", shell_output("#{bin}/graphite --help")
  end
end
