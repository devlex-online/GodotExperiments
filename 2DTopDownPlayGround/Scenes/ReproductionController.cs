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
        private string _pathToBabyScene;
        private PackedScene _babyScene;

        [Signal]
        public delegate void Birth(Node baby);

        public override void _Ready()
        {
            _estimatedBirthTimer = GetNode<Timer>("EstimatedBirthTimer");
            _estimatedBirthTimer.Connect("timeout", this, "TimerOnTimeout");
            _babyScene = ResourceLoader.Load(_pathToBabyScene) as PackedScene;
        }

        public void TimerOnTimeout()
        {
            var babyNode = _babyScene.Instance();
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
