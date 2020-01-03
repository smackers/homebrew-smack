require_relative '../requirements/dotnet_requirement'
require_relative '../language/dotnet'

class Corral < Formula
  desc "A solver for the reachability modulo theories problem."
  homepage "https://github.com/boogie-org/corral"
  url "https://www.nuget.org/api/v2/package/Corral/1.0.1"
  sha256 "28e1dd11c78fc74f799013a0a941ab9ca7d70eb815e65e258813c8562f5b0eb8"

  depends_on DotnetRequirement
  depends_on "z3"

  def install
    system "dotnet", "tool", "install", "corral", *Language::Dotnet.std_dotnet_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"a.bpl").write "procedure {:entrypoint} p(b: bool) { assert b; }"
    (testpath/"b.bpl").write "procedure {:entrypoint} p(b: bool) { assert b || !b; }"
    assert_match "This assertion can fail", shell_output("#{bin}/corral #{testpath}/a.bpl")
    assert_match "Program has no bugs", shell_output("#{bin}/corral #{testpath}/b.bpl")
  end
end
