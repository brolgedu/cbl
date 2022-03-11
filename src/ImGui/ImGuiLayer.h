#pragma once

#include "Core/CBLLayer.h"
#include "Core/CBLEntryList.h"
#include "Core/CBLClipboard.h"

class ImGuiLayer : public CBLLayer {
public:
    ImGuiLayer(const std::string &name = "ImGuiLayer");
    ~ImGuiLayer();

    virtual void OnEvent(){};
    virtual void OnAttach();
    virtual void OnDetach();
    virtual void OnImGuiRender();
    virtual void SetDefaultTheme();

    void BeginImGuiDockSpace();
    void EndImGuiDockSpace();

    void Begin();
    void End();

private:
    std::string mName;
    // CBLEntryList *mEntryList;
    // CBLClipboard *mClipboard;
};

