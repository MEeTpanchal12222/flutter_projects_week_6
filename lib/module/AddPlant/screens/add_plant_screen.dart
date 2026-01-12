import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/add_plant_provider.dart';
import '../../../core/services/di.dart';
import '../../../utils/Extension/responsive_ui_extension.dart';
import '../../../utils/theme/app_theme.dart';
import '../../../utils/theme/input_decoration.dart';
import '../../../utils/widgets/common_top_notification.dart';
import '../widgets/label.dart';

class AddPlantScreen extends StatefulWidget {
  const AddPlantScreen({super.key});

  @override
  State<AddPlantScreen> createState() => _AddPlantScreenState();
}

class _AddPlantScreenState extends State<AddPlantScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<AddPlantProvider>()..fetchCategories(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              context.pop();
            },
            child: Icon(Icons.arrow_back),
          ),
          title: Text("Add New Plant", style: GoogleFonts.cabin(fontWeight: FontWeight.bold)),
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        body: Consumer<AddPlantProvider>(
          builder: (context, provider, _) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(context.widthPercentage(6)),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: provider.pickImage,
                      child: Container(
                        height: context.heightPercentage(25),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey.shade300, width: 1),
                        ),
                        child: provider.imageFile != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.file(provider.imageFile!, fit: BoxFit.cover),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_a_photo_outlined,
                                    size: 40,
                                    color: Colors.grey[400],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Upload Plant Image",
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(height: 25),

                    Label(text: "Plant Name"),
                    TextFormField(
                      controller: provider.nameCtrl,
                      decoration: inputDecoration("e.g. Fiddle Leaf Fig"),
                      validator: (v) => v!.isEmpty ? "Please enter a name" : null,
                    ),
                    const SizedBox(height: 20),

                    Label(text: "Description"),
                    TextFormField(
                      controller: provider.descCtrl,
                      maxLines: 3,
                      decoration: inputDecoration("Tell us about this plant..."),
                    ),
                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Label(text: "Price (\$)"),
                              TextFormField(
                                controller: provider.priceCtrl,
                                keyboardType: TextInputType.number,
                                decoration: inputDecoration("0.00"),
                                validator: (v) => v!.isEmpty ? "Required" : null,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Label(text: "Category"),
                              DropdownButtonFormField<int>(
                                initialValue: provider.selectedCategoryId,
                                decoration: inputDecoration("Select"),
                                borderRadius: BorderRadius.circular(12),
                                barrierDismissible: true,
                                dropdownColor: AppTheme.backgroundLight,
                                focusColor: AppTheme.primary.withValues(alpha: 0.1),
                                items: context.read<AddPlantProvider>().categories.map((category) {
                                  return DropdownMenuItem<int>(
                                    value: category['id'] as int,
                                    child: Text(category['name'] as String),
                                  );
                                }).toList(),
                                onChanged: (val) => provider.setCategory(val!),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: context.heightPercentage(6)),

                    SizedBox(
                      width: double.infinity,
                      height: context.hightForButton(56),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        onPressed: provider.isLoading
                            ? null
                            : () async {
                                if (provider.imageFile == null) {
                                  showTopNotification(context, "Please select an image");

                                  return;
                                }
                                if (_formKey.currentState!.validate()) {
                                  final success = await provider.addPlant();
                                  if (success && mounted) {
                                    showTopNotification(
                                      context,
                                      "Plant added successfully!",
                                      isError: false,
                                    );

                                    Navigator.pop(context);
                                  }
                                }
                              },
                        child: provider.isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text(
                                "Submit Plant",
                                style: TextStyle(
                                  fontSize: context.responsiveTextSize(18),
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
