using Godot;
using System;

public class SceneHandler : Node
{

    private PackedScene _mapstart;
    public override void _Ready()
    {
        _mapstart = ResourceLoader.Load<PackedScene>("res://Scenes/MainScenes/World.tscn");
        Node mapstart_instance = _mapstart.Instance();
        AddChild(mapstart_instance);
    }

}
