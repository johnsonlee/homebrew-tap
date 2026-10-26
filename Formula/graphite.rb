class Graphite < Formula
  desc "Build, query, and serve Graphite static analysis graphs"
  homepage "https://github.com/johnsonlee/graphite"
  version "2.11.4"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.11.4/graphite-2.11.4-aarch64-apple-darwin.tar.gz"
      sha256 "12d6522e7eb3c193fc63116e1364bb2bec1ea1c912624a789006cfa0c56c05b4"
    end
    on_intel do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.11.4/graphite-2.11.4-x86_64-apple-darwin.tar.gz"
      sha256 "cbf4d10f2772149889b9f73a5acb2aadd2db5ee41f55f84e1b31e7bdadc31d4e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.11.4/graphite-2.11.4-aarch64-unknown-linux-musl.tar.gz"
      sha256 "663577fdf94f928a724bf40faeb7b653d906f74c2aa0b4bf4a4662625c7c12d2"
    end
    on_intel do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.11.4/graphite-2.11.4-x86_64-unknown-linux-musl.tar.gz"
      sha256 "0ba961817deb1bb35b08f411cb30bd7779e7933ff0b5c7af8fe6f0ad4bfb2a67"
    end
  end

  # The JVM frontend: `graphite build` runs it to analyse JAR/WAR/APK inputs.
  resource "frontend-jvm" do
    url "https://github.com/johnsonlee/graphite/releases/download/v2.11.4/graphite.jar"
    sha256 "0400e841405206b714259b165e3e692373979947e9fba3be52e2c6ea6f05bed6"
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
