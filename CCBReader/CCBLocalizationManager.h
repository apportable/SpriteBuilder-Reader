//
//  CCBLocalization.h
//  Example
//
//  Created by Viktor on 8/12/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#define CCBLocalize(key) \
[[CCBLocalizationManager sharedManager] localizedStringForKey:(key)]

@interface CCBLocalizationManager : NSObject
{
    NSMutableDictionary* _translations;
}

@property (nonatomic,readonly) NSDictionary* translations;

+ (id)sharedManager;



@end
