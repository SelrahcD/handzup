defmodule HandzupWeb.RoomChannel do
  use Phoenix.Channel
  alias HandzupWeb.Presence


  def join("room:lobby", _message, socket) do
    {:ok, socket}
  end

  def join("room:" <> room_id, params, socket) do
    send(self(), :after_join)

    {:ok, assign(socket, :user, params["name"])}
  end

  def handle_in("raise_hand", _params, socket) do
    broadcast!(socket, "hand_raised", %{user: socket.assigns.user})
    {:noreply, socket}
  end

  def handle_info(:after_join, socket) do
    push(socket, "presence_state", Presence.list(socket))
    {:ok, _} = Presence.track(socket, "user:#{socket.assigns.user}", %{
      name: socket.assigns.user,
      online_at: inspect(System.system_time(:second))
    })
    {:noreply, socket}
  end

end
