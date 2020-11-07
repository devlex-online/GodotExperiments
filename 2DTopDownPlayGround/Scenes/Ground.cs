using Godot;
using System;

public class Ground : TileMap
{
   
    
    public override void _Ready()
    {
        var waterAreaScene = ResourceLoader.Load("res://Scenes/WaterArea.tscn") as PackedScene;
        
        var used_water_tiles = GetUsedCellsById(TileSet.FindTileByName("landscape_river_n_s_1"));

        foreach (Vector2 tileVectorInGrid in used_water_tiles)
        {
            //If für autotileCoords
            Vector2 zeroTileVector = new Vector2(0,0);
            if(GetCellAutotileCoord((int)tileVectorInGrid.x, (int)tileVectorInGrid.y) == zeroTileVector)
            {
                var waterAreaInstance = waterAreaScene.Instance() as Area2D;
                waterAreaInstance.Position = MapToWorld(tileVectorInGrid);
                AddChild(waterAreaInstance);
            }
        }
    }
}
