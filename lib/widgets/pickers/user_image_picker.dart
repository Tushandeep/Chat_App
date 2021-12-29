import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final Function(File pickedImage) imagePickerFn;

  const UserImagePicker({
    Key? key,
    required this.imagePickerFn,
  }) : super(key: key);

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  dynamic _pickedImage;
  bool _changeImage = false;

  bool _imageTapped = false;

  void _pickImage() async {
    final imageFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 150,
    );
    setState(() {
      _changeImage = true;
      _pickedImage = imageFile!.path;
    });
    widget.imagePickerFn(File(_pickedImage));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 1000),
      height: (_imageTapped) ? 300 : 120,
      width: (_imageTapped) ? 300 : 120,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        shape: BoxShape.circle,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              setState(() {
                _imageTapped = !_imageTapped;
              });
            },
            child: AnimatedPositioned(
              duration: const Duration(milliseconds: 1000),
              height: (_imageTapped) ? 300 : null,
              width: (_imageTapped) ? 300 : null,
              child: (!_changeImage)
                  ? const Icon(
                      Iconsax.user,
                      size: 40,
                    )
                  : FittedBox(
                      fit: BoxFit.fill,
                      child: CircleAvatar(
                        radius: (_imageTapped) ? 150 : 60,
                        backgroundImage: FileImage(
                          File(
                            _pickedImage,
                          ),
                        ),
                      ),
                    ),
            ),
          ),
          if (!_imageTapped)
            Positioned(
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 35,
                  width: 35,
                  padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: Icon(
                      Iconsax.edit,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
