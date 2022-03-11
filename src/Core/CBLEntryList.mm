#import "CBLEntryList.h"

@implementation CBLEntryList

- (id)init {
    @autoreleasepool {
        self = [super init];
        mClipboard = [[CBLClipboard alloc] init];
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

- (void)UpdateList {
    if ([mClipboard UpdateClipboardText]) {
        NSString *timestamp = [[mClipboard GetTimeStamp] mutableCopy];
        NSString *clipboard_text = [[mClipboard GetClipboardText] mutableCopy];
        CBLEntryNode *node = [CBLEntryNode CreateEntryNode:timestamp :clipboard_text];
        [self AddNodeToEntries:node];
    }
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


- (void)ShowTable {
    // Using those as a base value to create width/height that are factor of the size of our font
    const float TEXT_BASE_WIDTH = ImGui::CalcTextSize("A").x;
    const float TEXT_BASE_HEIGHT = ImGui::GetTextLineHeightWithSpacing();

    int freeze_cols = 1;
    int freeze_rows = 1;

    // Options
    static ImGuiTableFlags flags = ImGuiTableFlags_Resizable | ImGuiTableFlags_Reorderable | ImGuiTableFlags_RowBg |
                                   ImGuiTableFlags_NoBordersInBody | ImGuiTableFlags_ScrollY;

    // Submit table
    if (ImGui::BeginTable("Entry Table", 2, flags, ImVec2(0, 0), 0.0f)) {
        // Declare columns
        // We use the "user_id" parameter of TableSetupColumn() to specify a user id that will be stored in the sort specifications.
        ImGui::TableSetupColumn("Timestamp", ImGuiTableColumnFlags_NoSort | ImGuiTableColumnFlags_WidthFixed |
                                             ImGuiTableColumnFlags_NoHide, 0.0f, EntryNodeColumnID_Timestamp);
        static ImGuiTableFlags contents_flags = ImGuiTableColumnFlags_NoSort | ImGuiTableColumnFlags_WidthStretch;
        ImGui::TableSetupColumn("Contents", contents_flags, 0.0f, EntryNodeColumnID_Contents);
        ImGui::TableSetupScrollFreeze(freeze_cols, freeze_rows);

        // Show headers
        ImGui::TableHeadersRow();
        {
            [self PopulateTable];
        }
        ImGui::EndTable();
    }
}

- (void)PopulateTable {

    // ======= Testing purposes only ======== //
    static bool called = false;
    if (!called) {
        [self PopulateRandomEntries];
        called = true;
    }
    // ====================================== //

    // Begin function
    [self UpdateList];
    float row_min_height = 0.0f; // Auto

    // Populate the table with data
    for (int row_n = 0; row_n < mEntryNodes.size(); row_n++) {
        CBLEntryNode *item = mEntryNodes[row_n];
        const char *timestamp = [[item GetTimestamp] UTF8String];
        ImGui::PushID(timestamp);
        ImGui::TableNextRow(ImGuiTableRowFlags_None, row_min_height);

        ImGui::TableSetColumnIndex(0);
        ImGui::TextWrapped("%s", timestamp);

        const char *contents = [[item GetContents] UTF8String];
        const bool item_is_selected = mSelection.contains(item);

        if (ImGui::TableSetColumnIndex(1)) {

            // TODO: Wrap text w/in selectable
            if (ImGui::Selectable(contents, item_is_selected, ImGuiSelectableFlags_SpanAllColumns,
                                  ImVec2(0, row_min_height))) {
                [mClipboard SetClipboardText:contents];
                mSelection.clear();
                mSelection.push_back(item);
            }
        }
        ImGui::PopID();
    }
}

@end

namespace ImGui {

    // This function will eventually allow for wrapped text w/in a selectable
    bool SelectableWrapped(const char* label, bool selected = false, ImGuiSelectableFlags flags = 0, const ImVec2& size = ImVec2(0, 0)) {
        // const float text_size = ImGui::CalcTextSize("A").x;
        //
        // Selectable("##hidden", selected, flags, ImVec2(text_size, size.y));

        // You might calc CalcTextSizeA() with wrapping setting to obtain a size,
        // use this size to create a Selectable() with an empty label (e.g. Selectable("##hidden", size))
        // then using ImDrawList->AddText() to render the text over it.
    }
}