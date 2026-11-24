defmodule AbacatepayElixirSdk.MixProject do
  use Mix.Project

  @version "0.3.0"
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
      test_coverage: [tool: ExCoveralls]
    ]
  end

  def cli do
    [
      preferred_envs: [
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
      {:req, "~> 0.5.10 or ~> 0.6.1"},
      {:jason, "~> 1.4"},
      {:excoveralls, "~> 0.18", only: :test},
      {:exvcr, "~> 0.15", only: :test},
      {:ex_doc, "~> 0.40", only: :dev, runtime: false}
    ]
  end

  defp description do
    """
    Official Elixir SDK for AbacatePay - Brazil's modern payment platform.
    Integrates with the v2 payments API and supports existing v1 integrations.
    """
  end

  defp package do
    [
      name: "abacatepay_elixir_sdk",
      licenses: ["MIT"],
      links: %{
        "GitHub" => @source_url,
        "SDK documentation" => "https://hexdocs.pm/abacatepay_elixir_sdk",
        "API reference" => "https://docs.abacatepay.com/pages/reference/introduction",
        "AbacatePay" => "https://abacatepay.com"
      },
      maintainers: ["AbacatePay Team"],
      files:
        ~w(lib test config mix.exs README.md README.pt-BR.md guides CONTRIBUTING.md CHANGELOG.md LICENSE),
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
        "README.pt-BR.md",
        "guides/migrating-to-v2.md",
        "CHANGELOG.md",
        "CONTRIBUTING.md",
        "LICENSE"
      ],
      groups_for_modules: [
        "API v2": ~r/^AbacatepayElixirSdk\.V2(\.|$)/,
        "API v1 clients": [
          AbacatepayElixirSdk.BillingClient,
          AbacatepayElixirSdk.CustomerClient,
          AbacatepayElixirSdk.PixClient,
          AbacatepayElixirSdk.CouponClient,
          AbacatepayElixirSdk.WithdrawClient,
          AbacatepayElixirSdk.StoreClient,
          AbacatepayElixirSdk.PublicMrrClient
        ],
        "HTTP & Core": [
          AbacatepayElixirSdk,
          AbacatepayElixirSdk.HttpClient,
          AbacatepayElixirSdk.Response,
          AbacatepayElixirSdk.Error
        ],
        "API v1 data structures": [
          AbacatepayElixirSdk.Billing,
          AbacatepayElixirSdk.Billing.Product,
          AbacatepayElixirSdk.Customer,
          AbacatepayElixirSdk.Pix,
          AbacatepayElixirSdk.Coupon,
          AbacatepayElixirSdk.Store,
          AbacatepayElixirSdk.Withdraw,
          AbacatepayElixirSdk.Mrr,
          AbacatepayElixirSdk.MerchantInfo,
          AbacatepayElixirSdk.Revenue
        ]
      ]
    ]
  end
end
