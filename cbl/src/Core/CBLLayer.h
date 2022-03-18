#pragma once

class CBLLayer {
public:
    CBLLayer(const std::string &name = "Layer");
    virtual ~CBLLayer();

    virtual void OnEvent() {}

    virtual void OnAttach() {}

    virtual void OnDetach() {}

    virtual void OnUpdate() {}

    virtual void OnImGuiRender() {}

    inline const std::string &GetName() const { return mDebugName; }

protected:
    std::string mDebugName;
};