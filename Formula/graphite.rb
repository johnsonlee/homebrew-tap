class Graphite < Formula
  desc "Build, query, and serve Graphite static analysis graphs"
  homepage "https://github.com/johnsonlee/graphite"
  version "2.9.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.9.0/graphite-2.9.0-aarch64-apple-darwin.tar.gz"
      sha256 "fdd4d96df1beaf971a6f8d5a2f7ff180fea70b1803bdc8b0f0cd5c8ab295de34"
    end
    on_intel do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.9.0/graphite-2.9.0-x86_64-apple-darwin.tar.gz"
      sha256 "1424ce48cef88d333551e97ba0f978c8fa1d8219d4acdfb476adf9a06a8f9028"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.9.0/graphite-2.9.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "36558c07e04d08db759ecbc737d0f07ad27e4e3bd1c9c37b79c4618b7a8eba21"
    end
    on_intel do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.9.0/graphite-2.9.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "2b3841713d798faf193d58b7678524a58e02a1a587a00eeea9ca276b280db421"
    end
  end

  # The JVM frontend: `graphite build` runs it to analyse JAR/WAR/APK inputs.
  resource "frontend-jvm" do
    url "https://github.com/johnsonlee/graphite/releases/download/v2.9.0/graphite.jar"
    sha256 "acf08abd3bc5a9999bef52fabaa4b0d2e9c475faa4dad75378fe1eecb616a5b7"
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
