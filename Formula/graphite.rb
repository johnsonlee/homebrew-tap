class Graphite < Formula
  desc "Build, query, and serve Graphite static analysis graphs"
  homepage "https://github.com/johnsonlee/graphite"
  version "2.8.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.8.0/graphite-2.8.0-aarch64-apple-darwin.tar.gz"
      sha256 "c0445bad6094b69659ea4baf3f94d0d3ced4b2552233ba356ce282c1c5606ec0"
    end
    on_intel do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.8.0/graphite-2.8.0-x86_64-apple-darwin.tar.gz"
      sha256 "298862a4483ca8cb8498c90a11777c9b441a1463006b7ccd5ec75bdb9ddf27e1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.8.0/graphite-2.8.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "670a5a5c9373ad2549ba284df9ade4957fb3aff26e48f0921579080249d19596"
    end
    on_intel do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.8.0/graphite-2.8.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "9851fcfc66fbb62d37c9b36333e47bb51e0f2c2a8959d3583489d175ef7e8cee"
    end
  end

  # The JVM frontend: `graphite build` runs it to analyse JAR/WAR/APK inputs.
  resource "frontend-jvm" do
    url "https://github.com/johnsonlee/graphite/releases/download/v2.8.0/graphite.jar"
    sha256 "711b766724ffdf924418f5919d95148be01c781229216e449de725ff5a32040c"
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
