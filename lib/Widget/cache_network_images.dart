import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MyCacheNetworkImages extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final double? width;
  final double radius;
  final EdgeInsetsGeometry? margin;
  final BoxBorder? border;
  final BoxFit fit;
  const MyCacheNetworkImages(
      {super.key,
        required this.imageUrl,
        this.height,
        this.width,
        required this.radius,
        this.border,
        this.margin,
        required  this.fit});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      width: width,
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => Container(
        padding: margin,
        height: height,
        width: width,
        decoration: BoxDecoration(
          border: border,
          borderRadius: BorderRadius.circular(radius),
          image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
              colorFilter: const ColorFilter.mode(
                  Colors.transparent, BlendMode.colorDodge)),
        ),
      ),
      placeholder: (context, url) => SizedBox(
          height: height,
          width: width,
          child: const Center(child: CircularProgressIndicator())
      ),

      errorWidget: (context, url, error) => Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            border: border,
            borderRadius: BorderRadius.circular(radius),

          ),
          child:  Center(child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network("https://www.caspianpolicy.org/no-image.png",
              height: height,
              width: width,

              fit: BoxFit.cover,),
          ))),
    );
  }
}
