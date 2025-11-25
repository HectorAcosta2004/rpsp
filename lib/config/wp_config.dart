import 'package:flutter/material.dart';

class WPConfig {
  /// The Name of your app
  static const String appName = 'Rpsp';

  /// The url of your app, should not inclued any '/' slash or any 'https://' or 'http://'
  /// Otherwise it may break the compaitbility, And your website must be
  /// a wordpress website.
  static const String url = 'rpsp.adventistasumn.org';

  /// Your onesignal id
  static const String oneSignalId = '85a1d19b-6490-4c8a-9a7e-b051c0d4de49';

  /// Deeplinks config
  /// If you are using something like this:
  /// https://newspro.uixxy.com/sample-post/
  /// make this true or else false
  static const bool usingPlainFormatLink = true;

  /// IF we should keep the caching of home categories tab caching or not
  /// if this is false, then we will fetch new data and refresh the
  /// list if user changes tab or click on one
  static bool enableHomeTabCache = true;
}
