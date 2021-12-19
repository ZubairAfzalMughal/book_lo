import 'package:book_lo/utility/color_palette.dart';
import 'package:flutter/material.dart';

loadingIndicator() => CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(ColorPlatte.primaryColor),
    );
