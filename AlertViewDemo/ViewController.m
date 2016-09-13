//
//  ViewController.m
//  AlertViewDemo
//
//  Created by shanpengtao on 16/9/13.
//  Copyright © 2016年 shanpengtao. All rights reserved.
//

#import "ViewController.h"
#import "JobAlertManager.h"

@interface ViewController ()

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _dataArray = @[@"一个按钮",@"两个按钮",@"三个按钮"];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = _dataArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *cancelButtons;
    switch (indexPath.row) {
        case 0:
        {
            cancelButtons = @[];
        }
            break;
        case 1:
        {
            cancelButtons = @[@"确定"];
        }
            break;
        case 2:
        {
            cancelButtons = @[@"O(∩_∩)O哈！", @"/(ㄒoㄒ)/哭~~"];
        }
            break;
        default:
            break;
    }
    
    [JobAlertManager showAlertViewWithTitle:@"提示" message:@"This is a message to test oooooooooooooooooooooooooo" cancelButtonTitle:@"取消" otherButtonTitles:cancelButtons callback:^(NSInteger buttonIndex) {
        NSLog(@"buttonIndex:%ld",buttonIndex);
    }];

}

@end
