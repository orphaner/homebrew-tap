class Omnitail < Formula
  desc "Follow many log streams at once, in stacked panes: files, commands, docker, compose, kubernetes"
  homepage "https://github.com/orphaner/omnitail"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/orphaner/omnitail/releases/download/v0.1.0/omnitail-aarch64-apple-darwin.tar.xz"
      sha256 "619458de67f7846a9a9b792e11dc5af66ace403a5d1039a289e73c7ffd0b5292"
    end
    if Hardware::CPU.intel?
      url "https://github.com/orphaner/omnitail/releases/download/v0.1.0/omnitail-x86_64-apple-darwin.tar.xz"
      sha256 "6b89d9ef250a7ffe319e97c5e1d3506816682c0b573215a588f95eb5ae661583"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/orphaner/omnitail/releases/download/v0.1.0/omnitail-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b2c3e69e3c6a0bdfd0d1cfbeb0baf53fc4e93f49a79c8b5992f9bc5402717772"
    end
    if Hardware::CPU.intel?
      url "https://github.com/orphaner/omnitail/releases/download/v0.1.0/omnitail-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d8ce904c20305a518b633c3c6651780ea11cf32fd99faf5302bf7f73a54acdb0"
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
