import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posbinduptm/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:posbinduptm/core/common/widgets/loader.dart';
import 'package:posbinduptm/core/constants/constants.dart';
import 'package:posbinduptm/core/theme/app_pallete.dart';
import 'package:posbinduptm/core/utils/pick_image.dart';
import 'package:posbinduptm/core/utils/show_snackbar.dart';
import 'package:posbinduptm/features/blog/domain/entities/blog_entity.dart';
import 'package:posbinduptm/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:posbinduptm/features/blog/presentation/widgets/blog_field_editor.dart';

class UpdateBlogPage extends StatefulWidget {
  final BlogEntity blog;

  const UpdateBlogPage({super.key, required this.blog});

  @override
  State<UpdateBlogPage> createState() => _UpdateBlogPageState();
}

class _UpdateBlogPageState extends State<UpdateBlogPage> {
  late TextEditingController titleController;
  late TextEditingController contentController;
  final formKey = GlobalKey<FormState>();
  List<String> selectedTopics = [];
  File? image;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.blog.title);
    contentController = TextEditingController(text: widget.blog.content);
    selectedTopics = List.from(widget.blog.topics);
    debugPrint("📌 BLOG ID: ${widget.blog.id}");
  }

  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    }
  }

  void updateBlog() async {
    final userState = context.read<AppUserCubit>().state;

    if (userState is! AppUserLoggedIn) {
      showSnackBar(context, "Error: User tidak ditemukan.");
      return;
    }

    final posterId = userState.user.id;
    final blogId = widget.blog.id.trim();
    final title = titleController.text.trim();
    final content = contentController.text.trim();
    final posterName = widget.blog.posterName;

    debugPrint("📌 Blog ID: $blogId");
    debugPrint("📌 Poster ID: $posterId");
    debugPrint("📌 Judul: $title");
    debugPrint("📌 Isi: $content");
    debugPrint("📌 Topik: $selectedTopics");
    debugPrint(
        "📌 Gambar: ${image != null ? 'Baru dipilih' : 'Gunakan yang lama'}");

    if (formKey.currentState!.validate() && selectedTopics.isNotEmpty) {
      context.read<BlogBloc>().add(
            BlogUpdate(
              blogId: blogId,
              title: title,
              content: content,
              topics: selectedTopics,
              posterId: posterId,
              posterName: posterName,
              image: image,
            ),
          );
    } else {
      showSnackBar(context, "Error: Lengkapi semua bidang sebelum update.");
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String? newImageUrl; // Untuk menyimpan URL baru atau lama

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: updateBlog,
            icon: const Icon(Icons.done_rounded),
          ),
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            debugPrint("❌ Update gagal: ${state.error}");
            showSnackBar(context, state.error);
          } else if (state is BlogUpdateSuccess) {
            newImageUrl = state.updatedBlog.imageUrl;
            debugPrint("✅ Blog berhasil diupdate!");

            // Kirim data terbaru ke halaman sebelumnya
            Navigator.pop(
              context,
              widget.blog.copyWith(
                title: titleController.text.trim(),
                content: contentController.text.trim(),
                topics: selectedTopics,
                // imageUrl: image != null ? newImageUrl : widget.blog.imageUrl,
                imageUrl: newImageUrl,
                posterName: widget.blog.posterName,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return const Loader();
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    image != null
                        ? GestureDetector(
                            onTap: selectImage,
                            child: SizedBox(
                              height: 150,
                              width: double.infinity,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  image!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: selectImage,
                            child: SizedBox(
                              height: 150,
                              width: double.infinity,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: widget.blog.imageUrl.isNotEmpty
                                    ? Image.network(
                                        widget.blog.imageUrl,
                                        fit: BoxFit.cover,
                                      )
                                    : DottedBorder(
                                        color: AppPallete.borderColor,
                                        dashPattern: const [20, 4],
                                        radius: const Radius.circular(10),
                                        borderType: BorderType.RRect,
                                        strokeCap: StrokeCap.round,
                                        child: const SizedBox(
                                          height: 150,
                                          width: double.infinity,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.folder_open,
                                                size: 40,
                                              ),
                                              SizedBox(height: 15),
                                              Text(
                                                'Pilih gambar',
                                                style: TextStyle(fontSize: 15),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                          ),
                    const SizedBox(height: 20),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: Constant.topics
                            .map(
                              (e) => Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (selectedTopics.contains(e)) {
                                        selectedTopics.remove(e);
                                      } else {
                                        selectedTopics.add(e);
                                      }
                                    });
                                  },
                                  child: Chip(
                                    label: Text(
                                      e,
                                      style: TextStyle(
                                        color: selectedTopics.contains(e)
                                            ? Colors.white
                                            : AppPallete.borderColor,
                                      ),
                                    ),
                                    color: selectedTopics.contains(e)
                                        ? const WidgetStatePropertyAll(
                                            AppPallete.gradientGreen2)
                                        : null,
                                    side: selectedTopics.contains(e)
                                        ? null
                                        : const BorderSide(
                                            color: AppPallete.borderColor,
                                          ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    BlogFieldEditor(
                      controller: titleController,
                      hintText: 'Judul Blog',
                    ),
                    const SizedBox(height: 10),
                    BlogFieldEditor(
                      controller: contentController,
                      hintText: 'Isi Blog',
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
