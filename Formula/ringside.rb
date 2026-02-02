class Ringside < Formula
  desc "A CLI tool that syncs git repositories into a local project directory"
  homepage "https://github.com/bantamhq/ringside"
  version "0.0.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bantamhq/ringside/releases/download/v0.0.2/ringside-aarch64-apple-darwin.tar.xz"
      sha256 "54b84e2e2bbce0b591292015cdf78f0d9af7b0364656247b48c45aa0c445fa97"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bantamhq/ringside/releases/download/v0.0.2/ringside-x86_64-apple-darwin.tar.xz"
      sha256 "02cb2c0f850aedb17d1cf37400fad59459c9bb33328c66f3cf3b7dbe8366c725"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bantamhq/ringside/releases/download/v0.0.2/ringside-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1b26097a448c8d951eb13bbc00f72c9a4b876ed542712d7154aecda345d6cc69"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bantamhq/ringside/releases/download/v0.0.2/ringside-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "753598ef6e7a4b7c07df70ca1e2fb3842b3d749ad47ae9522d60abfce34ed386"
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
