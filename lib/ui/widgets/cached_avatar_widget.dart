import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dealer_app/ui/widgets/avartar_widget.dart';
import 'package:dealer_app/utils/common_utils.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:flutter/cupertino.dart';

class CachedAvatarWidget extends StatelessWidget {
  const CachedAvatarWidget({
    required this.path,
    required this.isMale,
    this.width = 450,
    Key? key,
  }) : super(key: key);
  final String path;
  final bool isMale;
  final double width;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: NetworkUtils.getBearerToken(),
      builder: (context, snapshot) {
        if (path.isNotEmpty && snapshot.hasData) {
          return CachedNetworkImage(
            httpHeaders: {
              HttpHeaders.authorizationHeader: snapshot.data ?? Symbols.empty
            },
            imageUrl: path,
            imageBuilder: (context, imageProvider) => getAvatar(imageProvider),
            placeholder: (context, url) => getAvatar(),
            errorWidget: (context, url, error) => getAvatar(),
          );
        }
        return getAvatar();
      },
    );
  }

  Widget getAvatar([ImageProvider? imageProvider]) {
    return AvatarWidget(
      isMale: isMale,
      image: imageProvider,
      width: width,
    );
  }
}
