#pragma once

#include "Core/CBLColor.h"
#include "Core/CBLWindow.h"
#include "Core/CBLClipboard.h"

#include "ImGui/ImGuiLayer.h"
#include "Panels/CBLEntryList.h"


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
    void ShowTextEditorWindow(bool *p_open);
    // void ShowHelpWindow(bool *p_open);

    bool IsKeyPressed(int key);
private:
    CBLEntryList *mEntryList;
    CBLClipboard *mClipboard;
    CBLWindow* mWindow;
};


