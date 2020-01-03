module Language
    module Dotnet
        def self.std_dotnet_install_args(libexec)
            %W[
                --add-source
                #{Dir.pwd}
                --tool-path
                #{libexec}/bin
            ]
        end
    end
end
