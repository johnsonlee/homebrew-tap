class Graphite < Formula
  desc "Build, query, and serve Graphite static analysis graphs"
  homepage "https://github.com/johnsonlee/graphite"
  version "2.17.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.17.0/graphite-2.17.0-aarch64-apple-darwin.tar.gz"
      sha256 "1fe6f08dd840de33fd9dbce0d7f4f6901f59ed701c6c6ddbe7df999d8335c231"
    end
    on_intel do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.17.0/graphite-2.17.0-x86_64-apple-darwin.tar.gz"
      sha256 "09fffbf12c4f8ce9f9e2b18685e135f7e4c587ce33bdbad1ffa5a84f809757e8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.17.0/graphite-2.17.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "b3dd3d5a75b8e39775e7ca436f45b0597cec08df3f6228bea93a9bbc573456b1"
    end
    on_intel do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.17.0/graphite-2.17.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "cd7cefbede50e54020f849febf21fbc7ff7404c2f228528975ee60a394ca4698"
    end
  end

  # The JVM frontend: `graphite build` runs it to analyse JAR/WAR/APK inputs.
  resource "frontend-jvm" do
    url "https://github.com/johnsonlee/graphite/releases/download/v2.17.0/graphite.jar"
    sha256 "c5ee9a4c75c7320cf4eb72121693a8f4daa28d7461b686c6d7471139ccfa7481"
  end

  # The Apple frontend: `graphite build` runs it on a Swift package. It drives
  # the Swift toolchain on the machine (Xcode, or swift.org's on Linux); the
  # formula does not depend on one.
  resource "frontend-apple" do
    on_macos do
      on_arm do
        url "https://github.com/johnsonlee/graphite/releases/download/v2.17.0/graphite-frontend-apple-2.17.0-aarch64-apple-darwin.tar.gz"
        sha256 "caa8546bf720065efee541560065d67683f4b6b21cd699d5cbcb8a8a3d70df86"
      end
      on_intel do
        url "https://github.com/johnsonlee/graphite/releases/download/v2.17.0/graphite-frontend-apple-2.17.0-x86_64-apple-darwin.tar.gz"
        sha256 "f8236a9087f81425da878daa270967d4329feec85ed51f9c1c14ce1158c4a407"
      end
    end
    on_linux do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.17.0/graphite-frontend-apple-2.17.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a522c18a37fe90987d388f26b6895b0ac9f8a8270bff2f65fb12904fd0041af4"
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
