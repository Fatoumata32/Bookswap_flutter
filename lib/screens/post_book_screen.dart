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

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
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

    // For new book, image is required
    if (widget.book == null && _imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a book cover image'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final firestoreService = ref.read(firestoreServiceProvider);
      final storageService = ref.read(storageServiceProvider);

      String imageUrl = widget.book?.imageUrl ?? '';

      // Upload new image if selected
      if (_imageFile != null) {
        // Delete old image if updating
        if (widget.book != null && widget.book!.imageUrl.isNotEmpty) {
          await storageService.deleteImage(widget.book!.imageUrl);
        }
        imageUrl = await storageService.uploadBookImage(_imageFile!, user.uid);
      }

      // Get user profile for name
      final userProfile = await firestoreService.getUserProfile(user.uid);
      final userName = userProfile?.displayName ?? 'Unknown';

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
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: const Color(0xFF242B47),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[700]!),
                  ),
                  child: _imageFile != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            _imageFile!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : widget.book?.imageUrl != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                widget.book!.imageUrl,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_photo_alternate,
                                  size: 60,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Tap to add book cover',
                                  style: TextStyle(color: Colors.grey[400]),
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