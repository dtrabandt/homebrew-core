class Fmdiff < Formula
  desc "Use FileMerge as a diff command for Subversion and Mercurial"
  homepage "https://www.defraine.net/~brunod/fmdiff/"
  url "https://github.com/brunodefraine/fmscripts/archive/20150915.tar.gz"
  sha256 "45ead0c972aa8ff5b3f9cf1bcefbc069931fd8218b2e28ff76958437a3fabf96"
  head "https://github.com/brunodefraine/fmscripts.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "03bf7b7acda053f3b96de99591fb97cef678297941eab37f52802a3c2734afdd" => :high_sierra
    sha256 "59d9c9d8a8759531a2f715619cfb2bce404fc7378235cf416ea5a426eb8d967f" => :sierra
    sha256 "59d9c9d8a8759531a2f715619cfb2bce404fc7378235cf416ea5a426eb8d967f" => :el_capitan
    sha256 "59d9c9d8a8759531a2f715619cfb2bce404fc7378235cf416ea5a426eb8d967f" => :yosemite
  end

  # Needs FileMerge.app, which has been part of Xcode since Xcode 4 (OS X 10.7)
  # Prior to that it was included in the Developer Tools package.
  # "make" has logic for checking both possibilities.
  depends_on :xcode if OS.mac? && MacOS.version >= :lion

  depends_on :macos

  def install
    system "make"
    system "make", "DESTDIR=#{bin}", "install"
  end

  test do
    ENV.prepend_path "PATH", testpath

    # dummy filemerge script
    (testpath/"filemerge").write <<~EOS
      #!/bin/sh
      echo "it works"
    EOS

    chmod 0744, testpath/"filemerge"
    touch "test"

    assert_match(/it works/, shell_output("#{bin}/fmdiff test test"))
  end
end
