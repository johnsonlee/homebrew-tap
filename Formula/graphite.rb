class Graphite < Formula
  desc "Build, query, and serve Graphite static analysis graphs"
  homepage "https://github.com/johnsonlee/graphite"
  version "2.16.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.16.0/graphite-2.16.0-aarch64-apple-darwin.tar.gz"
      sha256 "f443790287e978e954ac8e3bc6ec72aa7fcd5627ee80e0323ce8e86d9bac632c"
    end
    on_intel do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.16.0/graphite-2.16.0-x86_64-apple-darwin.tar.gz"
      sha256 "543d9fa70712d9ff2ca36d2b9bb0e71db01c1e874c7eb4ae35172d26eaf5f3ac"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.16.0/graphite-2.16.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "20edfa9219b348c4238d0dd15c48d3fb27c9de8e1d71694ce3db57f350808818"
    end
    on_intel do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.16.0/graphite-2.16.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "e02ac902e67df8c8a168ee2153a8f40d9b4916e999b727183d630824c723c3d8"
    end
  end

  # The JVM frontend: `graphite build` runs it to analyse JAR/WAR/APK inputs.
  resource "frontend-jvm" do
    url "https://github.com/johnsonlee/graphite/releases/download/v2.16.0/graphite.jar"
    sha256 "4efb051d916179bac63c64c4e1075c5430d314465a47fd4c814e3f378a0efdab"
  end

  # The Apple frontend: `graphite build` runs it on a Swift package. It drives
  # the Swift toolchain on the machine (Xcode, or swift.org's on Linux); the
  # formula does not depend on one.
  resource "frontend-apple" do
    on_macos do
      on_arm do
        url "https://github.com/johnsonlee/graphite/releases/download/v2.16.0/graphite-frontend-apple-2.16.0-aarch64-apple-darwin.tar.gz"
        sha256 "a54b0fc5bcafc7f97a24f295a69a37b7a7c129106f2b98163df74f7e37775418"
      end
      on_intel do
        url "https://github.com/johnsonlee/graphite/releases/download/v2.16.0/graphite-frontend-apple-2.16.0-x86_64-apple-darwin.tar.gz"
        sha256 "c3ffa12dd9aa449b32f2a59f83ed4f1b977afd90960c4232db8eb66bd6a0b11a"
      end
    end
    on_linux do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.16.0/graphite-frontend-apple-2.16.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "caaccc58238062eb30b6bb3169faf2252b2afb95fb60126e1cfef697d2a2cc69"
    end
  end

  depends_on "openjdk@17"

  def install
    libexec.install "graphite"
    resource("frontend-jvm").stage { libexec.install "graphite.jar" }
    if OS.mac? || Hardware::CPU.intel?
      resource("frontend-apple").stage { libexec.install "graphite-frontend-apple" }
    end
    (bin/"graphite").write_env_script libexec/"graphite",
      GRAPHITE_JAVA:         "#{Formula["openjdk@17"].opt_bin}/java",
      GRAPHITE_FRONTEND_JVM: "#{libexec}/graphite.jar"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/graphite --help")
    assert_match "jvm", shell_output("#{bin}/graphite frontend list")
    assert_match "apple", shell_output("#{bin}/graphite frontend list")
  end
end
