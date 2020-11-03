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

            _network.Connect("peer_connected", this, "_OnPeerConnected");
            _network.Connect("peer_disconnected", this, "_OnPeerDisconnected");
        }

        public void _OnPeerConnected(int id)
        {
            GD.Print("User " + id + " Connected");
        }

        public void _OnPeerDisconnected(int id)
        {
            GD.Print("User " + id + " Disconnected");
        }

        [Remote]
        public void FetchDamage(ulong requester)
        {
            var playerId = GetTree().GetRpcSenderId();
            RpcId(playerId, "ReturnDamage", 150, requester);
            GD.Print("Sending Damage to Player " + playerId);
        }
    }
}
