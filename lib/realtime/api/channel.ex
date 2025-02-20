defmodule Realtime.Api.Channel do
  @moduledoc """
  Defines the Channel schema
  """
  use Ecto.Schema
  import Ecto.Changeset
  @derive {Jason.Encoder, only: [:name, :inserted_at, :updated_at, :id]}

  @type t :: %__MODULE__{}

  @schema_prefix "realtime"
  schema "channels" do
    field(:name, :string)
    field(:check, :boolean, default: false)
    timestamps()

    has_many(:broadcasts, Realtime.Api.Broadcast)
  end

  def changeset(channel, attrs) do
    channel
    |> cast(attrs, [:name, :check, :inserted_at, :updated_at])
    |> validate_required([:name])
    |> put_timestamp(:updated_at)
    |> maybe_put_timestamp(:inserted_at)
  end

  def check_changeset(channel, attrs) do
    channel
    |> change()
    |> put_change(:check, attrs[:check])
  end

  defp put_timestamp(changeset, field) do
    put_change(changeset, field, NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second))
  end

  defp maybe_put_timestamp(changeset, field) do
    case Map.get(changeset.data, field, nil) do
      nil -> put_timestamp(changeset, field)
      _ -> changeset
    end
  end
end
