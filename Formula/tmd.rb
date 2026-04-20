class Tmd < Formula
  desc "Terminal markdown previewer, powered by carbonyl"
  homepage "https://github.com/johnsonlee/tmd"
  version "0.5.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/johnsonlee/tmd/releases/download/v0.5.0/tmd-aarch64-apple-darwin.tar.gz"
      sha256 "32414bc0d2df09c4f2d8066b06a457f7bac0d0ab730c1ea0f02472313721c1dc"
    end
    on_intel do
      url "https://github.com/johnsonlee/tmd/releases/download/v0.5.0/tmd-x86_64-apple-darwin.tar.gz"
      sha256 "cf789627cee9cb3babf55fba487fd6afc776fb8f1d28d0c02c3a83b09d28d6d5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/johnsonlee/tmd/releases/download/v0.5.0/tmd-aarch64-unknown-linux-musl.tar.gz"
      sha256 "41fd7cfa04e9bae7e72860a531546e62332f7ad485b052f0512c787e4485cc76"
    end
    on_intel do
      url "https://github.com/johnsonlee/tmd/releases/download/v0.5.0/tmd-x86_64-unknown-linux-musl.tar.gz"
      sha256 "f8dbc8251b1f9a290002189f7fde588c4cba497c2226c292b99a471627014a2f"
    end
  end

  depends_on "johnsonlee/tap/carbonyl"

  def install
    bin.install "tmd"
  end

  test do
    assert_match "tmd", shell_output("#{bin}/tmd --version")
  end
end
