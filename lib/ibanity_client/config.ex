defmodule IbanityClient.Config do
  @moduledoc """
  Loads all environment variables once (no global variables)
  """

  def load! do
    env = Dotenvy.source!([".env"])
    #Store each config value globally in the Application environment (write)
    Application.put_env(:ibanity_client, :client_id,       env["IBANITY_CLIENT_ID"])
    Application.put_env(:ibanity_client, :client_secret,   env["IBANITY_CLIENT_SECRET"])
    Application.put_env(:ibanity_client, :redirect_uri,    env["IBANITY_REDIRECT_URI"])
    Application.put_env(:ibanity_client, :cert_passphrase, env["IBANITY_CERT_PASSPHRASE"])
  end

  #Get data
  #Fetch_env! will crash immediately if the value is missing
  def client_id,       do: Application.fetch_env!(:ibanity_client, :client_id)
  def client_secret,   do: Application.fetch_env!(:ibanity_client, :client_secret)
  def redirect_uri,    do: Application.fetch_env!(:ibanity_client, :redirect_uri)
  def cert_passphrase, do: Application.fetch_env!(:ibanity_client, :cert_passphrase)
end
