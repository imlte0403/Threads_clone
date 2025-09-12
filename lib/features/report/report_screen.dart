import 'package:flutter/material.dart';
import '../../constants/gaps.dart';
import '../../widgets/post_modalBottomSheet.dart';

class ReportOption {
  final String id;
  final String title;
  final bool hasSubOptions;

  ReportOption({
    required this.id,
    required this.title,
    required this.hasSubOptions,
  });
}

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {

  final List<ReportOption> reportOptions = [
    ReportOption(
      id: 'dont_like',
      title: "I just don't like it",
      hasSubOptions: false,
    ),
    ReportOption(
      id: 'unlawful',
      title: "It's unlawful content under NetzDG",
      hasSubOptions: true,
    ),
    ReportOption(id: 'spam', title: "It's spam", hasSubOptions: false),
    ReportOption(
      id: 'hate_speech',
      title: "Hate speech or symbols",
      hasSubOptions: false,
    ),
    ReportOption(
      id: 'nudity',
      title: "Nudity or sexual activity",
      hasSubOptions: false,
    ),
    ReportOption(
      id: 'false_info',
      title: "False information",
      hasSubOptions: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);

              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.white,
                builder: (context) => const PostModalBottomSheet(),
              );
            },
          ),
          title: const Text(
            'Report',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: Container(color: Colors.grey[300], height: 1.0),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 제목
                    const Text(
                      'Why are you reporting this thread?',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    Gaps.v8,
                    // 설명
                    Text(
                      'Your report is anonymous, except if you\'re reporting an intellectual property infringement. If someone is in immediate danger, call the local emergency services - don\'t wait.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        height: 1.4,
                      ),
                    ),
                    Gaps.v24,
                    // 신고 옵션들
                    ...reportOptions.map(
                      (option) => _buildReportOption(option),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportOption(ReportOption option) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!, width: 1.0),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 6.0),
        title: Text(
          option.title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        ),
        trailing: option.hasSubOptions
            ? const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey)
            : null,
        onTap: () {
          // TODO: 신고 기능 구현?
        },
      ),
    );
  }
}
