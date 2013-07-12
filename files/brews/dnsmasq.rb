require 'formula'

class Dnsmasq < Formula
  homepage 'http://www.thekelleys.org.uk/dnsmasq/doc.html'
  url 'http://www.thekelleys.org.uk/dnsmasq/dnsmasq-2.66.tar.gz'
  sha256 '36232fa23d1a8efc6f84a29da5ff829c2aa40df857b9116a9320ea37b651a982'
  version '2.66-boxen1'

  option 'with-idn', 'Compile with IDN support'

  depends_on "libidn" if build.include? 'with-idn'
  depends_on 'pkg-config' => :build

  def install
    ENV.deparallelize

    # Fix etc location
    inreplace "src/config.h", "/etc/dnsmasq.conf",
      "/opt/boxen/config/dnsmasq/dnsmasq.conf"

    # Optional IDN support
    if ARGV.include? '--with-idn'
      inreplace "src/config.h", "/* #define HAVE_IDN */", "#define HAVE_IDN"
    end

    # Fix compilation on Lion
    ENV.append_to_cflags "-D__APPLE_USE_RFC_3542" if 10.7 <= MACOS_VERSION
    inreplace "Makefile" do |s|
      s.change_make_var! "CFLAGS", ENV.cflags
    end

    system "make install PREFIX=#{prefix}"
  end
end
