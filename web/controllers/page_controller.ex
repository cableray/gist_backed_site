defmodule GistBackedSite.PageController do
  use GistBackedSite.Web, :controller
  @realm "Editing"
  plug :basic_auth when action in [:edit, :update]

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

  defp basic_auth(conn, _) do
    case Plug.Conn.get_req_header(conn, "authorization") do
      ["Basic " <> encoded_creds] -> 
        if valid_credentials? conn, Base.decode64!(encoded_creds) do
          conn
        else
          send_unauthorized_response(conn)
        end
      _ -> send_unauthorized_response(conn)
    end
  end

  defp send_unauthorized_response(conn) do
     Plug.Conn.put_resp_header(conn, "www-authenticate", "Basic realm=\"#{@realm}\"")
    |> Plug.Conn.send_resp(401, "401 Unauthorized")
    |> Plug.Conn.halt
  end

  defp valid_credentials?(_conn, credentials) do
    [username, password] = String.split(credentials, ":")
    password == Application.get_env(:gist_backed_site, :basic_auth)[:password]
  end
end
