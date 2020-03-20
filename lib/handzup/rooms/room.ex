defmodule Handzup.Rooms.Room do
  use GenServer, restart: :temporary

  def start_link(room_name) do
    GenServer.start_link(__MODULE__, [], name: via_tuple(room_name))
  end

  def raise_hand(room_name, username) do
    GenServer.cast(via_tuple(room_name), {:raise_hand, username})
  end

  def get_raised_hands(room_name) do
    GenServer.call(via_tuple(room_name), :get_raised_hands)
  end

  def init(raised_hands) do
    {:ok, raised_hands}
  end

  def handle_cast({:raise_hand, username}, raised_hands) do
    {:noreply, raised_hands ++ [username]}
  end

  def handle_call(:get_raised_hands, _from, raised_hands) do
    {:reply, raised_hands, raised_hands}
  end

  defp via_tuple(room_name) do
    {:via, Registry, {Registry.Rooms, room_name}}
  end
end