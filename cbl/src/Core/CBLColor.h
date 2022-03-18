#pragma once

#include <unordered_map>
#include <imgui.h>

enum Color {
    CBLCol_Text = 0,
    CBLCol_TextDisabled,
    CBLCol_WindowBg,              // Background of normal windows
    CBLCol_ChildBg,               // Background of child windows
    CBLCol_PopupBg,               // Background of popups, menus, tooltips windows
    CBLCol_Border,
    CBLCol_BorderShadow,
    CBLCol_FrameBg,               // Background of checkbox, radio button, plot, slider, text input
    CBLCol_FrameBgHovered,
    CBLCol_FrameBgActive,
    CBLCol_TitleBg,
    CBLCol_TitleBgActive,
    CBLCol_TitleBgCollapsed,
    CBLCol_MenuBarBg,
    CBLCol_ScrollbarBg,
    CBLCol_ScrollbarGrab,
    CBLCol_ScrollbarGrabHovered,
    CBLCol_ScrollbarGrabActive,
    CBLCol_CheckMark,
    CBLCol_SliderGrab,
    CBLCol_SliderGrabActive,
    CBLCol_Button,
    CBLCol_ButtonHovered,
    CBLCol_ButtonActive,
    CBLCol_Header,                // Header* colors are used for CollapsingHeader, TreeNode, Selectable, MenuItem
    CBLCol_HeaderHovered,
    CBLCol_HeaderActive,
    CBLCol_Separator,
    CBLCol_SeparatorHovered,
    CBLCol_SeparatorActive,
    CBLCol_ResizeGrip,
    CBLCol_ResizeGripHovered,
    CBLCol_ResizeGripActive,
    CBLCol_Tab,
    CBLCol_TabHovered,
    CBLCol_TabActive,
    CBLCol_TabUnfocused,
    CBLCol_TabUnfocusedActive,
    CBLCol_DockingPreview,        // Preview overlay color when about to docking something
    CBLCol_DockingEmptyBg,        // Background color for empty node (e.g. CentralNode with no window docked into it)
    CBLCol_PlotLines,
    CBLCol_PlotLinesHovered,
    CBLCol_PlotHistogram,
    CBLCol_PlotHistogramHovered,
    CBLCol_TableHeaderBg,         // Table header background
    CBLCol_TableBorderStrong,     // Table outer and header borders (prefer using Alpha=1.0 here)
    CBLCol_TableBorderLight,      // Table inner borders (prefer using Alpha=1.0 here)
    CBLCol_TableRowBg,            // Table row background (even rows)
    CBLCol_TableRowBgAlt,         // Table row background (odd rows)
    CBLCol_TextSelectedBg,
    CBLCol_DragDropTarget,
    CBLCol_NavHighlight,          // Gamepad/keyboard: current highlighted item
    CBLCol_NavWindowingHighlight, // Highlight window when using CTRL+TAB
    CBLCol_NavWindowingDimBg,     // Darken/colorize entire screen behind the CTRL+TAB window list, when active
    CBLCol_ModalWindowDimBg      // Darken/colorize entire screen behind a modal window, when one is active
};

namespace CBL {

static ImVec4 GetColorsFromBits(int x, int y, int z, int w = 255) {
    return {(float) x / 255, (float) y / 255, (float) z / 255, (float) w / 255};
}

struct ThemeColors {
    ImVec4 BlackColor                   = GetColorsFromBits(29, 32, 36);
    ImVec4 WhiteColor                   = GetColorsFromBits(246, 246, 246, 252);
    ImVec4 PrimaryColor                 = GetColorsFromBits(57, 63, 71);
    ImVec4 SecondaryColorDark           = GetColorsFromBits(64, 75, 92);
    ImVec4 SecondaryColorLight          = GetColorsFromBits(66, 83, 112);
    ImVec4 AccentColor                  = GetColorsFromBits(130, 162, 216);
    ImVec4 AccentHovered                = GetColorsFromBits(130, 162, 216, 140);
};
static ThemeColors ThemeColors;

static std::unordered_map<Color, ImVec4> CBLColors = {
        {CBLCol_WindowBg,             ThemeColors.PrimaryColor},
        {CBLCol_PopupBg,              ThemeColors.PrimaryColor},
        {CBLCol_FrameBg,              ThemeColors.SecondaryColorLight},
        {CBLCol_FrameBgHovered,       ThemeColors.AccentHovered},
        {CBLCol_FrameBgActive,        ThemeColors.SecondaryColorLight},
        {CBLCol_TitleBg,              ThemeColors.PrimaryColor},
        {CBLCol_TitleBgActive,        ThemeColors.PrimaryColor},
        {CBLCol_MenuBarBg,            ThemeColors.PrimaryColor},
        {CBLCol_ScrollbarBg,          ThemeColors.WhiteColor},
        {CBLCol_ScrollbarGrab,        ThemeColors.SecondaryColorDark},
        {CBLCol_ScrollbarGrabHovered, ThemeColors.AccentColor},
        {CBLCol_ScrollbarGrabActive,  ThemeColors.SecondaryColorDark},
        {CBLCol_CheckMark,            ThemeColors.AccentColor},
        {CBLCol_SliderGrab,           ThemeColors.AccentColor},
        {CBLCol_SliderGrabActive,     ThemeColors.AccentColor},
        {CBLCol_Button,               ThemeColors.SecondaryColorLight},
        {CBLCol_ButtonHovered,        ThemeColors.AccentHovered},
        {CBLCol_ButtonActive,         ThemeColors.SecondaryColorLight},
        {CBLCol_Header,               ThemeColors.SecondaryColorLight},
        {CBLCol_HeaderHovered,        ThemeColors.AccentHovered},
        {CBLCol_HeaderActive,         ThemeColors.SecondaryColorLight},
        {CBLCol_Separator,            GetColorsFromBits(127, 128, 129, 42)},
        {CBLCol_SeparatorHovered,     GetColorsFromBits(29, 32, 36, 113)},
        {CBLCol_SeparatorActive,      GetColorsFromBits(127, 128, 129, 42)},
        {CBLCol_Tab,                  ThemeColors.PrimaryColor},
        {CBLCol_TabHovered,           ThemeColors.AccentHovered},
        {CBLCol_TabActive,            ThemeColors.SecondaryColorLight},
        {CBLCol_TabUnfocused,         GetColorsFromBits(57, 63, 71, 255)},
        {CBLCol_TabUnfocusedActive,   GetColorsFromBits(40, 43, 46, 107)},
        {CBLCol_DockingPreview,       ThemeColors.AccentHovered},
        {CBLCol_DockingEmptyBg,       ThemeColors.PrimaryColor},
        {CBLCol_TableHeaderBg,        ThemeColors.SecondaryColorLight},
        {CBLCol_TableBorderStrong,    ThemeColors.BlackColor},
        {CBLCol_TableBorderLight,     GetColorsFromBits(127, 128, 129, 30)},
        {CBLCol_TableRowBg,           GetColorsFromBits(64, 75, 92, 150)},
        // {CBLCol_TableRowBgAlt,        GetColorsFromBits(64, 75, 92, 150)},
        {CBLCol_TextSelectedBg,       GetColorsFromBits(ThemeColors.BlackColor.x, ThemeColors.BlackColor.y,
                                                        ThemeColors.BlackColor.z, 170)}
};

static ImVec4 &GetColor(Color color) {
    return CBLColors[color];
}

};