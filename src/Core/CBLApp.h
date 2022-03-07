#pragma once

#import "ImGui/ImGuiLayer.h"

#include "Core/Core.h"
#include "Core/CBLWindow.h"
#include "Core/CBLLayerStack.h"

#ifdef __cplusplus
extern "C" {
#endif

@interface CBLApp : NSObject {
    CBLWindow* mWindow;
    GraphicsContext* mContext;
    ImGuiLayer *mImGuiLayer;
    bool mRunning;
    bool mMinimized;

    CBLLayerStack mLayerStack;
}
@property(nonatomic, strong) CBLApp *sInstance;

- (id)init;

- (void)Run;
- (void)Close;

- (void)PushLayer:(ImGuiLayer *)layer;
- (void)PushOverlay:(ImGuiLayer *)layer;

+ (CBLApp *)Get;

- (CBLWindow*)GetWindow;

@end

#ifdef __cplusplus
}
#endif