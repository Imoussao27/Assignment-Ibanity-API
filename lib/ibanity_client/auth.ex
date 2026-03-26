defmodule IbanityClient.Auth do
  @moduledoc """
  Handles OAuth2 token exchange with the Ibanity API.
  """
  @token_url "https://api.ibanity.com/ponto-connect/oauth2/token"

  def get_user_token(code, verifier) do

    #Retrieve data from the global config (sensitive data)
    client_id     = IbanityClient.Config.client_id()
    client_secret = IbanityClient.Config.client_secret()
    redirect_uri  = IbanityClient.Config.redirect_uri()

    #Build the request body for the token exchange
    body = URI.encode_query(%{
      grant_type:    "authorization_code", # user consent flow
      code:          code, # user consented
      redirect_uri:  redirect_uri, # match the one registered in the Ibanity portal
      code_verifier: verifier # PKCE verifier (SHA256)
    })

    #POST to the token endpoint
    response =
      Req.post!(
        @token_url,
        body: body,
        headers: [{"content-type", "application/x-www-form-urlencoded"}], # standard OAuth2 format
        auth: {:basic, "#{client_id}:#{client_secret}"}, # identity of our app
        connect_options: [transport_opts: IbanityClient.SSL.opts()] # mTLS secures the connection on both sides
      )
    response.body["access_token"]
  end
end
