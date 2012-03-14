//
//  ESBaseModelObject.m
//	
//  Created by Doug Russell
//  Copyright (c) 2011 Doug Russell. All rights reserved.
//  
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//  
//  http://www.apache.org/licenses/LICENSE-2.0
//  
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//  

#import "ESBaseModelObject.h"
#import "NSObject+PropertyDictionary.h"
#import "ESObjectMapFunctions.h"

@implementation ESBaseModelObject

+ (ESObjectMap *)objectMap
{
	return GetObjectMapForClass([self class]);
}

+ (id)newWithDictionary:(NSDictionary *)dictionary
{
	return [[[self class] alloc] initWithDictionary:dictionary];
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
	if (dictionary == nil)
		return nil;
	self = [self init];
	if (self)
		[self configureWithDictionary:dictionary];
	return self;
}

- (void)configureWithDictionary:(NSDictionary *)dictionary
{
	ConfigureObjectWithDictionary(self, dictionary);
}

- (NSDictionary *)dictionaryRepresentation
{
	return GetDictionaryRepresentation(self);
}

@end
