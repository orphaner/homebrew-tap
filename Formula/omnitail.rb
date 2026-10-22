class Omnitail < Formula
  desc "Follow many log streams at once, in stacked panes: files, commands, docker, compose, kubernetes"
  homepage "https://github.com/orphaner/omnitail"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/orphaner/omnitail/releases/download/v0.4.0/omnitail-aarch64-apple-darwin.tar.xz"
      sha256 "8f3d29ab1e8d3c5488490f3d8cb23300c67c603487402c9d5f674c81b88d79ae"
    end
    if Hardware::CPU.intel?
      url "https://github.com/orphaner/omnitail/releases/download/v0.4.0/omnitail-x86_64-apple-darwin.tar.xz"
      sha256 "b7b8bc4ea9cedebc89dc9069c65cb971862ca5b5402815169fa7bf17733f6d08"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/orphaner/omnitail/releases/download/v0.4.0/omnitail-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "53de2c5cf4370a6f352757e1d0bbe43922620e370ddbbb5b76b4096422b70da7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/orphaner/omnitail/releases/download/v0.4.0/omnitail-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "05ee547e49abc8bbe406ea90c82c990eaf3ff413d3c295ddd1b882ccebfd2358"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
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
      bin.install "omnitail"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "omnitail"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "omnitail"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "omnitail"
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
