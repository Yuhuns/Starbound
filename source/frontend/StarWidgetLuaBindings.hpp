#pragma once

#include "StarLua.hpp"
#include "StarGuiReader.hpp"

namespace Star {

STAR_CLASS(Widget);

namespace LuaBindings {
  LuaCallbacks makeWidgetCallbacks(Widget* parentWidget, GuiReader* reader);
}

}

