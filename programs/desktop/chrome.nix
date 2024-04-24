{...}: {
  programs.chromium = {
    enable = true;
    extensions = [
      {id = "nngceckbapebfimnlniiiahkandclblb";} #Bitwarden
      {id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";} #uBlock Origin
      {id = "likgccmbimhjbgkjambclfkhldnlhbnn";} #Yomitan
      {id = "acpchjgielgmkgkplljakcibfbjjppbk";} #Migaku
      {id = "mnjggcdmjocbbbhaepdhchncahnbgone";} #Sponsorblock
      {id = "eimadpbcbfnmbkopoojfekhnkhdbieeh";} #Dark Reader
      {id = "dbepggeogbaibhgnhhndojpepiihcmeb";} #Vimium
      {id = "oejgccbfbmkkpaidnkphaiaecficdnfn";} #Toggl
    ];
  };
}
