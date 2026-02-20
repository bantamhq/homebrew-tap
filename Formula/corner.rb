class Corner < Formula
  desc "A terminal-based task journal for developers. Capture ideas without leaving your workflow, find them when you need them."
  homepage "https://github.com/bantamhq/corner"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bantamhq/corner/releases/download/v0.1.0/corner-aarch64-apple-darwin.tar.xz"
      sha256 "9c2bc6c875f039329342e490934063d6f31075a2ded7a5161256edd47b76efa5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bantamhq/corner/releases/download/v0.1.0/corner-x86_64-apple-darwin.tar.xz"
      sha256 "bf4486d969cb0d7979753fb3db658b36461b431082b3a3a20b0135218b317e9e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bantamhq/corner/releases/download/v0.1.0/corner-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "514ec94038394c2ef3f9ae318cae9b26bfabd7a148a32a51e1c1aa20a191e701"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bantamhq/corner/releases/download/v0.1.0/corner-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6a561734d746e17918d78b7a5f57729399e0f31a536e560abe8473945c4970f1"
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
    bin.install "corner" if OS.mac? && Hardware::CPU.arm?
    bin.install "corner" if OS.mac? && Hardware::CPU.intel?
    bin.install "corner" if OS.linux? && Hardware::CPU.arm?
    bin.install "corner" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
