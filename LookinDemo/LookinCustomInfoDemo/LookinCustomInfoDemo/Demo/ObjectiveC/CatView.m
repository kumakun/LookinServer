//
//  CatView.m
//  LookinDemoOC
//
//  Created by likai.123 on 2023/10/16.
//

#import "CatView.h"
#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    CatViewGenderMale,
    CatViewGenderFemale
} CatViewGender;

@interface CatView ()

@property(nonatomic, copy) NSString *name;
@property(nonatomic, assign) double age;
@property(nonatomic, assign) BOOL isFriendly;
@property(nonatomic, strong) UIColor *skinColor;
@property(nonatomic, assign) CatViewGender gender;

@end

@implementation CatView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.name = @"British shorthairs";
        self.age = 6.4;
        self.isFriendly = NO;
        self.skinColor = [UIColor redColor];
        self.gender = CatViewGenderMale;
    }
    return self;
}

- (NSDictionary<NSString *, id> *)lookin_customDebugInfos {
    NSDictionary<NSString *, id> *ret = @{
        @"properties": [self catView_makeCustomProperties],
        @"subviews": [self catView_makeCustomSubviews]
    };
    return ret;
}

- (NSArray *)catView_makeCustomProperties {
    NSMutableArray *properties = [NSMutableArray array];
    
    __weak __typeof__(self) weakSelf = self;
    // string property
    NSMutableDictionary *stringProperty = @{
        @"section": @"CatInfo",
        @"title": @"Nickname",
        @"valueType": @"string",
        @"retainedSetter": ^(NSString *newString) {
            weakSelf.name = newString;
        }
    }.mutableCopy;
    if (self.name) {
        stringProperty[@"value"] = self.name;
    }
    [properties addObject:stringProperty];
    
    // number property
    [properties addObject:@{
        @"section": @"CatInfo",
        @"title": @"Age",
        @"value": @(self.age),
        @"valueType": @"number",
        @"retainedSetter": ^(NSNumber *newNumber) {
            weakSelf.age = [newNumber doubleValue];
        }
    }];
    
    // bool property
    [properties addObject:@{
        @"section": @"Animal Info",
        @"title": @"IsFriendly",
        @"value": @(self.isFriendly),
        @"valueType": @"bool",
        @"retainedSetter": ^(BOOL newBool) {
            weakSelf.isFriendly = newBool;
        }
    }];
    
    // color property
    NSMutableDictionary *colorProperty = @{
        @"section": @"Animal Info",
        @"title": @"SkinColor",
        @"valueType": @"color",
        @"retainedSetter": ^(UIColor *newColor) {
            weakSelf.skinColor = newColor;
        }
    }.mutableCopy;
    if (self.skinColor) {
        // 向 Dictionary 里插入 nil 会导致 Crash
        colorProperty[@"value"] = self.skinColor;
    }
    [properties addObject:colorProperty];
    
    // enum property
    [properties addObject:@{
        @"section": @"Animal Info",
        @"title": @"Gender",
        @"value": [self stringFromGender:self.gender],
        @"valueType": @"enum",
        // Set object for this key when the valueType is "enum".
        @"allEnumCases": @[@"Male", @"Female"],
        @"retainedSetter": ^(NSString *newValue) {
            weakSelf.gender = [self genderFromString:newValue];
        }
    }];
    
    return [properties copy];;
}

- (NSArray *)catView_makeCustomSubviews {
    NSMutableArray *subviews = [NSMutableArray array];
    
    [subviews addObject:@{
        @"title": @"CatBaby0",
        // Optional
        // 可选
        @"subtitle": @"Nice Baby",
        // Optional. If you set object for this key, there will be a wireframe in Lookin middle area. The rect is in UIWindow coordinate (not superview coordinate).
        // 可选。如果包含该 key，则 Lookin 中间会为该 subview 展示一个线框。这里的 Rect 是相对于当前 Window 的（不是相对于父元素）
        @"frameInWindow": [NSValue valueWithCGRect:CGRectMake(100, 100, 200, 300)],
        // Optional. Your custom debug infos in the right panel of Lookin.
        // 可选。这些信息会展示在 Lookin 的右侧面板。
        @"properties": @[
            @{
                @"section": @"CatInfo",
                @"title": @"Nickname",
                @"value": @"Tom",
                @"valueType": @"string",
            },
            @{
                @"section": @"CatInfo",
                @"title": @"Age",
                @"value": @8,
                @"valueType": @"number",
            },
        ]
    }];

    [subviews addObject:@{
        @"title": @"CatBaby1",
        // Optional. You can add custom subviews recursively.
        // 可选。你可以递归地添加你的虚拟 subview。
        @"subviews": @[
            @{ @"title": @"CatBabyBaby" },
            @{ @"title": @"CatBabyBaby" }
        ]
    }];
    
    return [subviews copy];
}

- (NSString *)stringFromGender:(CatViewGender)gender {
    switch (gender) {
        case CatViewGenderMale:
            return @"Male";
        case CatViewGenderFemale:
            return @"Female";
    }
}

- (CatViewGender)genderFromString:(NSString *)string {
    if ([string isEqualToString:@"Male"]) {
        return CatViewGenderMale;
    } else if ([string isEqualToString:@"Female"]) {
        return CatViewGenderFemale;
    } else {
        return CatViewGenderFemale;
    }
}

@end
