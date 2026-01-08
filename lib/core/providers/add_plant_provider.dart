import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../constant.dart';

class AddPlantProvider extends ChangeNotifier {
  final SupabaseClient _supabase;
  AddPlantProvider(this._supabase);

  // --- Controllers ---
  final nameCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final priceCtrl = TextEditingController();

  // --- UI State ---
  List<Map<String, dynamic>> categories = [];
  int? selectedCategoryId;
  File? imageFile;
  bool isLoading = false;
  bool isInitialLoading = true;

  final ImagePicker _picker = ImagePicker();

  // --- Setters ---
  void setCategory(int id) {
    selectedCategoryId = id;
    notifyListeners();
  }

  // --- Fetch Logic ---
  Future<void> fetchCategories() async {
    isInitialLoading = true;
    notifyListeners();
    try {
      final response = await _supabase
          .from(AppConstants.categoriesTable)
          .select('id, name')
          .order('name');

      categories = List<Map<String, dynamic>>.from(response);

      if (categories.isNotEmpty && selectedCategoryId == null) {
        selectedCategoryId = categories.first['id'];
      }
    } catch (e) {
      debugPrint("Error fetching categories: $e");
    } finally {
      isInitialLoading = false;
      notifyListeners();
    }
  }

  // --- Image Handling ---
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

  // --- Logic ---
  Future<bool> addPlant() async {
    if (imageFile == null || selectedCategoryId == null) return false;

    isLoading = true;
    notifyListeners();

    try {
      // 1. Generate unique file name and path
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final path = 'uploads/$fileName';

      // 2. Upload to Supabase Storage ('plant_images' bucket)
      debugPrint("Attempting storage upload...");
      await _supabase.storage
          .from('plant_images')
          .upload(
            path,
            imageFile!,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      // 3. Get Public URL
      final imageUrl = _supabase.storage
          .from('plant_images')
          .getPublicUrl(path);

      // 4. Insert Metadata into Database
      debugPrint("Attempting database insert into products table...");
      await _supabase.from(AppConstants.productsTable).insert({
        'name': nameCtrl.text.trim(),
        'description': descCtrl.text.trim(),
        'price': double.tryParse(priceCtrl.text) ?? 0.0,
        'category_id': selectedCategoryId,
        'image_url': imageUrl,
        'rating': 5.0, // Default rating for new product
      });

      _clearForm();
      return true;
    } on PostgrestException catch (e) {
      // ✅ Specific logging for Table RLS errors
      debugPrint("Database Error (Check products table RLS): ${e.message}");
      rethrow;
    } on StorageException catch (e) {
      // ✅ Specific logging for Storage RLS errors
      debugPrint("Storage Error (Check plant_images bucket RLS): ${e.message}");
      rethrow;
    } catch (e) {
      debugPrint("General Error adding plant: $e");
      rethrow;
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
    if (categories.isNotEmpty) {
      selectedCategoryId = categories.first['id'];
    }
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
