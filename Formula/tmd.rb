class Tmd < Formula
  desc "Terminal markdown previewer, powered by carbonyl"
  homepage "https://github.com/johnsonlee/tmd"
  version "0.6.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/johnsonlee/tmd/releases/download/v0.6.0/tmd-aarch64-apple-darwin.tar.gz"
      sha256 "55177745b36fb68ac850fe4707156d9cb1e4d6a421822ecb2df66d045c23f41f"
    end
    on_intel do
      url "https://github.com/johnsonlee/tmd/releases/download/v0.6.0/tmd-x86_64-apple-darwin.tar.gz"
      sha256 "5e6d8e7794c5d98328fef09c66eef0b7b9334becd7f86960617ffbbffa49adec"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/johnsonlee/tmd/releases/download/v0.6.0/tmd-aarch64-unknown-linux-musl.tar.gz"
      sha256 "b78f55d73a09c01f04120ea33dbd52dca278c5fb84060a6f77df0a7a8a8f4d51"
    end
    on_intel do
      url "https://github.com/johnsonlee/tmd/releases/download/v0.6.0/tmd-x86_64-unknown-linux-musl.tar.gz"
      sha256 "a25396cd40665c30803520a0c3822066aff6eff1c4f21f668e2fc57cf05e0ceb"
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
