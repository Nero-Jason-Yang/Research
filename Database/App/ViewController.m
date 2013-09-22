//
//  ViewController.m
//  Database
//
//  Created by Jason Yang on 13-7-22.
//  Copyright (c) 2013年 nero. All rights reserved.
//

#import "ViewController.h"
#import "NSDictionaryTransformerTest.h"
#import "ToManyRelationshipTest.h"
#import "TransformerRelationshipTest.h"
#import "SameAttributesForDifferentEntitiesTest.h"
#import "ReadWriteSaveConcurrentTest.h"
#import "OverrideWithDifferentReturnTypesTest.h"
#import "KeyedArchiverTest.h"
#import "FetchWithPredicateNilTest.h"
#import "CategoryWithPropertiesTest.h"
#import "AssetForURLTest.h"
#import "DerivedManagedObjectTest.h"
#import "ALAssetTransformerTest.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onNSDictionaryTransformer:(id)sender
{
    NSDictionaryTransformerTest *tester = [[NSDictionaryTransformerTest alloc] init];
    [tester test];
}

- (IBAction)onToManyRelationship:(id)sender
{
    ToManyRelationshipTest *tester = [[ToManyRelationshipTest alloc] init];
    [tester test];
}

- (IBAction)onTransformerRelationship:(id)sender
{
    TransformerRelationshipTest *tester = [[TransformerRelationshipTest alloc] init];
    [tester test];
}

- (IBAction)onSameAttributesForDifferentEntities:(id)sender
{
    SameAttributesForDifferentEntitiesTest *tester = [[SameAttributesForDifferentEntitiesTest alloc] init];
    [tester test];
}

- (IBAction)onReadWriteSaveConcurrent:(id)sender
{
    ReadWriteSaveConcurrentTest *tester = [[ReadWriteSaveConcurrentTest alloc] init];
    [tester test];
}

- (IBAction)onOverrideWithDiffernetReturnTypes:(id)sender
{
    OverrideWithDifferentReturnTypesTest *tester = [[OverrideWithDifferentReturnTypesTest alloc] init];
    [tester test];
}

- (IBAction)onKeyedArchiver:(id)sender
{
    KeyedArchiverTest *tester = [[KeyedArchiverTest alloc] init];
    [tester test];
}

- (IBAction)onFetchWithPredicateNil:(id)sender
{
    FetchWithPredicateNilTest *tester = [[FetchWithPredicateNilTest alloc] init];
    [tester test];
}

- (IBAction)onCategoryWithProperties:(id)sender
{
    CategoryWithPropertiesTest *tester = [[CategoryWithPropertiesTest alloc] init];
    [tester test];
}

- (IBAction)onAssetForURL:(id)sender
{
    AssetForURLTest *tester = [[AssetForURLTest alloc] init];
    [tester test];
}

- (IBAction)onDerivedManagedObject:(id)sender
{
    DerivedManagedObjectTest *tester = [[DerivedManagedObjectTest alloc] init];
    [tester test];
}

- (IBAction)onALAssetTransformer:(id)sender
{
    ALAssetTransformerTest *tester = [[ALAssetTransformerTest alloc] init];
    [tester test];
}
@end
