#import "CBLEntryList.h"

#import "ImGui/ImGuiLayer.h"

#import "Renderer/CBLColor.h"

@implementation CBLEntryList

- (id)init {
    @autoreleasepool {
        self = [super init];
        mClipboard = [[CBLClipboard alloc] init];
        mScrollToBottom = false;
        return self;
    }
}

- (bool)AddNodeToEntries:(CBLEntryNode *)entryNode {
    if (!entryNode) { return false; }
    mEntryNodes.push_back(entryNode);
    return true;
}

- (CBLEntryList *)GetEntryList {
    if (!self) { return [[CBLEntryList alloc] init]; }
    return (CBLEntryList *) self;
}

- (void)UpdateEntryList {
    if ([mClipboard UpdateClipboardText]) {
        NSString *timestamp = [[mClipboard GetTimeStamp] mutableCopy];
        NSString *clipboard_text = [[mClipboard GetClipboardText] mutableCopy];
        mScrollToBottom = ![self ContainsContents:clipboard_text];

        CBLEntryNode *node = [CBLEntryNode CreateEntryNode:timestamp :clipboard_text];
        [self AddNodeToEntries:node];
    }
}

- (bool)ContainsContents:(NSString *)contents {
    for (auto &node: mEntryNodes) {
        if ([[node GetContents] isEqualToString:contents]) {
            return true;
        }
    }
    return false;
}

- (void)SortEntries {
}

- (CBLEntryNode *)GetEntryAtIndex:(int)index {
    return mEntryNodes[index];
}

- (int)GetSize {
    return mEntryNodes.size();
}

- (std::vector<CBLEntryNode *>)GetNodes {
    return mEntryNodes;
}

- (void)ShowEntryTable {
    // Using those as a base value to create width/height that are factor of the size of our font
    const float TEXT_BASE_WIDTH = ImGui::CalcTextSize("A").x;
    const float TEXT_BASE_HEIGHT = ImGui::GetTextLineHeightWithSpacing();

    int freeze_cols = 0;
    int freeze_rows = 0;

    HelpMarker(
            "Text copied to the clipboard will be posted in the Entry List.\n"
            "Double-clicking a cell will copy that text to you clipboard.\n"
            "Right-clicking a cell will give you the option to copy or delete the text."
            "Pressing CMD+L will clear the entire list."
    );

    // Options
    static ImGuiTableFlags table_flags = ImGuiTableFlags_Borders | ImGuiTableFlags_BordersOuter |
                                         ImGuiTableFlags_BordersInner | ImGuiTableFlags_Reorderable |
                                         ImGuiTableFlags_RowBg | ImGuiTableFlags_ScrollY | ImGuiTableFlags_ScrollX;

    // Submit table
    if (ImGui::BeginTable("Entry Table", 2, table_flags, ImVec2(0, 0), 0.0f)) {
        // Declare columns
        // We use the "user_id" parameter of TableSetupColumn() to specify a user id that will be stored in the sort specifications.
        static ImGuiTableFlags timestamp_flags = ImGuiTableColumnFlags_NoSort | ImGuiTableColumnFlags_WidthFixed |
                                                 ImGuiTableColumnFlags_NoHide | ImGuiTableColumnFlags_NoHeaderLabel;
        static ImGuiTableFlags contents_flags = ImGuiTableColumnFlags_NoSort | ImGuiTableColumnFlags_WidthStretch;
        ImGui::TableSetupColumn("Timestamp", timestamp_flags, 0.0f, EntryNodeColumnID_Timestamp);
        ImGui::TableSetupColumn("Contents", contents_flags, 0.0f, EntryNodeColumnID_Contents);
        ImGui::TableSetupScrollFreeze(freeze_cols, freeze_rows);

        // Show headers
        // ImGui::TableHeadersRow();
        {
            // Set the scroll to the most recent entry (unless it has been added from the table either by double-clicking on selectable or copying/deleting from popup context menu
            if (mScrollToBottom) {
                ImGui::SetScrollY(ImGui::GetScrollMaxY());
            }
            mScrollToBottom = false;

            // Show table
            [self BuildEntryTable];
        }
        ImGui::EndTable();
    }
}

- (void)ClearTable {
    mEntryNodes.clear();
}

- (void)BuildEntryTable {

    // ======= Testing purposes only ======== //
    static bool enable_test = false;
    if (enable_test) {
        static bool called = false;
        if (!called) {
            [self PopulateRandomEntries];
            called = true;
        }
    }
    // ====================================== //

    // Begin function
    [self UpdateEntryList];
    float row_min_height = 0.0f; // Auto

    // Populate the table with data
    for (int row_n = 0; row_n < mEntryNodes.size(); row_n++) {

        CBLEntryNode *node = mEntryNodes[row_n];
        ImGui::PushID([node GetID]);
        ImGui::TableNextRow(ImGuiTableRowFlags_None, row_min_height);

        ImGui::TableSetColumnIndex(0);
        const char *timestamp = [[node GetTimestamp] UTF8String];
        ImGui::Text("%s", timestamp);

        if (ImGui::TableSetColumnIndex(1)) {
            const char *contents = [[node GetContents] UTF8String];
            const bool item_is_selected = [node IsSelected];

            // TODO: Wrap text w/in selectable
            if (ImGui::Selectable(contents, item_is_selected,
                                  ImGuiSelectableFlags_SpanAllColumns | ImGuiSelectableFlags_AllowDoubleClick,
                                  ImVec2(0, row_min_height))) {

                if (ImGui::IsMouseDoubleClicked(ImGuiMouseButton_Left)) {
                    [mClipboard SetClipboardText:contents];
                    mScrollToBottom = false;
                }
                [self ClearSelectedEntries];
                [node SetSelected:true];
            }

            // Popup menu when right-clicking hovered row
            if (ImGui::BeginPopupContextItem("entry_list_popup", ImGuiMouseButton_Right)) {
                // Deselect currently selected node
                [[self GetSelectedEntry] SetSelected:false];
                // Selected right-clicked entry
                [node SetSelected:true];
                if (ImGui::MenuItem("Copy")) {
                    [mClipboard SetClipboardText:contents];
                    mScrollToBottom = false;
                }
                if (ImGui::MenuItem("Delete")) { [self DeleteEntryNode:node]; }
                ImGui::EndPopup();
            }
        }
        ImGui::PopID();
    }
}

- (CBLEntryNode *)GetSelectedEntry {
    for (auto node: mEntryNodes) {
        if ([node IsSelected]) {
            return node;
        }
    }
    return nullptr;
}

- (void)DeleteEntryNode:(CBLEntryNode *)entryNode {
#pragma clang diagnostic push // Suppress typecheck bug with CLion IDE.
#pragma ide diagnostic ignored "err_typecheck_invalid_operands"
    for (auto it = mEntryNodes.end(); it >= mEntryNodes.begin(); --it) {
        if (*it == entryNode) {
            mEntryNodes.erase(it);
            return;
        }
    }
#pragma clang diagnostic pop
}

- (void)ClearSelectedEntries {
    for (auto node: mEntryNodes) {
        [node SetSelected:false];
    }
}


// ======= Testing purposes only ======================================================================== //
// ====================================================================================================== //
- (void)PopulateRandomEntries {
    std::vector<std::string>
            stringBank = {
            {"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."},
            {"porttitor eget dolor morbi non"},
            {"neque ornare aenean euismod elementum"},
            {"ac auctor augue mauris augue neque gravida in"},
            {"Lobortis mattis aliquam faucibus purus in massa tempor nec feugiat."},
            {"Faucibus in ornare quam viverra orci sagittis eu volutpat."}};

    for (std::string str: stringBank) {
        CBLEntryNode *node = [CBLEntryNode CreateEntryNode:[mClipboard GetTimeStamp]
                :[NSString stringWithUTF8String:str.c_str()]];
        mEntryNodes.push_back(node);
    }
}
// ====================================================================================================== //

@end

namespace ImGui {

    // This function will eventually allow for wrapped text w/in a selectable
    bool SelectableWrapped(const char *label, bool selected = false, ImGuiSelectableFlags flags = 0,
                           const ImVec2 &size = ImVec2(0, 0)) {
        // const float text_size = ImGui::CalcTextSize("A").x;
        //
        // Selectable("##hidden", selected, flags, ImVec2(text_size, size.y));

        // You might calc CalcTextSizeA() with wrapping setting to obtain a size,
        // use this size to create a Selectable() with an empty label (e.g. Selectable("##hidden", size))
        // then using ImDrawList->AddText() to render the text over it.
    }
}