using System;
using DTopDownPlayGround.Enums;
using Godot;

namespace DTopDownPlayGround.Scenes
{
    public class ReproductionController : Node
    {
        public Gender Gender { get; set; }

        [Signal]
        private delegate void HadSex();

        private bool _isPregnant = false;
        [Export]
        private int _pregnancyTime = 10;

        private Timer _estimatedBirthTimer;
        
        [Export] 
        private string _pathToMaleBabyScene;
        [Export] 
        private string _pathToFemaleBabyScene;
        private PackedScene _maleBabyScene;
        private PackedScene _femaleBabyScene;
        private RandomNumberGenerator _rng;

        [Signal]
        public delegate void Birth(Node baby);

        public override void _Ready()
        {
            _rng = new RandomNumberGenerator();
            _rng.Randomize();
            _estimatedBirthTimer = GetNode<Timer>("EstimatedBirthTimer");
            _estimatedBirthTimer.Connect("timeout", this, "TimerOnTimeout");
            _maleBabyScene = ResourceLoader.Load(_pathToMaleBabyScene) as PackedScene;
            _femaleBabyScene = ResourceLoader.Load(_pathToFemaleBabyScene) as PackedScene;
        }

        public void TimerOnTimeout()
        {
            var babyNode = _rng.RandiRange(1, 100) > 50 ? _maleBabyScene.Instance() : _femaleBabyScene.Instance();
            EmitSignal(nameof(Birth), babyNode);
        }
        
        public void Sex(ReproductionController partner)
        {
            if (Gender.CanHaveSexWith(partner.Gender) && !_isPregnant)
            {
                EmitSignal(nameof(HadSex));
                if (Gender == Gender.Female)
                {
                    _isPregnant = true;
                    _estimatedBirthTimer.Start(_pregnancyTime);
                }
            }
        }
    }
}
