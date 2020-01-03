class DotnetRequirement < Requirement
    fatal true

    satisfy(:build_env => false) { which("dotnet") }

    def message; <<~EOS
      dotnet is required; install it via one of:
        brew cask install dotnet
        brew cask install dotnet-sdk
      EOS
    end
  end
