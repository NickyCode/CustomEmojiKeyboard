//
//  FPFEditorEmojiView.m
//  FanPink
//
//  Created by NickyWan on 16/7/20.
//  Copyright © 2016年 Kugou. All rights reserved.
//

#import "FPFEditorEmojiView.h"
#import "FPFEmojiBarItem.h"
#import "FPFEmojiItemLayout.h"
#import "FPFEmojiManager.h"
#import "FPFSystemEmojiItem.h"
#import "FPFCustomEmojiItem.h"
#import "UIButton+WebCache.h"
#import "FPFSkinThemeManger.h"
#import "FPFSkinView.h"

static const CGSize kBarItemSize = (CGSize){60, 44};

static const NSInteger kBarCollectionTag = 100;
static const NSInteger kEmojiCollectionTag = 101;

static NSString * const kBarItemIdentifier = @"kBarItemIdentifier";
static NSString * const kSystemEmojiItemIdentifier = @"kSystemEmojiItemIdentifier";
static NSString * const kCustomEmojiItemIdentifier = @"kCustomEmojiItemIdentifier";



@interface FPFEditorEmojiView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) UIView *rootView;

@property (nonatomic, strong) UIButton *clearBtn;
@property (nonatomic, strong) UICollectionView *barView;
@property (nonatomic, strong) UICollectionView *emojiView;
@property (nonatomic, strong) FPFEmojiItemLayout *emojiLayout;
@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) NSArray *source;
@property (nonatomic, assign) NSInteger currentSourceSection;

@property (nonatomic, strong) FPFEmojiManager *manager;
@property (nonatomic, assign) BOOL firstLoad;

@property (nonatomic, weak) FPFEmoticon *lastEmoticon;

@end

@implementation FPFEditorEmojiView

- (instancetype)initWithRootView:(UIView *)rootView
{
    self = [self initWithFrame:rootView.bounds];
    if (self) {
        
        _source = [self.manager emojiSource];
        _currentSourceSection = 0;
        
        [self addSubview:self.clearBtn];
        [self addSubview:self.barView];
        [self addSubview:self.emojiView];
        [self addSubview:self.pageControl];
    }
    return self;
}

#pragma mark - clear btn action

- (void)clearEmoticon:(UIButton *)btn
{
    if ([_delegate respondsToSelector:@selector(emojiView:didClearEmoticon:)]) {
        [self.delegate emojiView:self didClearEmoticon:self.lastEmoticon];
    }
}

#pragma mark - scroll view delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (kEmojiCollectionTag == scrollView.tag) {
        CGFloat contentOffsetX = scrollView.contentOffset.x;
        NSInteger page = contentOffsetX / scrollView.width;
        
        for (NSInteger section = 0; section < self.emojiView.numberOfSections; section++) {
            
            NSInteger pageIndexOfSection = [self.emojiLayout.pageIndexOfSections[[@(section) stringValue]] integerValue];
            NSInteger numOfPageInSection = [self.emojiLayout.numOfPageInSections[[@(section) stringValue]] integerValue];

            if (pageIndexOfSection+numOfPageInSection > page) {

                self.currentSourceSection = section;
                [self.barView reloadData];
                
                self.pageControl.numberOfPages = numOfPageInSection;
                self.pageControl.currentPage = page - pageIndexOfSection;
                
                break;
            }
        }
    }
}

#pragma mark - delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (kBarCollectionTag == collectionView.tag) {
        NSInteger emojiSection = indexPath.row;
        self.currentSourceSection = emojiSection;
        [self.barView reloadData];
        NSInteger pageIndexOfSection = [self.emojiLayout.pageIndexOfSections[[@(emojiSection) stringValue]] integerValue];
        self.emojiView.contentOffset = (CGPoint){self.emojiView.width * pageIndexOfSection, 0};
        
        NSInteger numOfPageInSection = [self.emojiLayout.numOfPageInSections[[@(emojiSection) stringValue]] integerValue];
        self.pageControl.numberOfPages = numOfPageInSection;
        self.pageControl.currentPage = 0;
    }
    
    if (kEmojiCollectionTag == collectionView.tag) {
        
        if ([_delegate respondsToSelector:@selector(emojiView:didSelectedEmoticon:)]) {
            
            FPFEmoticonGroup *group = _source[indexPath.section];
            FPFEmoticon *emoji = group.emoticons[indexPath.row];
            
            self.lastEmoticon = emoji;
            
            [self.delegate emojiView:self didSelectedEmoticon:emoji];
        }
        
    }
}

#pragma mark - datasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (kBarCollectionTag == collectionView.tag) {
        return 1;
    } else {
        return _source.count;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (kBarCollectionTag == collectionView.tag) {
        return _source.count;
    } else {
        FPFEmoticonGroup *group = _source[section];
        return group.emoticons.count;
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.firstLoad) {
        NSInteger numOfPageInSection0 = [self.emojiLayout.numOfPageInSections[[@0 stringValue]] integerValue];
        _pageControl.numberOfPages = numOfPageInSection0;
        _pageControl.currentPage = 0;
        self.firstLoad = YES;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = nil;
    
    if (kBarCollectionTag == collectionView.tag) {
         cell = [collectionView dequeueReusableCellWithReuseIdentifier:kBarItemIdentifier forIndexPath:indexPath];
        FPFEmojiBarItem *cellview = (FPFEmojiBarItem *)cell;
        
//        if (indexPath.row == 0) {
//            cellview.imageView.image = [UIImage imageNamed:@"message_post_face_default"];
//        }
//        
//        else if (indexPath.row == 1) {
//            cellview.imageView.image = [UIImage imageNamed:@"message_post_face_rabbit"];
//        }
        if (indexPath.row == 0) {
            cellview.imageView.image = [UIImage imageNamed:@"message_post_face_rabbit"];
        }
        
        else {
            cellview.imageView.image = nil;
        }
        
        if (indexPath.row == _currentSourceSection) {
            NSString *color = [[[FPFSkinThemeManger shareInstace] plistDic] objectForKey:message_post_tool_view_bg_color];
            cell.backgroundColor = [UIColor colorWithHexString:color];
        } else {
            cell.backgroundColor = [UIColor clearColor];
        }
    }
    
    if (kEmojiCollectionTag == collectionView.tag) {
        
//        if (indexPath.section == 0) {
//            cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSystemEmojiItemIdentifier forIndexPath:indexPath];
//            FPFSystemEmojiItem *item = (FPFSystemEmojiItem *)cell;
//            
//            FPFEmoticonGroup *group = _source[indexPath.section];
//            FPFEmoticon *emoji = group.emoticons[indexPath.row];
//            
//            [item.btn setTitle:emoji.name forState:UIControlStateNormal];
//            
//            __weak typeof(self) wself = self;
//            [item setSelectedEmoji:^{
//                [wself collectionView:collectionView didSelectItemAtIndexPath:indexPath];
//            }];
//        }
//        
//        else {
        
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCustomEmojiItemIdentifier forIndexPath:indexPath];
            FPFCustomEmojiItem *item = (FPFCustomEmojiItem *)cell;
            
            FPFEmoticonGroup *group = _source[indexPath.section];
            FPFEmoticon *emoji = group.emoticons[indexPath.row];
        
            [item.btn sd_setImageWithURL:emoji.path forState:UIControlStateNormal];
        
            item.nameLabel.text = emoji.name;
            
            __weak typeof(self) wself = self;
            [item setSelectedEmoji:^{
                [wself collectionView:collectionView didSelectItemAtIndexPath:indexPath];
            }];
//        }
    }
    
    return cell;
}

#pragma mark - getter

- (FPFEmojiItemLayout *)emojiLayout
{
    if (!_emojiLayout) {
        _emojiLayout = [[FPFEmojiItemLayout alloc] init];
    }
    return _emojiLayout;
}

- (UICollectionView *)emojiView
{
    if (!_emojiView) {
        
        CGSize pagesize = (CGSize){ScreenWidth, self.height - kBarItemSize.height};
        
        UICollectionView *emojiView = [[UICollectionView alloc] initWithFrame:(CGRect){CGPointZero, pagesize}
                                                       collectionViewLayout:self.emojiLayout];
        _emojiView = emojiView;
        emojiView.tag = kEmojiCollectionTag;
        
        [emojiView registerClass:[FPFSystemEmojiItem class] forCellWithReuseIdentifier:kSystemEmojiItemIdentifier];
        [emojiView registerClass:[FPFCustomEmojiItem class] forCellWithReuseIdentifier:kCustomEmojiItemIdentifier];

        
        emojiView.pagingEnabled = YES;
        emojiView.bounces = YES;
        emojiView.allowsMultipleSelection = NO;
        emojiView.backgroundColor = [UIColor clearColor];
        emojiView.showsVerticalScrollIndicator = NO;
        emojiView.showsHorizontalScrollIndicator = NO;
        emojiView.delegate = self;
        emojiView.dataSource = self;
    }
    
    return _emojiView;
}

- (UICollectionView *)barView
{
    if (!_barView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UIAccessibilityScrollDirectionRight;
        layout.itemSize = kBarItemSize;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        
        UICollectionView *barview = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.height-kBarItemSize.height, ScreenWidth-kBarItemSize.width, kBarItemSize.height)
                                                       collectionViewLayout:layout];
        _barView = barview;
        barview.tag = kBarCollectionTag;
        
        [barview registerClass:[FPFEmojiBarItem class] forCellWithReuseIdentifier:kBarItemIdentifier];
        
        barview.bounces = NO;
        barview.allowsMultipleSelection = NO;
        
        NSString *color = [[[FPFSkinThemeManger shareInstace] plistDic] objectForKey:message_post_emoji_bar_bg_color];
        barview.backgroundColor = [UIColor colorWithHexString:color];
        barview.showsVerticalScrollIndicator = NO;
        barview.showsHorizontalScrollIndicator = NO;
        barview.delegate = self;
        barview.dataSource = self;
    }
    
    return _barView;
}

- (UIButton *)clearBtn
{
    if (!_clearBtn) {
        UIButton *backBtn = [[UIButton alloc] initWithFrame:(CGRect){{ScreenWidth-kBarItemSize.width,self.height-kBarItemSize.height}, kBarItemSize}];
        _clearBtn = backBtn;
        
        NSString *color = [[[FPFSkinThemeManger shareInstace] plistDic] objectForKey:message_post_emoji_bar_bg_color];
        backBtn.backgroundColor = [UIColor colorWithHexString:color];
        [backBtn setImage:[UIImage imageNamed:@"message_post_face_btn_delete_nor"] forState:UIControlStateNormal];
        [backBtn setImage:[UIImage imageNamed:@"message_post_face_btn_delete_hl"] forState:UIControlStateHighlighted];
        [backBtn addTarget:self action:@selector(clearEmoticon:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clearBtn;
}

- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.barView.top-23, ScreenWidth, 23)];
    }
    return _pageControl;
}

- (FPFEmojiManager *)manager
{
    if (!_manager) {
        _manager = [[FPFEmojiManager alloc] init];
    }
    return _manager;
}

@end
