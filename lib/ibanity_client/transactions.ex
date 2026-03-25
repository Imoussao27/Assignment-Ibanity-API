defmodule IbanityClient.Transactions do
@moduledoc """
  Handles fetching and displaying transactions from the Ibanity API.
  """
  def list_transactions(token, account_id) do

    #Build the URL with the account_id and limit to 10 transactions
    url ="https://api.ibanity.com/ponto-connect/accounts/#{account_id}/transactions?page[limit]=10"

    #Fetch transactions using the access token and mTLS certificates
    response =
      Req.get!(
        url,
        headers: [
          {"authorization", "Bearer #{token}"}, # authorized to access the account data
          {"accept", "application/json"} # tells Ibanity to respond in JSON
        ],
        connect_options: [transport_opts: IbanityClient.SSL.opts()]
      )
    response.body
  end

  def print_10_transactions(transactions) do

    #Display transaction
    transactions["data"] # list of transactions
    |> Enum.with_index(1) # add index to each transaction
    |> Enum.each(fn {transaction, index} -> # iterate over each element
      attrs = transaction["attributes"]

      IO.puts("""
      Transaction #{index}:
      #{attrs["description"]}
      Amount: #{attrs["amount"]}
      Remittance: #{attrs["remittanceInformation"]}
      ---------------------------------------------
      """)
    end)
end
end
