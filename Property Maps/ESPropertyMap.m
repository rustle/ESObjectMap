//
//  ESPropertyMap.m
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

#import "ESPropertyMap.h"

@implementation ESPropertyMap
@synthesize inputKey=_inputKey;
@synthesize outputKey=_outputKey;
@synthesize transformBlock=_transformBlock;
@synthesize inverseTransformBlock=_inverseTransformBlock;

+ (id)newPropertyMapWithInputKey:(NSString *)inputKey outputKey:(NSString *)outputKey
{
	return [[[self class] alloc] initWithInputKey:inputKey outputKey:outputKey transformBlock:nil];
}

+ (id)newPropertyMapWithInputKey:(NSString *)inputKey outputKey:(NSString *)outputKey transformBlock:(ESTransformBlock)transformBlock
{
	return [[[self class] alloc] initWithInputKey:inputKey outputKey:outputKey transformBlock:transformBlock];
}

- (id)initWithInputKey:(NSString *)inputKey outputKey:(NSString *)outputKey
{
	return [self initWithInputKey:inputKey outputKey:outputKey transformBlock:nil];
}

- (id)initWithInputKey:(NSString *)inputKey outputKey:(NSString *)outputKey transformBlock:(ESTransformBlock)transformBlock
{
	self = [super init];
	if (self)
	{
		if (inputKey == nil)
			inputKey = outputKey;
		self.inputKey = inputKey;
		self.outputKey = outputKey;
		self.transformBlock = transformBlock;
	}
	return self;
}

@end
