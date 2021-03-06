class Mongoose < Formula
  desc "Web server build on top of Libmongoose embedded library"
  homepage "https://github.com/cesanta/mongoose"
  url "https://github.com/cesanta/mongoose/archive/6.12.tar.gz"
  sha256 "cde4f61bf541c0df7507c5f138d0068fc643aea19ab3241414db2e659b71ddb3"

  bottle do
    cellar :any
    sha256 "b55ab50af9bea08d026102370b6bf9b24d9d1926caa97dddf8a47520ff69d3ce" => :high_sierra
    sha256 "a71f64a6f888bb252486be06bc75bc02d5f7ec8dee799300fe49653ce914b4ce" => :sierra
    sha256 "e80290df08f6d557b0fe750c882de3d87c0edc2ee12853afd3628d06c26147f3" => :el_capitan
    sha256 "1571a9f467b2cf0ffb2cd9e320b8cca9d38cc6a9fd7b7738281e3f32af924294" => :x86_64_linux
  end

  depends_on "openssl"

  conflicts_with "suite-sparse", :because => "suite-sparse vendors libmongoose.dylib"

  def install
    # No Makefile but is an expectation upstream of binary creation
    # https://github.com/cesanta/mongoose/issues/326
    cd "examples/simplest_web_server" do
      system "make"
      bin.install "simplest_web_server" => "mongoose"
    end

    if OS.mac?
      system ENV.cc, "-dynamiclib", "mongoose.c", "-o", "libmongoose.dylib"
      lib.install "libmongoose.dylib"
    else
      system ENV.cc, "-fPIC", "-c", "mongoose.c"
      system ENV.cc, "-shared", "-Wl,-soname,libmongoose.so", "-o", "libmongoose.so", "mongoose.o", "-lc", "-lpthread"
      lib.install "libmongoose.so"
    end
    include.install "mongoose.h"
    pkgshare.install "examples", "jni"
    doc.install Dir["docs/*"]
  end

  test do
    (testpath/"hello.html").write <<~EOS
      <!DOCTYPE html>
      <html>
        <head>
          <title>Homebrew</title>
        </head>
        <body>
          <p>Hi!</p>
        </body>
      </html>
    EOS

    begin
      pid = fork { exec "#{bin}/mongoose" }
      sleep 2
      assert_match "Hi!", shell_output("curl http://localhost:8000/hello.html")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
