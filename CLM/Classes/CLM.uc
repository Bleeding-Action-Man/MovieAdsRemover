//=============================================================================
// Removes the 'Movie Ads' section in LobbyMenu
// Major thanks to Marco/ScaryGhost for some code reference
// Made by Vel-San @ https://steamcommunity.com/id/Vel-San/
//=============================================================================

class CLM extends Mutator Config(CLM_Config);

simulated function Tick(float DeltaTime) {
    local PlayerController localController;

    MutLog("-----|| Injecting 'Movie' Remover ||-----");

    localController= Level.GetLocalPlayerController();
    if (localController != none) {
        localController.Player.InteractionMaster.AddInteraction("CLM.CustomInteraction", localController.Player);
    }
    Disable('Tick');
}

simulated function TimeStampLog(coerce string s)
{
  log("["$Level.TimeSeconds$"s]" @ s, 'CLM');
}

simulated function MutLog(string s)
{
  log(s, 'CLM');
}

defaultproperties
{
  GroupName = "KF-CLM"
  FriendlyName = "Movie Ads Removed - v1.0"
  Description = "Remove 'Movie Section' from LobbyMenu; Written by Vel-San"
  bAddToServerPackages=true
  RemoteRole = ROLE_SimulatedProxy
  bAlwaysRelevant = true
}
