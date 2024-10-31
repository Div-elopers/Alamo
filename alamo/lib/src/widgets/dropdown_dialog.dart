import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveDropdown extends StatelessWidget {
  final String? value;
  final List<String> items;
  final ValueChanged<String?>? onChanged;
  final String? Function(String?)? validator;

  const AdaptiveDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      // iOS-specific dropdown using CupertinoPicker
      return _buildCupertinoDropdown(context);
    } else {
      // Material Design dropdown for Android and Web
      return _buildMaterialDropdown(onChanged);
    }
  }

  Widget _buildMaterialDropdown(
    ValueChanged<String?>? onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: const InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 0.1, color: Colors.black),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: validator,
    );
  }

  Widget _buildCupertinoDropdown(BuildContext context) {
    return GestureDetector(
      onTap: () => _showCupertinoPicker(context),
      child: InputDecorator(
        decoration: const InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 0.1, color: Colors.black),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        child: Text(value ?? items.first),
      ),
    );
  }

  void _showCupertinoPicker(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: CupertinoPicker(
            magnification: 1.22,
            squeeze: 1.2,
            useMagnifier: true,
            itemExtent: 32.0,
            scrollController: FixedExtentScrollController(
              initialItem: items.indexOf(value ?? items.first),
            ),
            onSelectedItemChanged: (int selectedItem) {
              onChanged!(items[selectedItem]);
            },
            children: items.map((String item) => Center(child: Text(item))).toList(),
          ),
        ),
      ),
    );
  }
}
