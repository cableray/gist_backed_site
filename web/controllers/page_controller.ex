defmodule GistBackedSite.PageController do
  use GistBackedSite.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
