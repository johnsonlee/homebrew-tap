class Graphite < Formula
  desc "Build, query, and serve Graphite static analysis graphs"
  homepage "https://github.com/johnsonlee/graphite"
  version "2.11.3"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.11.3/graphite-2.11.3-aarch64-apple-darwin.tar.gz"
      sha256 "3ed8f0759eef761bb60903a6e73cf206fc76fd737dff2e054fd1d59dccd06040"
    end
    on_intel do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.11.3/graphite-2.11.3-x86_64-apple-darwin.tar.gz"
      sha256 "7f6ffcb23cf35e36637efacda691040a9efec215cc1f750ad6d8cad96ece7af4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.11.3/graphite-2.11.3-aarch64-unknown-linux-musl.tar.gz"
      sha256 "ed1fe28981c7f48a2518174a6af1a1eab8caa90233daef8c6e849553b2611693"
    end
    on_intel do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.11.3/graphite-2.11.3-x86_64-unknown-linux-musl.tar.gz"
      sha256 "83df09f969a01e8bdac0cfba13875d13ac28c96a40091671c7e41ad6d5f20565"
    end
  end

  # The JVM frontend: `graphite build` runs it to analyse JAR/WAR/APK inputs.
  resource "frontend-jvm" do
    url "https://github.com/johnsonlee/graphite/releases/download/v2.11.3/graphite.jar"
    sha256 "2f776b7a07cf20915e10f44774febceea34939d5abec445947d65270f47ad129"
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
