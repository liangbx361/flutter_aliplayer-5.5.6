//
//  AliPlayerProxy.m
//  flutter_aliplayer
//
//  Created by aliyun on 2021/5/18.
//

#import "AliPlayerProxy.h"
#import <MJExtension/MJExtension.h>

@interface AliPlayerProxy ()
@property(nonatomic,strong) NSTimer *timer;
@end

@implementation AliPlayerProxy

#pragma mark AVPDelegate

/**
 @brief 播放器状态改变回调
 @param player 播放器player指针
 @param oldStatus 老的播放器状态 参考AVPStatus
 @param newStatus 新的播放器状态 参考AVPStatus
 */
- (void)onPlayerStatusChanged:(AliPlayer*)player oldStatus:(AVPStatus)oldStatus newStatus:(AVPStatus)newStatus {
    self.eventSink(@{kAliPlayerMethod:@"onStateChanged",@"newState":@(newStatus),kAliPlayerId:_playerId});
}

/**
 @brief 错误代理回调
 @param player 播放器player指针
 @param errorModel 播放器错误描述，参考AliVcPlayerErrorModel
 */
- (void)onError:(AliPlayer*)player errorModel:(AVPErrorModel *)errorModel {
    self.eventSink(@{kAliPlayerMethod:@"onError",@"errorCode":@(errorModel.code),@"errorMsg":errorModel.message,kAliPlayerId:_playerId});
}

- (void)onSEIData:(AliPlayer*)player type:(int)type data:(NSData *)data {
    NSString *str = [NSString stringWithUTF8String:data.bytes];
    NSLog(@"SEI: %@", str);
    self.eventSink(@{kAliPlayerMethod:@"onSeiData",@"data":str?:@"",@"type":@(type),kAliPlayerId:_playerId});
}

/**
 @brief 播放器事件回调
 @param player 播放器player指针
 @param eventType 播放器事件类型，@see AVPEventType
 */
-(void)onPlayerEvent:(AliPlayer*)player eventType:(AVPEventType)eventType {
    switch (eventType) {
        case AVPEventPrepareDone:
            self.eventSink(@{kAliPlayerMethod:@"onPrepared",kAliPlayerId:_playerId});
            break;
        case AVPEventFirstRenderedStart:
            self.eventSink(@{kAliPlayerMethod:@"onRenderingStart",kAliPlayerId:_playerId});
            break;
        case AVPEventLoadingStart:
            self.eventSink(@{kAliPlayerMethod:@"onLoadingBegin",kAliPlayerId:_playerId});
            break;
        case AVPEventLoadingEnd:
            self.eventSink(@{kAliPlayerMethod:@"onLoadingEnd",kAliPlayerId:_playerId});
            break;
        case AVPEventCompletion:
            self.eventSink(@{kAliPlayerMethod:@"onCompletion",kAliPlayerId:_playerId});
            break;
        case AVPEventSeekEnd:
            self.eventSink(@{kAliPlayerMethod:@"onSeekComplete",kAliPlayerId:_playerId});
            break;
        default:
            break;
    }
}

/**
 @brief 播放器事件回调
 @param player 播放器player指针
 @param eventWithString 播放器事件类型
 @param description 播放器事件说明
 @see AVPEventType
 */
-(void)onPlayerEvent:(AliPlayer*)player eventWithString:(AVPEventWithString)eventWithString description:(NSString *)description {
    self.eventSink(@{kAliPlayerMethod:@"onInfo",@"infoCode":@(eventWithString),@"extraMsg":description,kAliPlayerId:_playerId});
}

/**
 @brief 视频大小变化回调
 @param player 播放器player指针
 @param width 视频宽度
 @param height 视频高度
 @param rotation 视频旋转角度
 */
- (void)onVideoSizeChanged:(AliPlayer*)player width:(int)width height:(int)height rotation:(int)rotation {
    self.eventSink(@{kAliPlayerMethod:@"onVideoSizeChanged",@"width":@(width),@"height":@(height),@"rotation":@(rotation),kAliPlayerId:_playerId});
}


/**
 @brief 视频当前播放位置回调
 @param player 播放器player指针
 @param position 视频当前播放位置
 */
- (void)onCurrentPositionUpdate:(AliPlayer*)player position:(int64_t)position {
     self.eventSink(@{kAliPlayerMethod:@"onInfo",@"infoCode":@(2),@"extraValue":@(position),kAliPlayerId:_playerId});
}

/**
 @brief 视频当前播放内容对应的utc时间回调
 @param player 播放器player指针
 @param time utc时间
 */
- (void)onCurrentUtcTimeUpdate:(AliPlayer *)player time:(int64_t)time {
    self.eventSink(@{kAliPlayerMethod:@"onCurrentUtcTimeUpdate",@"time":@(time),kAliPlayerId:_playerId});
}

/**
 @brief 视频当前播放缓存命中回调
 @param player 播放器player指针
 @param size 文件大小
 */
- (void)onLocalCacheLoaded:(AliPlayer *)player size:(int64_t)size {
    self.eventSink(@{kAliPlayerMethod:@"onLocalCacheLoaded",@"size":@(size),kAliPlayerId:_playerId});
}

/**
 @brief 视频缓存位置回调
 @param player 播放器player指针
 @param position 视频当前缓存位置
 */
- (void)onBufferedPositionUpdate:(AliPlayer*)player position:(int64_t)position {
    self.eventSink(@{kAliPlayerMethod:@"onInfo",@"infoCode":@(1),@"extraValue":@(position),kAliPlayerId:_playerId});
}

/**
 @brief 获取track信息回调
 @param player 播放器player指针
 @param info track流信息数组 参考AVPTrackInfo
 */
- (void)onTrackReady:(AliPlayer*)player info:(NSArray<AVPTrackInfo*>*)info {
    self.eventSink(@{kAliPlayerMethod:@"onTrackReady",kAliPlayerId:_playerId});
}

/**
 @brief 字幕头信息回调，ass字幕，如果实现了此回调，则播放器不会渲染字幕，由调用者完成渲染，否则播放器自动完成字幕的渲染
 @param player 播放器player指针
 @param trackIndex 字幕显示的索引号
 @param header 头内容
 */
- (void)onSubtitleHeader:(AliPlayer *)player trackIndex:(int)trackIndex Header:(NSString *)header{
    self.eventSink(@{kAliPlayerMethod:@"onSubtitleHeader",@"trackIndex":@(trackIndex),@"header":header?:@"",kAliPlayerId:_playerId});
}

/**
 @brief 外挂字幕被添加
 @param player 播放器player指针
 @param trackIndex 字幕显示的索引号
 @param URL 字幕url
 */
- (void)onSubtitleExtAdded:(AliPlayer*)player trackIndex:(int)trackIndex URL:(NSString *)URL {
    self.eventSink(@{kAliPlayerMethod:@"onSubtitleExtAdded",@"trackIndex":@(trackIndex),@"url":URL,kAliPlayerId:_playerId});
}

/**
 @brief 字幕显示回调
 @param player 播放器player指针
 @param trackIndex 字幕流索引.
 @param subtitleID  字幕ID.
 @param subtitle 字幕显示的字符串
 */
- (void)onSubtitleShow:(AliPlayer*)player trackIndex:(int)trackIndex subtitleID:(long)subtitleID subtitle:(NSString *)subtitle {
    self.eventSink(@{kAliPlayerMethod:@"onSubtitleShow",@"trackIndex":@(trackIndex),@"subtitleID":@(subtitleID),@"subtitle":subtitle,kAliPlayerId:_playerId});
}

/**
 @brief 字幕隐藏回调
 @param player 播放器player指针
 @param trackIndex 字幕流索引.
 @param subtitleID  字幕ID.
 */
- (void)onSubtitleHide:(AliPlayer*)player trackIndex:(int)trackIndex subtitleID:(long)subtitleID {
    self.eventSink(@{kAliPlayerMethod:@"onSubtitleHide",@"trackIndex":@(trackIndex),@"subtitleID":@(subtitleID),kAliPlayerId:_playerId});
}

/**
 @brief 获取截图回调
 @param player 播放器player指针
 @param image 图像
 */
- (void)onCaptureScreen:(AliPlayer *)player image:(UIImage *)image {
    BOOL result =[UIImagePNGRepresentation(image)writeToFile:_snapshotPath atomically:YES]; // 保存成功会返回YES
    if (result == YES) {
        self.eventSink(@{kAliPlayerMethod:@"onSnapShot",@"snapShotPath":_snapshotPath,kAliPlayerId:_playerId});
    }
}

/**
 @brief track切换完成回调
 @param player 播放器player指针
 @param info 切换后的信息 参考AVPTrackInfo
 */
- (void)onTrackChanged:(AliPlayer*)player info:(AVPTrackInfo*)info {
    NSLog(@"onTrackChanged==%@",info.mj_JSONString);
    self.eventSink(@{kAliPlayerMethod:@"onTrackChanged",@"info":info.mj_keyValues,kAliPlayerId:_playerId});
}

/**
 @brief 获取缩略图成功回调
 @param positionMs 指定的缩略图位置
 @param fromPos 此缩略图的开始位置
 @param toPos 此缩略图的结束位置
 @param image 缩图略图像指针,对于mac是NSImage，iOS平台是UIImage指针
 */
- (void)onGetThumbnailSuc:(int64_t)positionMs fromPos:(int64_t)fromPos toPos:(int64_t)toPos image:(id)image {
    NSData *imageData = UIImageJPEGRepresentation(image,1);
//    FlutterStandardTypedData * fdata = [FlutterStandardTypedData typedDataWithBytes:imageData];
    self.eventSink(@{kAliPlayerMethod:@"onThumbnailGetSuccess",@"thumbnailRange":@[@(fromPos),@(toPos)],@"thumbnailbitmap":imageData,kAliPlayerId:_playerId});
}

/**
 @brief 获取缩略图失败回调
 @param positionMs 指定的缩略图位置
 */
- (void)onGetThumbnailFailed:(int64_t)positionMs {
    self.eventSink(@{kAliPlayerMethod:@"onThumbnailGetFail",kAliPlayerId:_playerId});
}

/**
 @brief 视频缓冲进度回调
 @param player 播放器player指针
 @param progress 缓存进度0-100
 */
- (void)onLoadingProgress:(AliPlayer*)player progress:(float)progress {
    self.eventSink(@{kAliPlayerMethod:@"onLoadingProgress",@"percent":@((int)progress),kAliPlayerId:_playerId});
}

/**
 @brief 当前下载速度回调
 @param player 播放器player指针
 @param speed bits per second
 */
- (void)onCurrentDownloadSpeed:(AliPlayer *)player speed:(int64_t)speed {
    self.eventSink(@{kAliPlayerMethod:@"onCurrentDownloadSpeed",@"speed":@(speed),kAliPlayerId:_playerId});
}

#pragma mark -- AVPEventReportParamsDelegate
/**
 @brief 回调
 @param params  埋点事件参数
 */
- (void)onEventReportParams:(NSDictionary<NSString *, NSString *>*)params {
    self.eventSink(@{kAliPlayerMethod:@"onEventReportParams",@"params":params,kAliPlayerId:_playerId});
}

#pragma mark -- AliPlayerPictureInPictureDelegate
/**
 * 画中画准备启动
 */
- (void)pictureInPictureControllerWillStartPictureInPicture {
    self.eventSink(@{kAliPlayerMethod:@"pipWillStart",kAliPlayerId:_playerId});
}

/**
 * 画中画已经启动
 */
- (void)pictureInPictureControllerDidStartPictureInPicture {
    self.eventSink(@{kAliPlayerMethod:@"pipDidStart",kAliPlayerId:_playerId});
}

/**
 * 画中画准备停止
 */
- (void)pictureInPictureControllerWillStopPictureInPicture {
    self.eventSink(@{kAliPlayerMethod:@"pipWillStop",kAliPlayerId:_playerId});
}

/**
 * 画中画已经停止
 */
- (void)pictureInPictureControllerDidStopPictureInPicture {
    self.eventSink(@{kAliPlayerMethod:@"pipDidStop",kAliPlayerId:_playerId});
}

-(void)bindPlayerView:(FlutterAliPlayerView*)fapv{
    _fapv = fapv;
    self.player.playerView = fapv.view;
}

- (void)timerAction {
    if ([_player isKindOfClass:AVPLiveTimeShift.class]) {
        AVPTimeShiftModel *timeShiftModel = ((AVPLiveTimeShift*)self.player).timeShiftModel;
        if (!timeShiftModel) {
            return;
        }
        self.eventSink(@{kAliPlayerMethod:@"onUpdater",@"currentTime":@((int)(timeShiftModel.currentTime)),@"shiftStartTime":@((int)(timeShiftModel.startTime)),@"shiftEndTime":@((int)(timeShiftModel.endTime)),kAliPlayerId:_playerId});
    }
}

- (void)dealloc
{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

#pragma --mark getters
- (AliPlayer *)player{
    if (!_player) {
        if (_playerType==1) {
            _player = [[AliListPlayer alloc] init];
            ((AliListPlayer*)_player).stsPreloadDefinition = @"FD";
        }else if(_playerType==2){
            _player = [[AVPLiveTimeShift alloc] init];
            _timer = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
            [_timer fire];
        }else{
            _player = [[AliPlayer alloc] init];
        }
        _player.scalingMode =  AVP_SCALINGMODE_SCALEASPECTFIT;
        _player.rate = 1;
        _player.delegate = self;
    }
    return _player;
}

@end
