class Cutman < Formula
  desc "A lightweight, self-hostable git server built for organizing code, experiments, and AI context."
  homepage "https://github.com/bantamhq/cutman"
  version "0.0.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bantamhq/cutman/releases/download/0.0.1/cutman-aarch64-apple-darwin.tar.xz"
      sha256 "ac4579411fb7fce31a9dc5286d155246fb521e05102e5c63bf7344cf788d8725"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bantamhq/cutman/releases/download/0.0.1/cutman-x86_64-apple-darwin.tar.xz"
      sha256 "80891d1a5e81108617743b0476e1aecdf59ff7aedc6cf0bd9abafd5b74842f91"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bantamhq/cutman/releases/download/0.0.1/cutman-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "70d552011c9dccaffa0f4c729800c788d8b146314cf1c328b44cbd892f5f4cad"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bantamhq/cutman/releases/download/0.0.1/cutman-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2fc2a14fa78e555aefc7939bb0aa51bf715636d945978cd187d9a154b0fce979"
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
    bin.install "cutman" if OS.mac? && Hardware::CPU.arm?
    bin.install "cutman" if OS.mac? && Hardware::CPU.intel?
    bin.install "cutman" if OS.linux? && Hardware::CPU.arm?
    bin.install "cutman" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
