class Tmd < Formula
  desc "Terminal markdown previewer, powered by carbonyl"
  homepage "https://github.com/johnsonlee/tmd"
  version "0.8.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/johnsonlee/tmd/releases/download/v0.8.0/tmd-aarch64-apple-darwin.tar.gz"
      sha256 "658842dc2bab9c13050590d2bb713d15e95e3d264a3e2c86b8c56e83e2602c0a"
    end
    on_intel do
      url "https://github.com/johnsonlee/tmd/releases/download/v0.8.0/tmd-x86_64-apple-darwin.tar.gz"
      sha256 "b322140d9146377c96216da27fff869cdfdeaca69693b773a8663781cad8533d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/johnsonlee/tmd/releases/download/v0.8.0/tmd-aarch64-unknown-linux-musl.tar.gz"
      sha256 "37c6196667a2b69494c78d90e486789b0a2ec7193ce914dc6b1105e908b38238"
    end
    on_intel do
      url "https://github.com/johnsonlee/tmd/releases/download/v0.8.0/tmd-x86_64-unknown-linux-musl.tar.gz"
      sha256 "6611568ee6f746243f9af6b6153a5bd1de861323f3b2ecebcd28bb8836151911"
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
