import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AppNetworkImage extends StatelessWidget {
  // Private constructor for use by factory constructors
  const AppNetworkImage._({
    super.key,
    required this.imageUrl,
    this.height,
    this.width,
    required this.fit,
    this.useCachedImage = true,
    this.placeholder,
    this.errorWidget,
    this.borderRadius,
    this.shimmerColor,
    this.fadeInDuration,
  });

  // Main factory constructor that decides which implementation to use
  factory AppNetworkImage({
    Key? key,
    required String imageUrl,
    double? height,
    double? width,
    BoxFit fit = BoxFit.cover,
    bool useCachedImage = true,
    Widget? placeholder,
    Widget? errorWidget,
    BorderRadius? borderRadius,
    Color? shimmerColor,
    Duration? fadeInDuration,
  }) {
    return AppNetworkImage._(
      key: key,
      imageUrl: imageUrl,
      height: height,
      width: width,
      fit: fit,
      useCachedImage: useCachedImage,
      placeholder: placeholder,
      errorWidget: errorWidget,
      borderRadius: borderRadius,
      shimmerColor: shimmerColor,
      fadeInDuration: fadeInDuration,
    );
  }

  // Factory constructor for cached images
  factory AppNetworkImage.cached({
    Key? key,
    required String imageUrl,
    double? height,
    double? width,
    BoxFit fit = BoxFit.cover,
    Widget? placeholder,
    Widget? errorWidget,
    BorderRadius? borderRadius,
    Color shimmerColor = const Color(0xFFE0E0E0),
    Duration fadeInDuration = const Duration(milliseconds: 300),
  }) {
    return AppNetworkImage._(
      key: key,
      imageUrl: imageUrl,
      height: height,
      width: width,
      fit: fit,
      useCachedImage: true,
      placeholder: placeholder,
      errorWidget: errorWidget,
      borderRadius: borderRadius,
      shimmerColor: shimmerColor,
      fadeInDuration: fadeInDuration,
    );
  }

  // Factory constructor for standard network images (not cached)
  factory AppNetworkImage.standard({
    Key? key,
    required String imageUrl,
    required double height,
    required double width,
    BoxFit fit = BoxFit.cover,
    Widget? placeholder,
    Widget? errorWidget,
    BorderRadius? borderRadius,
  }) {
    return AppNetworkImage._(
      key: key,
      imageUrl: imageUrl,
      height: height,
      width: width,
      fit: fit,
      useCachedImage: false,
      placeholder: placeholder,
      errorWidget: errorWidget,
      borderRadius: borderRadius,
    );
  }

  // Factory constructor for profile avatars
  factory AppNetworkImage.avatar({
    Key? key,
    required String imageUrl,
    double size = 40,
    BorderRadius? borderRadius,
    Widget? errorWidget,
  }) {
    return AppNetworkImage._(
      key: key,
      imageUrl: imageUrl,
      height: size,
      width: size,
      fit: BoxFit.cover,
      useCachedImage: true,
      borderRadius: borderRadius ?? BorderRadius.circular(size / 2),
      errorWidget: errorWidget,
    );
  }

  // Instance variables
  final String imageUrl;
  final double? height;
  final double? width;
  final BoxFit fit;
  final bool useCachedImage;
  final Widget? placeholder;
  final Widget? errorWidget;
  final BorderRadius? borderRadius;
  final Color? shimmerColor;
  final Duration? fadeInDuration;

  @override
  Widget build(BuildContext context) {
    // Default placeholder widget if none provided
    final defaultPlaceholder = Container(
      height: height,
      width: width,
      color:
          shimmerColor ?? Theme.of(context).colorScheme.surfaceContainerHighest,
    );

    // Default error widget if none provided
    final defaultErrorWidget = Container(
      height: height,
      width: width,
      color: Theme.of(context).colorScheme.onErrorContainer,
      child: Center(
        child: Icon(
          Icons.image_not_supported,
          color: Theme.of(context).colorScheme.errorContainer,
        ),
      ),
    );

    // The image widget (either cached or regular)
    Widget imageWidget;

    if (useCachedImage) {
      imageWidget = CachedNetworkImage(
        imageUrl: imageUrl,
        height: height,
        width: width,
        fit: fit,
        fadeInDuration: fadeInDuration ?? const Duration(milliseconds: 300),
        placeholder: (context, url) => placeholder ?? defaultPlaceholder,
        errorWidget: (context, url, error) => errorWidget ?? defaultErrorWidget,
      );
    } else {
      imageWidget = Image.network(
        imageUrl,
        height: height,
        width: width,
        fit: fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return placeholder ?? defaultPlaceholder;
        },
        errorBuilder: (context, error, stackTrace) =>
            errorWidget ?? defaultErrorWidget,
      );
    }

    // Apply border radius if specified
    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }
}
