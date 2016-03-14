defmodule GistBackedSite.PageController do
  use GistBackedSite.Web, :controller

  def index(conn, _params) do
    content = GistBackedSite.GitHub.get_gist_file!(GistBackedSite.Endpoint.config(:default_gist_id), "index.html")
    render conn, "index.html", content: content
  end
end
