class Agentshield < Formula
  desc "Local-first runtime security gateway for AI agents"
  homepage "https://github.com/gzhole/Agentic-gateway"
  url "https://github.com/gzhole/Agentic-gateway/archive/v0.1.1.tar.gz"
  sha256 "170517e26bc649088879d713625e27d9fdab3021cf2ed5123de2d324a526ff46"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/gzhole/agentshield/internal/cli.Version=#{version}
      -X github.com/gzhole/agentshield/internal/cli.GitCommit=#{tap.user}
      -X github.com/gzhole/agentshield/internal/cli.BuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/agentshield"

    # Install wrapper script for IDE agent integration
    (share/"agentshield").install "scripts/agentshield-wrapper.sh"
    chmod 0755, share/"agentshield/agentshield-wrapper.sh"

    # Install default policy packs
    (share/"agentshield/packs").install Dir["packs/*.yaml"]
  end

  def caveats
    <<~EOS
      To set up AgentShield for your IDE agent:
        agentshield setup

      To install wrapper and default policy packs:
        agentshield setup --install

      Wrapper script installed to:
        #{share}/agentshield/agentshield-wrapper.sh

      Configure your IDE agent's shell to:
        Shell path: #{share}/agentshield/agentshield-wrapper.sh
        Shell args: -c
    EOS
  end

  test do
    assert_match "AgentShield #{version}", shell_output("#{bin}/agentshield version")
  end
end
