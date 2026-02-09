class Agentshield < Formula
  desc "Local-first runtime security gateway for AI agents"
  homepage "https://github.com/gzhole/Agentic-gateway"
  url "https://github.com/gzhole/Agentic-gateway/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "0019dfc4b32d63c1392aa264aed2253c1e0c2fb09216f8e2cc269bbfb8bb49b5"
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
  end

  test do
    assert_match "AgentShield #{version}", shell_output("#{bin}/agentshield version")
  end
end
