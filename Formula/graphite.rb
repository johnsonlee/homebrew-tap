class Graphite < Formula
  desc "Build, query, and serve Graphite static analysis graphs"
  homepage "https://github.com/johnsonlee/graphite"
  version "2.19.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.19.0/graphite-2.19.0-aarch64-apple-darwin.tar.gz"
      sha256 "1b4c69f575a5132318e109f87156c849a2e80e56b4e15649caef2a0db71b7c97"
    end
    on_intel do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.19.0/graphite-2.19.0-x86_64-apple-darwin.tar.gz"
      sha256 "3a252dec5f2a7daf5dd68fdb81751652349842792598e4bcd84c580da6efc67e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.19.0/graphite-2.19.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "e06e042583c50c7c638b841a692af372edc40a7d0052d77e737b469cdb4a8cea"
    end
    on_intel do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.19.0/graphite-2.19.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "0c6ecca9ae581e80c45b5a1853db0da5d9fa9677d7c446a3020b9cce90c962a9"
    end
  end

  # The JVM frontend: `graphite build` runs it to analyse JAR/WAR/APK inputs.
  resource "frontend-jvm" do
    url "https://github.com/johnsonlee/graphite/releases/download/v2.19.0/graphite.jar"
    sha256 "7454a09af94638b4c85d8713c8d39be46b25758c758d3799f68240a15c6cbf17"
  end

  # The Apple frontend: `graphite build` runs it on a Swift package. It drives
  # the Swift toolchain on the machine (Xcode, or swift.org's on Linux); the
  # formula does not depend on one.
  resource "frontend-apple" do
    on_macos do
      on_arm do
        url "https://github.com/johnsonlee/graphite/releases/download/v2.19.0/graphite-frontend-apple-2.19.0-aarch64-apple-darwin.tar.gz"
        sha256 "23142211aed393cc92b305708424b9aa69f0bf44cdd2b26f49444e9e0db901be"
      end
      on_intel do
        url "https://github.com/johnsonlee/graphite/releases/download/v2.19.0/graphite-frontend-apple-2.19.0-x86_64-apple-darwin.tar.gz"
        sha256 "327ebe5c669c6c40f32f3ad84f9583a68cb6aac14252b35960e9271df1ff0b8d"
      end
    end
    on_linux do
      url "https://github.com/johnsonlee/graphite/releases/download/v2.19.0/graphite-frontend-apple-2.19.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "688375246f148507ed2b5720af01e1084822a6b28592f8f5e0e4ef6aee26b0b3"
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
