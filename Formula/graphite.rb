class Graphite < Formula
  desc "Query and inspect Graphite static analysis graphs"
  homepage "https://github.com/johnsonlee/graphite"
  version "1.0.0-rc8"
  url "https://github.com/johnsonlee/graphite/releases/download/v#{version}/graphite-query.jar"
  sha256 "24777a6dfa8b8935058b614652d62b89cace70d555cf90ee6085234e375d77c2"
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
