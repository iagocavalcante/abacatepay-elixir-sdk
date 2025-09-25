import Config

config :abacatepay_elixir_sdk,
  api_token: "abc_dev",
  environment: :sandbox

config :exvcr,
  vcr_cassette_library_dir: "test/fixtures/vcr_cassettes",
  custom_cassette_library_dir: "test/fixtures/custom_cassettes"
