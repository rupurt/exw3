defmodule ExW3.Normalize do
  @spec transform_to_integer(map(), list()) :: map()
  def transform_to_integer(map, keys) do
    for k <- keys, into: %{} do
      {:ok, v} = map |> Map.get(k) |> ExW3.Utils.hex_to_integer()
      {k, v}
    end
  end
end
