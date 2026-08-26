/** WTR Pro 的 Home Manager 用户入口。 */
{ hostConfig, ... }:

{
  imports = [ ../../modules/home/default.nix ];

  home = {
    username = hostConfig.user.name;
    homeDirectory = hostConfig.user.homeDirectory;
  };

  modules = hostConfig.homeModules;
}
