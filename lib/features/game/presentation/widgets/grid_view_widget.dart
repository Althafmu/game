import 'package:flutter/material.dart';
import 'package:game/features/game/domain/models/cell.dart';
import 'grid_cell_widget.dart';

class GridViewWidget extends StatelessWidget {
  final List<List<Cell?>> grid;
  final Cell? selected;
  final void Function(Cell) onTap;

  const GridViewWidget({
    super.key,
    required this.grid,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final rows = grid.length;
    final cols = grid.first.length;

    return LayoutBuilder(builder: (ctx, constraints) {
      final cellSize = (constraints.maxWidth - 8) / cols;
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: List.generate(rows, (r) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(cols, (c) {
              final cell = grid[r][c];
              return SizedBox(
                width: cellSize,
                height: cellSize,
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: cell == null
                      ? const DecoratedBox(decoration: BoxDecoration(color: Color(0xFFEFEFF5), borderRadius: BorderRadius.all(Radius.circular(8))))
                      : GridCellWidget(
                          cell: cell,
                          selected: selected?.id == cell.id,
                          onTap: () => onTap(cell),
                        ),
                ),
              );
            }),
          );
        }),
      );
    });
  }
}
