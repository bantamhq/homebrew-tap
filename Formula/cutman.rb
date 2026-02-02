class Cutman < Formula
  desc "A lightweight, self-hostable git server built for organizing code, experiments, and AI context."
  homepage "https://github.com/bantamhq/cutman"
  version "0.0.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bantamhq/cutman/releases/download/0.0.1/cutman-aarch64-apple-darwin.tar.xz"
      sha256 "2624bd97d3b31c88fd9d7c0b53dc51b08bf48886dfeaff1c922c1e75a51495a2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bantamhq/cutman/releases/download/0.0.1/cutman-x86_64-apple-darwin.tar.xz"
      sha256 "7b032afbc646221900102f40fe1864ee4ce8c98db8e99278fdd64c1106c2c019"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bantamhq/cutman/releases/download/0.0.1/cutman-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "06a5b40f0912dd213abd5955b2dbc713e31eef0249d31f65532b9349d5b3ceec"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bantamhq/cutman/releases/download/0.0.1/cutman-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "27f261c329e3a510ca8068cc780043eafd1a364418eadfbb9e6834733bd25b93"
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
