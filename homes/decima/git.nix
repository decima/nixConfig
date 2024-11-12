{ config, pkgs, ... }:
let 
    editor = "vim";
in
{
    
    programs.git = {
        enable = true;
        userName = "decima";
        userEmail = "h.larget@gmail.com";
        aliases = {
        logadog = "log --all --decorate --oneline --graph";
        br = "branch";
        co = "checkout";
        st = "status";
        tempo = "commit -a -m tempo";
        su = "submodule update --init --recursive";
        cp = "cherry-pick";
        please = "push --force-with-lease --force-if-includes";
        master = "!git checkout master && git pull && git checkout -";
        };
        extraConfig = {
        core.editor = editor;
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
        url."git@github.com".insteadOf = "https://github.com";
        "tig \"bind\"".generic = [
            "r !git rebase -i %(commit)^"
            "p @sh -c \"echo -n %(commit) | xclip\""
        ]; 
        
        };
  };
}