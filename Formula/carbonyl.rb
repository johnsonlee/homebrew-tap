class Carbonyl < Formula
  desc "Chromium based browser that runs in the terminal"
  homepage "https://github.com/johnsonlee/carbonyl"
  version "0.0.3"
  revision 1
  license "BSD-3-Clause"

  # Mirror of upstream fathyb/carbonyl v0.0.3 assets; bit-for-bit identical.
  # Hosted on johnsonlee/carbonyl so this formula is not at the mercy of
  # upstream link churn. See the release notes for provenance.
  on_macos do
    on_arm do
      url "https://github.com/johnsonlee/carbonyl/releases/download/v0.0.3/carbonyl.macos-arm64.zip"
      sha256 "8cf9197264d8ea94a8ff9d00eebf35d8d094c7f84b8530f1bd41f9eaaed98064"
    end
    on_intel do
      url "https://github.com/johnsonlee/carbonyl/releases/download/v0.0.3/carbonyl.macos-amd64.zip"
      sha256 "29717506254364de1988a070cd3877c7de31c9de91c0878535ac71b33d7029a3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/johnsonlee/carbonyl/releases/download/v0.0.3/carbonyl.linux-arm64.zip"
      sha256 "5b75c99138cdabe454935e2c60994adce0bd4571f16e4eecfdf867c59a1197be"
    end
    on_intel do
      url "https://github.com/johnsonlee/carbonyl/releases/download/v0.0.3/carbonyl.linux-amd64.zip"
      sha256 "46a902ea29bb32f773fb4ee341423705b92345a810422b8df93eaea6a1ec7ad2"
    end
  end

  def install
    # Each zip extracts into a top-level `carbonyl-0.0.3/` directory containing
    # the main binary alongside its runtime siblings (icudtl.dat, v8 snapshot,
    # EGL/GLES dylibs, libcarbonyl). Homebrew has already chdir'd into that
    # directory, so we drop everything into libexec as a self-contained bundle.
    libexec.install Dir["*"]

    # Chromium locates sibling resources (icudtl.dat, v8 snapshot, dylibs)
    # relative to argv[0]/_NSGetExecutablePath, which on macOS returns the
    # invocation path — symlinks included. A `bin.install_symlink` would
    # therefore cause the binary to look for icudtl.dat next to the symlink
    # in HOMEBREW_PREFIX/bin and fail. A wrapper script exec's the real path
    # so the binary sees its own libexec as the resource root.
    (bin/"carbonyl").write <<~SH
      #!/bin/bash
      exec "#{libexec}/carbonyl" "$@"
    SH
    (bin/"carbonyl").chmod 0755
  end

  test do
    assert_match "Carbonyl", shell_output("#{bin}/carbonyl --help")
  end
end
