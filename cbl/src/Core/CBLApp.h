#pragma once

#import "Core/CBLLayer.h"
#import "ImGui/ImGuiLayer.h"

#include "Core/Core.h"
#include "Core/CBLWindow.h"
#include "Core/CBLLayerStack.h"

#include "Editor/CBLEditorLayer.h"

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