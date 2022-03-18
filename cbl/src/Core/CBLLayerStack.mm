#include "CBLLayerStack.h"

CBLLayerStack::CBLLayerStack() {
}

CBLLayerStack::~CBLLayerStack() {
    for (CBLLayer *layer: mLayers) {
        delete layer;
    }
}

void CBLLayerStack::PushLayer(CBLLayer *layer) {
    mLayers.emplace(mLayers.begin() + mLayerInsertIndex, layer);
    ++mLayerInsertIndex;
}

void CBLLayerStack::PushOverlay(CBLLayer *overlay) {
    mLayers.emplace_back(overlay);
}

void CBLLayerStack::PopLayer(CBLLayer *layer) {
    auto it = std::find(mLayers.begin(), mLayers.end(), layer);
    if (it != mLayers.end()) {
        mLayers.erase(it);
        --mLayerInsertIndex;
    }
}

void CBLLayerStack::PopOverlay(CBLLayer *overlay) {
    auto it = std::find(mLayers.begin(), mLayers.end(), overlay);
    if (it != mLayers.end()) {
        mLayers.erase(it);
    }
}
