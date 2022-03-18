#pragma once

#include "Core/Core.h"
#include "Core/CBLColor.h"

#include "Renderer/GraphicsContext.h"

#include "imgui.h"
#include <GLFW/glfw3.h>
#define GLFW_EXPOSE_NATIVE_COCOA
#include <GLFW/glfw3native.h>

#import <objc/runtime.h>
#include <string>


struct WindowProps {
    std::string Title;
    unsigned int Width;
    unsigned int Height;
    ImVec4 Color;

    WindowProps(const std::string &title = "CBL",
                unsigned int width = 1280,
                unsigned int height = 720,
                ImVec4 titleColor = CBL::GetColor(CBLCol_MenuBarBg))
            : Title(title), Width(width), Height(height), Color(titleColor) {}
};

class CBLWindow {
public:
    CBLWindow(const WindowProps &props);
    virtual ~CBLWindow();

    static CBLWindow *Create(const WindowProps &props = WindowProps());

    void SetVSync(bool enabled);
    void SetWindowTitleColor(GLFWwindow *window, ImVec4 &color);

    inline virtual void *GetNativeWindow() const { return mWindow; }

    inline unsigned int GetWidth() const { return mData.Width; }

    inline unsigned int GetHeight() const { return mData.Height; }

    void OnUpdate();

    bool IsVSync() const;
private:
    virtual void Init(const WindowProps &props);
    virtual void Shutdown();

private:
    GLFWwindow *mWindow;
    GraphicsContext *mContext;

    struct WindowData {
        WindowData() {}

        std::string Title;
        unsigned int Width, Height;
        ImVec4 Color;
        bool VSync;
    };

    WindowData mData;
};

