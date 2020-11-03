using Godot;

namespace DTopDownPlayGround.Scenes
{
    public class EatableObject : Node
    {
        [Export]
        private NodePath _collisionArea;

        private Area2D _area2D;
        public override void _Ready()
        {
            _area2D = GetNode<Area2D>(_collisionArea);
            _area2D.Connect("body_entered", this, "OnBodyEntered");
        }

        public void OnBodyEntered(Node body)
        {
            var needsControllerNode = body.FindNode("NeedsController");
            if (needsControllerNode != null  && needsControllerNode.GetType() == typeof(NeedsController))
            {
                ((NeedsController)needsControllerNode).ModifyHunger(-50);
                GetParent().QueueFree();
            }
        }
    }
}
