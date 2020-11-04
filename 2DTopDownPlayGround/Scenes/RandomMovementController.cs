using Godot;

namespace DTopDownPlayGround.Scenes
{
    public class RandomMovementController : Node
    {

        [Export]
        private NodePath _kinematicBodyNodePath;

        private KinematicBody2D _kinematicBody;

        private RandomNumberGenerator _rng;
        private Vector2 _velocity;

        public Vector2? Target
        {
            get
            {
                return _target;
            }
            set
            {
                _target = value;
                _hasTarget = value != null;
            }
        }

        private Vector2? _target = null;
        private bool _hasTarget = false;
        public override void _Ready()
        {
            _rng = new RandomNumberGenerator();
            _rng.Randomize();
            _velocity = NewVelocity();
            GD.Print(_rng.Seed);
            _kinematicBody = GetNode<KinematicBody2D>(_kinematicBodyNodePath);
        }

        public override void _PhysicsProcess(float delta)
        {
            if (_hasTarget)
            {
                _velocity = GetVelocityToTarget();
            }
            var collision = _kinematicBody.MoveAndCollide(_velocity * delta);
            if (collision != null)
            {
                _velocity = NewVelocity();
            }
        }

        private Vector2 GetVelocityToTarget()
        {
            if (_hasTarget)
            {
                return (GetParent<Node2D>().Position.DirectionTo(_target.Value)).Normalized() * 100f;
            }
            else
            {
                return NewVelocity();
            }
        }
        private Vector2 NewVelocity()
        {
            Vector2 velocity = new Vector2(_rng.Randf(), _rng.Randf()).Normalized();
            velocity.x *= _rng.RandiRange(1, 100) > 50 ? 1 : -1;
            velocity.y *= _rng.RandiRange(1, 100) > 50 ? 1 : -1;
            velocity *= 100f;
            return velocity;
        }
    }
}
