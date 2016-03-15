defmodule GistBackedSite.GitHub do
  use HTTPoison.Base

  @expected_fields ~w(
    login id avatar_url gravatar_id url html_url followers_url
    following_url gists_url starred_url subscriptions_url
    organizations_url repos_url events_url received_events_url type
    site_admin name company blog location email hireable bio
    public_repos public_gists followers following created_at updated_at
  )

  def process_url(url) do
    "https://api.github.com" <> url
  end

  def process_response_body(body) do
    body
    |> Poison.decode!
    # |> Dict.take(@expected_fields)
    # |> Enum.map(fn({k, v}) -> {String.to_atom(k), v} end)
  end

  def process_request_body(body) do
    body |>
    Poison.encode!
  end

  def process_request_headers(headers) do
    [{"Authorization", "token " <> GistBackedSite.Endpoint.config(:github_api_key)}] ++ headers
  end

  def get_gist!(id) do
    get!("/gists/" <> id)
  end

  def get_gist_file!(id, file_name) do
    get_gist!(id) |>
    get_file_content(file_name)
  end

  def get_file_content(%HTTPoison.Response{body: %{"files" => files}}, file_name) do
    %{^file_name => %{"content" => content}} = files
    content
  end

  def update_gist!(id, payload) do
    patch!("/gists/" <> id, payload)
  end

  def update_gist_file!(id, file_name, content) do
    update_gist!(id, %{"files" => %{file_name => %{"content" => content}}})
  end
end
