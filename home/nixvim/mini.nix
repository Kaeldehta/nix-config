{ ... }: {

  programs.nixvim = {

    plugins.mini = {
      enable = true;
      modules = { pick = { }; };
    };

  };

}
