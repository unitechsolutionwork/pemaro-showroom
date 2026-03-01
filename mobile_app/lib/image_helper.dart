// lib/image_helper.dart

String proxyImage(String url) {
  final cleanUrl = url.replaceFirst('https://', '').replaceFirst('http://', '');
  return 'https://images.weserv.nl/?url=$cleanUrl';
}
