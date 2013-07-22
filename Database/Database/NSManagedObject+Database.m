#import "NSManagedObject+Database.h"

@implementation NSManagedObject (Database)

- (void)save
{
    NSError *error = nil;
    if (![self.managedObjectContext save:&error])  {
        NSLog(@"Unresolved error %@, %@, at file:%s(%d)", error, [error userInfo], __FILE__, __LINE__);
        abort();
    }
}

- (id)save:(NSError **)error
{
    if ([self.managedObjectContext save:error]) {
        return self;
    }
    return nil;
}

#pragma mark - values

- (id)valueForKey:(NSString *)key withDescriptions:(NSDictionary *)descriptions
{
    if ([descriptions objectForKey:key]) {
        return [self valueForKey:key];
    }
    return nil;
}

- (void)setValue:(id)value forKey:(NSString *)key withDescriptions:(NSDictionary *)descriptions
{
    if ([descriptions objectForKey:key]) {
        [self setValue:value forKey:key];
    }
}

- (NSDictionary *)valuesForKeysWithDescriptions:(NSDictionary *)descriptions
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (id key in descriptions.allKeys) {
        id value = [self valueForKey:key];
        if (value) {
            [dic setObject:value forKey:key];
        }
    }
    return dic;
}

- (void)setValuesForKeys:(NSDictionary *)keyedValues withDescriptions:(NSDictionary *)descriptions
{
    [keyedValues enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([descriptions objectForKey:key]) {
            [self setValue:obj forKey:key];
        }
    }];
}

- (void)clearValuesExceptKeys:(NSSet *)keys withDescriptions:(NSDictionary *)descriptions
{
    for (id key in descriptions.allKeys) {
        if (![keys containsObject:key]) {
            [self setValue:nil forKey:key];
        }
    }
}

#pragma mark attributes

- (id)attributeValueForKey:(NSString *)key
{
    return [self valueForKey:key withDescriptions:self.entity.attributesByName];
}

- (void)setAttributeValue:(id)value forKey:(NSString *)key
{
    [self setValue:value forKey:key withDescriptions:self.entity.attributesByName];
}

- (NSDictionary *)attributes
{
    return [self valuesForKeysWithDescriptions:self.entity.attributesByName];
}

- (void)setAttributes:(NSDictionary *)attributes
{
    [self setValuesForKeys:attributes withDescriptions:self.entity.attributesByName];
}

- (void)clearAttributesExceptKeys:(NSSet *)keys
{
    [self clearValuesExceptKeys:keys withDescriptions:self.entity.attributesByName];
}

#pragma mark relationships

- (NSString *)relationshipEntityNameForKey:(NSString *)key
{
    NSRelationshipDescription *desc = [self.entity.relationshipsByName objectForKey:key];
    if (desc) {
        return desc.destinationEntity.name;
    }
    return nil;
}

- (id)relationshipValueForKey:(NSString *)key
{
    return [self valueForKey:key withDescriptions:self.entity.relationshipsByName];
}

- (void)setRelationshipValue:(id)value forKey:(NSString *)key
{
    [self setValue:value forKey:key withDescriptions:self.entity.relationshipsByName];
}

- (NSDictionary *)relationships
{
    return [self valuesForKeysWithDescriptions:self.entity.relationshipsByName];
}

- (void)setRelationships:(NSDictionary *)relationships
{
    [self setValuesForKeys:relationships withDescriptions:self.entity.relationshipsByName];
}

- (void)clearRelationshipsExceptKeys:(NSSet *)keys
{
    [self clearValuesExceptKeys:keys withDescriptions:self.entity.relationshipsByName];
}

#pragma mark properties

- (id)propertyValueForKey:(NSString *)key
{
    return [self valueForKey:key withDescriptions:self.entity.propertiesByName];
}

- (void)setPropertyValue:(id)value forKey:(NSString *)key
{
    [self setValue:value forKey:key withDescriptions:self.entity.propertiesByName];
}

- (NSDictionary *)properties
{
    return [self valuesForKeysWithDescriptions:self.entity.propertiesByName];
}

- (void)setProperties:(NSDictionary *)properties
{
    [self setValuesForKeys:properties withDescriptions:self.entity.propertiesByName];
}

- (void)clearPropertiesExceptKeys:(NSSet *)keys
{
    [self clearValuesExceptKeys:keys withDescriptions:self.entity.propertiesByName];
}

@end
