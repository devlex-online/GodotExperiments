using System;
using System.Collections.Generic;
using System.Linq;
using Godot;
using Array = Godot.Collections.Array;

namespace DTopDownPlayGround
{
    public class ExtendedTileMap : TileMap
    {
        public Array GetUsedCellsByTileNames(List<String> tileNames)
        {
            var usedTiles = new Array();
            foreach (var tileName in tileNames.Distinct())
            {
                var tempUsedTiles = GetUsedCellsById(TileSet.FindTileByName(tileName));
                
                foreach (var tempUsedTile in tempUsedTiles)
                {
                    usedTiles.Add(tempUsedTile);
                }
            }
        
            return usedTiles;
        }
        public void AddNodeToTiles(string _pathToAddedScene, List<string> _tileNames, List<Vector2> _autoTileCoordinateVectors)
        {
            var sceneToAdd = ResourceLoader.Load(_pathToAddedScene) as PackedScene;

            var used_plant_tiles = GetUsedCellsByTileNames(_tileNames);

            foreach (Vector2 tileVectorInGrid in used_plant_tiles)
            {
                foreach (var autoTileCoordinateVector in _autoTileCoordinateVectors)
                {
                    var convertedToIntVector = new Vector2((int)autoTileCoordinateVector.x, (int)autoTileCoordinateVector.y);
                    if ( convertedToIntVector == GetCellAutotileCoord((int) tileVectorInGrid.x, (int) tileVectorInGrid.y))
                    {
                        var plantInstance = sceneToAdd.Instance() as Area2D;
                        plantInstance.Position = MapToWorld(tileVectorInGrid);
                        AddChild(plantInstance);
                    }
                }

                
            }
        }
    }
}
