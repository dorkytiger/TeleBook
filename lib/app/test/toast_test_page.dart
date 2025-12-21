import 'package:flutter/material.dart';
import 'package:tele_book/app/service/toast_service.dart';

/// Toast 测试页面
class ToastTestPage extends StatelessWidget {
  const ToastTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Toast 测试'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'ToastService 测试',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),

              // 文本提示
              ElevatedButton(
                onPressed: () {
                  ToastService.showText('这是一条文本提示');
                },
                child: const Text('显示文本提示'),
              ),
              const SizedBox(height: 16),

              // 加载中
              ElevatedButton(
                onPressed: () {
                  ToastService.showLoading('加载中...');
                  // 3秒后自动关闭
                  Future.delayed(const Duration(seconds: 3), () {
                    ToastService.dismiss();
                  });
                },
                child: const Text('显示加载中（3秒后关闭）'),
              ),
              const SizedBox(height: 16),

              // 成功提示
              ElevatedButton(
                onPressed: () {
                  ToastService.showSuccess('操作成功');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: const Text('显示成功提示'),
              ),
              const SizedBox(height: 16),

              // 失败提示
              ElevatedButton(
                onPressed: () {
                  ToastService.showError('操作失败');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('显示失败提示'),
              ),
              const SizedBox(height: 16),

              // 手动关闭
              ElevatedButton(
                onPressed: () {
                  ToastService.dismiss();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
                child: const Text('手动关闭 Toast'),
              ),
              const SizedBox(height: 40),

              // 模拟异步操作
              ElevatedButton.icon(
                onPressed: _simulateAsyncOperation,
                icon: const Icon(Icons.cloud_download),
                label: const Text('模拟异步操作'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _simulateAsyncOperation() async {
    ToastService.showLoading('正在处理...');

    // 模拟网络请求
    await Future.delayed(const Duration(seconds: 2));

    // 随机成功或失败
    final isSuccess = DateTime.now().second % 2 == 0;

    ToastService.dismiss(); // 先关闭 loading

    if (isSuccess) {
      ToastService.showSuccess('处理成功');
    } else {
      ToastService.showError('处理失败，请重试');
    }
  }
}

