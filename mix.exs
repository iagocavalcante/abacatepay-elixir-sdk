defmodule AbacatepayElixirSdk.MixProject do
  use Mix.Project

  @version "0.1.0"
  @source_url "https://github.com/iagocavalcante/abacatepay-elixir-sdk"

  def project do
    [
      app: :abacatepay_elixir_sdk,
      version: @version,
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      docs: docs(),
      source_url: @source_url,
      homepage_url: "https://abacatepay.com",
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
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
      {:req, "~> 0.5.10"},
      {:jason, "~> 1.4"},
      {:excoveralls, "~> 0.18", only: :test},
      {:exvcr, "~> 0.15", only: :test},
      {:ex_doc, "~> 0.34", only: :dev, runtime: false}
    ]
  end

  defp description do
    """
    Official Elixir SDK for AbacatePay - Brazil's modern payment platform.
    Provides complete API integration for PIX payments, billing, customer management,
    coupons, and withdrawals with robust error handling and comprehensive testing.
    """
  end

  defp package do
    [
      name: "abacatepay_elixir_sdk",
      licenses: ["MIT"],
      links: %{
        "GitHub" => @source_url,
        "Documentation" => "https://docs.abacatepay.com",
        "AbacatePay" => "https://abacatepay.com"
      },
      maintainers: ["AbacatePay Team"],
      files: ~w(lib test config mix.exs README.md CHANGELOG.md LICENSE),
      exclude_patterns: [~r/test\/fixtures\/vcr_cassettes\/.*/]
    ]
  end

  defp docs do
    [
      main: "readme",
      name: "AbacatePay Elixir SDK",
      source_ref: "v#{@version}",
      source_url: @source_url,
      homepage_url: "https://abacatepay.com",
      extras: [
        "README.md",
        "CHANGELOG.md",
        "CONTRIBUTING.md",
        "LICENSE"
      ],
      groups_for_modules: [
        "API Clients": [
          AbacatepayElixirSdk.BillingClient,
          AbacatepayElixirSdk.CustomerClient,
          AbacatepayElixirSdk.PixClient,
          AbacatepayElixirSdk.CouponClient,
          AbacatepayElixirSdk.WithdrawClient,
          AbacatepayElixirSdk.StoreClient
        ],
        "HTTP & Core": [
          AbacatepayElixirSdk.HttpClient,
          AbacatepayElixirSdk
        ],
        "Data Structures": [
          AbacatepayElixirSdk.Billing
        ]
      ]
    ]
  end
end
