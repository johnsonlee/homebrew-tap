class Tmd < Formula
  desc "Terminal markdown previewer, powered by carbonyl"
  homepage "https://github.com/johnsonlee/tmd"
  url "https://github.com/johnsonlee/tmd/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "bf00c8dc590a2bbfd8701b4511fb538650f78621dbeb9a2aac3c9b23354ac3e5"
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
