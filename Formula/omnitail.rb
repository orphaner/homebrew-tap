class Omnitail < Formula
  desc "Follow many log streams at once, in stacked panes: files, commands, docker, compose, kubernetes"
  homepage "https://github.com/orphaner/omnitail"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/orphaner/omnitail/releases/download/v0.3.0/omnitail-aarch64-apple-darwin.tar.xz"
      sha256 "18f691b99db5687d94476299b8c3acd1f025d84f1dccee26e25d1cf88dea208d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/orphaner/omnitail/releases/download/v0.3.0/omnitail-x86_64-apple-darwin.tar.xz"
      sha256 "051567bf3975ae38030d4cf4c4a3b8ff8b8620746c77ef4ab60e65261efa406f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/orphaner/omnitail/releases/download/v0.3.0/omnitail-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "27ad58f733ce55db631dd8f988cd24960286c0bb2e22cdfe088ab79a207227ba"
    end
    if Hardware::CPU.intel?
      url "https://github.com/orphaner/omnitail/releases/download/v0.3.0/omnitail-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "079e432e1bb342c25ef1758c1a692a4cd2552a3c0384143fec62f7f474d556d2"
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
