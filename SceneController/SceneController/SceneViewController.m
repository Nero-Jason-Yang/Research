#import "SceneViewController.h"
#import "SceneViewCell.h"

@interface SceneViewController () <GridLayoutDelegate>

@end

@implementation SceneViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout
{
    if (self = [super initWithCollectionViewLayout:layout]) {
        GridLayout *sceneLayout = (GridLayout *)layout;
        sceneLayout.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.collectionView registerClass:SceneViewCell.class forCellWithReuseIdentifier:@"SceneCell"];
    self.collectionView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <GridLayout>

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return (int)self.contentSizeForCells.width * (int)self.contentSizeForCells.height;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SceneViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"SceneCell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor colorWithRed:(float)rand() / RAND_MAX green:(float)rand() / RAND_MAX blue:(float)rand() / RAND_MAX alpha:1.0];
    
    return cell;
}

@end
