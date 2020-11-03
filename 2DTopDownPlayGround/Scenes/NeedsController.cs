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
        
        private float _hunger = 0f;
        private float _thirst = 0f;
        private float _reproduction = 0f;

        public void ModifyHunger(float modifier)
        {
            _hunger = ModifyNeed(_hunger, modifier, _hungerMax);
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
            GD.Print(_hunger,_thirst,_reproduction);
        }
    }
}
