#pragma once

#import "Core/Core.h"
#import "Core/CBLLayer.h"
#import "Core/CBLWindow.h"
#import "Core/CBLLayerStack.h"

#import "ImGui/ImGuiLayer.h"
#import "Editor/CBLEditorLayer.h"

#ifdef __cplusplus
extern "C" {
#endif

@interface CBLApp : NSObject {

    CBLWindow* mWindow;
    GraphicsContext* mContext;

    ImGuiLayer *mImGuiLayer;
    CBLLayerStack mLayerStack;
    CBLEditorLayer *mEditorLayer;

    bool mRunning;
    bool mMinimized;
}
@property(nonatomic, strong) CBLApp *sInstance;

- (id)init;

+ (CBLApp *)Get;

- (void)Run;
- (void)Close;

- (void)PushLayer:(CBLLayer *)layer;
- (void)PushOverlay:(CBLLayer *)layer;

- (CBLWindow*)GetWindow;
-(bool)WindowMinimized;


@end

#ifdef __cplusplus
}
#endif