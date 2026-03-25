defmodule IbanityClient.SSL do
  @moduledoc """
  Handle SSL/mTLS configuration (avoid repetition).
  """

  def opts do

    #Load env variable
    env        = Dotenvy.source!([".env"], overwrite: true)
    passphrase = env["IBANITY_CERT_PASSPHRASE"]

    #Certificates generated from Ibanity (mTLS)
    [
      certfile: "certs/certificate.pem", # public certif to proove my id to ibanity
      keyfile: "certs/private_key.pem", # private key
      password: String.to_charlist(passphrase), # password to decrypt the private key
      cacertfile: :certifi.cacertfile() # verify that the Ibanity server is legitimate
    ]
  end

end
