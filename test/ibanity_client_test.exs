defmodule IbanityClientTest do
  use ExUnit.Case
  doctest IbanityClient

  test "greets the world" do
    assert IbanityClient.hello() == :world
  end
end
