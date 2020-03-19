defmodule HandzupWeb.RoomChannel do
  use Phoenix.Channel

  def join("room:lobby", _message, socket) do
    {:ok, socket}
  end

  def join("room:" <> room_id, params, socket) do
    IO.inspect(params, label: "joining params")

    {:ok, assign(socket, :user, params["name"])}
  end

  def handle_in("raise_hand", _params, socket) do
    broadcast!(socket, "hand_raised", %{user: socket.assigns.user})
    {:noreply, socket}
  end

end
