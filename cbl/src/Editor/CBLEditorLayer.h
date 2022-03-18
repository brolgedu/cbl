#pragma once

#include "ImGui/ImGuiLayer.h"
#include "Core/CBLEntryList.h"
#include "Core/CBLClipboard.h"
#include "Core/CBLWindow.h"

#include "Renderer/CBLColor.h"

class CBLEditorLayer : public ImGuiLayer {
public:
    CBLEditorLayer(const std::string &name = "Editor Layer");
    ~CBLEditorLayer();

    void OnEvent();
    virtual void OnAttach();
    virtual void OnDetach();
    virtual void OnImGuiRender();
    virtual void OnUpdate();

    void BeginImGuiDockSpace();
    void EndImGuiDockSpace();

    void ShowEntryWindow(bool* p_open);
    void ShowStatusPanel(bool* p_open);
    void ShowExamplePanel(bool* p_open);

    bool IsKeyPressed(int key);

private:
    CBLEntryList *mEntryList;
    CBLClipboard *mClipboard;
    CBLWindow* mWindow;
};


