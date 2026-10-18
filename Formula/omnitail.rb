class Omnitail < Formula
  desc "Follow many log streams at once, in stacked panes: files, commands, docker, compose, kubernetes"
  homepage "https://github.com/orphaner/omnitail"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/orphaner/omnitail/releases/download/v0.2.0/omnitail-aarch64-apple-darwin.tar.xz"
      sha256 "77a91fbe832f5382ad981f8e33bd668b13fa66578e48d22f1c7dbcb8f9a0d61b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/orphaner/omnitail/releases/download/v0.2.0/omnitail-x86_64-apple-darwin.tar.xz"
      sha256 "331d58db9b56c36ade5f63f1055c0143ae817353fe9a4872f11a5e7c308f0e62"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/orphaner/omnitail/releases/download/v0.2.0/omnitail-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d6425bc88656f351198fca1b0da37cc70fb7ebf3ea5c3bb2d20ccba6f0b643fa"
    end
    if Hardware::CPU.intel?
      url "https://github.com/orphaner/omnitail/releases/download/v0.2.0/omnitail-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a54795347de3d0aff7ea2ee80ee8782805c0393e171f00c8f7ae96089ea72127"
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
