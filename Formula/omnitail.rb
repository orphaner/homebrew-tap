class Omnitail < Formula
  desc "Follow many log streams at once, in stacked panes: files, commands, docker, compose, kubernetes"
  homepage "https://github.com/orphaner/omnitail"
  version "0.3.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/orphaner/omnitail/releases/download/v0.3.1/omnitail-aarch64-apple-darwin.tar.xz"
      sha256 "47ce2facbc9553b72059f386867a799af92edb8175ea8fc3eebf030e28540ef2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/orphaner/omnitail/releases/download/v0.3.1/omnitail-x86_64-apple-darwin.tar.xz"
      sha256 "849f626a7a6fb40dd3e065049f55245263bb1430755594aaee54218039fc2a5e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/orphaner/omnitail/releases/download/v0.3.1/omnitail-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4c05d87d866c856420327d95c670f27a8f0f33365709c6211498eb05044d8c09"
    end
    if Hardware::CPU.intel?
      url "https://github.com/orphaner/omnitail/releases/download/v0.3.1/omnitail-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f5d9aafef035a928c11bccf49ef3fbb6292881389ccad2e4e7d657acbbbb3a1b"
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
