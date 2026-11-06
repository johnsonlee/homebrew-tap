class Graphite < Formula
  desc "Build, query, and serve Graphite static analysis graphs"
  homepage "https://github.com/johnsonlee/graphite"
  version "2.14.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.14.0/graphite-2.14.0-aarch64-apple-darwin.tar.gz"
      sha256 "98cf71fe86cb3636d32243f41297289a22d19e2b0580439447c6caa07d7c6a45"
    end
    on_intel do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.14.0/graphite-2.14.0-x86_64-apple-darwin.tar.gz"
      sha256 "05f59b38343efed1870a3815edd5ac038c7e1d68f028d65a16f499a7410e8737"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.14.0/graphite-2.14.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "69533b52854be33e3b0826d0a33da2d97b3222ad375dcea06a9f501ba50fb064"
    end
    on_intel do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.14.0/graphite-2.14.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "44bc587f88201bababaa489c05376b61b11d6db4478718caf5eaae191c896bbf"
    end
  end

  # The JVM frontend: `graphite build` runs it to analyse JAR/WAR/APK inputs.
  resource "frontend-jvm" do
    url "https://github.com/johnsonlee/graphite/releases/download/v2.14.0/graphite.jar"
    sha256 "4062adec8534678a7b5b188ff858864e983bc0304b55f07635f8163c53f73df4"
  end

  # The Apple frontend: `graphite build` runs it on a Swift package. It drives
  # the Swift toolchain on the machine (Xcode, or swift.org's on Linux); the
  # formula does not depend on one.
  resource "frontend-apple" do
    on_macos do
      on_arm do
        url "https://github.com/johnsonlee/graphite/releases/download/v2.14.0/graphite-frontend-apple-2.14.0-aarch64-apple-darwin.tar.gz"
        sha256 "efdca3e4378213bba585feb2ff26a7331dd90d885faae0f9f59f1be6c2953261"
      end
      on_intel do
        url "https://github.com/johnsonlee/graphite/releases/download/v2.14.0/graphite-frontend-apple-2.14.0-x86_64-apple-darwin.tar.gz"
        sha256 "840e5413491cd60ed023deabd8bb66f6ab64ac763a1ff82083cb49aae8edfd7a"
      end
    end
    on_linux do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.14.0/graphite-frontend-apple-2.14.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a03d42fa54efc7255fde1bfdd9d3716854e3062ac7e98329927041c534838023"
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
