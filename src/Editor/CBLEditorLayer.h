#pragma once

#include "ImGui/ImGuiLayer.h"
#include "Core/CBLEntryList.h"
#include "Core/CBLClipboard.h"
#include "Core/CBLWindow.h"

class CBLEditorLayer : public ImGuiLayer {
public:
    CBLEditorLayer(const std::string &name = "Editor Layer");
    ~CBLEditorLayer();

    void OnEvent();
    virtual void OnAttach();
    virtual void OnDetach();
    virtual void OnImGuiRender();
private:
    CBLEntryList *mEntryList;
    CBLClipboard *mClipboard;
    CBLWindow* mWindow;
};


