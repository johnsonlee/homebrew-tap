class Graphite < Formula
  desc "Build, query, and serve Graphite static analysis graphs"
  homepage "https://github.com/johnsonlee/graphite"
  version "2.6.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.6.0/graphite-2.6.0-aarch64-apple-darwin.tar.gz"
      sha256 "51c8a7f849e4685625f1e93f37f1b113bea5473c9e68f707f125d0de157668b7"
    end
    on_intel do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.6.0/graphite-2.6.0-x86_64-apple-darwin.tar.gz"
      sha256 "86430bda239c273ce5ff811a31fca4234b3257b0af81ad8cc869e1a3504942d1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.6.0/graphite-2.6.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "8590f367aa30d9134df46d94b65413a4c5307df934cf84176b90df43dda47476"
    end
    on_intel do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.6.0/graphite-2.6.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "b9fb8c9258111d105af420cba1d6719da6238b4d3b7aa62b6f846a9d285bdfcc"
    end
  end

  # The JVM frontend: `graphite build` runs it to analyse JAR/WAR/APK inputs.
  resource "frontend-jvm" do
    url "https://github.com/johnsonlee/graphite/releases/download/v2.6.0/graphite.jar"
    sha256 "38a6e3ad593707bf795b4e4a8d67f4f7beabb2acd8390fd91e2a4aa17f2c66e1"
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
