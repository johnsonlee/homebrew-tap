class Graphite < Formula
  desc "Build, query, and serve Graphite static analysis graphs"
  homepage "https://github.com/johnsonlee/graphite"
  version "2.5.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.5.0/graphite-2.5.0-aarch64-apple-darwin.tar.gz"
      sha256 "c95ec798dcaa693c77f068728fc117823bdc361e64afbf5dd0f2c1af940b5b2f"
    end
    on_intel do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.5.0/graphite-2.5.0-x86_64-apple-darwin.tar.gz"
      sha256 "5faa65b5c15f1960dbb5b12913f53447b5ba5696db60d96cb317a749b4e0f4d4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.5.0/graphite-2.5.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "485791e4aeafe468c2ab3f71de244c052b25531571a0b0d4644d4a47f490e96d"
    end
    on_intel do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.5.0/graphite-2.5.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "afd4b98042a6286a86b4ab1f8b56e89d1e3a7e76080f4773af5d5437635397c7"
    end
  end

  # The JVM frontend: `graphite build` runs it to analyse JAR/WAR/APK inputs.
  resource "frontend-jvm" do
    url "https://github.com/johnsonlee/graphite/releases/download/v2.5.0/graphite.jar"
    sha256 "68703fee06e055abe0afa506947bbc1a8a50761556f651866b13c56b689edcab"
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
