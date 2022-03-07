#include "ImGuiLayer.h"

#include "imgui_impl_glfw.h"
#import <imgui_impl_opengl3.h>
#include "GLFW/glfw3.h" // for glfwTerminate()

#include "Core/CBLApp.h"
#import "Renderer/Renderer.h"

ImGuiLayer::ImGuiLayer(const std::string &name) {
    mEntryList = [[CBLEntryList alloc] init];
    mClipboard = [[CBLClipboard alloc] init];
}

ImGuiLayer::~ImGuiLayer() {
}

void ImGuiLayer::OnAttach() {
    // Setup Dear ImGui context
    IMGUI_CHECKVERSION();
    ImGui::CreateContext();
    ImGuiIO &io = ImGui::GetIO();
    (void) io;
    io.ConfigFlags |= ImGuiConfigFlags_NavEnableKeyboard;        // Enable Keyboard controls
    io.ConfigFlags |= ImGuiConfigFlags_DockingEnable;            // Enable Docking
    io.ConfigFlags |= ImGuiConfigFlags_ViewportsEnable;          // Enable Multi-viewport / Platform windows

    // Setup Dear ImGui style
    ImGui::StyleColorsDark();

    // When viewports are enabled we tweak WindowRounding/WindowBg so platform windows can look identical to the style
    ImGuiStyle &style = ImGui::GetStyle();
    if (io.ConfigFlags & ImGuiConfigFlags_ViewportsEnable) {
        style.WindowRounding = 0.0f;
        style.Colors[ImGuiCol_WindowBg].w = 1.0f;
    }

    // Load Fonts
    io.Fonts->AddFontFromFileTTF("../assets/fonts/DroidSans.ttf", 16.0f);;

    CBLApp *app = [CBLApp Get];
    GLFWwindow *window = (GLFWwindow *) app.GetWindow->GetNativeWindow();

    // Setup Platform/Renderer bindings
    ImGui_ImplGlfw_InitForOpenGL(window, true);
    ImGui_ImplOpenGL3_Init("#version 410 core");

}

void ImGuiLayer::OnDetach() {
    ImGui_ImplOpenGL3_Shutdown();
    ImGui_ImplGlfw_Shutdown();
    ImGui::DestroyContext();
    glfwTerminate();
}

void ImGuiLayer::Begin() {
    ImGui_ImplOpenGL3_NewFrame();
    ImGui_ImplGlfw_NewFrame();
    ImGui::NewFrame();
}

void ImGuiLayer::End() {
    CBLApp *app = [CBLApp Get];
    ImGuiIO &io = ImGui::GetIO();
    io.DisplaySize = ImVec2(app.GetWindow->GetWidth(), app.GetWindow->GetHeight());

    // Rendering
    ImGui::Render();
    Renderer::SetViewPort(0, 0, app.GetWindow->GetWidth(), app.GetWindow->GetHeight());
    Renderer::Clear();
    ImGui_ImplOpenGL3_RenderDrawData(ImGui::GetDrawData());

    if (io.ConfigFlags & ImGuiConfigFlags_ViewportsEnable) {
        GLFWwindow *backup_current_context = glfwGetCurrentContext();
        ImGui::UpdatePlatformWindows();
        ImGui::RenderPlatformWindowsDefault();
        glfwMakeContextCurrent(backup_current_context);
    }
}

void ImGuiLayer::BeginImGuiDockSpace() {
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
        window_flags |= ImGuiWindowFlags_NoBringToFrontOnFocus |
                        ImGuiWindowFlags_NoNavFocus;
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

void ImGuiLayer::EndImGuiDockSpace() {
    ImGui::End();
}

void ImGuiLayer::OnImGuiRender() {
    auto app = [CBLApp Get];
    GLFWwindow *window = (GLFWwindow *) app.GetWindow->GetNativeWindow();

    // Check if the window has been closed
    if (glfwWindowShouldClose(window)) {
        [app Close];
        return;
    }

    // Enable ImGui Docking
    BeginImGuiDockSpace();

    static bool show_demo_window = true;
    if (show_demo_window) {
        ImGui::ShowDemoWindow(&show_demo_window);
    }

    if (ImGui::BeginMenuBar()) {
        if (ImGui::BeginMenu("File")) {
            if (ImGui::MenuItem("Exit")) {
                [app Close];
            }
            ImGui::EndMenu();
        }
        ImGui::EndMenuBar();
    }

    // Build the list and table
    ImGui::Begin("Entry List");
    NSString *clipboard_text = nil;
    NSString *timestamp = nil;
    if ([mClipboard UpdateClipboardText]) {
        timestamp = [[mClipboard GetTimeStamp] mutableCopy];
        clipboard_text = [[mClipboard GetClipboardText] mutableCopy];
        CBLEntryNode *node = [CBLEntryNode CreateEntryNode:timestamp :clipboard_text];
        [mEntryList AddNodeToEntries:node];
    }
    [mEntryList ShowTable];
    ImGui::End();

    // Testing input keys :: Works
    if (glfwGetKey(window, GLFW_KEY_ESCAPE)) {
        [app Close];
    }

    EndImGuiDockSpace();
}
