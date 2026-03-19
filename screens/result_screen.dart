import 'package:flutter/material.dart';
import 'dart:typed_data';

class ResultScreen extends StatelessWidget {
  final Uint8List? imageBytes;
  final Map<String, dynamic> planData;

  const ResultScreen({
    super.key,
    required this.imageBytes,
    required this.planData,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generated Event Plan'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- 1. 海报显示区域 ---
            if (imageBytes != null && imageBytes!.isNotEmpty)
              Image.memory(
                imageBytes!,
                fit: BoxFit.contain,
                // 防止图片太大撑破布局
                width: MediaQuery.of(context).size.width,
              )
            else
              Container(
                height: 300,
                color: Colors.grey[200],
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.broken_image, size: 60, color: Colors.grey[400]),
                    const SizedBox(height: 12),
                    const Text(
                      'Failed to generate poster',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ],
                ),
              ),

            // --- 2. 详细计划显示区域 ---
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.description, color: Colors.blue),
                      SizedBox(width: 8),
                      Text(
                        'AI Planning Details',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 30, thickness: 1.5),
                  
                  // 动态遍历显示 planData 中的所有内容
                  if (planData.isEmpty)
                    const Text("No detailed plan data received.")
                  else
                    ...planData.entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry.key.toUpperCase(), // 标题
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.blueGrey[700],
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${entry.value}', // 内容
                              style: const TextStyle(
                                fontSize: 16,
                                height: 1.5,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  
                  const SizedBox(height: 30),
                  
                  // 返回按钮
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                      label: const Text("Edit Plan Details"),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
