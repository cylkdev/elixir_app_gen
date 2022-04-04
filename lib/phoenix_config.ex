defmodule PhoenixConfig do
  @moduledoc """
  My Moduledoc
  """

  alias PhoenixConfig.{EctoSchemaReflector, AbsintheTypeMerge, EctoArgumentsReflector}

  @type crud_from_schema_opts :: [
    only: list(AbsintheGenerator.CrudResource.crud_type),
    except: list(AbsintheGenerator.CrudResource.crud_type)
  ]

  def moduledoc, do: @moduledoc

  def crud_from_schema(ecto_schema, opts \\ []) do
    relation_types = EctoSchemaReflector.schema_relationship_types([ecto_schema])
    crud_resouce = ecto_schema
      |> EctoSchemaReflector.to_crud_resource(
        opts[:only],
        opts[:except]
      )
      |> EctoArgumentsReflector.build_crud_resource_args(opts[:args])

    [crud_resouce | relation_types]
  end

  def remove_relations(ecto_schema, relation_key) do
    &AbsintheTypeMerge.remove_relations(&1, ecto_schema, relation_key)
  end
end
