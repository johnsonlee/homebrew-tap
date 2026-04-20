class Tmd < Formula
  desc "Terminal markdown previewer, powered by carbonyl"
  homepage "https://github.com/johnsonlee/tmd"
  version "0.7.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/johnsonlee/tmd/releases/download/v0.7.0/tmd-aarch64-apple-darwin.tar.gz"
      sha256 "ed09f571a48873c09fdcaf2e732d9e535f608191cbb24ff3fa55989d0db978ce"
    end
    on_intel do
      url "https://github.com/johnsonlee/tmd/releases/download/v0.7.0/tmd-x86_64-apple-darwin.tar.gz"
      sha256 "1d19b5cbbc705e6e6a67b381a7f76c430405e8e92b4629662b82264065715c34"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/johnsonlee/tmd/releases/download/v0.7.0/tmd-aarch64-unknown-linux-musl.tar.gz"
      sha256 "bfd2397d6e75b20d92ab95c95053f9424c3ab5c76b1bff69c1f74a769014184b"
    end
    on_intel do
      url "https://github.com/johnsonlee/tmd/releases/download/v0.7.0/tmd-x86_64-unknown-linux-musl.tar.gz"
      sha256 "c266e46fb9d5280ededd656c6fe8cdc0745b440165d26c8895d4752448dad2ed"
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
