#pragma once

#include "Core.h"

#include "ImGui/ImGuiLayer.h"

class CBLLayerStack {
public:
    CBLLayerStack();
    ~CBLLayerStack();

    void PushLayer(ImGuiLayer *layer);
    void PushOverlay(ImGuiLayer *overlay);
    void PopLayer(ImGuiLayer *layer);
    void PopOverlay(ImGuiLayer *overlay);

    std::vector<ImGuiLayer *>::iterator begin() { return mLayers.begin(); }

    std::vector<ImGuiLayer *>::iterator end() { return mLayers.end(); }

private:
    std::vector<ImGuiLayer *> mLayers;
    unsigned int mLayerInsertIndex = 0;
};