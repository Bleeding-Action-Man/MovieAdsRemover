//=============================================================================
// Removes the 'Movie Ads' section in LobbyMenu
// Major thanks to Marco/ScaryGhost for some code reference
// Made by Vel-San @ https://steamcommunity.com/id/Vel-San/
//=============================================================================

class MovieAdsRemover extends Mutator Config(MovieAdsRemover_Config);

#exec OBJ LOAD FILE=MARTex.utx

// Config Vars
var config bool bCompletelyDisable, bReplaceWithTexture;
var config string sTextureName;
var config float fMaxFPS;

// Local Vars
var MovieAdsRemover Mut;

replication
{
  unreliable if (Role == ROLE_Authority)
                  bCompletelyDisable,bReplaceWithTexture,
                  sTextureName,
                  fMaxFPS;
}

// Initialization
simulated function PostBeginPlay()
{
  // Pointer To self
  Mut = self;
  default.Mut = self;
  class'MovieAdsRemover'.default.Mut = self;

  // Make sure Clients also download the Texture Package
  AddToPackageMap("MARTex.utx");
}

simulated function Tick(float DeltaTime) {
    local PlayerController localController;

    MutLog("-----|| Injecting 'Movie' Remover ||-----");

    localController= Level.GetLocalPlayerController();
    if (localController != none) {
        localController.Player.InteractionMaster.AddInteraction("MovieAdsRemover.CustomInteraction", localController.Player);
    }
    Disable('Tick');
}

simulated function TimeStampLog(coerce string s)
{
  log("["$Level.TimeSeconds$"s]" @ s, 'MovieAdsRemover');
}

simulated function MutLog(string s)
{
  log(s, 'MovieAdsRemover');
}

defaultproperties
{
  GroupName = "KF-MovieAdsRemover"
  FriendlyName = "Movie Ads Remover - v1.0"
  Description = "Remove 'Movies Section' from LobbyMenu, or replace with a custom IMG/GIF for your own Server; Written by Vel-San"
  bAddToServerPackages=true
  RemoteRole = ROLE_SimulatedProxy
  bAlwaysRelevant = true
}
