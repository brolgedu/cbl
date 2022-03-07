#include "CBLWindow.h"

#import "CBLog.h"

#define GL_SILENCE_DEPRECATION
#include <GLFW/glfw3.h> // Will drag system OpenGL headers
#include "imgui_impl_glfw.h"
#if defined(IMGUI_IMPL_OPENGL_ES2)
#include <GLES2/gl2.h>
#endif

static bool sGLFWInitialized = false;

static void GlfwErrorCallback(int error, const char *description) {
    fprintf(stderr, "Glfw Error %d: %s\n", error, description);
}

CBLWindow::CBLWindow(const WindowProps &props) { Init(props); }

CBLWindow::~CBLWindow() { Shutdown(); }

CBLWindow *CBLWindow::Create(const WindowProps &props) { return new CBLWindow(props); }

void CBLWindow::Init(const WindowProps &props) {
    mData.Title = props.Title;
    mData.Width = props.Width;
    mData.Height = props.Height;

    CBLog(@"Creating window %s, %d, %d)", props.Title.c_str(), props.Width, props.Height);

    if (!sGLFWInitialized) {
        int success = glfwInit();
        CBLAssert(success, @"Could not initialize GLFW!");

        glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, true);
        glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 4);
        glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 1);
        glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
        glfwSetErrorCallback(GlfwErrorCallback);

        sGLFWInitialized = true;
    }

    mWindow = glfwCreateWindow(static_cast<int>(mData.Width),
                               static_cast<int>(mData.Height),
                               mData.Title.c_str(), nullptr, nullptr);

    mContext = new GraphicsContext(mWindow);
    mContext->Init();
    SetVSync(true);
}


void CBLWindow::Shutdown() { glfwDestroyWindow(mWindow); }

void CBLWindow::OnUpdate() {
    glfwPollEvents();
    mContext->SwapBuffers();
}

void CBLWindow::SetVSync(bool enabled) {
    if (enabled) {
        glfwSwapInterval(1);
    } else {
        glfwSwapInterval(0);
    }

    mData.VSync = enabled;
}

bool CBLWindow::IsVSync() const { return mData.VSync; }
