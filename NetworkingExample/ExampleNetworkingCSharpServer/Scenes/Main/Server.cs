using Godot;

namespace ExampleNetworkingCSharpServer.Scenes.Main
{
    public class Server : Node
    {
        private NetworkedMultiplayerENet _network;
        private int _port = 1909;
        private int _max_players = 100;
        
        public override void _Ready()
        {
            _network = new NetworkedMultiplayerENet();
            StartServer();
        }

        private void StartServer()
        {
            _network.CreateServer(_port, _max_players);
            GetTree().NetworkPeer = _network;
            GD.Print("Server started");

            _network.Connect("peer_connect", this, "_OnPeerConnect");
            _network.Connect("peer_disconnect", this, "_OnPeerDisconnect");
        }

        public void _OnPeerConnect(int id)
        {
            GD.Print("User " + id + " Connected");
        }

        public void _OnPeerDisconnect(int id)
        {
            GD.Print("User " + id + " Disconnected");
        }
    }
}
