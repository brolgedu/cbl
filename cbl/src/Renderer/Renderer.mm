#include "Renderer.h"

#include "GLFW/glfw3.h"

#ifndef GL_SILENCE_DEPRECATION
#define GL_SILENCE_DEPRECATION
#endif

void Renderer::Init() {
}

void Renderer::SetViewPort(uint32_t x, uint32_t y, uint32_t width, uint32_t height) {
    glViewport(x, y, width, height);
}

void Renderer::SetClearColor(const ImVec4 &color) {
    glClearColor(color.x, color.y, color.z, color.w);
}

void Renderer::Clear() {
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
}
