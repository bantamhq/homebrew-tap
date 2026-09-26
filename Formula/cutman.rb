class Cutman < Formula
  desc "A lightweight, self-hostable git server built for organizing code, experiments, and AI context."
  homepage "https://github.com/bantamhq/cutman"
  version "0.0.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bantamhq/cutman/releases/download/0.0.2/cutman-aarch64-apple-darwin.tar.xz"
      sha256 "e290245ff49269b48b419f814e71f6e02f27171bcb9134329e7df05f97f37f7a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bantamhq/cutman/releases/download/0.0.2/cutman-x86_64-apple-darwin.tar.xz"
      sha256 "8bd3b1d1f6bfab6e33afd543102ab170e8f50a405934d31ac76ecfb2e1c2c2ee"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bantamhq/cutman/releases/download/0.0.2/cutman-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5b349601486a2845ae9415fc68461b635bdf2133881871ec85301005e4dbc405"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bantamhq/cutman/releases/download/0.0.2/cutman-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7cee041afea79c4f7f85c460a2c81afa289002e20e4360698011c8eec9f33128"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "cutman"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "cutman"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "cutman"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "cutman"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
