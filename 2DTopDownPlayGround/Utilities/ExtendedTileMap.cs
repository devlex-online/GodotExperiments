using System;
using System.Collections.Generic;
using System.Linq;
using Godot;
using Array = Godot.Collections.Array;

namespace DTopDownPlayGround.Utilities
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

        protected void AddNodeToTiles(string pathToAddedScene, List<string> tileNames, List<Vector2> autoTileCoordinateVectors)
        {
            var sceneToAdd = ResourceLoader.Load(pathToAddedScene) as PackedScene;

            var usedPlantTiles = GetUsedCellsByTileNames(tileNames);

            foreach (Vector2 tileVectorInGrid in usedPlantTiles)
            {
                foreach (var autoTileCoordinateVector in autoTileCoordinateVectors)
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
