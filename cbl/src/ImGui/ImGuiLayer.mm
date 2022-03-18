#include "ImGuiLayer.h"

#include "imgui_impl_glfw.h"
#import <imgui_impl_opengl3.h>
#include "GLFW/glfw3.h" // for glfwTerminate()

#include "Core/CBLApp.h"

ImGuiLayer::ImGuiLayer(const std::string &name)
        : mName(name) {
}

ImGuiLayer::~ImGuiLayer() {
}

void ImGuiLayer::OnAttach() {
    // Setup Dear ImGui context
    IMGUI_CHECKVERSION();
    ImGui::CreateContext();
    ImGuiIO &io = ImGui::GetIO();
    (void) io;
    io.IniFilename = "../cbl/config/imgui.ini";
    io.ConfigFlags |= ImGuiConfigFlags_NavEnableKeyboard;        // Enable Keyboard controls
    io.ConfigFlags |= ImGuiConfigFlags_DockingEnable;            // Enable Docking
    io.ConfigFlags |= ImGuiConfigFlags_ViewportsEnable;          // Enable Multi-viewport / Platform windows

    // Setup Dear ImGui style
    // ImGui::StyleColorsClassic();
    // ImGui::StyleColorsDark();
    SetSlateBlueTheme();

    // When viewports are enabled we tweak WindowRounding/WindowBg so platform windows can look identical to the style
    ImGuiStyle &style = ImGui::GetStyle();
    if (io.ConfigFlags & ImGuiConfigFlags_ViewportsEnable) {
        style.WindowRounding = 0.0f;
        style.Colors[ImGuiCol_WindowBg].w = 1.0f;
    }

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
    ImGui_ImplOpenGL3_RenderDrawData(ImGui::GetDrawData());

    if (io.ConfigFlags & ImGuiConfigFlags_ViewportsEnable) {
        GLFWwindow *backup_current_context = glfwGetCurrentContext();
        ImGui::UpdatePlatformWindows();
        ImGui::RenderPlatformWindowsDefault();
        glfwMakeContextCurrent(backup_current_context);
    }
}

void ImGuiLayer::OnImGuiRender() {
}

void ImGuiLayer::SetSlateBlueTheme() {
    auto &io = ImGui::GetIO();
    io.Fonts->AddFontFromFileTTF("../cbl/assets/fonts/FallingSkyBold-zemL.otf", 18.0f);

    // Set window title color
    CBLApp *app = [CBLApp Get];
    GLFWwindow *window = (GLFWwindow *) app.GetWindow->GetNativeWindow();
    app.GetWindow->SetWindowTitleColor(window, CBL::GetColor(CBLCol_MenuBarBg));

    // Set theme colors
    auto &style = ImGui::GetStyle();
    ImVec4 *colors = style.Colors;
    colors[ImGuiCol_WindowBg] = CBL::GetColor(CBLCol_WindowBg);
    colors[ImGuiCol_ChildBg] = CBL::GetColor(CBLCol_ChildBg);
    colors[ImGuiCol_PopupBg] = CBL::GetColor(CBLCol_PopupBg);
    colors[ImGuiCol_FrameBg] = CBL::GetColor(CBLCol_FrameBg);
    colors[ImGuiCol_FrameBgHovered] = CBL::GetColor(CBLCol_FrameBgHovered);
    colors[ImGuiCol_FrameBgActive] = CBL::GetColor(CBLCol_FrameBgActive);
    colors[ImGuiCol_TitleBg] = CBL::GetColor(CBLCol_TitleBg);
    colors[ImGuiCol_TitleBgActive] = CBL::GetColor(CBLCol_TitleBgActive);
    colors[ImGuiCol_MenuBarBg] = CBL::GetColor(CBLCol_MenuBarBg);
    colors[ImGuiCol_ScrollbarBg] = CBL::GetColor(CBLCol_ScrollbarBg);
    colors[ImGuiCol_ScrollbarGrab] = CBL::GetColor(CBLCol_ScrollbarGrab);
    colors[ImGuiCol_ScrollbarGrabHovered] = CBL::GetColor(CBLCol_ScrollbarGrabHovered);
    colors[ImGuiCol_ScrollbarGrabActive] = CBL::GetColor(CBLCol_ScrollbarGrabActive);
    colors[ImGuiCol_CheckMark] = CBL::GetColor(CBLCol_CheckMark);
    colors[ImGuiCol_SliderGrab] = CBL::GetColor(CBLCol_SliderGrab);
    colors[ImGuiCol_SliderGrabActive] = CBL::GetColor(CBLCol_SliderGrabActive);
    colors[ImGuiCol_Button] = CBL::GetColor(CBLCol_Button);
    colors[ImGuiCol_ButtonHovered] = CBL::GetColor(CBLCol_ButtonHovered);
    colors[ImGuiCol_ButtonActive] = CBL::GetColor(CBLCol_ButtonActive);
    colors[ImGuiCol_Header] = CBL::GetColor(CBLCol_Header);
    colors[ImGuiCol_HeaderHovered] = CBL::GetColor(CBLCol_HeaderHovered);
    colors[ImGuiCol_HeaderActive] = CBL::GetColor(CBLCol_HeaderActive);
    colors[ImGuiCol_Separator] = CBL::GetColor(CBLCol_Separator);
    colors[ImGuiCol_SeparatorHovered] = CBL::GetColor(CBLCol_SeparatorHovered);
    colors[ImGuiCol_SeparatorActive] = CBL::GetColor(CBLCol_SeparatorActive);
    colors[ImGuiCol_Tab] = CBL::GetColor(CBLCol_Tab);
    colors[ImGuiCol_TabHovered] = CBL::GetColor(CBLCol_TabHovered);
    colors[ImGuiCol_TabActive] = CBL::GetColor(CBLCol_TabActive);
    colors[ImGuiCol_TabUnfocused] = CBL::GetColor(CBLCol_TabUnfocused);
    colors[ImGuiCol_TabUnfocusedActive] = CBL::GetColor(CBLCol_TabUnfocusedActive);
    colors[ImGuiCol_DockingPreview] = CBL::GetColor(CBLCol_DockingPreview);
    colors[ImGuiCol_DockingEmptyBg] = CBL::GetColor(CBLCol_DockingEmptyBg);
    colors[ImGuiCol_TableHeaderBg] = CBL::GetColor(CBLCol_TableHeaderBg);
    colors[ImGuiCol_TableBorderStrong] = CBL::GetColor(CBLCol_TableBorderStrong);
    colors[ImGuiCol_TableBorderLight] = CBL::GetColor(CBLCol_TableBorderLight);
    colors[ImGuiCol_TableRowBg] = CBL::GetColor(CBLCol_TableRowBg);
    colors[ImGuiCol_TableRowBgAlt] = CBL::GetColor(CBLCol_TableRowBgAlt);
    colors[ImGuiCol_TextSelectedBg] = CBL::GetColor(CBLCol_TextSelectedBg);

    style.TabBorderSize = 1.0f;
    style.CellPadding = {12.0f, 6.0f};
    style.WindowRounding = 1.0f;
    style.ChildRounding = 1.0f;
    style.FrameRounding = 1.0f;
    style.GrabRounding = 1.0f;
    style.PopupRounding = 1.0f;
    style.ScrollbarRounding = 1.0f;
    style.TabRounding = 5.0f;
}
