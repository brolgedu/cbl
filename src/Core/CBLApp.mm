#include "imgui.h"

#include "CBLApp.h"
#include "CBLog.h"
#include "Renderer/Renderer.h"

@implementation CBLApp

static CBLApp *sInstance = nil;

- (id)init {
    @autoreleasepool {
        self = [super init];
        // Initialize variables
        CBLAssert(!sInstance, @"CBLApp already exists!");
        sInstance = self;

        mRunning = true;
        mWindow = CBLWindow::Create();

        mImGuiLayer = new ImGuiLayer();
        [self PushLayer:mImGuiLayer];

        return self;
    }
}

- (void)Run {
    ImVec4 clear_color = ImVec4(0.45f, 0.55f, 0.60f, 1.00f);
    Renderer::SetClearColor(clear_color);

    // Main loop
    while (mRunning) {

        mImGuiLayer->Begin();
        for (auto layer: mLayerStack) {
            layer->OnImGuiRender();
        }
        mImGuiLayer->End();

        mWindow->OnUpdate();
    }

    // Cleanup
    for (auto layer: mLayerStack) {
        layer->OnDetach();
    }
}

- (void)Close {
    mRunning = false;
}

- (void)PushLayer:(ImGuiLayer *)layer {
    mLayerStack.PushLayer(layer);
    layer->OnAttach();
}

- (void)PushOverlay:(ImGuiLayer *)layer {
    mLayerStack.PushOverlay(layer);
    layer->OnAttach();
}

+ (CBLApp *)Get {
    return sInstance;
}

- (CBLWindow *)GetWindow {
    return mWindow;
}

@end

// ==========================================
// Entry point
// ==========================================
int main(int, char **) {
    CBLApp *app = [[CBLApp alloc] init];
    [app Run];
    return 0;
}
