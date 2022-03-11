#include "CBLEditorLayer.h"
#include "Renderer/Renderer.h"

#include "Core/CBLApp.h"

#include "imgui.h"
#include "GLFW/glfw3.h"

CBLEditorLayer::CBLEditorLayer(const std::string &name)
        : ImGuiLayer(name) {
    mEntryList = [[CBLEntryList alloc] init];
}

CBLEditorLayer::~CBLEditorLayer() {
}

void CBLEditorLayer::OnAttach() {
}

void CBLEditorLayer::OnDetach() {
}

void CBLEditorLayer::OnImGuiRender() {
    OnEvent();

    static bool show_demo_window = false;
    if (show_demo_window) {
        ImGui::ShowDemoWindow(&show_demo_window);
    }

    static bool show_example_window = true;
    auto example_panel_flags = ImGuiWindowFlags_NoCollapse | ImGuiWindowFlags_None;
    ImGui::Begin("Example Panel", nullptr, example_panel_flags);
    ImGui::End();

    // Build the list and table
    ImGui::Begin("Entry Window");
    [mEntryList ShowTable];
    ImGui::End();
}

void CBLEditorLayer::OnEvent() {
    auto app = [CBLApp Get];
    GLFWwindow *window = (GLFWwindow *) [app GetWindow]->GetNativeWindow();
    // Testing input keys :: Works
    if (glfwGetKey(window, GLFW_KEY_ESCAPE)) {
        [app Close];
    }
}
