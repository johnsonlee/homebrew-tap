class Tmd < Formula
  desc "Terminal markdown previewer, powered by carbonyl"
  homepage "https://github.com/johnsonlee/tmd"
  url "https://github.com/johnsonlee/tmd/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "a619bc733ba8e10540bb24d6722e4e0f29cfaea719a18469f6ea36ba5d08cffb"
  license "MIT"
  head "https://github.com/johnsonlee/tmd.git", branch: "main"

  depends_on "rust" => :build
  depends_on "johnsonlee/tap/carbonyl"

  def install
    system "cargo", "install", *std_cargo_args(path: ".")
  end

  test do
    (testpath/"hello.md").write("# hello\n\nworld\n")
    assert_match "tmd", shell_output("#{bin}/tmd --version")
  end
end
