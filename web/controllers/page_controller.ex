defmodule GistBackedSite.PageController do
  use GistBackedSite.Web, :controller

  def index(conn, _params) do
    content = GistBackedSite.GitHub.get_gist_file!(GistBackedSite.Endpoint.config(:default_gist_id), "index.html")
    render conn, "index.html", content: content
  end

  def edit(conn, _params) do
    content = GistBackedSite.GitHub.get_gist_file!(GistBackedSite.Endpoint.config(:default_gist_id), "index.html")
    render conn, "edit.html", content: content
  end

  def update(conn, %{"content" => content}) do
    conn |>
    put_flash(:info, "update would have been successful") |>
    render("edit.html", content: content)
  end
end
