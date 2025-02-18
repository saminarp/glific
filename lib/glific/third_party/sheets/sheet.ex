defmodule Glific.Sheets.Sheet do
  @moduledoc """
  The minimal wrapper for the base Sheet structure
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias __MODULE__

  alias Glific.{
    Partners.Organization
  }

  @required_fields [
    :label,
    :url,
    :organization_id
  ]

  @optional_fields [:last_synced_at, :is_active]

  @type t() :: %__MODULE__{
          __meta__: Ecto.Schema.Metadata.t(),
          id: non_neg_integer | nil,
          label: String.t() | nil,
          url: String.t() | nil,
          is_active: boolean() | nil,
          last_synced_at: :utc_datetime | nil,
          organization_id: non_neg_integer | nil,
          organization: Organization.t() | Ecto.Association.NotLoaded.t() | nil,
          inserted_at: :utc_datetime | nil,
          updated_at: :utc_datetime | nil
        }

  schema "sheets" do
    field :label, :string
    field :url, :string
    field :is_active, :boolean, default: true
    field :last_synced_at, :utc_datetime

    belongs_to :organization, Organization

    timestamps(type: :utc_datetime_usec)
  end

  @doc """
  Standard changeset pattern we use for all data types
  """
  @spec changeset(Sheet.t(), map()) :: Ecto.Changeset.t()
  def changeset(sheet, attrs) do
    sheet
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint([:label, :url, :organization_id])
  end
end
