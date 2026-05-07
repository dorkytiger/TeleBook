enum ExportFormat {
  folder('文件夹'),
  zip('ZIP 压缩包'),
  pdf('PDF');

  final String label;

  const ExportFormat(this.label);
}

