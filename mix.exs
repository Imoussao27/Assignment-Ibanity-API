defmodule IbanityClient.MixProject do
  use Mix.Project

  def project do
    [
      app: :ibanity_client,
      version: "0.1.0",
      elixir: "~> 1.19",
      start_permanent: Mix.env() == :prod,
      deps: deps()
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
    {:req, "~> 0.4"}, # HTTP client to make requests to the Ibanity API
    {:jason, "~> 1.4"},
    {:certifi, "~> 2.9"}, # provides CA certificates to verify that the Ibanity server is who it claims to be (prevents man-in-the-middle attacks)
    {:dotenvy, "~> 0.8"}, # reads .env file
    {:plug_cowboy, "~> 2.6"} # starts a small HTTP server to listen for the OAuth2 callback
  ]
end
end
