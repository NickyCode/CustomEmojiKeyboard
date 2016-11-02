//
//  FPFEmojiItemLayout.m
//  FanPink
//
//  Created by NickyWan on 16/8/31.
//  Copyright © 2016年 Kugou. All rights reserved.
//

#import "FPFEmojiItemLayout.h"

static const CGSize kSystemEmojiSize = (CGSize){30, 30};
static const CGSize kCustomEmojiSize = (CGSize){50, 77};

@interface FPFEmojiItemLayout ()

@property (nonatomic, strong) NSArray *layoutInfoArr;
@property (nonatomic, assign) CGSize contentSize;

@property (nonatomic, strong, readwrite) NSMutableDictionary *pageIndexOfSections;
@property (nonatomic, strong, readwrite) NSMutableDictionary *numOfPageInSections;

@end


@implementation FPFEmojiItemLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.scrollDirection = UIAccessibilityScrollDirectionRight;
        self.minimumInteritemSpacing = 15;
        self.minimumLineSpacing = 23;
//        self.itemSize = kSystemEmojiSize;
//        self.sectionInset = UIEdgeInsetsMake(15, 12, 20, 12);

        self.itemSize = kCustomEmojiSize;
        self.sectionInset = UIEdgeInsetsMake(18, 28, 33, 28);
        
        _pageIndexOfSections = [NSMutableDictionary dictionary];
        _numOfPageInSections = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)prepareLayout
{
    [super prepareLayout];
    
    NSMutableArray *layoutInfoArr = [NSMutableArray array];
    NSInteger maxNumberOfItems = 0;
    //获取布局信息
    NSInteger numberOfSections = [self.collectionView numberOfSections];
    for (NSInteger section = 0; section < numberOfSections; section++){
        NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:section];
        NSMutableArray *subArr = [NSMutableArray arrayWithCapacity:numberOfItems];
        for (NSInteger item = 0; item < numberOfItems; item++){
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
            [subArr addObject:attributes];
        }
        if(maxNumberOfItems < numberOfItems){
            maxNumberOfItems = numberOfItems;
        }
        //添加到二维数组
        [layoutInfoArr addObject:[subArr copy]];
    }
    //存储布局信息
    self.layoutInfoArr = [layoutInfoArr copy];
    
    NSInteger numberOfpage = 0;
    for (NSInteger section = 0; section < numberOfSections; section++) {
        numberOfpage += [self numberOfpageInSection:section];
    }
    CGFloat width = numberOfpage * self.pageSize.width;
    CGFloat height = self.pageSize.height;
    
    self.contentSize = CGSizeMake(width, height);
}

- (NSInteger)numberOfSections
{
    return [self.collectionView numberOfSections];
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section
{
    return [self.collectionView numberOfItemsInSection:section];
}

- (NSInteger)numberOfItems
{
    NSInteger sections = [self numberOfSections];
    
    NSInteger numberOfItems = 0;
    for (NSInteger section = 0; section < sections; section++) {
        numberOfItems += [self numberOfItemsInSection:section];
    }
    return numberOfItems;
}

- (CGSize)pageSize
{
    return self.collectionView.bounds.size;
}

- (CGSize)avaliableSizePerPage
{
    return (CGSize){
        self.pageSize.width - self.sectionInset.left - self.sectionInset.right,
        self.pageSize.height - self.sectionInset.top - self.sectionInset.bottom
    };
}


- (NSInteger)numberOfItemsPerRowInSction:(NSInteger)section
 {
//     if (section > 0) {
         return 4;
//     } else {
//         return floor(((ScreenWidth-24) + self.minimumInteritemSpacing)/(kSystemEmojiSize.width + self.minimumInteritemSpacing));
//     }
 }
 
 - (NSInteger)numberOfRowsPerPageInSction:(NSInteger)section
 {
//     if (section > 0) {
         return 2;
//     } else {
//         return floor(((self.collectionView.height-35) + self.minimumLineSpacing)/(kSystemEmojiSize.height + self.minimumLineSpacing));
//     }
 }
 

- (NSInteger)numberOfItemsPerPageInSction:(NSInteger)section
{
    return [self numberOfItemsPerRowInSction:section] * [self numberOfRowsPerPageInSction:section];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    if (CGSizeEqualToSize(self.collectionView.bounds.size, newBounds.size)) {
        return NO;
    }else{
        return YES;
    }
}

- (NSInteger)numberOfpageInSection:(NSInteger)section
{
    NSNumber *page = _numOfPageInSections[[@(section) stringValue]];
    if (page) {
        return page.integerValue;
    } else {
        NSInteger numberOfpage = ceil((float)[self numberOfItemsInSection:section]/[self numberOfItemsPerPageInSction:section]);
        _numOfPageInSections[[@(section) stringValue]] = @(numberOfpage);
        return numberOfpage;
    }
}

- (NSInteger)pageIndexOfSection:(NSInteger)section
{
    NSNumber *index = _pageIndexOfSections[[@(section) stringValue]];
    if (index) {
        return index.integerValue;
    } else {
        NSInteger pageIndex = 0;
        for (NSInteger i = 0; i < section; i++) {
            pageIndex += [self numberOfpageInSection:i];
        }
        _pageIndexOfSections[[@(section) stringValue]] = @(pageIndex);
        return pageIndex;
    }
}

- (CGSize)collectionViewContentSize
{
    return self.contentSize;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == 0) {
//        self.itemSize = kSystemEmojiSize;
//        self.sectionInset = UIEdgeInsetsMake(15, 12, 20, 12);
//    } else {
        self.itemSize = kCustomEmojiSize;
        self.sectionInset = UIEdgeInsetsMake(18, 28, 33, 28);
//    }
    
    NSInteger section = indexPath.section;
    
    CGFloat vspace = (self.avaliableSizePerPage.width - [self numberOfItemsPerRowInSction:section]*self.itemSize.width)/([self numberOfItemsPerRowInSction:section]-1);
    CGFloat hspace = (self.avaliableSizePerPage.height - [self numberOfRowsPerPageInSction:section]*self.itemSize.height)/([self numberOfRowsPerPageInSction:section]-1);

    NSInteger index = indexPath.row;
    //
    NSInteger page = floor((float)index/[self numberOfItemsPerPageInSction:section]) + [self pageIndexOfSection:section];
    NSInteger row  = floor((float)(index % [self numberOfItemsPerPageInSction:section])/[self numberOfItemsPerRowInSction:section]);
    NSInteger n    = index % [self numberOfItemsPerRowInSction:section];
    CGRect frame = (CGRect){
        {page * self.pageSize.width + n*(self.itemSize.width + vspace) + self.sectionInset.left,
            self.sectionInset.top + row*(self.itemSize.height + hspace)},
        self.itemSize
    };
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.frame = frame;
    return attributes;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *layoutAttributesArr = [NSMutableArray array];
    [self.layoutInfoArr enumerateObjectsUsingBlock:^(NSArray *array, NSUInteger i, BOOL * _Nonnull stop) {
        [array enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if(CGRectIntersectsRect(obj.frame, rect)) {
                [layoutAttributesArr addObject:obj];
            }
        }];
    }];
    return layoutAttributesArr;
}

@end
