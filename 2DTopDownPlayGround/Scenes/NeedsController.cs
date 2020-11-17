using System;
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
        
        [field: Export]
        public float HungerMax { get; } = 100f;
        [field: Export]
        public float ThirstMax { get; } = 100f;
        [field: Export]
        public float ReproductionMax { get; } = 100f;

        [Export]
        private float _alwaysEatLimit = 50f;
        [Export]
        private float _maybeEatLimit = 25f;
        [Export]
        private float _alwaysDrinkLimit = 50f;
        [Export]
        private float _maybeDrinkLimit = 25f;
        [Export]
        private NodePath _eatAreaPath;
        [Export]
        private NodePath _searchFoodAreaPath;
        [Export]
        private NodePath _randomMovementControllerPath;
        
        private RandomMovementController _randomMovementController;

        public float Hunger { get; private set; }
        public float Thirst { get; private set; }
        public float Reproduction { get; private set; }

        private RandomNumberGenerator _rng;

        private bool _hasTargetFood;

        [Signal]
        public delegate void SexWith(Node other);
        
        public override void _Ready()
        {
            _rng = new RandomNumberGenerator();
            _rng.Randomize();
            var area2D = GetNode<Area2D>(_eatAreaPath);
            area2D.Connect("body_entered", this, "OnEatAreaBodyEntered");
            area2D.Connect("area_entered", this, "OnEatAreaAreaEntered");
            area2D = GetNode<Area2D>(_searchFoodAreaPath);
            area2D.Connect("body_entered", this, "OnSearchFoodAreaBodyEntered");
            area2D.Connect("area_entered", this, "OnSearchFoodAreaAreaEntered");
            _randomMovementController = GetNode<RandomMovementController>(_randomMovementControllerPath);
        }

        private void SetTargetFood(Vector2 target)
        {
            _hasTargetFood = true;
            _randomMovementController.Target = target;
        }
        private void ClearTargetFood()
        {
            _hasTargetFood = false;
            _randomMovementController.Target = null;
        }
        public void OnSearchFoodAreaBodyEntered(Node body)
        {

        }
        public void OnSearchFoodAreaAreaEntered(Area2D area)
        {
            if (area.IsInGroup("PlantArea") && Hunger > _alwaysEatLimit && !_hasTargetFood)
            {
                var node = area.GetNodeOrNull<EatableObject>(new NodePath("EatableObject"));
                if (node != null)
                {
                    SetTargetFood(node.GetParent<Node2D>().Position);
                }
            }
            else if (area.IsInGroup("WaterArea") && Thirst > _alwaysDrinkLimit && !_hasTargetFood)
            {
                if (area.IsInGroup("WaterArea"))
                {
                    SetTargetFood(area.Position);
                }
            }
            else if (area.IsInGroup("ReproductionArea") && Math.Abs(Reproduction - ReproductionMax) < 0.5 && !_hasTargetFood)
            {
                SetTargetFood(area.GetParent().GetParent<Node2D>().Position);
            }
        }
        public void OnEatAreaAreaEntered(Area2D area)
        {
            if (area.IsInGroup("PlantArea"))
            {
                if (Hunger > _alwaysEatLimit)
                {
                    var node = area.GetNodeOrNull<EatableObject>(new NodePath("EatableObject"));
                    if (node != null)
                    {
                        Eat(node);
                    }
                }
                else if (Hunger > _maybeEatLimit && _rng.RandiRange(1, 100) > 90)
                {
                    var node = area.GetNodeOrNull<EatableObject>(new NodePath("EatableObject"));
                    if (node != null)
                    {
                        Eat(node);
                    }
                }
            }
            else if (area.IsInGroup("WaterArea"))
            {
                if (Thirst > _alwaysDrinkLimit)
                {
                    Drink();
                }
                else if (Thirst > _maybeDrinkLimit && _rng.RandiRange(1, 100) > 90)
                {
                    Drink();
                }
            }
            else if (area.IsInGroup("ReproductionArea"))
            {
                if (Math.Abs(Reproduction - ReproductionMax) < 0.5)
                {
                    EmitSignal(nameof(SexWith), area.GetParent());
                }
            }
        }
        public void OnEatAreaBodyEntered(Node body)
        {

        }

        public void Drink()
        {
            ModifyThirst(ThirstMax * -1);
            ClearTargetFood();
        }
        public void Eat(EatableObject eatableObject)
        {
            Hunger = ModifyNeed(Hunger, eatableObject.HungerModifier, HungerMax);
            var tileMap = eatableObject.GetParent().GetParent<TileMap>();
            var tilepos = tileMap.WorldToMap(eatableObject.GetParent<Node2D>().Position);
            tileMap.SetCellv(tilepos, -1);
            eatableObject.GetParent().QueueFree();
            ClearTargetFood();
        }
        public void ModifyThirst(float modifier)
        {
            Thirst = ModifyNeed(Thirst, modifier, ThirstMax);
        }
        public void ModifyReproduction(float modifier)
        {
            Reproduction = ModifyNeed(Reproduction, modifier, ReproductionMax);
        }
    
        public override void _Process(float delta)
        {
            Hunger = RateCalculation(Hunger, _hungerRate, HungerMax, delta);
            Thirst = RateCalculation(Thirst, _thirstRate, ThirstMax, delta);
            Reproduction = RateCalculation(Reproduction, _reproductionRate, ReproductionMax, delta);
            if (Hunger <= _alwaysEatLimit)
            {
                ClearTargetFood();
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
           // GD.Print("H:",Hunger," T:",Thirst, " R:",Reproduction);
        }
    }
}
