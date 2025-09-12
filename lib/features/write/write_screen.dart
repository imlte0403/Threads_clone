import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../constants/sizes.dart';
import '../../constants/gaps.dart';
import '../../constants/app_colors.dart';
import '../../constants/text_style.dart';
import '../../constants/app_data.dart';
import '../../widgets/media_picker.dart';
import 'write_view_model.dart';

class _AvatarNetwork extends StatelessWidget {
  const _AvatarNetwork({required this.size, this.url});
  final double size;
  final String? url;

  @override
  Widget build(BuildContext context) {
    final u = url?.trim();
    if (u == null || u.isEmpty) {
      return SizedBox(
        width: size,
        height: size,
        child: ClipOval(
          child: Container(
            color: Theme.of(context).colorScheme.secondary,
            child: Icon(
              Icons.person,
              color: Theme.of(context).colorScheme.onSecondary,
              size: size * 0.6,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      width: size,
      height: size,
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: u,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: Theme.of(context).colorScheme.surface,
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: Theme.of(context).colorScheme.secondary,
            child: Icon(
              Icons.person,
              color: Theme.of(context).colorScheme.onSecondary,
              size: size * 0.6,
            ),
          ),
        ),
      ),
    );
  }
}

class WriteScreen extends ConsumerStatefulWidget {
  final String avatarUrl;

  const WriteScreen({
    super.key, 
    this.avatarUrl = '',
  });

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
        appBar: _buildAppBar(state),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(Sizes.size16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAvatar(),
                    Gaps.h16,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'jane_mobbin',
                            style: AppTextStyles.username(context),
                          ),
                          Gaps.v8,
                          _buildTextField(state),
                          if (state.hasMedia) _buildMediaGallery(state),
                          if (state.isUploadingMedia) _buildUploadProgress(state),
                          Gaps.v16,
                          _buildMediaButton(state),
                        ],
                      ),
                    ),
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
      elevation: 0,
      leadingWidth: Sizes.size80,
      leading: TextButton(
        onPressed: state.isBusy ? null : () => Navigator.of(context).pop(),
        child: Text(
          'Cancel',
          style: TextStyle(
            color: state.isBusy
                ? Theme.of(context).disabledColor
                : Theme.of(context).colorScheme.onSurface,
            fontSize: Sizes.size16,
          ),
        ),
      ),
      title: const Text(
        'New thread',
        style: TextStyle(fontSize: Sizes.size16, fontWeight: FontWeight.w600),
      ),
      centerTitle: true,
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1.0),
        child: Divider(height: 1.0),
      ),
    );
  }

  Widget _buildAvatar() {
    final avatarUrl = widget.avatarUrl.isNotEmpty ? widget.avatarUrl : profileImages.first;
    
    return _AvatarNetwork(size: Sizes.size36, url: avatarUrl);
  }

  Widget _buildTextField(WriteState state) {
    return TextField(
      controller: _textController,
      maxLines: null,
      enabled: !state.isBusy,
      decoration: InputDecoration(
        filled: false,
        hintText: 'Start a thread...',
        hintStyle: TextStyle(
          color: Theme.of(context).hintColor,
          fontSize: Sizes.size16,
        ),
        border: InputBorder.none,
      ),
      style: TextStyle(
        fontSize: Sizes.size16,
        color: AppColors.label(context),
      ),
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
    return Row(
      children: [
        InkWell(
          onTap: (state.isBusy || state.isUploadingMedia) ? null : _pickMedia,
          child: Transform.rotate(
            angle: 0.75,
            child: Icon(
              Icons.attach_file,
              color: (state.isBusy || state.isUploadingMedia)
                  ? Theme.of(context).disabledColor
                  : (state.hasMedia
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).hintColor),
              size: Sizes.size20,
            ),
          ),
        ),
        if (state.hasMedia && !state.isUploadingMedia) ...[
          Gaps.h12,
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.size8,
              vertical: Sizes.size4,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(Sizes.size12),
            ),
            child: Text(
              '${state.mediaFiles.length}개 첨부됨',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: Sizes.size12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
        if (state.isUploadingMedia) ...[
          Gaps.h8,
          SizedBox(
            width: Sizes.size16,
            height: Sizes.size16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).primaryColor,
              ),
            ),
          ),
          Gaps.h4,
          Text(
            '처리중...',
            style: TextStyle(
              color: Theme.of(context).hintColor,
              fontSize: Sizes.size12,
            ),
          ),
        ],
      ],
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
            Theme.of(context).primaryColor,
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
              ? Theme.of(context).primaryColor
              : Theme.of(context).disabledColor,
          fontSize: Sizes.size16,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}