#pragma once

#include "Core/CBLLayer.h"
#include "Core/CBLClipboard.h"

#include "imgui.h"

static void HelpMarker(const char *desc) {
    ImGui::TextDisabled("(?)");
    if (ImGui::IsItemHovered()) {
        ImGui::BeginTooltip();
        ImGui::PushTextWrapPos(ImGui::GetFontSize() * 35.0f);
        ImGui::TextUnformatted(desc);
        ImGui::PopTextWrapPos();
        ImGui::EndTooltip();
    }
}

class ImGuiLayer : public CBLLayer {
public:
    ImGuiLayer(const std::string &name = "ImGuiLayer");
    ~ImGuiLayer();

    virtual void OnEvent() {};
    virtual void OnAttach();
    virtual void OnDetach();
    virtual void OnImGuiRender();
    virtual void SetSlateBlueTheme();

    void Begin();
    void End();
private:
    std::string mName;
};

