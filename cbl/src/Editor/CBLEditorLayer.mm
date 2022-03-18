#include "CBLEditorLayer.h"
#include "Renderer/Renderer.h"

#include "Core/CBLApp.h"

#include "Core/CBLKeyCodes.h"

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

void CBLEditorLayer::OnUpdate() {
    // Render
    Renderer::SetClearColor(CBL::GetColor(CBLCol_WindowBg)); // Background color
    Renderer::Clear();
}

void CBLEditorLayer::OnImGuiRender() {
    static bool show_demo_window = false;
    static bool show_entry_window = true;
    static bool show_status_panel = false;
    static bool show_example_panel = false;

    auto app = [CBLApp Get];
    GLFWwindow *window = (GLFWwindow *) app.GetWindow->GetNativeWindow();

    // Check if the window has been closed
    if (glfwWindowShouldClose(window)) {
        [app Close];
        return;
    }

    // Check for events
    OnEvent();

    // Enable ImGui Docking
    BeginImGuiDockSpace();

    if (ImGui::BeginMenuBar()) {
        if (ImGui::BeginMenu("File")) {
            if (ImGui::MenuItem("Exit")) {
                [app Close];
            }
            ImGui::EndMenu();
        }
        if (ImGui::BeginMenu("View")) {
            if (ImGui::MenuItem("Show Entry List")) {
                if (!show_entry_window) {
                    show_entry_window = true;
                }
            }
            ImGui::EndMenu();
        }
        ImGui::EndMenuBar();
    }

    if (show_demo_window) {
        ImGui::ShowDemoWindow(&show_demo_window);
    }

    if (show_entry_window) {
        ShowEntryWindow(&show_entry_window);
    }
    if (show_status_panel) {
        ShowStatusPanel(&show_status_panel);
    }
    if (show_example_panel) {
        ShowExamplePanel(&show_example_panel);
    }

    EndImGuiDockSpace();
}

void CBLEditorLayer::OnEvent() {
    auto app = [CBLApp Get];

    if (IsKeyPressed(CBL_KEY_L)) {
        if (IsKeyPressed(CBL_KEY_LEFT_CONTROL)) {
            [mEntryList ClearTable];
        };
    }
}

void CBLEditorLayer::ShowExamplePanel(bool *p_open) {
    auto example_panel_flags = ImGuiWindowFlags_NoCollapse | ImGuiWindowFlags_None;
    ImGui::Begin("Example Panel", p_open, example_panel_flags);
    ImGui::End();
}

void CBLEditorLayer::ShowEntryWindow(bool *p_open) {
    // Build the list and table
    ImGui::Begin("Entry Window", p_open);
    [mEntryList ShowEntryTable];
    ImGui::End();
};

void CBLEditorLayer::ShowStatusPanel(bool *p_open) {
    ImGui::Begin("Status Panel", p_open);
    if (![mClipboard HasTextChanged]) {
        ImGui::TextWrapped("%s", [[mClipboard GetClipboardText] UTF8String]);
    }
    ImGui::End();
}

void CBLEditorLayer::BeginImGuiDockSpace() {
    static bool dockspaceOpen = true;
    static bool opt_fullscreen = true;
    static ImGuiDockNodeFlags dockspace_flags = ImGuiDockNodeFlags_None | ImGuiDockNodeFlags_PassthruCentralNode;

    // We are using the ImGuiWindowFlags_NoDocking flag to make the parent window not dockable into,
    // because it would be confusing to have two docking targets within each others.
    ImGuiWindowFlags window_flags = ImGuiWindowFlags_MenuBar | ImGuiWindowFlags_NoDocking;
    if (opt_fullscreen) {
        const ImGuiViewport *viewport = ImGui::GetMainViewport();
        ImGui::SetNextWindowPos(viewport->WorkPos);
        ImGui::SetNextWindowSize(viewport->WorkSize);
        ImGui::SetNextWindowViewport(viewport->ID);
        ImGui::PushStyleVar(ImGuiStyleVar_WindowRounding, 0.0f);
        ImGui::PushStyleVar(ImGuiStyleVar_WindowBorderSize, 0.0f);
        window_flags |= ImGuiWindowFlags_NoTitleBar | ImGuiWindowFlags_NoCollapse | ImGuiWindowFlags_NoResize |
                        ImGuiWindowFlags_NoMove;
        window_flags |= ImGuiWindowFlags_NoBringToFrontOnFocus | ImGuiWindowFlags_NoNavFocus;
    } else {
        dockspace_flags &= ~ImGuiDockNodeFlags_PassthruCentralNode;
    }

    // When using ImGuiDockNodeFlags_PassthruCentralNode, DockSpace() will render our background
    // and handle the pass-thru hole, so we ask Begin() to not render a background.
    if (dockspace_flags & ImGuiDockNodeFlags_PassthruCentralNode) {
        window_flags |= ImGuiWindowFlags_NoBackground;
    }

    ImGui::PushStyleVar(ImGuiStyleVar_WindowPadding, ImVec2(0.0f, 0.0f));
    ImGui::Begin("DockSpace", &dockspaceOpen, window_flags);
    ImGui::PopStyleVar();

    if (opt_fullscreen) {
        ImGui::PopStyleVar(2);
    }

    // Submit the DockSpace
    ImGuiIO &io = ImGui::GetIO();
    if (io.ConfigFlags & ImGuiConfigFlags_DockingEnable) {
        ImGuiID dockspace_id = ImGui::GetID("MyDockSpace");
        ImGui::DockSpace(dockspace_id, ImVec2(0.0f, 0.0f), dockspace_flags);
    }
}

void CBLEditorLayer::EndImGuiDockSpace() {
    ImGui::End();
}

bool CBLEditorLayer::IsKeyPressed(int key) {
    auto app = [CBLApp Get];
    GLFWwindow *window = (GLFWwindow *) [app GetWindow]->GetNativeWindow();
    return glfwGetKey(window, key);
}
