class Tmd < Formula
  desc "Terminal markdown previewer, powered by carbonyl"
  homepage "https://github.com/johnsonlee/tmd"
  url "https://github.com/johnsonlee/tmd/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "03e75b6954b66530cd14dba0984936ad05ef391bfca627f8296bc1a11546f2b8"
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
