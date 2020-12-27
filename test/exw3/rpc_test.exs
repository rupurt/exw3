defmodule ExW3.RpcTest do
  use ExUnit.Case

  describe ".accounts" do
    test "returns a list of accounts" do
      assert ExW3.accounts() |> is_list
    end

    test "can override the http endpoint" do
      assert ExW3.accounts(url: Ethereumex.Config.rpc_url()) |> is_list
    end
  end

  describe ".block_number" do
    test "gets block number" do
      assert ExW3.block_number() |> is_integer
    end

    test "can override the http endpoint" do
      assert ExW3.block_number(url: Ethereumex.Config.rpc_url()) |> is_integer
    end
  end

  describe ".balance" do
    test "gets balance" do
      account = ExW3.accounts() |> Enum.at(0)
      assert ExW3.balance(account) |> is_integer
    end

    test "can override the http endpoint" do
      account = ExW3.accounts() |> Enum.at(0)
      assert ExW3.balance(account, url: Ethereumex.Config.rpc_url()) |> is_integer
    end
  end
end
