import 'package:flutter/material.dart';
import 'package:zenbaba_funiture/data/model/product_model.dart';

class RawMaterialItem extends StatefulWidget {
  final RawMaterial rawMaterial;
  final VoidCallback onDelete;
  final VoidCallback onUpdate;
  const RawMaterialItem({
    super.key,
    required this.rawMaterial,
    required this.onDelete,
    required this.onUpdate,
  });

  @override
  State<RawMaterialItem> createState() => _RawMaterialItemState();
}

class _RawMaterialItemState extends State<RawMaterialItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: InkWell(
        onTap: widget.onUpdate,
        child: Row(
          children: [
            Expanded(
              child: Text(
                widget.rawMaterial.name,
                style: const TextStyle(
                  fontSize: 13,
                ),
              ),
            ),
            Expanded(
              child: Text(
                "${widget.rawMaterial.quantity} ${widget.rawMaterial.unit}",
                style: const TextStyle(
                  fontSize: 13,
                ),
              ),
            ),
            Expanded(
              child: Text(
                "${widget.rawMaterial.totalPrice}",
                style: const TextStyle(
                  fontSize: 13,
                ),
              ),
            ),
            GestureDetector(
                onTap: widget.onDelete,
                child: const SizedBox(
                  width: 20,
                  child: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
