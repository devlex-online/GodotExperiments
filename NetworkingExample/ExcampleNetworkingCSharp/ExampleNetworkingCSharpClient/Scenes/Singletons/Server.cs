using Godot;

namespace ExampleNetworkingCSharpClient.Scenes.Singletons
{
    public class Server : Node
    {
        private NetworkedMultiplayerENet _network;
        private string _ip = "127.0.0.1";
        private int _port = 1909;
    
        public override void _Ready()
        {
            ConnectToServer();
        }

        private void ConnectToServer()
        {
            _network = new NetworkedMultiplayerENet();
            _network.CreateClient(_ip, _port);
            GetTree().NetworkPeer = _network;

            _network.Connect("connection_failed", this, "_OnConnectionFailed");
            _network.Connect("connection_succeeded", this, "_OnConnectionSucceeded");

        }
    
        public void _OnConnectionFailed()
        {
            GD.Print("failed to connect");
        }
        public void _OnConnectionSucceeded()
        {
            GD.Print("Succesfully connected");
        }

        public void FetchDamage(ulong requester)
        {
            RpcId(1, "FetchDamage", requester);
        }

        [Remote]
        public void ReturnDamage(int damage, ulong requester)
        {
            GD.InstanceFromId(requester).Call("set_damage", damage);
        }
    }
}
