using Godot;

namespace DTopDownPlayGround.Scenes
{
	public class NeedIndicators : Control
	{
		[Export]
		private NodePath _needsControllerPath;

		private NeedsController _needsController;
		private ProgressBar _hungerBar;
		private ProgressBar _thirstBar;
		private ProgressBar _reproductionBar;

		public override void _Ready()
		{
			_needsController = GetNode<NeedsController>(_needsControllerPath);
			_hungerBar = GetNode<ProgressBar>("HungerBar");
			_thirstBar = GetNode<ProgressBar>("ThirstBar");
			_reproductionBar = GetNode<ProgressBar>("ReproductionBar");
		}


		public override void _PhysicsProcess(float delta)
		{        
			_hungerBar.MaxValue = _needsController.HungerMax;
			_hungerBar.Value = _needsController.Hunger;
			_thirstBar.MaxValue = _needsController.ThirstMax;
			_thirstBar.Value = _needsController.Thirst;
			_reproductionBar.MaxValue = _needsController.ReproductionMax;
			_reproductionBar.Value = _needsController.Reproduction;
		}
	}
}
