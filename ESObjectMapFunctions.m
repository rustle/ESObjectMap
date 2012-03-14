//
//  ESObjectMapFunctions.m
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

#import "ESObjectMapFunctions.h"
#import "ESMutableDictionary.h"
#import <objc/runtime.h>
#import "NSObject+PropertyDictionary.h"

void ConfigureObjectWithDictionary(id<ESObject> object, NSDictionary *dictionary)
{
	NSDictionary *propertyDictionary = [[object class] propertyDictionary];
	ESObjectMap *objectMap = [[object class] objectMap];
	for (ESDeclaredPropertyAttributes *attributes in [propertyDictionary allValues])
	{
		@autoreleasepool {
			NSString *inputKey;
			NSString *outputKey;
			id dictionaryValue;
			id propertyValue;
			
			outputKey = attributes.name;
			if (outputKey == nil)
				continue;
			// Get the property map, if it exists
			ESPropertyMap *propertyMap = [objectMap propertyMapForOutputKey:outputKey];
			if (propertyMap == nil) // If there's no property map, then assume inputKey simply maps to outputKey
				inputKey = outputKey;
			else // If there is a property map, get the input key
				inputKey = propertyMap.inputKey;
			// Grab our value from the input dictionary
			dictionaryValue = [dictionary valueForKeyPath:inputKey];
			if (dictionaryValue == nil)
				continue;
			if (dictionaryValue == [NSNull null])
				dictionaryValue = nil;
			// At this point we have a value (or nil) to work with, so let's make sure we can actually set it
			if (attributes.readOnly)
				[NSException raise:@"Readonly Exception" format:@"Attempted to set a readonly property: %@", attributes];
			switch (attributes.storageType) {
				case IDType:
					// If there's a transform block, execute it
					if (dictionaryValue && propertyMap.transformBlock)
						propertyValue = propertyMap.transformBlock(object, dictionaryValue);
					else
						propertyValue = dictionaryValue;
					[object setValue:propertyValue forKey:outputKey];
					break;
				case ObjectType:
					// If there's a transform block, execute it
					if (dictionaryValue && propertyMap.transformBlock)
						propertyValue = propertyMap.transformBlock(object, dictionaryValue);
					else
						propertyValue = dictionaryValue;
					if (propertyValue)
					{
						Class class = NSClassFromString(attributes.classString);
						if (![propertyValue isKindOfClass:class])
							[NSException raise:@"Class Mismatch" format:@"Object: %@ is not kind of class: %@", propertyValue, NSStringFromClass(class)];
					}
					[object setValue:propertyValue forKey:outputKey];
					break;
				case IntType:
				{
					int intPropertyValue = 0;
					// If there's a transform block, execute it
					if (dictionaryValue && ((ESIntPropertyMap *)propertyMap).intTransformBlock)
						intPropertyValue = ((ESIntPropertyMap *)propertyMap).intTransformBlock(dictionaryValue);
					else if (dictionaryValue)
						intPropertyValue = [dictionaryValue intValue];
					SetPrimitivePropertyValue(object, attributes.setter, &intPropertyValue);
					break;
				}
				case DoubleType:
				{
					double doublePropertyValue = 0.0;
					// If there's a transform block, execute it
					if (dictionaryValue && ((ESDoublePropertyMap *)propertyMap).doubleTransformBlock)
						doublePropertyValue = ((ESDoublePropertyMap *)propertyMap).doubleTransformBlock(dictionaryValue);
					else if (dictionaryValue)
						doublePropertyValue = [dictionaryValue doubleValue];
					SetPrimitivePropertyValue(object, attributes.setter, &doublePropertyValue);
					break;
				}
				case FloatType:
				{
					float floatPropertyValue = 0.0f;
					// If there's a transform block, execute it
					if (dictionaryValue && ((ESFloatPropertyMap *)propertyMap).floatTransformBlock)
						floatPropertyValue = ((ESFloatPropertyMap *)propertyMap).floatTransformBlock(dictionaryValue);
					else if (dictionaryValue)
						floatPropertyValue = [dictionaryValue floatValue];
					SetPrimitivePropertyValue(object, attributes.setter, &floatPropertyValue);
					break;
				}
				case BoolType:
				{
					BOOL boolPropertyValue = NO;
					// If there's a transform block, execute it
					if (dictionaryValue && ((ESBOOLPropertyMap *)propertyMap).boolTransformBlock)
						boolPropertyValue = ((ESBOOLPropertyMap *)propertyMap).boolTransformBlock(dictionaryValue);
					else if (dictionaryValue)
						boolPropertyValue = [dictionaryValue boolValue];
					SetPrimitivePropertyValue(object, attributes.setter, &boolPropertyValue);
					break;
				}
				default:
					break;
			}
		}
	}
}

NSDictionary * GetDictionaryRepresentation(id<ESObject> object)
{
	NSMutableDictionary *dictionaryRepresentation = [NSMutableDictionary new];
	NSDictionary *propertyDictionary = [[object class] propertyDictionary];
	ESObjectMap *objectMap = [[object class] objectMap];
	for (ESDeclaredPropertyAttributes *attributes in [propertyDictionary allValues])
	{
		@autoreleasepool {
			NSString *inputKey;
			NSString *outputKey;
			id dictionaryValue;
			id propertyValue;
			
			outputKey = attributes.name;
			if (outputKey == nil)
				continue;
			// Get the property map, if it exists
			ESPropertyMap *propertyMap = [objectMap propertyMapForOutputKey:outputKey];
			if (propertyMap == nil) // If there's no property map, then assume inputKey simply maps to outputKey
				inputKey = outputKey;
			else // If there is a property map, get the input key
				inputKey = propertyMap.inputKey;
			switch (attributes.storageType) {
				case IDType:
				case ObjectType:
					propertyValue = [object valueForKey:outputKey];
					if (propertyMap.inverseTransformBlock)
						dictionaryValue = propertyMap.inverseTransformBlock(object, propertyValue);
					else
						dictionaryValue = propertyValue;
					break;
				case IntType:
				{
					int result;
					GetPrimitivePropertyValue(object, attributes.getter, &result);
					dictionaryValue = [NSNumber numberWithInt:result];
					break;
				}
				case DoubleType:
				{
					double result;
					GetPrimitivePropertyValue(object, attributes.getter, &result);
					dictionaryValue = [NSNumber numberWithDouble:result];
					break;
				}
				case FloatType:
				{
					float result;
					GetPrimitivePropertyValue(object, attributes.getter, &result);
					dictionaryValue = [NSNumber numberWithFloat:result];
					break;
				}
				case BoolType:
				{
					BOOL result;
					GetPrimitivePropertyValue(object, attributes.getter, &result);
					dictionaryValue = [NSNumber numberWithBool:result];
					break;
				}
				default:
					break;
			}
			if (dictionaryValue)
				[dictionaryRepresentation setObject:dictionaryValue forKey:inputKey];
		}
	}
	return dictionaryRepresentation;
}

static ESMutableDictionary *_objectMapCache;

ESObjectMap * GetObjectMapForClass(Class objectClass)
{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_objectMapCache = [ESMutableDictionary new];
	});
	if (objectClass == nil)
		return nil;
	ESObjectMap *objectMap = [_objectMapCache objectForKey:objectClass];
	if (objectMap != nil)
		return objectMap;
	objectMap = [ESObjectMap new];
	[_objectMapCache setObject:objectMap forKey:objectClass];
	return objectMap;
}

void GetPrimitivePropertyValue(id object, SEL getter, void * value)
{
	NSInvocation *getInvocation = [NSInvocation invocationWithMethodSignature:[object methodSignatureForSelector:getter]];
	[getInvocation setTarget:object];
	[getInvocation setSelector:getter];
	[getInvocation invoke];
	[getInvocation getReturnValue:value];
}

void SetPrimitivePropertyValue(id object, SEL setter, void * value)
{
	NSInvocation *setIntInvocation = [NSInvocation invocationWithMethodSignature:[object methodSignatureForSelector:setter]];
	[setIntInvocation setTarget:object];
	[setIntInvocation setSelector:setter];
	[setIntInvocation setArgument:value atIndex:2];
	[setIntInvocation invoke];
}