ExUnit.start()

# The v1 cassettes recorded responses with Accept-Encoding: gzip.
Req.default_options(compressed: true)

ExVCR.Config.cassette_library_dir("test/fixtures/vcr_cassettes")
ExVCR.Config.filter_request_headers("authorization")
ExVCR.Config.filter_request_headers("Authorization")
ExVCR.Config.filter_sensitive_data("Bearer [^\"]+", "Bearer ***")
ExVCR.Config.filter_sensitive_data("abc_dev_[^\"]+", "abc_dev_***")
