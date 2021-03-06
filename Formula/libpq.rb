class Libpq < Formula
  desc "Postgres C API library"
  homepage "https://www.postgresql.org/docs/10/static/libpq.html"
  url "https://ftp.postgresql.org/pub/source/v10.5/postgresql-10.5.tar.bz2"
  sha256 "6c8e616c91a45142b85c0aeb1f29ebba4a361309e86469e0fb4617b6a73c4011"

  bottle do
    sha256 "59d624bb0b6f768941b4bec8ac4e609fd2c9ced5d5b684df45a0ccb02ecc0dd6" => :high_sierra
    sha256 "f6a18ba733548a055e58b9167bfaab26541d7186a76c1d6645f4c1f3ff16367e" => :sierra
    sha256 "47e6cef412a9622b9df2a8dfca6181a066502044fe5445e62b3f254ff03bb586" => :el_capitan
    sha256 "691d6a71a86fcedc7f5ad2ac2a91ae0687df72897d05a1817f068fad1be873e1" => :x86_64_linux
  end

  keg_only "conflicts with postgres formula"

  depends_on "openssl"
  unless OS.mac?
    depends_on "readline"
    depends_on "zlib"
  end

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--with-openssl"
    system "make"
    system "make", "-C", "src/bin", "install"
    system "make", "-C", "src/include", "install"
    system "make", "-C", "src/interfaces", "install"
    system "make", "-C", "doc", "install"
  end

  test do
    (testpath/"libpq.c").write <<~EOS
      #include <stdlib.h>
      #include <stdio.h>
      #include <libpq-fe.h>

      int main()
      {
          const char *conninfo;
          PGconn     *conn;

          conninfo = "dbname = postgres";

          conn = PQconnectdb(conninfo);

          if (PQstatus(conn) != CONNECTION_OK) // This should always fail
          {
              printf("Connection to database attempted and failed");
              PQfinish(conn);
              exit(0);
          }

          return 0;
        }
    EOS
    system ENV.cc, "libpq.c", "-L#{lib}", "-I#{include}", "-lpq", "-o", "libpqtest"
    ENV.prepend_path "LD_LIBRARY_PATH", lib unless OS.mac?
    assert_equal "Connection to database attempted and failed", shell_output("./libpqtest")
  end
end
