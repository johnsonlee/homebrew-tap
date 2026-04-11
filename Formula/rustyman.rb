class Rustyman < Formula
  desc "High-performance MITM HTTP/HTTPS proxy written in Rust"
  homepage "https://github.com/johnsonlee/rustyman"
  version "0.3.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/johnsonlee/rustyman/releases/download/v0.3.0/rustyman-aarch64-apple-darwin.tar.gz"
      sha256 "6f1ccb4828a9965dafa81659f8aa6b9fb713cf47d232839baf786703c7007623"
    else
      url "https://github.com/johnsonlee/rustyman/releases/download/v0.3.0/rustyman-x86_64-apple-darwin.tar.gz"
      sha256 "3726d8303277202891fe96294f478bd87d6cc88991febf7002156a8170ce78af"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/johnsonlee/rustyman/releases/download/v0.3.0/rustyman-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "f9d70a262c969007313783550ff5c19177078d0aa2977e13c2513f9cf881735e"
    else
      url "https://github.com/johnsonlee/rustyman/releases/download/v0.3.0/rustyman-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "fd13ee4fc5bd1ca7b5fbac9ec7b14053fff2f3c22aa604f5ca9c438478f0a7d8"
    end
  end

  def install
    bin.install "rustyman"
  end

  test do
    assert_match "rustyman", shell_output("#{bin}/rustyman --help")
  end
end
