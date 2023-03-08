import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gharelu/src/core/assets/assets.gen.dart';
import 'package:gharelu/src/core/extensions/context_extension.dart';

typedef LoadingErrorWidgetBuilder = Widget Function(
  BuildContext context,
  String url,
  dynamic error,
);

class CacheImageViewer extends StatelessWidget {
  const CacheImageViewer({Key? key, this.imageUrl, this.height, this.width, this.fit, this.error}) : super(key: key);
  final String? imageUrl;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final LoadingErrorWidgetBuilder? error;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl ?? '',
      progressIndicatorBuilder: (_, url, downloadProgress) {
        return url.isEmpty ? Image.asset(Assets.images.logo.path, fit: BoxFit.cover) : context.loader;
      },
      errorWidget: error ?? (context, url, error) => const Icon(Icons.error_outline),
      fit: fit ?? BoxFit.cover,
      height: height,
      width: width,
    );
  }
}
