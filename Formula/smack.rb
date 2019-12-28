class Smack < Formula
  desc "SMACK Software Verifier and Verification Toolchain"
  homepage "https://github.com/smackers/smack"
  url "https://github.com/smackers/smack/archive/v2.4.0.tar.gz"
  sha256 "32ebe2d99044e74e91db611934c781d740529213e6fdcc2b29a930ee14da7b93"

  depends_on "cmake" => :build
  depends_on "llvm@8"
  depends_on "python"
  depends_on "z3"

  def install
    system "cmake", ".", "-DCMAKE_INSTALL_PREFIX=#{prefix}", "-DCMAKE_BUILD_TYPE=Debug"
    system "make", "install"
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
    ENV["PATH"] = "/usr/local/opt/llvm@8/bin:#{ENV["PATH"]}"

    # TODO: remove `-t` once Smack no longer installs Corral
    system "#{bin}/smack", (testpath/"a.c"), "-t"
  end
end
