class Graphite < Formula
  desc "Build, query, and serve Graphite static analysis graphs"
  homepage "https://github.com/johnsonlee/graphite"
  version "2.12.1"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.12.1/graphite-2.12.1-aarch64-apple-darwin.tar.gz"
      sha256 "397cae6e36f72c52376918e32db6122493250d8af10027e373c999ea25417af2"
    end
    on_intel do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.12.1/graphite-2.12.1-x86_64-apple-darwin.tar.gz"
      sha256 "7a3cc266e8752fc559f64aa887dc855338481fe636afceae4e8f56b704d403ab"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.12.1/graphite-2.12.1-aarch64-unknown-linux-musl.tar.gz"
      sha256 "14e60a1bb982f99909e749c8c50eb9ea0c9ab9669043a067acb560b05a6c029a"
    end
    on_intel do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.12.1/graphite-2.12.1-x86_64-unknown-linux-musl.tar.gz"
      sha256 "0b77fe82d92b34ccb8326cac175e4a8e8f3c815dc271fd945611eafd30332fe2"
    end
  end

  # The JVM frontend: `graphite build` runs it to analyse JAR/WAR/APK inputs.
  resource "frontend-jvm" do
    url "https://github.com/johnsonlee/graphite/releases/download/v2.12.1/graphite.jar"
    sha256 "0ff4fa1878d9faedb3ff34d3adf00d97bc9defc5d2ef4dfff59e571c156e6737"
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
