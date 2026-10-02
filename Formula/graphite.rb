class Graphite < Formula
  desc "Build, query, and serve Graphite static analysis graphs"
  homepage "https://github.com/johnsonlee/graphite"
  version "2.10.1"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.10.1/graphite-2.10.1-aarch64-apple-darwin.tar.gz"
      sha256 "720a9ec99b3aea5fcca9deb2d491e793731935bf3d6a90e216f8287ac19cddbd"
    end
    on_intel do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.10.1/graphite-2.10.1-x86_64-apple-darwin.tar.gz"
      sha256 "e5d1b2ad6c5326e9ba55f37701b62ad0bd0e48e1e500f6bee5f2c05d1873e133"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.10.1/graphite-2.10.1-aarch64-unknown-linux-musl.tar.gz"
      sha256 "38191c041679ec79a20f2c750726034d21ee632d98a888a6883c7446ba568868"
    end
    on_intel do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.10.1/graphite-2.10.1-x86_64-unknown-linux-musl.tar.gz"
      sha256 "4a3a90d28b1e992cf138e835494242308554f0f2f8b933ae65b915513bb31ee2"
    end
  end

  # The JVM frontend: `graphite build` runs it to analyse JAR/WAR/APK inputs.
  resource "frontend-jvm" do
    url "https://github.com/johnsonlee/graphite/releases/download/v2.10.1/graphite.jar"
    sha256 "fd965ccf9c88afd172ae9fa3bcef1552fa5e6abae9a85cafb80736fc8f8c81ab"
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
