class Smack < Formula
  desc "SMACK Software Verifier and Verification Toolchain"
  homepage "https://github.com/smackers/smack"
  url "https://github.com/smackers/smack/archive/v2.4.0.tar.gz"
  sha256 "32ebe2d99044e74e91db611934c781d740529213e6fdcc2b29a930ee14da7b93"

  bottle do
    root_url "https://dl.bintray.com/smackers/bottles-smack"
    cellar :any
    rebuild 1
    sha256 "eeeed9a5f29508d12d9d1463de0e6afc078a1a1de9d93a28effdd3c3cc07a0e9" => :catalina
  end

  depends_on "cmake" => :build
  depends_on "llvm@8"
  depends_on "python"

  def install
    system "cmake", ".", "-DCMAKE_INSTALL_PREFIX=#{prefix}", "-DCMAKE_BUILD_TYPE=Debug"
    system "make", "install"

    # NOTE: this is a temporary fix the next release
    system "rm", prefix/"bin"/"boogie"
    system "rm", prefix/"bin"/"corral"
    system "rm", prefix/"bin"/"lockpwn"
    system "rm", prefix/"bin"/"symbooglix"
  end

  test do
    (testpath/"a.c").write <<~EOS
      #include <smack.h>
      int main() {
        assert(1);
        return 0;
      }
    EOS

    # Ensures LLVM binaries are in the path
    ENV.prepend_path "PATH", "#{shell_output("brew --prefix llvm@8").chomp}/bin"

    # TODO: remove `-t` once Smack no longer installs Corral
    system "#{bin}/smack", "-t", (testpath/"a.c")
  end
end
