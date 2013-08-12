//
//  CCBLocalization.m
//  Example
//
//  Created by Viktor on 8/12/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "CCBLocalizationManager.h"

@implementation CCBLocalizationManager

@synthesize translations = _translations;

+ (id)sharedManager
{
	static dispatch_once_t pred;
	static CCBLocalizationManager *loc = nil;
	dispatch_once(&pred, ^{
		loc = [[self alloc] init];
	});
	return loc;
}

- (id) init
{
    self = [super init];
    if (!self) return NULL;
    
    [self loadStringsFile:@"Strings.ccbLang"];
    
    return self;
}

- (void) loadStringsFile:(NSString*) file
{
    // Load default localization dictionary
    NSString* path = [[CCFileUtils sharedFileUtils] fullPathForFilename:file];
    
    // Load strings file
    NSDictionary* ser = [NSDictionary dictionaryWithContentsOfFile:path];
    
    // Check that format of file is correct
    NSAssert([[ser objectForKey:@"fileType"] isEqualToString:@"SpriteBuilderTranslations"], @"Invalid file format for SpriteBuilder localizations");
    
    // Check that file version is correct
    NSAssert([[ser objectForKey:@"fileVersion"] intValue] == 1, @"Translation file version is incompatible with this reader");
    
    // Load available languages
    NSArray* languages = [ser objectForKey:@"activeLanguages"];
    
    // Determine which language to use
    NSString* userLanguage = NULL;
    
    NSArray* preferredLangs = [NSLocale preferredLanguages];
    for (NSString* preferredLang in preferredLangs)
    {
        if ([languages containsObject:preferredLang])
        {
            userLanguage = preferredLang;
            break;
        }
    }
    
    // Create dictionary for translations
    if (_translations) [_translations release];
    _translations = [[NSMutableDictionary alloc] init];
    
    // Load translations
    if (userLanguage != NULL)
    {
        NSArray* translations = [ser objectForKey:@"translations"];
        
        for (NSDictionary* translation in translations)
        {
            NSString* key = [translation objectForKey:@"key"];
            NSString* value = [[translation objectForKey:@"translations"] objectForKey:userLanguage];
            
            if (key != NULL && value != NULL)
            {
                [_translations setObject:value forKey:key];
            }
        }
    }
}

- (NSString*) localizedStringForKey:(NSString*)key
{
    NSString* localizedString = [_translations objectForKey:key];
    if (!localizedString) localizedString = key;
    return localizedString;
}

- (void) dealloc
{
    [_translations release];
    [super dealloc];
}

@end
