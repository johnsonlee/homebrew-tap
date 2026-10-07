class Graphite < Formula
  desc "Build, query, and serve Graphite static analysis graphs"
  homepage "https://github.com/johnsonlee/graphite"
  version "2.11.1"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.11.1/graphite-2.11.1-aarch64-apple-darwin.tar.gz"
      sha256 "352a68a03fb7eaf8848350bba7081d3ccc80e0d0c654f3c6e28420ac06a70ef6"
    end
    on_intel do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.11.1/graphite-2.11.1-x86_64-apple-darwin.tar.gz"
      sha256 "58ecd85fbe8e9cc03619bc4b0bc8f2877d3403e025bd146bb23e2b577d12c71c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.11.1/graphite-2.11.1-aarch64-unknown-linux-musl.tar.gz"
      sha256 "99675c748bc01545b998591d4daf0663fc93405f3ff9a7aba06f9415e3ec1298"
    end
    on_intel do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.11.1/graphite-2.11.1-x86_64-unknown-linux-musl.tar.gz"
      sha256 "34f81b7c664a02ef1ee816b78dc47670ebf2bd34a3957aa0de8bf9fff1a0056f"
    end
  end

  # The JVM frontend: `graphite build` runs it to analyse JAR/WAR/APK inputs.
  resource "frontend-jvm" do
    url "https://github.com/johnsonlee/graphite/releases/download/v2.11.1/graphite.jar"
    sha256 "9f2b6e0fcf04ce31a1f11424aa61e34c1b640f5d632a90e63b1a3dbbee3cf238"
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
