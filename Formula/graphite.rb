class Graphite < Formula
  desc "Build, query, and serve Graphite static analysis graphs"
  homepage "https://github.com/johnsonlee/graphite"
  version "2.15.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.15.0/graphite-2.15.0-aarch64-apple-darwin.tar.gz"
      sha256 "eb355d1b8f10a4022f7af780c342f3eec1a88434abdeebb850aa15e562d6034f"
    end
    on_intel do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.15.0/graphite-2.15.0-x86_64-apple-darwin.tar.gz"
      sha256 "842d4b1983bf5da343b90635559de4ad3fc91f52e97de70e30603607f45ee1ad"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.15.0/graphite-2.15.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "066f30976cddc365776e85d1f0005a8b1b98dcebfdaa293118f908a438911331"
    end
    on_intel do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.15.0/graphite-2.15.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "8ce8e0acf65e30597fa606ed1d033199d6732fc6408244c0ad1e0cbf821d59c8"
    end
  end

  # The JVM frontend: `graphite build` runs it to analyse JAR/WAR/APK inputs.
  resource "frontend-jvm" do
    url "https://github.com/johnsonlee/graphite/releases/download/v2.15.0/graphite.jar"
    sha256 "7872bf6116b42a5040cf785806586babeaf30049dfb8a6bacf8f76448c963005"
  end

  # The Apple frontend: `graphite build` runs it on a Swift package. It drives
  # the Swift toolchain on the machine (Xcode, or swift.org's on Linux); the
  # formula does not depend on one.
  resource "frontend-apple" do
    on_macos do
      on_arm do
        url "https://github.com/johnsonlee/graphite/releases/download/v2.15.0/graphite-frontend-apple-2.15.0-aarch64-apple-darwin.tar.gz"
        sha256 "a03fb00159c36cb788c57b7dc93e4df54517c5490b9deef156e07391e36ca064"
      end
      on_intel do
        url "https://github.com/johnsonlee/graphite/releases/download/v2.15.0/graphite-frontend-apple-2.15.0-x86_64-apple-darwin.tar.gz"
        sha256 "1b9ff5f82f72ce5574d158a6d95d971111b5e13afda94a7590b8886c2af4f95d"
      end
    end
    on_linux do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.15.0/graphite-frontend-apple-2.15.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "fd46b0fee7a05cdafdb84e79c147d20ae20ec92dcbc383e0079f1db383d337d7"
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
