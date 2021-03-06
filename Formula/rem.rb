class Rem < Formula
  desc "Command-line tool to access OSX Reminders.app database"
  homepage "https://github.com/kykim/rem"
  url "https://github.com/kykim/rem/archive/20150618.tar.gz"
  sha256 "e57173a26d2071692d72f3374e36444ad0b294c1284e3b28706ff3dbe38ce8af"

  bottle do
    cellar :any_skip_relocation
    sha256 "0a3365c8653023f2b4de8c5b6243aec2de7c180d1be982adcdbe58afc159800e" => :high_sierra
    sha256 "326f7a21f696b7614a55a5edeb57e08482ff7b4c72506bcecff5deaa0552828e" => :sierra
    sha256 "c9892df4f6aa5d58097e4cc4d62388ccbb1e0c02604b1139cfe829d47d992442" => :el_capitan
    sha256 "d9a6303ff3935923ba53d093e95387caaf24460a4cd7fb7d330fa5c3988b551c" => :yosemite
    sha256 "bf65e89ec4ca486b95f04c1c737627b2e0091af8a5c137795e521b96664d75e2" => :mavericks
    sha256 "3c858e09bce1941b84ca3e5d77163cac4e3b7efcd6a1afcc72354a450c8ee495" => :mountain_lion
  end

  depends_on :xcode => :build if OS.mac?
  depends_on :macos

  conflicts_with "remind", :because => "both install `rem` binaries"

  def install
    xcodebuild "SYMROOT=build"
    bin.install "build/Release/rem"
  end

  test do
    system "#{bin}/rem", "version"
  end
end
