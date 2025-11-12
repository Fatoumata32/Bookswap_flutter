// Screen for creating or editing a book listing

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../models/book_model.dart';
import '../providers/auth_provider.dart';
import '../providers/listings_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class PostBookScreen extends ConsumerStatefulWidget {
  final Book? book; // For editing existing book

  const PostBookScreen({super.key, this.book});

  @override
  ConsumerState<PostBookScreen> createState() => _PostBookScreenState();
}

class _PostBookScreenState extends ConsumerState<PostBookScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _swapForController = TextEditingController();
  
  String _selectedCondition = 'Used';
  File? _imageFile;
  bool _isLoading = false;

  final List<String> _conditions = ['New', 'Like New', 'Good', 'Used'];

  @override
  void initState() {
    super.initState();
    if (widget.book != null) {
      _titleController.text = widget.book!.title;
      _authorController.text = widget.book!.author;
      _swapForController.text = widget.book!.swapFor;
      _selectedCondition = widget.book!.condition;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _swapForController.dispose();
    super.dispose();
  }

  Future<void> _showImageSourceDialog() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF242B47),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Choose Image Source',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Camera option
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.camera);
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFDB839),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            size: 40,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Camera',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Gallery option
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.gallery);
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFDB839),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Icon(
                            Icons.photo_library,
                            size: 40,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Gallery',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: source,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitBook() async {
    if (!_formKey.currentState!.validate()) return;

    final user = ref.read(currentUserProvider);
    if (user == null) return;

    setState(() => _isLoading = true);

    try {
      final firestoreService = ref.read(firestoreServiceProvider);
      final storageService = ref.read(storageServiceProvider);

      // Use placeholder image if none selected
      String imageUrl = widget.book?.imageUrl ?? 'https://via.placeholder.com/400x600.png?text=Book+Cover';

      // Upload new image if selected
      if (_imageFile != null) {
        // Delete old image if updating (but not placeholder)
        if (widget.book != null &&
            widget.book!.imageUrl.isNotEmpty &&
            !widget.book!.imageUrl.contains('placeholder')) {
          try {
            await storageService.deleteImage(widget.book!.imageUrl);
          } catch (e) {
            // Ignore deletion errors
          }
        }
        imageUrl = await storageService.uploadBookImage(_imageFile!, user.uid);
      }

      // Get user name
      final userName = user.displayName ?? user.email?.split('@')[0] ?? 'Anonymous';

      if (widget.book == null) {
        // Create new book
        final newBook = Book(
          id: '',
          title: _titleController.text.trim(),
          author: _authorController.text.trim(),
          condition: _selectedCondition,
          swapFor: _swapForController.text.trim(),
          imageUrl: imageUrl,
          ownerId: user.uid,
          ownerName: userName,
          createdAt: DateTime.now(),
        );

        await firestoreService.createBook(newBook);
      } else {
        // Update existing book
        await firestoreService.updateBook(widget.book!.id, {
          'title': _titleController.text.trim(),
          'author': _authorController.text.trim(),
          'condition': _selectedCondition,
          'swapFor': _swapForController.text.trim(),
          'imageUrl': imageUrl,
        });
      }

      if (mounted) {
        // Invalidate providers to refresh the lists
        ref.invalidate(userListingsProvider);
        ref.invalidate(allListingsProvider);
        if (widget.book != null) {
          ref.invalidate(bookProvider(widget.book!.id));
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.book == null
                  ? 'Book posted successfully!'
                  : 'Book updated successfully!',
            ),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book == null ? 'Post a Book' : 'Edit Book'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image picker
              GestureDetector(
                onTap: _showImageSourceDialog,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: const Color(0xFF242B47),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[700]!),
                  ),
                  child: _imageFile != null
                      ? Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                _imageFile!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFDB839),
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.black,
                                    size: 20,
                                  ),
                                  onPressed: _showImageSourceDialog,
                                ),
                              ),
                            ),
                          ],
                        )
                      : widget.book?.imageUrl != null
                          ? Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    widget.book!.imageUrl,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFDB839),
                                      shape: BoxShape.circle,
                                    ),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.black,
                                        size: 20,
                                      ),
                                      onPressed: _showImageSourceDialog,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.menu_book,
                                  size: 60,
                                  color: const Color(0xFFFDB839),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.camera_alt,
                                      size: 20,
                                      color: Colors.grey[500],
                                    ),
                                    const SizedBox(width: 8),
                                    Icon(
                                      Icons.photo_library,
                                      size: 20,
                                      color: Colors.grey[500],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Tap to add book cover',
                                  style: TextStyle(
                                    color: Colors.grey[300],
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Camera or Gallery',
                                  style: TextStyle(
                                    color: const Color(0xFFFDB839),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                ),
              ),
              const SizedBox(height: 24),

              // Book title
              const Text(
                'Book Title',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              CustomTextField(
                controller: _titleController,
                hintText: 'Enter book title',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter book title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Author
              const Text(
                'Author',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              CustomTextField(
                controller: _authorController,
                hintText: 'Enter author name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter author name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Swap For
              const Text(
                'Swap For',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              CustomTextField(
                controller: _swapForController,
                hintText: 'What book are you looking for?',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter what you want to swap for';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Condition
              const Text(
                'Condition',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: _conditions.map((condition) {
                  final isSelected = _selectedCondition == condition;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () {
                          setState(() => _selectedCondition = condition);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFFFDB839)
                                : const Color(0xFF242B47),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFFFDB839)
                                  : Colors.grey[700]!,
                            ),
                          ),
                          child: Text(
                            condition,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isSelected ? Colors.black : Colors.white,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),

              // Submit button
              CustomButton(
                text: widget.book == null ? 'Post' : 'Update',
                onPressed: _submitBook,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}