using Godot;
using System;
using System.Collections.Generic;
using DTopDownPlayGround;

public class EatablePlants : ExtendedTileMap
{
    [Export] private List<string> _tileNames;
    [Export] private List<Vector2> _autoTileCoordinateVectors;
    [Export] private string _pathToAddedScene;
    public override void _Ready()
    {
        AddNodeToTiles(_pathToAddedScene, _tileNames, _autoTileCoordinateVectors);
    }

}
