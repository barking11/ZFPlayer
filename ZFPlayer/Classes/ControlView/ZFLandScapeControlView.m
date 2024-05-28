//
//  ZFLandScapeControlView.m
//  ZFPlayer
//
// Copyright (c) 2016年 任子丰 ( http://github.com/renzifeng )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "ZFLandScapeControlView.h"
#import "UIView+ZFFrame.h"
#import "ZFUtilities.h"
#import "ZFPlayerStatusBar.h"
#if __has_include(<ZFPlayer/ZFPlayer.h>)
#import <ZFPlayer/ZFPlayerConst.h>
#else
#import "ZFPlayerConst.h"
#endif

@interface ZFLandScapeControlView () <ZFSliderViewDelegate>

@property (nonatomic, strong) ZFPlayerStatusBar *statusBarView;
/// 顶部工具栏
@property (nonatomic, strong) UIView *topToolView;
/// 返回按钮
@property (nonatomic, strong) UIButton *backBtn;
/// 标题
@property (nonatomic, strong) UILabel *titleLabel;
/// 底部工具栏
@property (nonatomic, strong) UIView *bottomToolView;
/// 播放或暂停按钮
@property (nonatomic, strong) UIButton *playOrPauseBtn;
/// 播放的当前时间
@property (nonatomic, strong) UILabel *currentTimeLabel;
/// 滑杆
@property (nonatomic, strong) ZFSliderView *slider;
/// 视频总时间
@property (nonatomic, strong) UILabel *totalTimeLabel;

@property (nonatomic, assign) BOOL isShow;

@property (nonatomic, strong) UIButton *fastForwardBtn;

@property (nonatomic, strong) UIButton *fastRewindBtn;
/// 锁定屏幕按钮
@property (nonatomic, strong) UIButton *lockBtn;

@property (nonatomic, strong) UIButton *mirrorBtn;

@property (nonatomic, strong) UIButton *zhuiBtn;

@property (nonatomic, strong) UIButton *beisuBtn;

@property (nonatomic, strong) UIButton *currentBeiSu;

@property (nonatomic, strong) UIView *beisuView;

@end

@implementation ZFLandScapeControlView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.topToolView];
        [self.topToolView addSubview:self.statusBarView];
        [self.topToolView addSubview:self.backBtn];
        [self.topToolView addSubview:self.titleLabel];
        [self.topToolView addSubview:self.beisuBtn];
        [self addSubview:self.bottomToolView];
        [self.bottomToolView addSubview:self.currentTimeLabel];
        
        [self.bottomToolView addSubview:self.slider];
        [self.bottomToolView addSubview:self.totalTimeLabel];
        
        [self addSubview:self.mirrorBtn];
        [self addSubview:self.lockBtn];
        [self addSubview:self.zhuiBtn];
        [self addSubview:self.beisuView];
        
        [self addSubview:self.playOrPauseBtn];
        [self addSubview:self.fastForwardBtn];
        [self addSubview:self.fastRewindBtn];
        
        [self addSubview:self.adView];
        [self addSubview:self.adCloseBtn];
        
        // 设置子控件的响应事件
        [self makeSubViewsAction];
        [self resetControlView];
        
        /// statusBarFrame changed
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(layoutControllerViews) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat min_x = 0;
    CGFloat min_y = 0;
    CGFloat min_w = 0;
    CGFloat min_h = 0;
    CGFloat min_view_w = self.bounds.size.width;
    CGFloat min_view_h = self.bounds.size.height;
    
    CGFloat min_margin = 9;
    
    min_x = 0;
    min_y = 0;
    min_w = min_view_w;
    min_h = iPhoneX ? 110 : 80;
    self.topToolView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = 0;
    min_y = 0;
    min_w = min_view_w;
    min_h = 20;
    self.statusBarView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = (iPhoneX && UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) ? 44: 15;
    if (@available(iOS 13.0, *)) {
        if (self.showCustomStatusBar) {
            min_y = self.statusBarView.zf_bottom;
        } else {
            min_y = UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation) ? 10 : (iPhoneX ? 40 : 20);
        }
    } else {
        min_y = (iPhoneX && UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) ? 10: (iPhoneX ? 40 : 20);
    }
    min_w = 40;
    min_h = 40;
    self.backBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = self.backBtn.zf_right + 5;
    min_y = 0;
    min_w = min_view_w - min_x - 15 ;
    min_h = 30;
    self.titleLabel.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.titleLabel.zf_centerY = self.backBtn.zf_centerY;
    
    min_w = 50;
    min_h = 30;
    min_x = min_view_w - min_w - 45;
    min_y = 0;
    self.beisuBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.beisuBtn.zf_centerY = self.backBtn.zf_centerY;
    
    min_w = min_view_w / 2;
    min_h = min_view_h / 3 * 2;
    min_x = (min_view_w - min_w) / 2;
    min_y = (min_view_h - min_h) / 2;
    self.adView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    self.adCloseBtn.frame = CGRectMake(min_view_w - 100, 20, 50, 20);
    
    min_h = iPhoneX ? 100 : 73;
    min_x = 0;
    min_y = min_view_h - min_h;
    min_w = min_view_w;
    self.bottomToolView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = 0;
    min_y = 0;
    min_w = 50;
    min_h = 50;
    self.playOrPauseBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.playOrPauseBtn.center = self.center;
    
    min_x = self.playOrPauseBtn.zf_left - 30 - min_w;
    self.fastRewindBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.fastRewindBtn.zf_centerY = self.playOrPauseBtn.zf_centerY;
    
    min_x = self.playOrPauseBtn.zf_right + 30;
    self.fastForwardBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.fastForwardBtn.zf_centerY = self.playOrPauseBtn.zf_centerY;
    
    min_x = (iPhoneX && UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) ? 44: 15;
    min_y = 32;
    min_w = 62;
    min_h = 30;
    self.currentTimeLabel.frame = CGRectMake(min_x, min_y, min_w, min_h);
    //    self.currentTimeLabel.zf_centerY = self.playOrPauseBtn.zf_centerY;
    
    min_w = 62;
    min_x = self.bottomToolView.zf_width - min_w - ((iPhoneX && UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) ? 44: min_margin);
    min_y = 0;
    min_h = 30;
    self.totalTimeLabel.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.totalTimeLabel.zf_centerY = self.currentTimeLabel.zf_centerY;
    
    min_x = self.currentTimeLabel.zf_right + 4;
    min_y = 0;
    min_w = self.totalTimeLabel.zf_left - min_x - 4;
    min_h = 30;
    self.slider.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.slider.zf_centerY = self.currentTimeLabel.zf_centerY;
    
    min_x = 0;
    min_y = 0;
    min_w = 40;
    min_h = 40;
    self.lockBtn.frame = CGRectMake(min_view_w - 50 - 40, min_y, min_w, min_h);
    self.lockBtn.zf_centerY = self.zf_centerY;
    
    min_y = self.lockBtn.zf_top - 65;
    self.mirrorBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.mirrorBtn.zf_centerX = self.lockBtn.zf_centerX;
    
    min_y = self.lockBtn.zf_bottom + 25;
    self.zhuiBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.zhuiBtn.zf_centerX = self.lockBtn.zf_centerX;
    
    if (!self.isShow) {
        self.topToolView.zf_y = -self.topToolView.zf_height;
        self.bottomToolView.zf_y = self.zf_height;
        //        self.lockBtn.zf_left = iPhoneX ? -82: -47;
    } else {
        //        self.lockBtn.zf_left = iPhoneX ? 50: 18;
        if (self.player.isLockedScreen) {
            self.topToolView.zf_y = -self.topToolView.zf_height;
            self.bottomToolView.zf_y = self.zf_height;
        } else {
            self.topToolView.zf_y = 0;
            self.bottomToolView.zf_y = self.zf_height - self.bottomToolView.zf_height;
        }
    }
    
    min_x = min_view_w - 150;
    min_y = 0;
    min_w = 150;
    min_h = min_view_h;
    
    self.beisuView.frame = CGRectMake(min_x, min_y, min_w, min_h);
}

- (void)makeSubViewsAction {
    [self.backBtn addTarget:self action:@selector(backBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.playOrPauseBtn addTarget:self action:@selector(playPauseButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.lockBtn addTarget:self action:@selector(lockButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.adCloseBtn addTarget:self action:@selector(adCloseAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.fastForwardBtn addTarget:self action:@selector(fastForward:) forControlEvents:UIControlEventTouchUpInside];
    [self.fastRewindBtn addTarget:self action:@selector(fastRewind:) forControlEvents:UIControlEventTouchUpInside];
    [self.mirrorBtn addTarget:self action:@selector(mirrirBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.zhuiBtn addTarget:self action:@selector(zhuiAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.beisuBtn addTarget:self action:@selector(showBeisuView) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - action

- (void)layoutControllerViews {
    [self layoutIfNeeded];
    [self setNeedsLayout];
}

- (void)adCloseAction:(UIButton *)sender {
    if (_adCloseHandler) {
        _adCloseHandler();
    }
}

- (void)backBtnClickAction:(UIButton *)sender {
    self.lockBtn.selected = NO;
    self.player.lockedScreen = NO;
    self.lockBtn.selected = NO;
    if (self.player.orientationObserver.supportInterfaceOrientation & ZFInterfaceOrientationMaskPortrait) {
        [self.player enterFullScreen:NO animated:YES];
    }
    if (self.backBtnClickCallback) {
        self.backBtnClickCallback();
    }
}

- (void)playPauseButtonClickAction:(UIButton *)sender {
    [self playOrPause];
}

/// 根据当前播放状态取反
- (void)playOrPause {
    self.playOrPauseBtn.selected = !self.playOrPauseBtn.isSelected;
    self.playOrPauseBtn.isSelected? [self.player.currentPlayerManager play]: [self.player.currentPlayerManager pause];
}

- (void)fastForward:(UIButton *)sender {
    [self.player seekToTime:self.player.currentTime + 10 completionHandler:^(BOOL finished) {
        
    }];
}

- (void)fastRewind:(UIButton *)sender {
    [self.player seekToTime:self.player.currentTime - 10 completionHandler:^(BOOL finished) {
        
    }];
}

- (void)playBtnSelectedState:(BOOL)selected {
    self.playOrPauseBtn.selected = selected;
}

- (void)lockButtonClickAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.player.lockedScreen = sender.selected;
}

- (void)mirrirBtnClickAction:(UIButton *)sender {
    if (_mirrorHandler) {
        _mirrorHandler();
    }
}

- (void)zhuiAction:(UIButton *)sender {
    if (_zhuiHandler) {
        _zhuiHandler();
    }
}

#pragma mark - ZFSliderViewDelegate

- (void)sliderTouchBegan:(float)value {
    self.slider.isdragging = YES;
}

- (void)sliderTouchEnded:(float)value {
    if (self.player.totalTime > 0) {
        self.slider.isdragging = YES;
        if (self.sliderValueChanging) self.sliderValueChanging(value, self.slider.isForward);
        @zf_weakify(self)
        [self.player seekToTime:self.player.totalTime*value completionHandler:^(BOOL finished) {
            @zf_strongify(self)
            self.slider.isdragging = NO;
            if (finished) {
                if (self.sliderValueChanged) self.sliderValueChanged(value);
                if (self.seekToPlay) {
                    [self.player.currentPlayerManager play];
                }
            }
        }];
    } else {
        self.slider.isdragging = NO;
        self.slider.value = 0;
    }
}

- (void)sliderValueChanged:(float)value {
    if (self.player.totalTime == 0) {
        self.slider.value = 0;
        return;
    }
    self.slider.isdragging = YES;
    NSString *currentTimeString = [ZFUtilities convertTimeSecond:self.player.totalTime*value];
    self.currentTimeLabel.text = currentTimeString;
    if (self.sliderValueChanging) self.sliderValueChanging(value,self.slider.isForward);
}

- (void)sliderTapped:(float)value {
    [self sliderTouchEnded:value];
    NSString *currentTimeString = [ZFUtilities convertTimeSecond:self.player.totalTime*value];
    self.currentTimeLabel.text = currentTimeString;
}

#pragma mark - public method

/// 重置ControlView
- (void)resetControlView {
    self.slider.value                = 0;
    self.slider.bufferValue          = 0;
    self.currentTimeLabel.text       = @"00:00";
    self.totalTimeLabel.text         = @"00:00";
    self.backgroundColor             = [UIColor clearColor];
    self.playOrPauseBtn.selected     = YES;
    self.titleLabel.text             = @"";
    self.topToolView.alpha           = 1;
    self.bottomToolView.alpha        = 1;
    self.isShow                      = NO;
    self.lockBtn.selected            = self.player.isLockedScreen;
}

- (void)showControlView {
    self.lockBtn.alpha               = 1;
    self.isShow                      = YES;
    if (self.player.isLockedScreen) {
        self.topToolView.zf_y        = -self.topToolView.zf_height;
        self.bottomToolView.zf_y     = self.zf_height;
    } else {
        self.topToolView.zf_y        = 0;
        self.bottomToolView.zf_y     = self.zf_height - self.bottomToolView.zf_height;
    }
    self.player.statusBarHidden      = NO;
    if (self.player.isLockedScreen) {
        self.topToolView.alpha       = 0;
        self.bottomToolView.alpha    = 0;
        self.playOrPauseBtn.alpha    = 0;
        self.fastForwardBtn.alpha    = 0;
        self.fastRewindBtn.alpha     = 0;
        self.mirrorBtn.alpha         = 0;
        self.zhuiBtn.alpha           = 0;
    } else {
        self.topToolView.alpha       = 1;
        self.bottomToolView.alpha    = 1;
        self.playOrPauseBtn.alpha    = 1;
        self.fastForwardBtn.alpha    = 1;
        self.fastRewindBtn.alpha     = 1;
        self.mirrorBtn.alpha         = 1;
        self.zhuiBtn.alpha           = 1;
    }
}

- (void)hideControlView {
    self.isShow                      = NO;
    self.topToolView.zf_y            = -self.topToolView.zf_height;
    self.bottomToolView.zf_y         = self.zf_height;
    self.player.statusBarHidden      = YES;
    self.topToolView.alpha           = 0;
    self.bottomToolView.alpha        = 0;
    self.lockBtn.alpha               = 0;
    self.playOrPauseBtn.alpha        = 0;
    self.fastForwardBtn.alpha        = 0;
    self.fastRewindBtn.alpha         = 0;
    self.mirrorBtn.alpha             = 0;
    self.zhuiBtn.alpha               = 0;
}

- (BOOL)shouldResponseGestureWithPoint:(CGPoint)point withGestureType:(ZFPlayerGestureType)type touch:(nonnull UITouch *)touch {
    CGRect sliderRect = [self.bottomToolView convertRect:self.slider.frame toView:self];
    if (CGRectContainsPoint(sliderRect, point)) {
        return NO;
    }
    if (self.player.isLockedScreen && type != ZFPlayerGestureTypeSingleTap) { // 锁定屏幕方向后只相应tap手势
        return NO;
    }
    return YES;
}

- (void)videoPlayer:(ZFPlayerController *)videoPlayer presentationSizeChanged:(CGSize)size {
    self.lockBtn.hidden = self.player.orientationObserver.fullScreenMode == ZFFullScreenModePortrait;
}

/// 视频view即将旋转
- (void)videoPlayer:(ZFPlayerController *)videoPlayer orientationWillChange:(ZFOrientationObserver *)observer {
    if (self.showCustomStatusBar) {
        if (self.hidden) {
            [self.statusBarView destoryTimer];
        } else {
            [self.statusBarView startTimer];
        }
    }
}

- (void)videoPlayer:(ZFPlayerController *)videoPlayer currentTime:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime {
    if (!self.slider.isdragging) {
        NSString *currentTimeString = [ZFUtilities convertTimeSecond:currentTime];
        self.currentTimeLabel.text = currentTimeString;
        NSString *totalTimeString = [ZFUtilities convertTimeSecond:totalTime];
        self.totalTimeLabel.text = totalTimeString;
        self.slider.value = videoPlayer.progress;
    }
}

- (void)videoPlayer:(ZFPlayerController *)videoPlayer bufferTime:(NSTimeInterval)bufferTime {
    self.slider.bufferValue = videoPlayer.bufferProgress;
}

- (void)showTitle:(NSString *)title fullScreenMode:(ZFFullScreenMode)fullScreenMode {
    self.titleLabel.text = title;
    self.player.orientationObserver.fullScreenMode = fullScreenMode;
    self.lockBtn.hidden = fullScreenMode == ZFFullScreenModePortrait;
}

/// 调节播放进度slider和当前时间更新
- (void)sliderValueChanged:(CGFloat)value currentTimeString:(NSString *)timeString {
    self.slider.value = value;
    self.currentTimeLabel.text = timeString;
    self.slider.isdragging = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.slider.sliderBtn.transform = CGAffineTransformMakeScale(1.2, 1.2);
    }];
}

/// 滑杆结束滑动
- (void)sliderChangeEnded {
    self.slider.isdragging = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.slider.sliderBtn.transform = CGAffineTransformIdentity;
    }];
}

#pragma mark - setter

- (void)setFullScreenMode:(ZFFullScreenMode)fullScreenMode {
    _fullScreenMode = fullScreenMode;
    self.player.orientationObserver.fullScreenMode = fullScreenMode;
    self.lockBtn.hidden = fullScreenMode == ZFFullScreenModePortrait;
}

- (void)setShowCustomStatusBar:(BOOL)showCustomStatusBar {
    _showCustomStatusBar = showCustomStatusBar;
    self.statusBarView.hidden = !showCustomStatusBar;
}

#pragma mark - getter

- (UIView *)adView {
    if (!_adView) {
        _adView = [UIView new];
        _adView.hidden = YES;
    }
    return _adView;
}

- (UIButton *)adCloseBtn {
    if (!_adCloseBtn) {
        _adCloseBtn = [UIButton new];
        _adCloseBtn.hidden = YES;
        [_adCloseBtn setTitle:@"关闭广告" forState:UIControlStateNormal];
        [_adCloseBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _adCloseBtn.titleLabel.font = [UIFont systemFontOfSize:9];
        _adCloseBtn.layer.cornerRadius = 10;
        _adCloseBtn.layer.borderColor = UIColor.whiteColor.CGColor;
        _adCloseBtn.layer.borderWidth = 0.7;
    }
    return _adCloseBtn;
}

- (ZFPlayerStatusBar *)statusBarView {
    if (!_statusBarView) {
        _statusBarView = [[ZFPlayerStatusBar alloc] init];
        _statusBarView.hidden = YES;
    }
    return _statusBarView;
}

- (UIView *)topToolView {
    if (!_topToolView) {
        _topToolView = [[UIView alloc] init];
        UIImage *image = ZFPlayer_Image(@"ZFPlayer_top_shadow");
        _topToolView.layer.contents = (id)image.CGImage;
    }
    return _topToolView;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:ZFPlayer_Image(@"ZFPlayer_back_full") forState:UIControlStateNormal];
    }
    return _backBtn;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:15.0];
    }
    return _titleLabel;
}

- (UIView *)bottomToolView {
    if (!_bottomToolView) {
        _bottomToolView = [[UIView alloc] init];
        UIImage *image = ZFPlayer_Image(@"ZFPlayer_bottom_shadow");
        _bottomToolView.layer.contents = (id)image.CGImage;
    }
    return _bottomToolView;
}

- (UIButton *)playOrPauseBtn {
    if (!_playOrPauseBtn) {
        _playOrPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playOrPauseBtn setImage:ZFPlayer_Image(@"ZFPlayer_play") forState:UIControlStateNormal];
        [_playOrPauseBtn setImage:ZFPlayer_Image(@"ZFPlayer_pause") forState:UIControlStateSelected];
    }
    return _playOrPauseBtn;
}

- (UIButton *)fastRewindBtn {
    if (!_fastRewindBtn) {
        _fastRewindBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fastRewindBtn setImage:[UIImage imageNamed:@"play_backward_10"] forState:UIControlStateNormal];
    }
    return _fastRewindBtn;;
}

- (UIButton *)fastForwardBtn {
    if (!_fastForwardBtn) {
        _fastForwardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fastForwardBtn setImage:[UIImage imageNamed:@"play_forward_10"] forState:UIControlStateNormal];
    }
    return _fastForwardBtn;;
}

- (UILabel *)currentTimeLabel {
    if (!_currentTimeLabel) {
        _currentTimeLabel = [[UILabel alloc] init];
        _currentTimeLabel.textColor = [UIColor whiteColor];
        _currentTimeLabel.font = [UIFont systemFontOfSize:14.0f];
        _currentTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _currentTimeLabel;
}

- (ZFSliderView *)slider {
    if (!_slider) {
        _slider = [[ZFSliderView alloc] init];
        _slider.delegate = self;
        _slider.maximumTrackTintColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.8];
        _slider.bufferTrackTintColor  = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
        _slider.minimumTrackTintColor = [UIColor whiteColor];
        [_slider setThumbImage:ZFPlayer_Image(@"ZFPlayer_slider") forState:UIControlStateNormal];
        _slider.sliderHeight = 2;
    }
    return _slider;
}

- (UILabel *)totalTimeLabel {
    if (!_totalTimeLabel) {
        _totalTimeLabel = [[UILabel alloc] init];
        _totalTimeLabel.textColor = [UIColor whiteColor];
        _totalTimeLabel.font = [UIFont systemFontOfSize:14.0f];
        _totalTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _totalTimeLabel;
}

- (UIButton *)lockBtn {
    if (!_lockBtn) {
        _lockBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lockBtn setImage:[UIImage imageNamed:@"play_unlock_screen"] forState:UIControlStateNormal];
        [_lockBtn setImage:[UIImage imageNamed:@"play_lock_screen"] forState:UIControlStateSelected];
    }
    return _lockBtn;
}

- (UIButton *)mirrorBtn {
    if (!_mirrorBtn) {
        _mirrorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_mirrorBtn setImage:[UIImage imageNamed:@"play_mirror_big"] forState:UIControlStateNormal];
    }
    return _mirrorBtn;
}

- (UIButton *)zhuiBtn {
    if (!_zhuiBtn) {
        _zhuiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_zhuiBtn setImage:[UIImage imageNamed:@"play_zhui_big"] forState:UIControlStateNormal];
    }
    return _zhuiBtn;
}

- (UIButton *)beisuBtn {
    if (!_beisuBtn) {
        _beisuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_beisuBtn setTitle:@"倍速" forState:UIControlStateNormal];
        [_beisuBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _beisuBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _beisuBtn;
}

- (UIView *)beisuView {
    if (!_beisuView) {
        _beisuView = [UIView new];
        _beisuView.hidden = YES;
        _beisuView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        
        NSArray *titles = @[@"2.0X", @"1.5X", @"1.25X", @"1.0X", @"0.5X"];
        CGFloat itemH = 50;
        CGFloat topMargin = (UIScreen.mainScreen.bounds.size.width - titles.count * itemH) / 2.0;
        
        for (int i = 0; i < titles.count; i ++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, topMargin + i * itemH, 130, itemH)];
            btn.tag = i;
            [btn addTarget:self action:@selector(beisuAction:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitle:titles[i] forState:UIControlStateNormal];
            [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithRed:0.9 green:0.3 blue:0.8 alpha:1] forState:UIControlStateSelected];
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
            [_beisuView addSubview:btn];
            
            if (i == 3) {
                btn.selected = YES;
                _currentBeiSu = btn;
            }
        }
    }
    return _beisuView;
}

#pragma mark - beisu

- (void)showBeisuView {
    self.beisuView.hidden = NO;
    self.beisuView.zf_x = self.beisuView.zf_x + self.beisuView.zf_width;
    [UIView animateWithDuration:0.3 animations:^{
        self.beisuView.zf_x = self.zf_width - self.beisuView.zf_width;
    }];
}

- (void)hiddenBeisuView {
    [UIView animateWithDuration:0.3 animations:^{
        self.beisuView.zf_x = self.beisuView.zf_x + self.beisuView.zf_width;
    } completion:^(BOOL finished) {
        self.beisuView.hidden = YES;
    }];
}

- (void)beisuAction:(UIButton *)sender {
    [self hiddenBeisuView];
    
    if (sender == _currentBeiSu) {
        return;
    }
    
    sender.selected = YES;
    _currentBeiSu.selected = NO;
    _currentBeiSu = sender;
    
    switch (sender.tag) {
        case 0:
            self.player.currentPlayerManager.rate = 2.0;
            break;
        case 1:
            self.player.currentPlayerManager.rate = 1.5;
            break;
        case 2:
            self.player.currentPlayerManager.rate = 1.25;
            break;
        case 3:
            self.player.currentPlayerManager.rate = 1.0;
            break;
        case 4:
            self.player.currentPlayerManager.rate = 0.5;
            break;
            
        default:
            break;
    }
    
}

@end
