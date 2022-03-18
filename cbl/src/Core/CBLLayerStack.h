#pragma once

#include "Core.h"

#include "Core/CBLLayer.h"

class CBLLayerStack {
public:
    CBLLayerStack();
    ~CBLLayerStack();

    void PushLayer(CBLLayer *layer);
    void PushOverlay(CBLLayer *overlay);
    void PopLayer(CBLLayer *layer);
    void PopOverlay(CBLLayer *overlay);

    std::vector<CBLLayer *>::iterator begin() { return mLayers.begin(); }

    std::vector<CBLLayer *>::iterator end() { return mLayers.end(); }

private:
    std::vector<CBLLayer *> mLayers;
    unsigned int mLayerInsertIndex = 0;
};