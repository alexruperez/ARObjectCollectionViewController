//
//  ARObjectCollectionExampleViewController.m
//  ARObjectCollectionViewControllerExample
//
//  Created by Alejandro Rupérez on 03/02/14.
//  Copyright (c) 2014 alexruperez. All rights reserved.
//

#import "ARObjectCollectionExampleViewController.h"
#import "ARObjectCollectionViewController.h"

@interface ARObjectCollectionExampleViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ARObjectCollectionExampleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"ARObjectCollectionViewController"];
    [self.textField becomeFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField.text isKindOfClass:[NSString class]] && [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:textField.text]])
    {
        ARObjectCollectionViewController *objectCollectionViewController = [[ARObjectCollectionViewController alloc] initWithObjectCollection:[NSURL URLWithString:textField.text]];
        [self.navigationController pushViewController:objectCollectionViewController animated:YES];
        return YES;
    }
    return NO;
}

@end
