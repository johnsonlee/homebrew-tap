class Graphite < Formula
  desc "Build, query, and serve Graphite static analysis graphs"
  homepage "https://github.com/johnsonlee/graphite"
  version "2.12.2"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.12.2/graphite-2.12.2-aarch64-apple-darwin.tar.gz"
      sha256 "8541bb5443d5be1062845394f28ca49e0bee887b57abfe87c1db3d999fc45143"
    end
    on_intel do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.12.2/graphite-2.12.2-x86_64-apple-darwin.tar.gz"
      sha256 "0a05810e93f0a238a8937a57996f24b96d93e6e443515b4ad4b123f69a329851"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.12.2/graphite-2.12.2-aarch64-unknown-linux-musl.tar.gz"
      sha256 "3ec086f05e80667e23ffd97e837b35bff206f061e08119f43fb0dfb41279c262"
    end
    on_intel do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.12.2/graphite-2.12.2-x86_64-unknown-linux-musl.tar.gz"
      sha256 "039e624d58cc0c18839f91b50697c4df304f2a9218e6854a55ca291017e73bfa"
    end
  end

  # The JVM frontend: `graphite build` runs it to analyse JAR/WAR/APK inputs.
  resource "frontend-jvm" do
    url "https://github.com/johnsonlee/graphite/releases/download/v2.12.2/graphite.jar"
    sha256 "89c6d340ee0b9f55eb4212e53bd5f3d9033464bcf4b47aecd963dc5d83396c68"
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
