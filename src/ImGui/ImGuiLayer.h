#pragma once

#include "Core/CBLEntryList.h"
#include "Core/CBLClipboard.h"

class ImGuiLayer {
public:
    ImGuiLayer(const std::string &name = "ImGuiLayer");
    ~ImGuiLayer();

    void OnAttach();
    void OnDetach();
    void OnImGuiRender();

    void BeginImGuiDockSpace();
    void EndImGuiDockSpace();

    void Begin();
    void End();

private:
    CBLEntryList* mEntryList;
    CBLClipboard* mClipboard;
};

