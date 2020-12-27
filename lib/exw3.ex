defmodule ExW3 do
  Module.register_attribute(__MODULE__, :unit_map, persist: true, accumulate: false)

  @unit_map %{
    :noether => 0,
    :wei => 1,
    :kwei => 1_000,
    :Kwei => 1_000,
    :babbage => 1_000,
    :femtoether => 1_000,
    :mwei => 1_000_000,
    :Mwei => 1_000_000,
    :lovelace => 1_000_000,
    :picoether => 1_000_000,
    :gwei => 1_000_000_000,
    :Gwei => 1_000_000_000,
    :shannon => 1_000_000_000,
    :nanoether => 1_000_000_000,
    :nano => 1_000_000_000,
    :szabo => 1_000_000_000_000,
    :microether => 1_000_000_000_000,
    :micro => 1_000_000_000_000,
    :finney => 1_000_000_000_000_000,
    :milliether => 1_000_000_000_000_000,
    :milli => 1_000_000_000_000_000,
    :ether => 1_000_000_000_000_000_000,
    :kether => 1_000_000_000_000_000_000_000,
    :grand => 1_000_000_000_000_000_000_000,
    :mether => 1_000_000_000_000_000_000_000_000,
    :gether => 1_000_000_000_000_000_000_000_000_000,
    :tether => 1_000_000_000_000_000_000_000_000_000_000
  }

  @spec get_unit_map() :: map()
  @doc "Returns the map used for ether unit conversion"
  def get_unit_map do
    @unit_map
  end

  @spec to_wei(integer(), atom()) :: integer()
  @doc "Converts the value to whatever unit key is provided. See unit map for details."
  def to_wei(num, key) do
    if @unit_map[key] do
      num * @unit_map[key]
    else
      throw("#{key} not valid unit")
    end
  end

  @spec from_wei(integer(), atom()) :: integer() | float() | no_return
  @doc "Converts the value to whatever unit key is provided. See unit map for details."
  def from_wei(num, key) do
    if @unit_map[key] do
      num / @unit_map[key]
    else
      throw("#{key} not valid unit")
    end
  end

  @spec keccak256(binary()) :: binary()
  @doc "Returns a 0x prepended 32 byte hash of the input string"
  def keccak256(string) do
    {:ok, hash} = ExKeccak.hash_256(string)

    Enum.join(["0x", hash |> Base.encode16(case: :lower)], "")
  end

  @spec bytes_to_string(binary()) :: binary()
  @doc "converts Ethereum style bytes to string"
  def bytes_to_string(bytes) do
    bytes
    |> Base.encode16(case: :lower)
    |> String.replace_trailing("0", "")
    |> Base.decode16!(case: :lower)
  end

  @spec format_address(binary()) :: integer()
  @doc "Converts an Ethereum address into a form that can be used by the ABI encoder"
  def format_address(address) do
    address
    |> String.slice(2..-1)
    |> Base.decode16!(case: :lower)
    |> :binary.decode_unsigned()
  end

  @spec to_address(binary()) :: binary()
  @doc "Converts bytes to Ethereum address"
  def to_address(bytes) do
    Enum.join(["0x", bytes |> Base.encode16(case: :lower)], "")
  end

  @spec to_checksum_address(binary()) :: binary()
  @doc "returns a checksummed address"
  def to_checksum_address(address) do
    address = address |> String.downcase() |> String.replace(~r/^0x/, "")

    {:ok, hash_bin} = ExKeccak.hash_256(address)

    hash =
      hash_bin
      |> Base.encode16(case: :lower)
      |> String.replace(~r/^0x/, "")

    keccak_hash_list =
      hash
      |> String.split("", trim: true)
      |> Enum.map(fn x -> elem(Integer.parse(x, 16), 0) end)

    list_arr =
      for n <- 0..(String.length(address) - 1) do
        number = Enum.at(keccak_hash_list, n)

        cond do
          number >= 8 -> String.upcase(String.at(address, n))
          true -> String.downcase(String.at(address, n))
        end
      end

    "0x" <> List.to_string(list_arr)
  end

  @doc "checks if the address is a valid checksummed address"
  @spec is_valid_checksum_address(binary()) :: boolean()
  def is_valid_checksum_address(address) do
    to_checksum_address(address) == address
  end

  defdelegate accounts, to: ExW3.Rpc
  defdelegate block_number, to: ExW3.Rpc
  defdelegate balance(account), to: ExW3.Rpc
  defdelegate tx_receipt(tx_hash), to: ExW3.Rpc
  defdelegate block(block_number), to: ExW3.Rpc
  defdelegate new_filter(map), to: ExW3.Rpc
  defdelegate get_filter_changes(filter_id), to: ExW3.Rpc
  defdelegate get_logs(filter, opts \\ []), to: ExW3.Rpc
  defdelegate uninstall_filter(filter_id), to: ExW3.Rpc
  defdelegate mine(num_blocks \\ 1), to: ExW3.Rpc
  defdelegate personal_list_accounts(opts \\ []), to: ExW3.Rpc
  defdelegate personal_new_account(password, opts \\ []), to: ExW3.Rpc
  defdelegate personal_unlock_account(params, opts \\ []), to: ExW3.Rpc
  defdelegate personal_send_transaction(param_map, passphrase, opts \\ []), to: ExW3.Rpc
  defdelegate personal_sign_transaction(param_map, passphrase, opts \\ []), to: ExW3.Rpc
  defdelegate personal_sign(data, address, passphrase, opts \\ []), to: ExW3.Rpc
  defdelegate personal_ec_recover(data0, data1, opts \\ []), to: ExW3.Rpc
  defdelegate eth_sign(data0, data1, opts \\ []), to: ExW3.Rpc
  defdelegate eth_call(arguments), to: ExW3.Rpc
  defdelegate eth_send(arguments), to: ExW3.Rpc
end
