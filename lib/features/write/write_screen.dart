import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../constants/sizes.dart';
import '../../constants/gaps.dart';
import '../../constants/app_colors.dart';
import '../../constants/text_style.dart';
import '../../widgets/media_picker.dart';
import 'write_view_model.dart';

class WriteScreen extends ConsumerStatefulWidget {
  const WriteScreen({super.key});

  @override
  ConsumerState<WriteScreen> createState() => _WriteScreenState();
}

class _WriteScreenState extends ConsumerState<WriteScreen> {
  late TextEditingController _textController;
  
  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _textController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _textController.removeListener(_onTextChanged);
    _textController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    ref.read(writeViewModelProvider.notifier).updateText(_textController.text);
  }

  // ==================== Media Handling ====================

  Future<void> _pickMedia() async {
    // 웹에서는 미디어 첨부 비활성화 (임시)
    if (kIsWeb) {
      _showErrorDialog('웹에서는 현재 이미지 첨부 기능을 지원하지 않습니다.\n텍스트만 게시할 수 있습니다.');
      return;
    }
    
    try {
      final result = await MediaPicker.show(context);
      if (result == null) return;

      final List<File> files = [];
      
      if (result['isMultiple'] == true) {
        files.addAll(result['files'] as List<File>);
      } else {
        files.add(result['file'] as File);
      }

      if (files.isNotEmpty) {
        // 파일 유효성 검사
        final viewModel = ref.read(writeViewModelProvider.notifier);
        final errors = viewModel.validateFiles(files);
        
        if (errors.isNotEmpty) {
          _showErrorDialog(errors.join('\n'));
          return;
        }

        viewModel.addMediaFiles(files);
      }
    } catch (e) {
      _showErrorDialog('미디어 선택 중 오류가 발생했습니다: $e');
    }
  }

  void _removeMedia(int index) {
    ref.read(writeViewModelProvider.notifier).removeMediaFile(index);
  }

  // ==================== Post Creation ====================

  Future<void> _createPost() async {
    final viewModel = ref.read(writeViewModelProvider.notifier);
    await viewModel.createPostWithProgress();
  }

  // ==================== UI Helpers ====================

  void _showErrorDialog(String message) {
    if (!mounted) return;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('오류'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  void _showSuccessSnackBar() {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('게시글이 성공적으로 작성되었습니다!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _clearForm() {
    _textController.clear();
    ref.read(writeViewModelProvider.notifier).reset();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(writeViewModelProvider);
    
    // 성공 처리
    ref.listen(writeViewModelProvider, (previous, current) {
      if (current.isSuccess && !(previous?.isSuccess ?? false)) {
        _showSuccessSnackBar();
        _clearForm();
        Navigator.of(context).pop();
      }
      
      if (current.errorMessage != null && current.errorMessage != previous?.errorMessage) {
        _showErrorDialog(current.errorMessage!);
      }
    });

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(Sizes.size20)),
      child: Scaffold(
        backgroundColor: AppColors.systemBackground(context),
        appBar: _buildAppBar(state),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(Sizes.size16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildUserInfo(),
                    Gaps.v16,
                    _buildTextField(state),
                    if (state.hasMedia) ...[
                      Gaps.v16,
                      _buildMediaGallery(state),
                    ],
                    if (state.isUploadingMedia) ...[
                      Gaps.v16,
                      _buildUploadProgress(state),
                    ],
                    Gaps.v16,
                    _buildMediaButton(state),
                  ],
                ),
              ),
            ),
            _buildBottomBar(state),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(WriteState state) {
    return AppBar(
      backgroundColor: AppColors.systemBackground(context),
      elevation: 0,
      leadingWidth: Sizes.size80,
      leading: TextButton(
        onPressed: state.isBusy ? null : () => Navigator.of(context).pop(),
        child: Text(
          'Cancel',
          style: TextStyle(
            color: state.isBusy
                ? AppColors.tertiaryLabel(context)
                : AppColors.label(context),
            fontSize: Sizes.size16,
          ),
        ),
      ),
      title: Text(
        'New Thread',
        style: TextStyle(
          fontSize: Sizes.size16,
          fontWeight: FontWeight.w600,
          color: AppColors.label(context),
        ),
      ),
      centerTitle: true,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(
          height: 1.0,
          color: AppColors.separator(context),
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return Row(
      children: [
        // Anonymous 아바타
        Container(
          width: Sizes.size36,
          height: Sizes.size36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.secondarySystemBackground(context),
          ),
          child: Icon(
            Icons.person,
            color: AppColors.label(context),
            size: Sizes.size20,
          ),
        ),
        Gaps.h12,
        Text(
          'anonymous',
          style: AppTextStyles.username(context),
        ),
      ],
    );
  }

  Widget _buildTextField(WriteState state) {
    return TextField(
      controller: _textController,
      maxLines: null,
      enabled: !state.isBusy,
      decoration: InputDecoration(
        hintText: 'What\'s on your mind?',
        hintStyle: TextStyle(
          color: AppColors.tertiaryLabel(context),
          fontSize: Sizes.size16,
        ),
        border: InputBorder.none,
        contentPadding: EdgeInsets.zero,
      ),
      style: TextStyle(
        fontSize: Sizes.size16,
        color: AppColors.label(context),
        height: 1.4,
      ),
      textInputAction: TextInputAction.newline,
    );
  }

  Widget _buildMediaGallery(WriteState state) {
    return SizedBox(
      height: Sizes.size120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: state.mediaFiles.length,
        itemBuilder: (context, index) {
          final file = state.mediaFiles[index];
          return Container(
            width: Sizes.size120,
            height: Sizes.size120,
            margin: EdgeInsets.only(
              right: index < state.mediaFiles.length - 1 ? Sizes.size8 : 0,
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(Sizes.size12),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.separator(context),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(Sizes.size12),
                    ),
                    child: Image.file(
                      file,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppColors.secondarySystemBackground(context),
                          child: Icon(
                            Icons.broken_image_outlined,
                            color: AppColors.tertiaryLabel(context),
                            size: Sizes.size32,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // 삭제 버튼
                if (!state.isBusy)
                  Positioned(
                    top: Sizes.size4,
                    right: Sizes.size4,
                    child: GestureDetector(
                      onTap: () => _removeMedia(index),
                      child: Container(
                        width: Sizes.size24,
                        height: Sizes.size24,
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: Sizes.size16,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildUploadProgress(WriteState state) {
    return Container(
      padding: const EdgeInsets.all(Sizes.size16),
      decoration: BoxDecoration(
        color: AppColors.secondarySystemBackground(context),
        borderRadius: BorderRadius.circular(Sizes.size12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: Sizes.size16,
                height: Sizes.size16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  value: state.uploadProgress,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.accent(context),
                  ),
                ),
              ),
              Gaps.h8,
              Text(
                '이미지 업로드 중...',
                style: TextStyle(
                  fontSize: Sizes.size14,
                  color: AppColors.label(context),
                ),
              ),
            ],
          ),
          Gaps.v8,
          LinearProgressIndicator(
            value: state.uploadProgress,
            backgroundColor: AppColors.separator(context),
            valueColor: AlwaysStoppedAnimation<Color>(
              AppColors.accent(context),
            ),
          ),
          Gaps.v4,
          Text(
            '${(state.uploadProgress * 100).toInt()}%',
            style: TextStyle(
              fontSize: Sizes.size12,
              color: AppColors.tertiaryLabel(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaButton(WriteState state) {
    return InkWell(
      onTap: state.isBusy ? null : _pickMedia,
      borderRadius: BorderRadius.circular(Sizes.size8),
      child: Padding(
        padding: const EdgeInsets.all(Sizes.size8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Transform.rotate(
              angle: 0.75,
              child: Icon(
                Icons.attach_file,
                color: state.isBusy
                    ? AppColors.tertiaryLabel(context)
                    : (state.hasMedia
                        ? AppColors.accent(context)
                        : AppColors.secondaryLabel(context)),
                size: Sizes.size20,
              ),
            ),
            if (state.hasMedia) ...[
              Gaps.h8,
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: Sizes.size8,
                  vertical: Sizes.size4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.accent(context).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(Sizes.size12),
                ),
                child: Text(
                  '${state.mediaFiles.length}개 첨부됨',
                  style: TextStyle(
                    color: AppColors.accent(context),
                    fontSize: Sizes.size12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(WriteState state) {
    return Container(
      padding: const EdgeInsets.all(Sizes.size16),
      decoration: BoxDecoration(
        color: AppColors.systemBackground(context),
        border: Border(
          top: BorderSide(
            color: AppColors.separator(context),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Anyone can reply',
            style: TextStyle(
              color: AppColors.tertiaryLabel(context),
              fontSize: Sizes.size14,
            ),
          ),
          _buildPostButton(state),
        ],
      ),
    );
  }

  Widget _buildPostButton(WriteState state) {
    if (state.isLoading) {
      return SizedBox(
        width: Sizes.size20,
        height: Sizes.size20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            AppColors.accent(context),
          ),
        ),
      );
    }

    return TextButton(
      onPressed: state.canPost ? _createPost : null,
      child: Text(
        'Post',
        style: TextStyle(
          color: state.canPost
              ? AppColors.accent(context)
              : AppColors.tertiaryLabel(context),
          fontSize: Sizes.size16,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}