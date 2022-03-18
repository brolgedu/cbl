#pragma once

class GLFWwindow;

class GraphicsContext {
public:
    GraphicsContext(GLFWwindow *windowHandle);

    void Init();
    void SwapBuffers();
private:
    GLFWwindow *mWindowHandle;
};
