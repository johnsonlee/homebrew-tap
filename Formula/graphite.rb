class Graphite < Formula
  desc "Build, query, and serve Graphite static analysis graphs"
  homepage "https://github.com/johnsonlee/graphite"
  version "2.18.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.18.0/graphite-2.18.0-aarch64-apple-darwin.tar.gz"
      sha256 "1c1bbbe21d601c91b743fbcd124e7f8af514940ee1e2e5b82e4dbd4c22d1ec2c"
    end
    on_intel do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.18.0/graphite-2.18.0-x86_64-apple-darwin.tar.gz"
      sha256 "d5e23ea6bb534abce2b01a13ab6bbca499ab7e0439e2c8226209842eea009fc4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.18.0/graphite-2.18.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "b553c34cd4cff387d4744701350f860e8ab3fa932edb3d0d497673bf831c1435"
    end
    on_intel do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.18.0/graphite-2.18.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "4d1d5fb115238d6d5c0e3821ba1f192cfa0ac2175d6c5d63e0a742585162a099"
    end
  end

  # The JVM frontend: `graphite build` runs it to analyse JAR/WAR/APK inputs.
  resource "frontend-jvm" do
    url "https://github.com/johnsonlee/graphite/releases/download/v2.18.0/graphite.jar"
    sha256 "d15a221a78b9ab60737ab64ffd1b4f75dd34ec64439303d7cca7a9b1a4b1063e"
  end

  # The Apple frontend: `graphite build` runs it on a Swift package. It drives
  # the Swift toolchain on the machine (Xcode, or swift.org's on Linux); the
  # formula does not depend on one.
  resource "frontend-apple" do
    on_macos do
      on_arm do
        url "https://github.com/johnsonlee/graphite/releases/download/v2.18.0/graphite-frontend-apple-2.18.0-aarch64-apple-darwin.tar.gz"
        sha256 "fd71a77a7810ce998bfc0ea14ebb2e14e04dd92d96977aa5ff181af030984227"
      end
      on_intel do
        url "https://github.com/johnsonlee/graphite/releases/download/v2.18.0/graphite-frontend-apple-2.18.0-x86_64-apple-darwin.tar.gz"
        sha256 "c53edd7ee97eafcdaf771671e9b469659c1ce8f494e8578a267a9c864bea1eea"
      end
    end
    on_linux do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.18.0/graphite-frontend-apple-2.18.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "3dbb63f631b0849c9fa029387dced132321f08985bc1d4e654e2c279b3e75aad"
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
