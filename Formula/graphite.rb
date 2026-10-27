class Graphite < Formula
  desc "Build, query, and serve Graphite static analysis graphs"
  homepage "https://github.com/johnsonlee/graphite"
  version "2.12.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.12.0/graphite-2.12.0-aarch64-apple-darwin.tar.gz"
      sha256 "f2372834708a2f2aeab3df87c38e77b2d494b92c3502ddf04de99c082cf1ce99"
    end
    on_intel do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.12.0/graphite-2.12.0-x86_64-apple-darwin.tar.gz"
      sha256 "ba1237a4138a29823610dad5fa445fd691fbf451bc5d3ac32e12a7c2771e7652"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.12.0/graphite-2.12.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "3982b7496f7f6f70d3bcde498f451a9731ef18bfd4e530bb03bdac9bf0acd442"
    end
    on_intel do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.12.0/graphite-2.12.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "a42512bdaace9bd3bcb3def4a9335f86bcfe2a1e93c481d2a7556cc62c9b5654"
    end
  end

  # The JVM frontend: `graphite build` runs it to analyse JAR/WAR/APK inputs.
  resource "frontend-jvm" do
    url "https://github.com/johnsonlee/graphite/releases/download/v2.12.0/graphite.jar"
    sha256 "d7aa8d726011d3d275f8444b402d21726dfbe4f2014d3b5825f8c763a4abf41b"
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
