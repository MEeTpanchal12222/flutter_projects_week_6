import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_projects_week_6/core/constant.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddPlantProvider extends ChangeNotifier {
  final SupabaseClient _supabase;
  AddPlantProvider(this._supabase);

  final nameCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final priceCtrl = TextEditingController();

  int selectedCategoryId = 1;
  File? imageFile;
  bool isLoading = false;

  final ImagePicker _picker = ImagePicker();

  void setCategory(int id) {
    selectedCategoryId = id;
    notifyListeners();
  }

  Future<void> pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );

      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  Future<bool> addPlant() async {
    if (imageFile == null) return false;

    isLoading = true;
    notifyListeners();

    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final path = 'plant_images/$fileName';

      await _supabase.storage.from('plant_images').upload(path, imageFile!);

      final imageUrl = _supabase.storage.from('plant_images').getPublicUrl(path);

      await _supabase.from(AppConstants.productsTable).insert({
        'name': nameCtrl.text.trim(),
        'description': descCtrl.text.trim(),
        'price': double.tryParse(priceCtrl.text) ?? 0.0,
        'category_id': selectedCategoryId,
        'image_url': imageUrl,
        'rating': 5.0,
      });

      _clearForm();
      return true;
    } catch (e) {
      debugPrint("Error adding plant: $e");
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void _clearForm() {
    nameCtrl.clear();
    descCtrl.clear();
    priceCtrl.clear();
    imageFile = null;
    selectedCategoryId = 1;
    notifyListeners();
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    descCtrl.dispose();
    priceCtrl.dispose();
    super.dispose();
  }
}
