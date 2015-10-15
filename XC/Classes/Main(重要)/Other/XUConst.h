#import <Foundation/Foundation.h>

#ifdef DEBUG
#define XULog(...) NSLog(__VA_ARGS__)
#else
#define XULog(...)
#endif

#define XUColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define XUGlobalBg XUColor(230, 230, 230)

#define XUNotificationCenter [NSNotificationCenter defaultCenter]

extern NSString *const XUCityDidChangeNotification;
extern NSString *const XUSelectCityName;

extern NSString *const XUSortDidChangeNotification;
extern NSString *const XUSelectSort;

extern NSString *const XUCategoryDidChangeNotification;
extern NSString *const XUSelectCategory;
extern NSString *const XUSelectSubcategoryName;

extern NSString *const XURegionDidChangeNotification;
extern NSString *const XUSelectRegion;
extern NSString *const XUSelectSubregionName;

extern NSString *const XUCollectStateDidChangeNotification;
extern NSString *const XUIsCollectKey;
extern NSString *const XUCollectDealKey;

extern NSString *const XURecentStateDidChangeNotification;
extern NSString *const XUIsRecentKey;
extern NSString *const XURecentDealKey;