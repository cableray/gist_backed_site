defmodule GistBackedSite.PageController do
  use GistBackedSite.Web, :controller
  plug BasicAuth, Application.get_env(:gist_backed_site, :basic_auth) when action in [:edit, :update]

  def index(conn, _params) do
    content = GistBackedSite.GitHub.get_gist_file!(GistBackedSite.Endpoint.config(:default_gist_id), "index.html")
    render conn, "index.html", content: content
  end

  def edit(conn, _params) do
    content = GistBackedSite.GitHub.get_gist_file!(GistBackedSite.Endpoint.config(:default_gist_id), "index.html")
    render conn, "edit.html", content: content
  end

  def update(conn, %{"content" => content}) do
    GistBackedSite.GitHub.update_gist_file!(GistBackedSite.Endpoint.config(:default_gist_id), "index.html", content)
    conn |>
    put_flash(:info, "update successful") |>
    redirect(to: page_path(conn, :index))
  end
end
