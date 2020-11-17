using System.Threading;
using DTopDownPlayGround.Enums;
using Godot;

namespace DTopDownPlayGround.Scenes
{
    public class ChickenBase : Node2D
    {
        [Export(PropertyHint.Enum)] private Gender _gender;
        private NeedsController _needsController;
        private ReproductionController _reproductionController;

        public override void _Ready()
        {
            _reproductionController = GetNode<ReproductionController>("ReproductionController");
            _needsController = GetNode<NeedsController>("NeedsController");
            _reproductionController.Gender = _gender;
            _reproductionController.Connect("HadSex", this, nameof(ReproductionControllerOnHadSex));
            _needsController.Connect("SexWith", this, nameof(NeedsControllerOnSexWith));
        }

        public void NeedsControllerOnSexWith(Node other)
        {
            var reproductionController =  other.GetNodeOrNull<ReproductionController>("ReproductionController");
            _reproductionController.Sex(reproductionController);
        }
        public void ReproductionControllerOnHadSex()
        {
            if (_gender == Gender.Male)
            {
                _needsController.ModifyReproduction(_needsController.ReproductionMax/2 * -1);
            }
            else
            {
                _needsController.ModifyReproduction(_needsController.ReproductionMax * -1);
            }
        }
    }
}
