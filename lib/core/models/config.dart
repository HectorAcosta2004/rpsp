// ignore_for_file: public_member_api_docs, sort_constructors_first
import '../repositories/others/post_style_local.dart';

class NewsProConfig {
  String mainTabName;
  List<int> homeTopTabCategories;
  List<int> blockedCategories;
  List<int> featuredPosts;
  bool automaticSlide;
  bool showTopLogoInHome;

  String privacyPolicyUrl;
  String termsAndServicesUrl;
  String cookieConsentText;
  bool showCookieConsent;
  String aboutPageUrl;

  String facebookUrl;
  String twitterUrl;
  String telegramUrl;
  String instagramUrl;
  String tiktokUrl;
  String youtubeUrl;
  String whatsappUrl;

  String appShareLink;
  String appstoreAppID;

  String ownerName;
  String ownerEmail;
  String ownerPhone;
  String ownerAddress;
  String appDescription;
  String reportEmail;

  bool isAdOn;
  bool isCustomAdOn;
  int interstialAdCount;
  int adIntervalinPost;
  int customAdIntervalInPost;

  bool showDateInApp;
  bool showAuthor;
  bool showTrendingPopularIcon;
  bool showComment;
  bool showViewOnWebsiteButton;
  bool showReportButton;

  bool isSocialLoginEnabled;
  bool isLoginEnabled;

  bool onboardingEnabled;
  bool multiLanguageEnabled;
  bool showAuthorsInExplorePage;
  bool showPostViews;

  PostDetailStyle postDetailStyle;
  bool hidePageStyle;

  NewsProConfig({
    required this.mainTabName,
    required this.homeTopTabCategories,
    required this.blockedCategories,
    required this.featuredPosts,
    required this.automaticSlide,
    required this.showTopLogoInHome,
    required this.privacyPolicyUrl,
    required this.termsAndServicesUrl,
    required this.cookieConsentText,
    required this.showCookieConsent,
    required this.aboutPageUrl,
    required this.facebookUrl,
    required this.twitterUrl,
    required this.telegramUrl,
    required this.instagramUrl,
    required this.tiktokUrl,
    required this.youtubeUrl,
    required this.whatsappUrl,
    required this.appShareLink,
    required this.appstoreAppID,
    required this.ownerName,
    required this.ownerEmail,
    required this.ownerPhone,
    required this.ownerAddress,
    required this.appDescription,
    required this.reportEmail,
    required this.isAdOn,
    required this.isCustomAdOn,
    required this.interstialAdCount,
    required this.adIntervalinPost,
    required this.customAdIntervalInPost,
    required this.showDateInApp,
    required this.showAuthor,
    required this.showTrendingPopularIcon,
    required this.showComment,
    required this.showViewOnWebsiteButton,
    required this.showReportButton,
    required this.isSocialLoginEnabled,
    required this.isLoginEnabled,
    required this.onboardingEnabled,
    required this.multiLanguageEnabled,
    required this.showAuthorsInExplorePage,
    required this.showPostViews,
    required this.postDetailStyle,
    required this.hidePageStyle,
  });

  factory NewsProConfig.fromMap(Map<String, dynamic> map) {
  int parseInt(dynamic value, [int defaultValue = 0]) {
    if (value == null) return defaultValue;
    return int.tryParse(value.toString()) ?? defaultValue;
  }

  List<int> parseIntList(dynamic value) {
    if (value is List) {
      return List<int>.from(value.map((e) => int.tryParse(e.toString()) ?? 0));
    }
    return [];
  }

  String parseString(dynamic value, [String defaultValue = '']) {
    if (value == null) return defaultValue;
    return value.toString();
  }

  bool parseBool(dynamic value, [bool defaultValue = false]) {
    if (value == null) return defaultValue;
    if (value is bool) return value;
    if (value is String) return value.toLowerCase() == 'true';
    if (value is int) return value != 0;
    return defaultValue;
  }

  return NewsProConfig(
    mainTabName: parseString(map['mainTabName'], 'Home'),
    homeTopTabCategories: parseIntList(map['homeTopTabCategories']),
    blockedCategories: parseIntList(map['blockedCategories']),
    featuredPosts: parseIntList(map['featuredPosts']),
    automaticSlide: parseBool(map['automaticSlide']),
    showTopLogoInHome: parseBool(map['showTopLogoInHome']),
    privacyPolicyUrl: parseString(map['privacyPolicyUrl']),
    termsAndServicesUrl: parseString(map['termsAndServicesUrl']),
    cookieConsentText: parseString(map['cookieConsentText']),
    showCookieConsent: parseBool(map['showCookieConsent']),
    aboutPageUrl: parseString(map['aboutPageUrl']),
    facebookUrl: parseString(map['facebookUrl']),
    twitterUrl: parseString(map['twitterUrl']),
    telegramUrl: parseString(map['telegramUrl']),
    instagramUrl: parseString(map['instagramUrl']),
    tiktokUrl: parseString(map['tiktokUrl']),
    youtubeUrl: parseString(map['youtubeUrl']),
    whatsappUrl: parseString(map['whatsappUrl']),
    appShareLink: parseString(map['appShareLink']),
    appstoreAppID: parseString(map['appstoreAppID']),
    ownerName: parseString(map['ownerName']),
    ownerEmail: parseString(map['ownerEmail']),
    ownerPhone: parseString(map['ownerPhone']),
    ownerAddress: parseString(map['ownerAddress']),
    appDescription: parseString(map['appDescription']),
    reportEmail: parseString(map['reportEmail']),
    isAdOn: parseBool(map['isAdOn'], false),
    isCustomAdOn: parseBool(map['isCustomAdOn']),
    interstialAdCount: parseInt(map['interstialAdCount']),
    adIntervalinPost: parseInt(map['adIntervalinPost']),
    customAdIntervalInPost: parseInt(map['customAdIntervalInPost']),
    showDateInApp: parseBool(map['showDateInApp']),
    showAuthor: parseBool(map['showAuthor']),
    showTrendingPopularIcon: parseBool(map['showTrendingPopularIcon']),
    showComment: parseBool(map['showComment']),
    showViewOnWebsiteButton: parseBool(map['showViewOnWebsiteButton']),
    showReportButton: parseBool(map['showReportButton']),
    isSocialLoginEnabled: parseBool(map['isSocialLoginEnabled']),
    isLoginEnabled: parseBool(map['isLoginEnabled']),
    onboardingEnabled: parseBool(map['onboardingEnabled']),
    multiLanguageEnabled: parseBool(map['multiLanguageEnabled']),
    showAuthorsInExplorePage: parseBool(map['showAuthorsInExplorePage']),
    showPostViews: parseBool(map['showPostViews']),
    postDetailStyle: PostDetailStyle.minimal, // valor por defecto si no lo tienes en el map
    hidePageStyle: parseBool(map['hidePageStyle']),
  );
}



  }
  

