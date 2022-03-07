#pragma once

#include "Core/Core.h"
#include "Renderer/GraphicsContext.h"

struct WindowProps {
    std::string Title;
    unsigned int Width;
    unsigned int Height;

    WindowProps(const std::string &title = "CBL: CMD+C List",
                unsigned int width = 1280,
                unsigned int height = 720)
            : Title(title), Width(width), Height(height) {}
};

class CBLWindow {
public:
    CBLWindow(const WindowProps &props);
    virtual ~CBLWindow();

    void OnUpdate();

    inline unsigned int GetWidth() const { return mData.Width; }

    inline unsigned int GetHeight() const { return mData.Height; }

    void SetVSync(bool enabled);
    bool IsVSync() const;

    inline virtual void *GetNativeWindow() const { return mWindow; }

    static CBLWindow *Create(const WindowProps &props = WindowProps());

private:
    virtual void Init(const WindowProps &props);
    virtual void Shutdown();
private:
    GLFWwindow *mWindow;
    GraphicsContext *mContext;

    struct WindowData {
        std::string Title;
        unsigned int Width, Height;
        bool VSync;
    };

    WindowData mData;
};

