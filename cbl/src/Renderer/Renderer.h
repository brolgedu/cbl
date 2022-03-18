#include "imgui.h"

class Renderer {
public:
    void Init();
    static void SetViewPort(uint32_t x, uint32_t y, uint32_t width, uint32_t height);
    static void SetClearColor(const ImVec4 &color);
    static void Clear();
};