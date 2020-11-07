using Godot;

namespace DTopDownPlayGround.Scenes
{
    public class NeedsController : Node
    {
        [Export]
        private float _hungerRate = 1f;
        [Export]
        private float _thirstRate = 1f;
        [Export]
        private float _reproductionRate = 1f;
        [Export]
        private float _hungerMax = 100f;
        [Export]
        private float _thirstMax = 100f;
        [Export]
        private float _reproductionMax = 100f;
        [Export]
        private float _alwaysEatLimit = 50f;
        [Export]
        private float _maybeEatLimit = 25f;
        [Export]
        private NodePath _eatAreaPath;
        [Export]
        private NodePath _searchFoodAreaPath;
        [Export]
        private NodePath _randomMovementControllerPath;
        
        private RandomMovementController _randomMovementController;
        
        private float _hunger = 0f;
        private float _thirst = 0f;
        private float _reproduction = 0f;
        
        private RandomNumberGenerator _rng;

        private bool _hasTargetFood = false;
        public override void _Ready()
        {
            _rng = new RandomNumberGenerator();
            _rng.Randomize();
            var area2D = GetNode<Area2D>(_eatAreaPath);
            area2D.Connect("body_entered", this, "OnEatAreaBodyEntered");
            area2D = GetNode<Area2D>(_searchFoodAreaPath);
            area2D.Connect("body_entered", this, "OnSearchFoodAreaBodyEntered");
            _randomMovementController = GetNode<RandomMovementController>(_randomMovementControllerPath);
        }

        private void setTargetFood(Vector2 target)
        {
            _hasTargetFood = true;
            _randomMovementController.Target = target;
        }
        private void clearTargetFood()
        {
            _hasTargetFood = false;
            _randomMovementController.Target = null;
        }
        public void OnSearchFoodAreaBodyEntered(Node body)
        {
            if (_hunger > _alwaysEatLimit && !_hasTargetFood)
            {
                var node = body.GetNodeOrNull<EatableObject>(new NodePath("EatableObject"));
                if (node != null)
                {
                    setTargetFood(node.GetParent<Node2D>().Position);
                }
            }
        }

        public void OnEatAreaBodyEntered(Node body)
        {
            if (_hunger > _alwaysEatLimit)
            {
                var node = body.GetNodeOrNull<EatableObject>(new NodePath("EatableObject"));
                if (node != null)
                {
                    Eat(node);
                }
            }
            else if (_hunger > _maybeEatLimit && _rng.RandiRange(1, 100) > 90)
            {
                var node = body.GetNodeOrNull<EatableObject>(new NodePath("EatableObject"));
                if (node != null)
                {
                    Eat(node);
                }
            }
        }
        public void Eat(EatableObject eatableObject)
        {
            _hunger = ModifyNeed(_hunger, eatableObject.HungerModifier, _hungerMax);
            eatableObject.GetParent().QueueFree();
            clearTargetFood();
        }
        public void ModifyThirst(float modifier)
        {
            _thirst = ModifyNeed(_thirst, modifier, _thirstMax);
        }
        public void ModifyReproduction(float modifier)
        {
            _reproduction = ModifyNeed(_reproduction, modifier, _reproductionMax);
        }
    
        public override void _Process(float delta)
        {
            _hunger = RateCalculation(_hunger, _hungerRate, _hungerMax, delta);
            _thirst = RateCalculation(_thirst, _thirstRate, _thirstMax, delta);
            _reproduction = RateCalculation(_reproduction, _reproductionRate, _reproductionMax, delta);
            if (_hunger <= _alwaysEatLimit)
            {
                clearTargetFood();
            }
        }

        private static float RateCalculation(float value, float ratePerSecond, float maxValue,float delta)
        {
            value += ratePerSecond * delta;
            return value >= maxValue ? maxValue : value;
        }
        private static float ModifyNeed(float value, float modifier, float maxValue)
        {
            value += modifier;
            if (value >= maxValue) return maxValue;
            if (value <= 0f) return 0f;
            return value;
        }

        public override void _PhysicsProcess(float delta)
        {
           // GD.Print(_hunger,_thirst,_reproduction);
        }
    }
}
