class Graphite < Formula
  desc "Build, query, and serve Graphite static analysis graphs"
  homepage "https://github.com/johnsonlee/graphite"
  version "2.11.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.11.0/graphite-2.11.0-aarch64-apple-darwin.tar.gz"
      sha256 "1bf303210dfda54ee0e450c9b7ed4f5f9d3cd978e01ccfe19ef9067063e0fad5"
    end
    on_intel do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.11.0/graphite-2.11.0-x86_64-apple-darwin.tar.gz"
      sha256 "db5575f98a87a9bd824335b3d8c4f4653ab5446e6e4ab7db3e9edc0ab284289b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.11.0/graphite-2.11.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "3af84ffdc431a95785d5a323ca49255dcf89b8bd0661990a5c25ff48c845de47"
    end
    on_intel do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.11.0/graphite-2.11.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "cf3b253aa8d91d362d47d3b8dd6eddb04c47b402fe6174d67be14bf5f3646b3d"
    end
  end

  # The JVM frontend: `graphite build` runs it to analyse JAR/WAR/APK inputs.
  resource "frontend-jvm" do
    url "https://github.com/johnsonlee/graphite/releases/download/v2.11.0/graphite.jar"
    sha256 "c0ff2a9e09f29fd9688555393e9f611a723f9dd8819bff76bcd372f484db2b9e"
  end

  depends_on "openjdk@17"

  def install
    libexec.install "graphite"
    resource("frontend-jvm").stage { libexec.install "graphite.jar" }
    (bin/"graphite").write_env_script libexec/"graphite",
      GRAPHITE_JAVA:         "#{Formula["openjdk@17"].opt_bin}/java",
      GRAPHITE_FRONTEND_JVM: "#{libexec}/graphite.jar"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/graphite --help")
    assert_match "jvm", shell_output("#{bin}/graphite frontend list")
  end
end
