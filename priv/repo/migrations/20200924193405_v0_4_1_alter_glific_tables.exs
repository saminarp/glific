defmodule Glific.Repo.Migrations.V041AlterGlificTables do
  use Ecto.Migration

  @moduledoc """
  v0.4.1 Alter Glific tables
  """

  @global_schema Application.fetch_env!(:glific, :global_schema)

  def change do
    credentials()

    providers()

    messages()

    bigquery_jobs()
  end

  # codebeat:disable[ABC]
  defp providers do
    alter table("providers", prefix: @global_schema) do
      add :shortcode, :string, comment: "Shortcode for the provider"
      add :group, :string

      add :is_required, :boolean, default: false, comment: "Whether mandatory for initial setup"

      # structure for keys
      add :keys, :jsonb,
        default: "{}",
        comment:
          "JSON Object containing details of the URLs, labels, workers etc. of the provider"

      # structure for secrets
      add :secrets, :jsonb,
        default: "{}",
        comment: "JSON object containing details of the API keys for the provider"

      remove :url
      remove :api_end_point
      remove :handler
      remove :worker
    end

    create unique_index(:providers, :shortcode, prefix: @global_schema)
  end

  # codebeat:enable[ABC]

  defp credentials do
    create table(:credentials) do
      # all the service keys which doesn't need encryption
      add :keys, :jsonb, default: "{}"

      # we will keep these keys encrypted
      add :secrets, :binary

      # Is the provider/service being currently active
      add :is_active, :boolean, default: false

      add :is_valid, :boolean, default: true

      # foreign key to provider id
      add :provider_id, references(:providers, on_delete: :nilify_all, prefix: @global_schema),
        null: false

      # foreign key to organization restricting scope of this table to this organization only
      add :organization_id, references(:organizations, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:credentials, [:provider_id, :organization_id])
  end

  defp messages do
    # using microsecond for correct ordering of messages
    alter table(:messages) do
      modify :inserted_at, :utc_datetime_usec,
        comment: "Time when the record entry was first made"

      modify :updated_at, :utc_datetime_usec,
        comment: "Time when the record entry was last updated"
    end
  end

  defp bigquery_jobs do
    create table(:bigquery_jobs) do
      # references the last message we processed
      add :table, :string, comment: "Table name"
      add :table_id, :integer, comment: "Table ID"

      # foreign key to organization restricting scope of this table to this organization only
      add :organization_id, references(:organizations, on_delete: :delete_all),
        null: false,
        comment: "Unique organization ID"

      timestamps(type: :utc_datetime)
    end
  end
end
