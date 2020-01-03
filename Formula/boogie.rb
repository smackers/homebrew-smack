require_relative '../requirements/dotnet_requirement'
require_relative '../language/dotnet'

class Boogie < Formula
  desc "An SMT-based program verifier."
  homepage "https://github.com/boogie-org/boogie"
  url "https://www.nuget.org/api/v2/package/Boogie/2.4.12"
  sha256 "79b180d9a22e841cc9571fc9f458e6f889368eac6d1963685a2e5774cbc14a72"

  depends_on DotnetRequirement
  depends_on "z3"

  def install
    system "dotnet", "tool", "install", "boogie", *Language::Dotnet.std_dotnet_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"a.bpl").write "procedure p(b: bool) { assert b; }"
    (testpath/"b.bpl").write "procedure p(b: bool) { assert b || !b; }"
    assert_match "0 verified, 1 error", shell_output("#{bin}/boogie #{testpath}/a.bpl")
    assert_match "1 verified, 0 errors", shell_output("#{bin}/boogie #{testpath}/b.bpl")
  end
end
