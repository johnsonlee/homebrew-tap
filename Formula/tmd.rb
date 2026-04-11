class Tmd < Formula
  desc "Terminal markdown previewer, powered by carbonyl"
  homepage "https://github.com/johnsonlee/tmd"
  version "0.4.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/johnsonlee/tmd/releases/download/v0.4.0/tmd-aarch64-apple-darwin.tar.gz"
      sha256 "97506a9a0681c8212cf14ccc12f9b7aeb9f84463220a7d9a78c93a880caf080f"
    end
    on_intel do
      url "https://github.com/johnsonlee/tmd/releases/download/v0.4.0/tmd-x86_64-apple-darwin.tar.gz"
      sha256 "bd4437beeea47b3598d1730fb23997a5918fa341dd84a530c5a12660c09126ff"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/johnsonlee/tmd/releases/download/v0.4.0/tmd-aarch64-unknown-linux-musl.tar.gz"
      sha256 "2038c0b911d247b93988552736c800f7ea2eaffae9a1c2132eda19a4ace1fc19"
    end
    on_intel do
      url "https://github.com/johnsonlee/tmd/releases/download/v0.4.0/tmd-x86_64-unknown-linux-musl.tar.gz"
      sha256 "9a8f57e2aa973adf73123858f4d2a75a7d36f8113641ae1cb816c34d2b0ce171"
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
