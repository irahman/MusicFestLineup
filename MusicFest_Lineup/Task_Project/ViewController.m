//
//  ViewController.m
//  Task_Project
//
//  Created by Irfan Rahman on 1/30/18.
//  Copyright © 2018 Irfan Rahman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Artists+CoreDataClass.h"
#import "ViewController.h"
#import "TableCell.h"
#import "DetailVc.h"
#import "AppDelegate.h"


#define Identifier              @"Identifier"

@interface ViewController ()

@end

@implementation ViewController

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
    
    self.jSonArray = [[NSMutableArray alloc]init];
    self.title = @"Artists";
    
    
    self.sortOBj =  [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sortOBj setImage:[UIImage imageNamed:@"ic_swap_vert"] forState:UIControlStateNormal];
    [self.sortOBj addTarget:self action:@selector(sortAct:)forControlEvents:UIControlEventTouchUpInside];
    [self.sortOBj setFrame:CGRectMake(0, 0, 32, 32)];
    
    UIView * rightBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    
    [rightBarView addSubview:self.sortOBj];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBarView];
    
    [self.tableObj registerNib:[TableCell nib] forCellReuseIdentifier:Identifier];
//    self.tableObj.separatorStyle = UITableViewStylePlain;
    
//    [self fetchResults];
    
    //    if (self.jSonArray.count == 0) {
    [self getJsonDataCall];
    //
    //    }
    
}
-(IBAction)sortAct:(id)sender{
    
    self.sortOBj.selected = !self.sortOBj.selected;
    NSSortDescriptor *sort;
    if ([self.sortOBj isSelected]) {
        sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    } else {
        sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:NO];
    }
    
    NSArray *sortArry =[self.jSonArray sortedArrayUsingDescriptors:@[sort]];
    
    [self.jSonArray removeAllObjects];
    self.jSonArray = sortArry.mutableCopy;
    [self.tableObj reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.jSonArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    
    NSManagedObject *modal = [self.jSonArray objectAtIndex:indexPath.row];
   
    NSData *data = [[NSData alloc]initWithBase64EncodedString:[modal valueForKey:@"image"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
    UIImage *img = [[UIImage alloc] initWithData:data];
    
    cell.textLabel.text = [modal valueForKey:@"name"];
    
    cell.imageView.image = img;
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Your custom operation
    NSManagedObjectModel *modal = [self.jSonArray objectAtIndex:indexPath.row];
    
    DetailVc * detail = [[DetailVc alloc] initWithNibName:@"DetailVc" bundle:nil];
    detail.modal = modal;
    [self.navigationController pushViewController:detail animated:YES];
}


-(void)getJsonDataCall{
    
    NSString *path = [@"http://assets.aloompa.com.s3.amazonaws.com/rappers/rappers.json" stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:path];
    NSError *error = nil;
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    if (data != nil) {
        
        
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error]; // this line triggers exception error
        self.jSonArray = [jsonDict objectForKey:@"artists"];
        
    }
    NSMutableArray *newArray= [[NSMutableArray alloc] init];
    
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Artists"];
    NSMutableArray *ecArray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    for (int i = 0 ; i< self.jSonArray.count;i++) {
        BOOL forJson = false;
        NSString *Str = [self.jSonArray[i] objectForKey:@"id"];
        
        NSLog(@"Id == %@",[self.jSonArray[i] objectForKey:@"id"]);
        
        for (int j = 0; j< ecArray.count ; j++) {
            NSManagedObject *modal = [ecArray objectAtIndex:j];
            
            NSString *IdStr = [modal valueForKey:@"id"];
            NSLog(@"NewID %@",IdStr);
            if (![Str isEqualToString:IdStr]) {
                forJson = true;
            }
        }
        if (!forJson ) {
            [newArray addObject:self.jSonArray[i]];
            
        }
    }
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    
    if (newArray.count > 0) {
        
        for (NSDictionary *dict  in newArray) {
            
            Artists *newDevice = [NSEntityDescription insertNewObjectForEntityForName:@"Artists" inManagedObjectContext:context];
            
//            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            
            id artistId = [dict valueForKey:@"id"];
            
            [newDevice setValue:[NSNumber numberWithInteger:[artistId integerValue]] forKey:@"id"];
            
            
            [newDevice setValue:[NSString stringWithFormat:@"%@",[dict valueForKey:@"name"]] forKey:@"name"];
            
            
            NSURL *url = [NSURL URLWithString:[dict objectForKey:@"image"]];
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *img = [[UIImage alloc] initWithData:data];
            
            NSString *base64 = [UIImagePNGRepresentation(img) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            
            
            
            [newDevice setValue:base64 forKey:@"image"];
            
            
            [newDevice setValue:[dict valueForKey:@"description"] forKey:@"discriptions"];
//            [request setEntity:newDevice];
            
            if (![context save:&error]) {
                NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
            }
            
        }
        
    }
    
    ////////// for results fetching from core data:
    
    [self fetchResults];
    
    
}


-(void)fetchResults{
    
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Artists"];
    self.jSonArray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    [self.tableObj reloadData];
    
}

@end
