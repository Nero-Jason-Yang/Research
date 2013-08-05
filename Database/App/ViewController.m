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
#import "ReadWriteSaveConcurrentTest.h"

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

- (IBAction)onReadWriteSaveConcurrent:(id)sender
{
    ReadWriteSaveConcurrentTest *tester = [[ReadWriteSaveConcurrentTest alloc] init];
    [tester test];
}

@end
