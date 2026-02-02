class Cutman < Formula
  desc "A lightweight, self-hostable git server built for organizing code, experiments, and AI context."
  homepage "https://github.com/bantamhq/cutman"
  version "0.0.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/bantamhq/cutman/releases/download/0.0.1/cutman-aarch64-apple-darwin.tar.xz"
      sha256 "3ef32d6bc1aa005f77423a14bf8e352bea5e624aced1641f9afe0d3d8384842c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bantamhq/cutman/releases/download/0.0.1/cutman-x86_64-apple-darwin.tar.xz"
      sha256 "9ecca6124a511a6eab18f3bebdabae7c4049702957e0261e6353cf89eeac0efe"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/bantamhq/cutman/releases/download/0.0.1/cutman-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "647835abc00acbaa731483f2f556d8b4f93939b801be4b36404b82b13cce778a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/bantamhq/cutman/releases/download/0.0.1/cutman-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "fc0a227bc1e99495fb77b28affdc0569fa39a7736a9b963e8fab20b990f9cb97"
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
