#include "CBLLayerStack.h"

CBLLayerStack::CBLLayerStack() {
}

CBLLayerStack::~CBLLayerStack() {
    for (ImGuiLayer *layer: mLayers) {
        delete layer;
    }
}

void CBLLayerStack::PushLayer(ImGuiLayer *layer) {
    mLayers.emplace(mLayers.begin() + mLayerInsertIndex, layer);
    ++mLayerInsertIndex;
}

void CBLLayerStack::PushOverlay(ImGuiLayer *overlay) {
    mLayers.emplace_back(overlay);
}

void CBLLayerStack::PopLayer(ImGuiLayer *layer) {
    auto it = std::find(mLayers.begin(), mLayers.end(), layer);
    if (it != mLayers.end()) {
        mLayers.erase(it);
        --mLayerInsertIndex;
    }
}

void CBLLayerStack::PopOverlay(ImGuiLayer *overlay) {
    auto it = std::find(mLayers.begin(), mLayers.end(), overlay);
    if (it != mLayers.end()) {
        mLayers.erase(it);
    }
}
