//
//  MiYiTagSearchBarVC.m
//  MiYi
//
//  Created by 叶星龙 on 15/8/27.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//

#import "MiYiTagSearchBarVC.h"

@interface MiYiTagSearchBarVC ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong) UISearchBar *searchBar;

@property (nonatomic, strong) UITextField *searchField;

@property (nonatomic ,strong) UITableView *tableView ;

@property (nonatomic ,strong) NSArray *dataList;

@property (nonatomic ,strong) NSMutableArray *resultsData;

@property (strong, nonatomic) NSMutableDictionary *sectionDict;

@end

@implementation MiYiTagSearchBarVC



- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *pathBundle=nil;
    if (_isType) {
        pathBundle =@"brand";
    }else{
        pathBundle =@"feature";
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:pathBundle ofType:@"plist"];
    self.dataList = [NSArray arrayWithContentsOfFile:path];
    _resultsData =[NSMutableArray array];
    
    _searchBar =[[UISearchBar alloc]init];
    [self.searchBar setPlaceholder:@"搜索"];
    [self.searchBar setTintColor:HEX_COLOR_THEME];
    [self.searchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"TagSearchBar"] forState:UIControlStateNormal];
    self.searchBar.delegate=self;
    self.navigationItem.titleView=_searchBar;
    
    UITableView *tableView =[[UITableView alloc]initWithFrame:(CGRect){0,0,kWindowWidth,kWindowHeight-64}];
    tableView.backgroundColor=HEX_COLOR_VIEW_BACKGROUND;
    tableView.dataSource=self;
    tableView.delegate=self;
    [tableView setSectionHeaderHeight:50];
    [tableView setRowHeight:50];
    [self.view addSubview:tableView];
    tableView.tableHeaderView=[[UIView alloc]init];
    tableView.tableFooterView=[[UIView alloc]init];
    _tableView=tableView;

    self.sectionDict = [NSMutableDictionary dictionaryWithCapacity:self.dataList.count];
    
    // Do any additional setup after loading the view.
}
//源字符串内容是否包含或等于要搜索的字符串内容
-(void)filterContentForSearchText:(NSString*)searchText
{
    NSMutableArray *tempResults = [NSMutableArray array];
    NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
    
    for (int i = 0; i < _dataList.count; i++) {
            NSString *storeString = _dataList[i];
            NSRange storeRange = NSMakeRange(0, storeString.length);
            NSRange foundRange = [storeString rangeOfString:searchText options:searchOptions range:storeRange];
            if (foundRange.length) {
                [tempResults addObject:storeString];
            }
        
    }
    [_resultsData removeAllObjects];
    if (tempResults .count ==0) {
        [tempResults addObject: _searchBar.text];
    }
    [_resultsData addObjectsFromArray:tempResults];

    [_tableView reloadData];
    
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"%@",searchBar.text);
    if (searchBar.text.length!=0) {
        [self filterContentForSearchText:searchBar.text];
    }else
    {
        [_resultsData removeAllObjects];
        [_tableView reloadData];
    }
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_resultsData.count!=0) {
        return 1;
    }
    return self.dataList.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"TagSearchBarCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    if (_resultsData.count!=0) {
        cell.textLabel.text = _resultsData[indexPath.row];

        return    cell;
    }

    
    [cell.textLabel setText:self.dataList[indexPath.row]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_resultsData.count!=0) {
        _block ( _resultsData[indexPath.row]);
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }

    _block(self.dataList[indexPath.row]);
    [self.navigationController popViewControllerAnimated:YES];
}
//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    NSMutableArray *array = [NSMutableArray array];
//    for(int section='A';section<='Z';section++)
//    {
//        [array addObject:[NSString stringWithFormat:@"%c",section]];
//    }
//    return array;
//}
//// 自定义索引与数组的对应关系
//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
//{
//    return (index+1==26)?0:(index+1);
//}
@end
