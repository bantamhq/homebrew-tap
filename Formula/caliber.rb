class Caliber < Formula
  desc "A terminal-based task journal for developers. Capture ideas without leaving your workflow, find them when you need them."
  homepage "https://github.com/bantamhq/caliber"
  version "1.0.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bantamhq/caliber/releases/download/v1.0.1/caliber-aarch64-apple-darwin.tar.xz"
      sha256 "3c552931b801f25ba305ecbd5d9797a79e986b3646ccc62d7634e8b3e806f4c5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bantamhq/caliber/releases/download/v1.0.1/caliber-x86_64-apple-darwin.tar.xz"
      sha256 "04fa13f905d5625f9a0f38c91d4a726f549f556bde4fe47c0626d3ee256ad373"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bantamhq/caliber/releases/download/v1.0.1/caliber-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f4f24f7b56e2ee982ce1d4952cda46128da7504e9f3256737d9ff06e8fcd1589"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bantamhq/caliber/releases/download/v1.0.1/caliber-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b39f79843cd6b858c914d5a8d69085aa067e9f84f0cd61e6c86c9ee3d2bd457d"
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
