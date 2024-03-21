#pragma once

#include "StarPlatformServices_pc.hpp"

namespace Star {

STAR_CLASS(SteamDesktopService);

class SteamDesktopService : public DesktopService {
public:
  SteamDesktopService(PcPlatformServicesStatePtr state);
  virtual ~SteamDesktopService() = default;

  void openUrl(String const& url) override;
};

}

