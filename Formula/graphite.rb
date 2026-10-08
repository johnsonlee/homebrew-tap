class Graphite < Formula
  desc "Build, query, and serve Graphite static analysis graphs"
  homepage "https://github.com/johnsonlee/graphite"
  version "2.11.2"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.11.2/graphite-2.11.2-aarch64-apple-darwin.tar.gz"
      sha256 "dcf937b6917e2589d8c55714c4635c5bd8f17d303f4ea6d6d0f31dd3314cf9eb"
    end
    on_intel do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.11.2/graphite-2.11.2-x86_64-apple-darwin.tar.gz"
      sha256 "5d5ceddbc7fc268597e8aea591ed2c06b572fa959a9d7a12685a9009d24b5759"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.11.2/graphite-2.11.2-aarch64-unknown-linux-musl.tar.gz"
      sha256 "e3fe6c2eb1c18a2eefba93f01e3f87fc74cecf83c00f4be9ba8f6096d77d9b69"
    end
    on_intel do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.11.2/graphite-2.11.2-x86_64-unknown-linux-musl.tar.gz"
      sha256 "03d5c588fc86f562b2d3f2557fe730a290c57f4f579f6421954ee23d2f91621d"
    end
  end

  # The JVM frontend: `graphite build` runs it to analyse JAR/WAR/APK inputs.
  resource "frontend-jvm" do
    url "https://github.com/johnsonlee/graphite/releases/download/v2.11.2/graphite.jar"
    sha256 "4f89dc26bb74f591cd5390fa194cba05f87506a8d16afd7cadfc8ca555ef7ff8"
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
