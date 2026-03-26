defmodule IbanityClient do
 @moduledoc """
  Main module that orchestrates the full Ibanity OAuth2 flow
  """

  def run do
  #Start the callback server on localhost:4000
  IbanityClient.CallbackServer.start()

  #Load env variable
  IbanityClient.Config.load!() # crash if there is no .env file
  client_id = IbanityClient.Config.client_id()

  #Generate PKCE
  verifier  = :crypto.strong_rand_bytes(64) |> Base.url_encode64(padding: false) # random 64 byte string encoded in base64
  challenge = :crypto.hash(:sha256, verifier) |> Base.url_encode64(padding: false) # SHA256 hash


  #Build authorization URL
  params = URI.encode_query(%{
    "client_id"             => client_id, # identify my app
    "redirect_uri"          => "http://localhost:4000/callback",
    "response_type"         => "code", # expect an authorization code back
    "scope"                 => "ai offline_access",
    "state"                 => "state123",
    "code_challenge"        => challenge, # Ibanity stores it
    "code_challenge_method" => "S256"
  })

  #Display URL
  IO.puts("\nOpen this link in your browser:\nhttps://sandbox-authorization.myponto.com/oauth2/auth?#{params}\n")

  #Register the current process and wait for the authorization code
  Process.register(self(), IbanityClient.Orchestrator)

  #Waiting for a message (code)
  code = receive do
    {:auth_code, code} -> code
  after
    :timer.minutes(5) -> raise "Timeout: no code received within 5 minutes"
  end


  #Exchange the authorization code for an access token
  token = IbanityClient.Auth.get_user_token(code, verifier)
  IO.puts("Token received : #{token}")

  #Fetch the first account id
  account_id = IbanityClient.Accounts.get_first_account_id(token)

  #Fetch and display 10 transactions
  transactions = IbanityClient.Transactions.list_transactions(token, account_id)
  IbanityClient.Transactions.print_10_transactions(transactions)

end


end
