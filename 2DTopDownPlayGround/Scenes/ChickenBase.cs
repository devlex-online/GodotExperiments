using DTopDownPlayGround.Enums;
using Godot;

namespace DTopDownPlayGround.Scenes
{
    public class ChickenBase : Node2D
    {
        [Export(PropertyHint.Enum)] private Gender _gender;

        // Called when the node enters the scene tree for the first time.
        public override void _Ready()
        {
        
        }

//  // Called every frame. 'delta' is the elapsed time since the previous frame.
//  public override void _Process(float delta)
//  {
//      
//  }
    }
}
