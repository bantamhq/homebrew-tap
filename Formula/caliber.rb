class Caliber < Formula
  desc "A terminal-based task journal for developers. Capture ideas without leaving your workflow, find them when you need them."
  homepage "https://github.com/bantamhq/caliber"
  version "1.0.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bantamhq/caliber/releases/download/v1.0.0/caliber-aarch64-apple-darwin.tar.xz"
      sha256 "aedc5fac39f666c1a81f34b4a0209b9704b687b909bfda5f8844501f04733e21"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bantamhq/caliber/releases/download/v1.0.0/caliber-x86_64-apple-darwin.tar.xz"
      sha256 "0a5f328bc1aa3c120cc686e6dc9d0633f584819ed1baf7000e0a4d6d7f65553d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bantamhq/caliber/releases/download/v1.0.0/caliber-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6aaf2358266f260567025f7cd2846fa0069955ac2da4224f485455c62838002b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bantamhq/caliber/releases/download/v1.0.0/caliber-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "325fef96c2755f74ebc683518c37c2e14cd03536a723b1b54117131ab39eee21"
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
