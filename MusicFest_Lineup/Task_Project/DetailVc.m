//
//  DetailVc.m
//  Task_Project
//
//  Created by Irfan Rahman on 1/30/18.
//  Copyright © 2018 Irfan Rahman. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "DetailVc.h"
#import <CoreData/CoreData.h>
@interface DetailVc ()

@end

@implementation DetailVc
- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //NSDictionary * dict = self.modal;
    NSString *imageStr = [self.modal valueForKey:@"image"];
    NSData *data = [[NSData alloc]initWithBase64EncodedString: imageStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
    UIImage *img = [[UIImage alloc] initWithData:data];
 
    self.artImagePro.image = img;
    
    self.artNameObj.text = [NSString stringWithFormat:@"Name  :  %@",[self.modal valueForKey:@"name"]];
    
    self.artDetailObj.text = [NSString stringWithFormat:@"%@",[self.modal valueForKey:@"discriptions"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
