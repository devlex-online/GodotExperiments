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

        public override void _Ready()
        {
            _estimatedBirthTimer = GetNode<Timer>("EstimatedBirthTimer");
            _estimatedBirthTimer.Connect("timeout", this, "TimerOnTimeout");
        }

        public void TimerOnTimeout()
        {
            GD.Print("BIRTH!!!!");
        }
        
        public void Sex(ReproductionController partner)
        {
            if (Gender.CanHaveSexWith(partner.Gender) && !_isPregnant)
            {
                EmitSignal(nameof(HadSex));
                _isPregnant = true;
                _estimatedBirthTimer.Start(_pregnancyTime);
            }
        }
    }
}
