defmodule OpentelemetryRavix.MixProject do
  use Mix.Project

  def project do
    [
      app: :opentelemetry_ravix,
      version: "0.0.2",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      elixirc_paths: elixirc_paths(Mix.env()),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      dialyzer: [
        plt_file: {:no_warn, "priv/plts/dialyzer.plt"}
      ],
      source_url: "https://github.com/YgorCastor/opentelemetry-ravix",
      homepage_url: "https://github.com/YgorCastor/opentelemetry-ravix",
      docs: [
        main: "readme",
        extras: ["README.md"]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ravix, "~> 0.7"},
      {:opentelemetry_api, "~> 1.1"},
      {:opentelemetry_process_propagator, "~> 0.2"},
      {:telemetry, "~> 1.1"},
      {:dialyxir, "~> 1.1", only: [:dev, :test], runtime: false},
      {:opentelemetry, "~> 1.0", only: [:dev, :test]},
      {:opentelemetry_exporter, "~> 1.0", only: [:dev, :test]},
      {:ex_doc, "~> 0.29", only: [:dev], runtime: false},
      {:excoveralls, "~> 0.14", only: :test},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:version_tasks, "~> 0.12", only: [:dev, :test], runtime: false}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp description() do
    "A OpenTelemetry implementation for Ravix"
  end

  defp package() do
    [
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/YgorCastor/opentelemetry-ravix"},
      sponsor: "ycastor.eth"
    ]
  end
end
