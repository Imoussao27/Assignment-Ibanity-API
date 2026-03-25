defmodule IbanityClient.Accounts do
  @moduledoc """
  Fetches the list of accounts from the Ibanity API and returns the first account ID
  """
  @url "https://api.ibanity.com/ponto-connect/accounts"

  def get_first_account_id(token) do

    # Get accounts using the access token (proof we can see the account)
    response =
      Req.get!(
        @url,
        headers: [
          {"authorization", "Bearer #{token}"}, # authorized to access the account data
          {"accept", "application/json"} # tells Ibanity to respond in JSON
        ],
        connect_options: [transport_opts: IbanityClient.SSL.opts()]
      )

    case response.body["data"] do # check if we received any accounts
      [] ->
        IO.puts("No accounts found") # list empty
        nil
      # check if the list has one element and ignore the rest
      [first | _] -> first["id"] # return first account id
    end
  end
end
