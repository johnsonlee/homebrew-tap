class Graphite < Formula
  desc "Query and inspect Graphite static analysis graphs"
  homepage "https://github.com/johnsonlee/graphite"
  version "1.0.0-rc5"
  url "https://github.com/johnsonlee/graphite/releases/download/v#{version}/graphite-query.jar"
  sha256 "2578bf6b7e5706862a782940bf48303d19729880b70af53c935c8725b1189548"
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
