class Graphite < Formula
  desc "Build, query, and serve Graphite static analysis graphs"
  homepage "https://github.com/johnsonlee/graphite"
  version "2.7.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.7.0/graphite-2.7.0-aarch64-apple-darwin.tar.gz"
      sha256 "7fc3934592b375e80b2d64e615050bbc028759528c3ca6f261fd8fb42cafc283"
    end
    on_intel do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.7.0/graphite-2.7.0-x86_64-apple-darwin.tar.gz"
      sha256 "ec12ab859ad0db3ebfb8994e2adaab3dbc967ba4e87c6459f23c5013b04406f2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.7.0/graphite-2.7.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "e240eb5e22a80cfd99614fdd54d5c803ef2e032e9fa14c8bb4f357f1c5c71fac"
    end
    on_intel do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.7.0/graphite-2.7.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "08f842b53b03ab21352494c28a2519a85eb81c31124b5eece1db1afa3275b099"
    end
  end

  # The JVM frontend: `graphite build` runs it to analyse JAR/WAR/APK inputs.
  resource "frontend-jvm" do
    url "https://github.com/johnsonlee/graphite/releases/download/v2.7.0/graphite.jar"
    sha256 "594c50274440402d71647eeacd397ec3f6392af929412461a74d25fa19732552"
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
