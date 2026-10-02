class Graphite < Formula
  desc "Build, query, and serve Graphite static analysis graphs"
  homepage "https://github.com/johnsonlee/graphite"
  version "2.10.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.10.0/graphite-2.10.0-aarch64-apple-darwin.tar.gz"
      sha256 "4e9b5670dd28d0efec08d91ee3d0a1b882519ecd3c4109fe36dc242c406b6ad4"
    end
    on_intel do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.10.0/graphite-2.10.0-x86_64-apple-darwin.tar.gz"
      sha256 "9300bffc4e5c9861b7311ce17277c758405028a93dcefce0ac6da4cd40f67f4d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.10.0/graphite-2.10.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "ea4f15310cb3a67afc2ff087e503e1c27e3771f137c0cc60df94a46bbdfa90d9"
    end
    on_intel do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.10.0/graphite-2.10.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "e1ea5785ca86574141b85baa7729ee1dff78069e9daae6fc31f7b2a3d28b40b0"
    end
  end

  # The JVM frontend: `graphite build` runs it to analyse JAR/WAR/APK inputs.
  resource "frontend-jvm" do
    url "https://github.com/johnsonlee/graphite/releases/download/v2.10.0/graphite.jar"
    sha256 "b2bc3f6af5bdadf8013079d6d5b8b4814c076c0657ef9f7fbcb3bc80d9d52b40"
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
