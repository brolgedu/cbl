#include "GraphicsContext.h"

#include "Core/Core.h"
#include "Core/CBLog.h"

#include <GLFW/glfw3.h>

GraphicsContext::GraphicsContext(GLFWwindow *windowHandle)
        : mWindowHandle(windowHandle) {
    CBLAssert(windowHandle, @"Window Handle is null!")
}

void GraphicsContext::Init() {
    glfwMakeContextCurrent(mWindowHandle);
}

void GraphicsContext::SwapBuffers() {
    glfwSwapBuffers(mWindowHandle);
}
