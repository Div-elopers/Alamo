import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveDropdown extends StatefulWidget {
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
  State<AdaptiveDropdown> createState() => _AdaptiveDropdownState();
}

class _AdaptiveDropdownState extends State<AdaptiveDropdown> {
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    // Initialize _selectedValue with the initial value passed to the widget
    _selectedValue = widget.value;
  }

  @override
  void didUpdateWidget(covariant AdaptiveDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update _selectedValue if the widget's value changes externally
    if (widget.value != oldWidget.value) {
      setState(() {
        _selectedValue = widget.value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      // iOS-specific dropdown using CupertinoPicker
      return _buildCupertinoDropdown(context);
    } else {
      // Material Design dropdown for Android and Web
      return _buildMaterialDropdown();
    }
  }

  Widget _buildMaterialDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedValue,
      items: widget.items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          _selectedValue = newValue;
        });
        if (widget.onChanged != null) {
          widget.onChanged!(newValue);
        }
      },
      decoration: const InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 0.1, color: Colors.black),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: widget.validator,
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
        child: Text(
          _selectedValue ?? widget.items.first,
          style: const TextStyle(fontSize: 16),
        ),
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
              initialItem: widget.items.indexOf(_selectedValue ?? widget.items.first),
            ),
            onSelectedItemChanged: (int selectedItem) {
              final newValue = widget.items[selectedItem];
              setState(() {
                _selectedValue = newValue;
              });
              if (widget.onChanged != null) {
                widget.onChanged!(newValue);
              }
            },
            children: widget.items.map((String item) => Center(child: Text(item))).toList(),
          ),
        ),
      ),
    );
  }
}
