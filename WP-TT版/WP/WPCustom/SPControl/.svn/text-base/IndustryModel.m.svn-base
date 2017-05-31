//
//  IndustryModel.m
//  WP
//
//  Created by apple on 15/9/1.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "IndustryModel.h"

@implementation IndustryModel
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.fathername forKey:@"choisefathername"];
    [aCoder encodeObject:self.fatherID forKey:@"choisefatherid"];
    [aCoder encodeObject:self.industryID forKey:@"choiseindustryid"];
    [aCoder encodeObject:self.industryName forKey:@"choiseindustryname"];
    [aCoder encodeObject:self.fullname forKey:@"fullname"];
}
-(id)initWithCoder:(NSCoder*)aDecoder
{
    if (self = [super init]) {
        self.fathername = [aDecoder decodeObjectForKey:@"choisefathername"];
        self.fatherID = [aDecoder decodeObjectForKey:@"choisefatherid"];
        self.industryID = [aDecoder decodeObjectForKey:@"choiseindustryid"];
        self.industryName = [aDecoder decodeObjectForKey:@"choiseindustryname"];
        self.fullname = [aDecoder decodeObjectForKey:@"fullname"];
    }
    return self;
}
@end
