class Ringside < Formula
  desc "A CLI tool that syncs git repositories into a local project directory"
  homepage "https://github.com/bantamhq/ringside"
  version "0.0.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bantamhq/ringside/releases/download/v0.0.2/ringside-aarch64-apple-darwin.tar.xz"
      sha256 "fe049d59ffd490e9e728cc8b2a4de5643cb82cea6c0e7afabe6410fcf2448c8f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bantamhq/ringside/releases/download/v0.0.2/ringside-x86_64-apple-darwin.tar.xz"
      sha256 "be73a2bec89011e7d491794e0baabbffce7516e28594ec27f9bbffbe06b9321a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bantamhq/ringside/releases/download/v0.0.2/ringside-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e8adf5dec823e66236fcff606bbc4fa1ec48955da476e8fba0fb150c2084cb5e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bantamhq/ringside/releases/download/v0.0.2/ringside-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "93a00a3cbe62d73c33b8182de628c4e8a24554b66e85c9ed0977481ff560652c"
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
    bin.install "ringside" if OS.mac? && Hardware::CPU.arm?
    bin.install "ringside" if OS.mac? && Hardware::CPU.intel?
    bin.install "ringside" if OS.linux? && Hardware::CPU.arm?
    bin.install "ringside" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
