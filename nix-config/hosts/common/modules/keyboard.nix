{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    xkbcomp
    xev
  ];
}
