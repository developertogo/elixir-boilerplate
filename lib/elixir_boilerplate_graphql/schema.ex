defmodule ElixirBoilerplateGraphQL.Schema do
  use Absinthe.Schema

  import_types(Absinthe.Type.Custom)
  import_types(ElixirBoilerplateGraphQL.Application.Types)

  query do
    import_fields(:application_queries)
  end

  # Even if having an empty mutation block is valid and works in Ansinthe, it
  # causes a Javascript error in GraphiQL so uncomment it when you add the
  # first mutation.
  #
  # mutation do
  # end

  def context(context) do
    Map.put(context, :loader, Dataloader.add_source(Dataloader.new(), :repo, Dataloader.Ecto.new(ElixirBoilerplate.Repo)))
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end

  def middleware(middleware, _, _) do
    [NewRelic.Absinthe.Middleware, ElixirBoilerplateGraphQL.OperationNameLogger] ++ middleware
  end
end
