class Caliber < Formula
  desc "A terminal-based task journal for developers. Capture ideas without leaving your workflow, find them when you need them."
  homepage "https://github.com/bantamhq/caliber"
  version "1.0.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bantamhq/caliber/releases/download/v1.0.2/caliber-aarch64-apple-darwin.tar.xz"
      sha256 "7a511784bfa902c63341fc085fa4c2203eb130a312688f54fd73434ddcaef1fa"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bantamhq/caliber/releases/download/v1.0.2/caliber-x86_64-apple-darwin.tar.xz"
      sha256 "7bc1284d902a449deb38ad3da975926766153601be99ee4e9243c116e7eff02e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bantamhq/caliber/releases/download/v1.0.2/caliber-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6b7587845ffa4672c71ce18d702616a852c015eb6319e670dc516ee5d3661b83"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bantamhq/caliber/releases/download/v1.0.2/caliber-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6eb3218aa8f2d2ca503fa0cc71592fb8ca088aa9b9a6b480772ae32cb67bd11f"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "caliber" if OS.mac? && Hardware::CPU.arm?
    bin.install "caliber" if OS.mac? && Hardware::CPU.intel?
    bin.install "caliber" if OS.linux? && Hardware::CPU.arm?
    bin.install "caliber" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
