import 'package:flutter/material.dart';
import 'package:game/features/game/domain/models/cell.dart';

class GridCellWidget extends StatefulWidget {
  final Cell cell;
  final bool selected;
  final VoidCallback onTap;
  const GridCellWidget({super.key, required this.cell, required this.selected, required this.onTap});

  @override
  State<GridCellWidget> createState() => _GridCellWidgetState();
}

class _GridCellWidgetState extends State<GridCellWidget> with SingleTickerProviderStateMixin {
  late AnimationController _shakeCtrl;

  @override
  void initState() {
    super.initState();
    _shakeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 250));
  }

  @override
  void dispose() {
    _shakeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMatched = widget.cell.matched;
    final bg = isMatched ? Colors.grey.shade300 : Colors.white;
    final border = widget.selected ? Colors.indigo : Colors.grey.shade400;
    final textColor = isMatched ? Colors.black54 : Colors.black;

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedOpacity(
        opacity: isMatched ? 0.4 : 1.0,
        duration: const Duration(milliseconds: 180),
        child: AnimatedScale(
          scale: widget.selected ? 1.05 : 1.0,
          duration: const Duration(milliseconds: 120),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: border, width: 2),
              boxShadow: [
                if (!isMatched) BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2)),
              ],
            ),
            child: Center(
              child: Text(
                '${widget.cell.value}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
