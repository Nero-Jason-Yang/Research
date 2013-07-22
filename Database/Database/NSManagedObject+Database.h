#import <CoreData/CoreData.h>

@interface NSManagedObject (Database)

- (void)save;
- (id)save:(NSError **)error;

// attributes
- (id)attributeValueForKey:(NSString *)key;
- (void)setAttributeValue:(id)value forKey:(NSString *)key;
- (NSDictionary *)attributes;
- (void)setAttributes:(NSDictionary *)attributes;
- (void)clearAttributesExceptKeys:(NSSet *)keys;

// relationships
- (NSString *)relationshipEntityNameForKey:(NSString *)key;
- (id)relationshipValueForKey:(NSString *)key;
- (void)setRelationshipValue:(id)value forKey:(NSString *)key;
- (NSDictionary *)relationships;
- (void)setRelationships:(NSDictionary *)relationships;
- (void)clearRelationshipsExceptKeys:(NSSet *)keys;

// properties
- (id)propertyValueForKey:(NSString *)key;
- (void)setPropertyValue:(id)value forKey:(NSString *)key;
- (NSDictionary *)properties;
- (void)setProperties:(NSDictionary *)properties;
- (void)clearPropertiesExceptKeys:(NSSet *)keys;

@end
