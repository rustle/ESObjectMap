//
//  ESObjectMap.m
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

#import "ESObjectMap.h"
#import "ESMutableDictionary.h"

@interface ESObjectMap ()
@property (strong, nonatomic, readonly) ESMutableDictionary* propertyMaps;
@end

@implementation ESObjectMap
@synthesize mapClass=_mapClass;
@synthesize propertyMaps=_propertyMaps;

+ (id)newObjectMapWithClass:(Class)class
{
	return [[[self class] alloc] initWithClass:class];
}

- (id)initWithClass:(Class)class
{
	if (class == nil)
		return nil;
	self = [self init];
	if (self)
	{
		_mapClass = class;
	}
	return self;
}

- (id)init
{
	self = [super init];
	if (self)
	{
		_propertyMaps = [ESMutableDictionary new];
	}
	return self;
}

- (ESPropertyMap *)propertyMapForOutputKey:(NSString *)outputKey
{
	return [self.propertyMaps objectForKey:outputKey];
}

- (void)addPropertyMap:(ESPropertyMap *)propertyMap
{
	if (propertyMap.outputKey == nil)
		return;
	[self.propertyMaps setObject:propertyMap forKey:propertyMap.outputKey];
}

@end
