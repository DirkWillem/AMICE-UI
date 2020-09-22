import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

typedef Widget TileBuilder(BuildContext context);

class Tile {
  final TileBuilder builder;
  final int colspan;
  final int rowspan;

  Tile(
      {@required this.builder, @required this.colspan, @required this.rowspan});
}

class PageBase extends StatelessWidget {
  List<Tile> _tiles;

  PageBase(this._tiles);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        var width = constraints.normalize().maxWidth;
        return StaggeredGridView.countBuilder(
          crossAxisCount: width ~/ 180,
          padding: EdgeInsets.all(4),
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          itemCount: _tiles.length,
          itemBuilder: (BuildContext context, int index) =>
              _tiles[index].builder(context),
          staggeredTileBuilder: (int index) =>
              StaggeredTile.count(_tiles[index].colspan, _tiles[index].rowspan),
        );
      }
    );
  }
}
