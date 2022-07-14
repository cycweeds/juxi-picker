#import <React/RCTViewManager.h>

@interface RCT_EXTERN_MODULE(PickerViewManager, RCTViewManager)


RCT_EXPORT_VIEW_PROPERTY(data, NSArray)

RCT_EXPORT_VIEW_PROPERTY(numColumns, int)


RCT_EXPORT_VIEW_PROPERTY(textColor, NSArray)

RCT_EXPORT_VIEW_PROPERTY(textFontSize, NSNumber)

RCT_EXPORT_VIEW_PROPERTY(textFontWeight, NSString)

RCT_EXPORT_VIEW_PROPERTY(textFontFamily, NSString)


RCT_EXPORT_VIEW_PROPERTY(textSelectColor, NSArray)

RCT_EXPORT_VIEW_PROPERTY(textSelectFontSize, NSNumber)

RCT_EXPORT_VIEW_PROPERTY(textSelectFontWeight, NSString)

RCT_EXPORT_VIEW_PROPERTY(textSelectFontFamily, NSString)


RCT_EXPORT_VIEW_PROPERTY(onSelectCallback, RCTBubblingEventBlock)

@end
