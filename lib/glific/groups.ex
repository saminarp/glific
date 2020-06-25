defmodule Glific.Groups do
  @moduledoc """
  The Groups context.
  """
  import Ecto.Query, warn: false

  alias Glific.Repo
  alias Glific.Groups.Group
  alias Glific.Groups.{ContactGroup, UserGroup}

  @doc """
  Returns the list of groups.

  ## Examples

      iex> list_groups()
      [%Group{}, ...]

  """
  @spec list_groups(map()) :: [Group.t()]
  def list_groups(args \\ %{}) do
    args
    |> Enum.reduce(Group, fn
      {:opts, opts}, query ->
        query |> opts_with(opts)

      {:filter, filter}, query ->
        query |> filter_with(filter)
    end)
    |> Repo.all()
  end

  defp opts_with(query, opts) do
    Enum.reduce(opts, query, fn
      {:order, order}, query ->
        query |> order_by([c], {^order, fragment("lower(?)", c.label)})

      {:limit, limit}, query ->
        query |> limit(^limit)

      {:offset, offset}, query ->
        query |> offset(^offset)
    end)
  end

  @doc """
  Return the count of groups, using the same filter as list_groups
  """
  @spec count_groups(map()) :: integer
  def count_groups(args \\ %{}) do
    args
    |> Enum.reduce(Group, fn
      {:filter, filter}, query ->
        query |> filter_with(filter)
    end)
    |> Repo.aggregate(:count)
  end

  @spec filter_with(Ecto.Queryable.t(), %{optional(atom()) => any}) :: Ecto.Queryable.t()
  defp filter_with(query, filter) do
    Enum.reduce(filter, query, fn
      {:label, label}, query ->
        from q in query, where: ilike(q.label, ^"%#{label}%")
    end)
  end

  @doc """
  Gets a single group.

  Raises `Ecto.NoResultsError` if the Group does not exist.

  ## Examples

      iex> get_group!(123)
      %Group{}

      iex> get_group!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_group!(integer) :: Group.t()
  def get_group!(id), do: Repo.get!(Group, id)

  @doc """
  Creates a group.

  ## Examples

      iex> create_group(%{field: value})
      {:ok, %Group{}}

      iex> create_group(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_group(map()) :: {:ok, Group.t()} | {:error, Ecto.Changeset.t()}
  def create_group(attrs \\ %{}) do
    %Group{}
    |> Group.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a group.

  ## Examples

      iex> update_group(group, %{field: new_value})
      {:ok, %Group{}}

      iex> update_group(group, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_group(Group.t(), map()) :: {:ok, Group.t()} | {:error, Ecto.Changeset.t()}
  def update_group(%Group{} = group, attrs) do
    group
    |> Group.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a group.

  ## Examples

      iex> delete_group(group)
      {:ok, %Group{}}

      iex> delete_group(group)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_group(Group.t()) :: {:ok, Group.t()} | {:error, Ecto.Changeset.t()}
  def delete_group(%Group{} = group) do
    Repo.delete(group)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking group changes.

  ## Examples

      iex> change_group(group)
      %Ecto.Changeset{data: %Group{}}

  """
  @spec change_group(Group.t(), map()) :: Ecto.Changeset.t()
  def change_group(%Group{} = group, attrs \\ %{}) do
    Group.changeset(group, attrs)
  end

  @doc """
  Returns the list of contacts groups.

  ## Examples

      iex> list_contacts_groups()
      [%ContactGroup{}, ...]

  """
  @spec list_contacts_groups(map()) :: [ContactGroup.t()]
  def list_contacts_groups(_args \\ %{}) do
    Repo.all(ContactGroup)
  end

  @doc """
  Gets a single contact.

  Raises `Ecto.NoResultsError` if the Contact does not exist.

  ## Examples

      iex> get_contact_group!(123)
      %Contact{}

      iex> get_contact_group!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_contact_group!(integer) :: ContactGroup.t()
  def get_contact_group!(id) do
    Repo.get!(ContactGroup, id)
  end

  @doc """
  Creates a contact.

  ## Examples

      iex> create_contact_group(%{field: value})
      {:ok, %Contact{}}

      iex> create_contact_group(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_contact_group(map()) :: {:ok, ContactGroup.t()} | {:error, Ecto.Changeset.t()}
  def create_contact_group(attrs \\ %{}) do
    # Merge default values if not present in attributes
    %ContactGroup{}
    |> ContactGroup.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a contact group.

  ## Examples

      iex> update_contact_group(contact_group, %{field: new_value})
      {:ok, %ContactGroup{}}

      iex> update_contact_group(contact_group, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_contact_group(ContactGroup.t(), map()) ::
          {:ok, ContactGroup.t()} | {:error, Ecto.Changeset.t()}
  def update_contact_group(%ContactGroup{} = contact_group, attrs) do
    contact_group
    |> ContactGroup.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a contact group.

  ## Examples

      iex> delete_contact_group(contact_group)
      {:ok, %ContactGroup{}}

      iex> delete_contact_group(contact_group)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_contact_group(ContactGroup.t()) :: {:ok, ContactGroup.t()} | {:error, Ecto.Changeset.t()}
  def delete_contact_group(%ContactGroup{} = contact_group) do
    Repo.delete(contact_group)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking contact changes.

  ## Examples

      iex> change_contact_group(contact_group)
      %Ecto.Changeset{data: %ContactGroup{}}

  """
  @spec change_contact_group(ContactGroup.t(), map()) :: Ecto.Changeset.t()
  def change_contact_group(%ContactGroup{} = contact_group, attrs \\ %{}) do
    ContactGroup.changeset(contact_group, attrs)
  end


  @doc """
  Returns the list of users groups.

  ## Examples

      iex> list_users_groups()
      [%UserGroup{}, ...]

  """
  @spec list_users_groups(map()) :: [UserGroup.t()]
  def list_users_groups(_args \\ %{}) do
    Repo.all(UserGroup)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user_group!(123)
      %User{}

      iex> get_user_group!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_user_group!(integer) :: UserGroup.t()
  def get_user_group!(id) do
    Repo.get!(UserGroup, id)
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user_group(%{field: value})
      {:ok, %User{}}

      iex> create_user_group(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_user_group(map()) :: {:ok, UserGroup.t()} | {:error, Ecto.Changeset.t()}
  def create_user_group(attrs \\ %{}) do
    # Merge default values if not present in attributes
    %UserGroup{}
    |> UserGroup.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user group.

  ## Examples

      iex> update_user_group(user_group, %{field: new_value})
      {:ok, %UserGroup{}}

      iex> update_user_group(user_group, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_user_group(UserGroup.t(), map()) ::
          {:ok, UserGroup.t()} | {:error, Ecto.Changeset.t()}
  def update_user_group(%UserGroup{} = user_group, attrs) do
    user_group
    |> UserGroup.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user group.

  ## Examples

      iex> delete_user_group(user_group)
      {:ok, %UserGroup{}}

      iex> delete_user_group(user_group)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_user_group(UserGroup.t()) :: {:ok, UserGroup.t()} | {:error, Ecto.Changeset.t()}
  def delete_user_group(%UserGroup{} = user_group) do
    Repo.delete(user_group)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user_group(user_group)
      %Ecto.Changeset{data: %UserGroup{}}

  """
  @spec change_user_group(UserGroup.t(), map()) :: Ecto.Changeset.t()
  def change_user_group(%UserGroup{} = user_group, attrs \\ %{}) do
    UserGroup.changeset(user_group, attrs)
  end
end
