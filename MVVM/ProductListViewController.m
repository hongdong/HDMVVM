
#import "ProductListViewController.h"
#import "APIClient.h"
#import "ProductListViewModel.h"
#import <MJRefresh/MJRefresh.h>
#import "ProductListCell.h"
#import "MacroHeader.h"

@interface ProductListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *table;

@property (nonatomic, strong) ProductListViewModel *viewModel;

@end

@implementation ProductListViewController

#pragma mark - Life Circle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViewUI];
    [self initViewModel];
    [self bindViewModel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UI

- (void)setupViewUI {
    
    self.title = @"产品列表";
    WS(weakSelf)
    self.table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.viewModel.fetchProductCommand execute:nil];
    }];
    
    self.table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf.viewModel.fetchMoreProductCommand execute:nil];
    }];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:nil action:nil];
}

- (void)initViewModel {
    
    _viewModel = [ProductListViewModel new];
    @weakify(self)
    //这个command是否在执行
    [_viewModel.fetchProductCommand.executing subscribeNext:^(NSNumber *executing) {
        NSLog(@"command executing:%@", executing);
        if (!executing.boolValue) {
            @strongify(self)
            [self.table.mj_header endRefreshing];
        }
    }];
    
    [_viewModel.fetchMoreProductCommand.executing subscribeNext:^(NSNumber *executing) {
        if (!executing.boolValue) {
            @strongify(self);
            [self.table.mj_footer endRefreshing];
        }
    }];
    
    [_viewModel.errors subscribeNext:^(NSError *error) {
        ResponseData *data = [ResponseData mj_objectWithKeyValues:error.userInfo];
        NSLog(@"something error:%@", data.mj_keyValues);
        //TODO: 这里可以选择一种合适的方式将错误信息展示出来
    }];
    
}

- (void)bindViewModel {
    @weakify(self);
    self.navigationItem.rightBarButtonItem.rac_command = [[RACCommand alloc]initWithEnabled:[[RACSignal
                                                                                             combineLatest:@[self.viewModel.fetchProductCommand.executing, self.viewModel.fetchMoreProductCommand.executing]] or]
                                                                                signalBlock:^RACSignal *(id input) {
                                                                                    @strongify(self);
                                                                                    [self.viewModel.cancelCommand execute:nil];
                                                                                    return [RACSignal empty];
                                                                                }];
    
    [RACObserve(self.viewModel, items) subscribeNext:^(id x) {
        @strongify(self);
        [self.table reloadData];
    }];
    
    //没有更多数据时，隐藏table的footer
    RAC(self.table.mj_footer, hidden) = [self.viewModel.hasMoreData not];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProductListCell" forIndexPath:indexPath];
    cell.viewModel = [self.viewModel itemViewModelForIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
