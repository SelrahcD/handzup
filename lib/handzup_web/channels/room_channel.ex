defmodule HandzupWeb.RoomChannel do
  use Phoenix.Channel
  alias HandzupWeb.Presence


  def join("room:" <> _room_id, params, socket) do
    send(self(), :after_join)

    case Registry.lookup(Registry.Rooms, socket.topic) do
      [] -> Handzup.Rooms.RoomsSupervisor.start_child(socket.topic)
      _ -> :error
    end

    {:ok, assign(socket, :user, params["name"])}
  end

  def handle_in("raise_hand", _params, socket) do
    Handzup.Rooms.Room.raise_hand(socket.topic, socket.assigns.user)

    broadcast!(socket, "waiting_list_updated", %{list: Handzup.Rooms.Room.get_raised_hands(socket.topic)})

    {:noreply, socket}
  end

  def handle_info(:after_join, socket) do
    push(socket, "presence_state", Presence.list(socket))
    push(socket, "waiting_list_updated", %{list: Handzup.Rooms.Room.get_raised_hands(socket.topic)})

    {:ok, _} = Presence.track(socket, "user:#{socket.assigns.user}", %{
      name: socket.assigns.user,
      online_at: inspect(System.system_time(:second))
    })

    {:noreply, socket}
  end

end
