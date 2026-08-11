{ ... }:
{

  programs.nixvim = {

    plugins.mini = {
      enable = true;
      mockDevIcons = true;
      modules = {
        pairs = { };
        icons = { };
      };
    };

  };

}
