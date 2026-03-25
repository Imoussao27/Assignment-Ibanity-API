defmodule IbanityClient.CallbackServer do
  @moduledoc """
  Small HTTP server that listens for the OAuth2 callback on localhost:4000.
  Goal : Catch the authorization code that Ponto sends back after the user consents
  """
  use Plug.Router

  plug :match  # reads the URL path
  plug Plug.Parsers, parsers: [:urlencoded] # reads parameters
  plug :dispatch # execute get "/callback"

  get "/callback" do
    code = conn.query_params["code"] # HTTP connexion

    if code do
      send(IbanityClient.Orchestrator, {:auth_code, code}) # sends the code to the process
      send_resp(conn, 200, "Authorization successful.")
    else
      error = conn.query_params["error_description"]
      send_resp(conn, 400, "Authorization failed : #{error}")
    end


  end

  #Handle any other routes (favicon.ico requested automatically by the browser)
  match _ do
    send_resp(conn, 404, "Not found")
  end

  def start do
  #Start the server on port 4000
   case Plug.Cowboy.http(__MODULE__, [], port: 4000) do
    {:ok, _} -> IO.puts("Callback server started on http://localhost:4000")
    #{:error, {:already_started, _}} -> :ok # doesnt crash if we recompile the code
  end
  end
end
