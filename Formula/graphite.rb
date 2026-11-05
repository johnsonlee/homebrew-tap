class Graphite < Formula
  desc "Build, query, and serve Graphite static analysis graphs"
  homepage "https://github.com/johnsonlee/graphite"
  version "2.13.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.13.0/graphite-2.13.0-aarch64-apple-darwin.tar.gz"
      sha256 "7a4a64283cb6f1c04a63102e377dda7af4f7a36526d1d3f2cc91b2a5d79fc84c"
    end
    on_intel do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.13.0/graphite-2.13.0-x86_64-apple-darwin.tar.gz"
      sha256 "146dc380006dde357de2a53ad83250d39d6bd13269ca98a90882352deb850740"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.13.0/graphite-2.13.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "0287b11c33b9fbdc542a480c62cb73777c2f5ba91796c355bcbfc3f9b2c0aba1"
    end
    on_intel do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.13.0/graphite-2.13.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "9a90924ff1db10d20fc189f2217893741595599517bf675b2278dd4de45b4430"
    end
  end

  # The JVM frontend: `graphite build` runs it to analyse JAR/WAR/APK inputs.
  resource "frontend-jvm" do
    url "https://github.com/johnsonlee/graphite/releases/download/v2.13.0/graphite.jar"
    sha256 "713a878bc771cb4af177eda0fd420e37a76f9800e3f2405861f7999191b5eac1"
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
