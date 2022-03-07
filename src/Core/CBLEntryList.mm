#import "CBLEntryList.h"

#include "imgui.h"

@implementation CBLEntryList

- (id)init {
    @autoreleasepool {
        self = [super init];
        return self;
    }
}

- (bool)AddNodeToEntries:(CBLEntryNode *)entryNode {
    if (!entryNode) { return false; }
    mEntryNodes.push_back(entryNode);
    return true;
}

+ (CBLEntryList *)GetEntryList {
    if (!self) { return [[CBLEntryList alloc] init]; }
    return (CBLEntryList *) self;
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

- (void)ShowTable {
    // Using those as a base value to create width/height that are factor of the size of our font
    const float TEXT_BASE_WIDTH = ImGui::CalcTextSize("A").x;
    const float TEXT_BASE_HEIGHT = ImGui::GetTextLineHeightWithSpacing();

    // Update item list if we changed the number of mEntryNodes
    bool items_need_sort = false;
    int freeze_cols = 1;
    int freeze_rows = 1;
    static ImVec2 outer_size_value = ImVec2(0.0f, TEXT_BASE_HEIGHT * 12);
    static float inner_width_with_scroll = 0.0f; // Auto-extend
    static bool outer_size_enabled = false;
    static bool show_headers = true;
    static bool show_wrapped_text = true;

    // Options
    static ImGuiTableFlags flags =
            ImGuiTableFlags_Resizable | ImGuiTableFlags_Reorderable | ImGuiTableFlags_Hideable |
            ImGuiTableFlags_Sortable | ImGuiTableFlags_SortMulti
            | ImGuiTableFlags_RowBg | ImGuiTableFlags_BordersOuter | ImGuiTableFlags_BordersV |
            ImGuiTableFlags_NoBordersInBody
            | ImGuiTableFlags_ScrollY;

    // Submit table
    const float inner_width_to_use = (flags & ImGuiTableFlags_ScrollX) ? inner_width_with_scroll : 0.0f;
    if (ImGui::BeginTable("Entry List", 2, flags, outer_size_enabled ? outer_size_value : ImVec2(0, 0),
                          inner_width_to_use)) {
        // Declare columns
        // We use the "user_id" parameter of TableSetupColumn() to specify a user id that will be stored in the sort specifications.
        ImGui::TableSetupColumn("Date", ImGuiTableColumnFlags_NoSort | ImGuiTableColumnFlags_WidthFixed |
                                        ImGuiTableColumnFlags_NoHide, 0.0f, EntryNodeColumnID_Date);
        static ImGuiTableFlags contents_flags = ImGuiTableColumnFlags_NoSort | ImGuiTableColumnFlags_WidthStretch;
        ImGui::TableSetupColumn("Contents", contents_flags, 0.0f, EntryNodeColumnID_Contents);
        ImGui::TableSetupScrollFreeze(freeze_cols, freeze_rows);

        // Sort our data if sort specs have been changed!
        // ImGuiTableSortSpecs *sorts_specs = ImGui::TableGetSortSpecs();
        // if (sorts_specs && sorts_specs->SpecsDirty) {
        //     items_need_sort = true;
        // }

        // if (sorts_specs && items_need_sort) {
        //     CBLEntryNode::s_current_sort_specs = sorts_specs; // Store in variable accessible by the sort function.
        //     qsort(mEntryNodes.data(), mEntryNodes.size(), sizeof(mEntryNodes), CBLEntryNode::CompareWithSortSpecs);
        //     CBLEntryNode::s_current_sort_specs = NULL;
        //     sorts_specs->SpecsDirty = false;
        // }
        // items_need_sort = false;

        // Take note of whether we are currently sorting based on the Quantity field,
        // we will use this to trigger sorting when we know the data of this column has been modified.
        const bool sorts_specs_using_date = (ImGui::TableGetColumnFlags(0) & ImGuiTableColumnFlags_IsSorted) != 0;

        // Show headers
        if (show_headers) {
            ImGui::TableHeadersRow();
        }

        ImGui::PushButtonRepeat(true);
        {
            [self PopulateTable];
        }
        ImGui::PopButtonRepeat();
        ImGui::EndTable();
    }
}

- (void)PopulateTable {
    ImVector<const char *> selection;
    float row_min_height = 0.0f; // Auto
    static int contents_type = CT_SelectableSpanRow;

    for (int row_n = 0; row_n < mEntryNodes.size(); row_n++) {
        // Populate the table with data
        CBLEntryNode *item = mEntryNodes[row_n];
        const char *timestamp = [[item GetTimestamp] UTF8String];
        const bool item_is_selected = selection.contains(timestamp);
        ImGui::PushID(timestamp);
        ImGui::TableNextRow(ImGuiTableRowFlags_None, row_min_height);

        ImGui::TableSetColumnIndex(0);
        char label[32];
        sprintf(label, "%s", timestamp);
        if (contents_type == CT_Text) {
            ImGui::TextUnformatted(label);
        } else if (contents_type == CT_Button) {
            ImGui::Button(label);
        } else if (contents_type == CT_SmallButton) {
            ImGui::SmallButton(label);
        } else if (contents_type == CT_FillButton) {
            ImGui::Button(label, ImVec2(-FLT_MIN, 0.0f));
        } else if (contents_type == CT_Selectable || contents_type == CT_SelectableSpanRow) {
            ImGuiSelectableFlags selectable_flags = (contents_type == CT_SelectableSpanRow) ?
                                                    ImGuiSelectableFlags_SpanAllColumns |
                                                    ImGuiSelectableFlags_AllowItemOverlap
                                                                                            : ImGuiSelectableFlags_None;
            if (ImGui::Selectable(label, item_is_selected, selectable_flags, ImVec2(0, row_min_height))) {
                if (ImGui::GetIO().KeyCtrl) {
                    if (item_is_selected) {
                        selection.find_erase_unsorted(timestamp);
                    } else {
                        selection.push_back(timestamp);
                    }
                } else {
                    selection.clear();
                    selection.push_back(timestamp);
                }
            }
        }

        if (ImGui::TableSetColumnIndex(1)) {
            ImGui::TextWrapped("%s", [[item GetContents] UTF8String]);
        }

        ImGui::PopID();
    }
}

@end