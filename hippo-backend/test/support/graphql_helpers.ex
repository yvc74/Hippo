defmodule GraphqlHelpers do
  use Phoenix.ConnTest

  @endpoint HippoWeb.Endpoint
  def skeleton(query, variables \\ %{}) do
    %{
      "operationName" => nil,
      "query" => query,
      "variables" => variables
    }
  end

  def gql(conn, query) do
    conn
    |> put_req_header("content-type", "application/json")
    |> post("/graphql", query)
  end
end
