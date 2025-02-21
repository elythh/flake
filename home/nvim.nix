{
  inputs,
  ...
}:
{

  config.home.packages = [ inputs.nixvim.packages."x86_64-linux".default ];
  config.home.sessionVariables.EDITOR = "nvim";
}
