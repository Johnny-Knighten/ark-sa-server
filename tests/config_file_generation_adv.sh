#!/bin/bash

source ./tests/test_helper_functions.sh

######################################
# Advance Environment Variable Tests #
######################################

GAME_SETTINGS_PATH="/ark-server/server/ShooterGame/Saved/Config/WindowsServer"
ARK_SA_BOOTSTRAP_PATH="/usr/local/bin/ark-sa-bootstrap.sh"

perform_test "Single File With a Single Section With a Single Var" \
             'docker run --rm \
              -e DRY_RUN=True \
              -e CONFIG_GameUserSettings_ServerSettings_XPMultiplier=1.0 \
              -e GAME_SETTINGS_PATH=${GAME_SETTINGS_PATH} \
              -e ARK_SA_BOOTSTRAP_PATH=${ARK_SA_BOOTSTRAP_PATH} \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c "$ARK_SA_BOOTSTRAP_PATH > /dev/null 2>&1 && \
                  test -f $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"[ServerSettings]\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"XPMultiplier=1.0\" $GAME_SETTINGS_PATH/GameUserSettings.ini"'

perform_test "Single File With a Single Section With Two Vars" \
             'docker run --rm \
              -e DRY_RUN=True \
              -e CONFIG_GameUserSettings_ServerSettings_XPMultiplier=1.0 \
              -e CONFIG_GameUserSettings_ServerSettings_TamingSpeedMultiplier=1.0 \
              -e GAME_SETTINGS_PATH=${GAME_SETTINGS_PATH} \
              -e ARK_SA_BOOTSTRAP_PATH=${ARK_SA_BOOTSTRAP_PATH} \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c "$ARK_SA_BOOTSTRAP_PATH > /dev/null 2>&1 && \
                  test -f $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"[ServerSettings]\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"XPMultiplier=1.0\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"TamingSpeedMultiplier=1.0\" $GAME_SETTINGS_PATH/GameUserSettings.ini "'

perform_test "Single File With Two Sections Each With a Single Var" \
             'docker run --rm \
              -e DRY_RUN=True \
              -e CONFIG_GameUserSettings_ServerSettings_XPMultiplier=1.0 \
              -e CONFIG_GameUserSettings_SessionSetting_SessionName=Test123 \
              -e GAME_SETTINGS_PATH=${GAME_SETTINGS_PATH} \
              -e ARK_SA_BOOTSTRAP_PATH=${ARK_SA_BOOTSTRAP_PATH} \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c "$ARK_SA_BOOTSTRAP_PATH > /dev/null 2>&1 && \
                  test -f $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"[ServerSettings]\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"XPMultiplier=1.0\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"[SessionSetting]\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"SessionName=Test123\" $GAME_SETTINGS_PATH/GameUserSettings.ini"'

perform_test "Two Files Each With a Single Section and a Single Var" \
             'docker run --rm \
              -e DRY_RUN=True \
              -e CONFIG_GameUserSettings_ServerSettings_XPMultiplier=1.0 \
              -e CONFIG_Game_SLASH_Script_SLASH_ShooterGame_DOT_ShooterGameMode_BabyImprintingStatScaleMultiplier=1.0 \
              -e GAME_SETTINGS_PATH=${GAME_SETTINGS_PATH} \
              -e ARK_SA_BOOTSTRAP_PATH=${ARK_SA_BOOTSTRAP_PATH} \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c "$ARK_SA_BOOTSTRAP_PATH > /dev/null 2>&1 && \
                  test -f $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"[ServerSettings]\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"XPMultiplier=1.0\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  test -f $GAME_SETTINGS_PATH/Game.ini && \
                  grep -q \"[/Script/ShooterGame.ShooterGameMode]\" $GAME_SETTINGS_PATH/Game.ini && \
                  grep -q \"BabyImprintingStatScaleMultiplier=1.0\" $GAME_SETTINGS_PATH/Game.ini"'

perform_test "New CONFIG_ Introduced Between Runs Generates New Config Entry" \
             'docker run --rm \
              -e DRY_RUN=True \
              -e CONFIG_GameUserSettings_ServerSettings_XPMultiplier=1.0 \
              -e GAME_SETTINGS_PATH=${GAME_SETTINGS_PATH} \
              -e ARK_SA_BOOTSTRAP_PATH=${ARK_SA_BOOTSTRAP_PATH} \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c "$ARK_SA_BOOTSTRAP_PATH > /dev/null 2>&1 && \
                  test -f $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"[ServerSettings]\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"XPMultiplier=1.0\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  export CONFIG_GameUserSettings_ServerSettings_PetXPMultiplier=2.0 && \
                  $ARK_SA_BOOTSTRAP_PATH > /dev/null 2>&1 && \
                  test -f $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  test -f $GAME_SETTINGS_PATH/GameUserSettings.ini.backup && \
                  grep -q \"XPMultiplier=1.0\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"PetXPMultiplier=2.0\" $GAME_SETTINGS_PATH/GameUserSettings.ini"'

perform_test "New Config and Backup Config Generated If CONFIG_ Value Changed Between Runs" \
             'docker run --rm \
              -e DRY_RUN=True \
              -e CONFIG_GameUserSettings_ServerSettings_XPMultiplier=1.0 \
              -e GAME_SETTINGS_PATH=${GAME_SETTINGS_PATH} \
              -e ARK_SA_BOOTSTRAP_PATH=${ARK_SA_BOOTSTRAP_PATH} \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c "$ARK_SA_BOOTSTRAP_PATH > /dev/null 2>&1 && \
                  test -f $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"[ServerSettings]\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"XPMultiplier=1.0\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  export CONFIG_GameUserSettings_ServerSettings_XPMultiplier=2.0 && \
                  $ARK_SA_BOOTSTRAP_PATH > /dev/null 2>&1 && \
                  test -f $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  test -f $GAME_SETTINGS_PATH/GameUserSettings.ini.backup && \
                  grep -q \"XPMultiplier=2.0\" $GAME_SETTINGS_PATH/GameUserSettings.ini"'

perform_test "Backup Config Not Generated If CONFIG_ Value Does Not Change Between Runs" \
             'docker run --rm \
              -e DRY_RUN=True \
              -e CONFIG_GameUserSettings_ServerSettings_XPMultiplier=1.0 \
              -e GAME_SETTINGS_PATH=${GAME_SETTINGS_PATH} \
              -e ARK_SA_BOOTSTRAP_PATH=${ARK_SA_BOOTSTRAP_PATH} \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c "$ARK_SA_BOOTSTRAP_PATH > /dev/null 2>&1 && \
                  test -f $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"[ServerSettings]\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"XPMultiplier=1.0\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  export CONFIG_GameUserSettings_ServerSettings_XPMultiplier=1.0 && \
                  $ARK_SA_BOOTSTRAP_PATH > /dev/null 2>&1 && \
                  test -f $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  test ! -f $GAME_SETTINGS_PATH/GameUserSettings.ini.backup && \
                  grep -q \"XPMultiplier=1.0\" $GAME_SETTINGS_PATH/GameUserSettings.ini"'

perform_test "Removing CONFIG_ Enviroment Variable Between Run Deletes Config From File" \
             'docker run --rm \
              -e DRY_RUN=True \
              -e CONFIG_GameUserSettings_ServerSettings_XPMultiplier=1.0 \
              -e GAME_SETTINGS_PATH=${GAME_SETTINGS_PATH} \
              -e ARK_SA_BOOTSTRAP_PATH=${ARK_SA_BOOTSTRAP_PATH} \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c "$ARK_SA_BOOTSTRAP_PATH > /dev/null 2>&1 && \
                  test -f $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"[ServerSettings]\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"XPMultiplier=1.0\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  unset CONFIG_GameUserSettings_ServerSettings_XPMultiplier && \
                  $ARK_SA_BOOTSTRAP_PATH > /dev/null 2>&1 && \
                  grep -vq \"XPMultiplier=1.0\" $GAME_SETTINGS_PATH/GameUserSettings.ini"'

perform_test "Mega Test - Lots Of Vars" \
             'docker run --rm \
              -e DRY_RUN=True \
              -e CONFIG_GameUserSettings_ServerSettings_DifficultyOffset=0.20 \
              -e CONFIG_GameUserSettings_ServerSettings_PlayerDamageMultiplier=1.0 \
              -e CONFIG_GameUserSettings_ServerSettings_StructureResistanceMultiplier=1.0 \
              -e CONFIG_GameUserSettings_ServerSettings_XPMultiplier=1.0 \
              -e CONFIG_GameUserSettings_ServerSettings_TamingSpeedMultiplier=1.0 \
              -e CONFIG_GameUserSettings_ServerSettings_HarvestAmountMultiplier=1.0 \
              -e CONFIG_GameUserSettings_ServerSettings_PlayerCharacterWaterDrainMultiplier=1.0 \
              -e CONFIG_GameUserSettings_ServerSettings_PlayerCharacterFoodDrainMultiplier=1.0 \
              -e CONFIG_GameUserSettings_ServerSettings_DinoCharacterFoodDrainMultiplier=1.0 \
              -e CONFIG_GameUserSettings_ServerSettings_PlayerCharacterStaminaDrainMultiplier=1.0 \
              -e CONFIG_GameUserSettings_ServerSettings_DinoCharacterStaminaDrainMultiplier=1.0 \
              -e CONFIG_GameUserSettings_ServerSettings_PlayerCharacterHealthRecoveryMultiplier=1.0 \
              -e CONFIG_GameUserSettings_ServerSettings_DinoCharacterHealthRecoveryMultiplier=1.0 \
              -e CONFIG_GameUserSettings_ServerSettings_HarvestHealthMultiplier=1.0 \
              -e CONFIG_GameUserSettings_ServerSettings_StartTimeOverride=False \
              -e CONFIG_GameUserSettings_ServerSettings_StartTimeHour=10.0 \
              -e CONFIG_GameUserSettings_ServerSettings_ListenServerTetherDistanceMultiplier=1.0 \
              -e CONFIG_GameUserSettings_ServerSettings_RaidDinoCharacterFoodDrainMultiplier=1.0 \
              -e CONFIG_GameUserSettings_ServerSettings_StructurePreventResourceRadiusMultiplier=1.0 \
              -e CONFIG_GameUserSettings_ServerSettings_PvEDinoDecayPeriodMultiplier=1.0 \
              -e CONFIG_GameUserSettings_ServerSettings_AllowRaidDinoFeeding=False \
              -e CONFIG_GameUserSettings_ServerSettings_PerPlatformMaxStructuresMultiplier=1 \
              -e CONFIG_GameUserSettings_ServerSettings_GlobalVoiceChat=False \
              -e CONFIG_GameUserSettings_ServerSettings_ProximityChat=False \
              -e CONFIG_GameUserSettings_ServerSettings_NoTributeDownloads=False \
              -e CONFIG_GameUserSettings_ServerSettings_AllowThirdPersonPlayer=True \
              -e CONFIG_GameUserSettings_ServerSettings_AlwaysNotifyPlayerLeft=False \
              -e CONFIG_GameUserSettings_ServerSettings_DontAlwaysNotifyPlayerJoined=False \
              -e CONFIG_GameUserSettings_ServerSettings_ServerHardcore=False \
              -e CONFIG_GameUserSettings_ServerSettings_ServerCrosshair=True \
              -e CONFIG_GameUserSettings_ServerSettings_ServerForceNoHUD=False \
              -e CONFIG_GameUserSettings_ServerSettings_ShowMapPlayerLocation=True \
              -e CONFIG_GameUserSettings_ServerSettings_EnablePvPGamma=True \
              -e CONFIG_GameUserSettings_ServerSettings_DisableStructureDecayPvE=False \
              -e CONFIG_GameUserSettings_ServerSettings_AllowFlyerCarryPvE=False \
              -e CONFIG_GameUserSettings_ServerSettings_OnlyAllowSpecifiedEngrams=False \
              -e CONFIG_GameUserSettings_ServerSettings_AllowHideDamageSourceFromLogs=True \
              -e CONFIG_GameUserSettings_ServerSettings_RandomSupplyCratePoints=False \
              -e CONFIG_GameUserSettings_ServerSettings_DisableWeatherFog=False \
              -e CONFIG_GameUserSettings_ServerSettings_PreventDownloadSurvivors=False \
              -e CONFIG_GameUserSettings_ServerSettings_PreventDownloadItems=False \
              -e CONFIG_GameUserSettings_ServerSettings_PreventDownloadDinos=False \
              -e CONFIG_GameUserSettings_ServerSettings_DisablePvEGamma=False \
              -e CONFIG_GameUserSettings_ServerSettings_DisableDinoDecayPvE=False \
              -e CONFIG_GameUserSettings_ServerSettings_AdminLogging=False \
              -e CONFIG_GameUserSettings_ServerSettings_AllowCaveBuildingPvE=False \
              -e CONFIG_GameUserSettings_ServerSettings_ForceAllowCaveFlyers=False \
              -e CONFIG_GameUserSettings_ServerSettings_PreventOfflinePvP=False \
              -e CONFIG_GameUserSettings_ServerSettings_PvPDinoDecay=False \
              -e CONFIG_GameUserSettings_ServerSettings_OverrideStructurePlatformPrevention=False \
              -e CONFIG_GameUserSettings_ServerSettings_AllowAnyoneBabyImprintCuddle=False \
              -e CONFIG_GameUserSettings_ServerSettings_DisableImprintDinoBuff=False \
              -e CONFIG_GameUserSettings_ServerSettings_ShowFloatingDamageText=False \
              -e CONFIG_GameUserSettings_ServerSettings_PreventDiseases=False \
              -e CONFIG_GameUserSettings_ServerSettings_NonPermanentDiseases=False \
              -e CONFIG_GameUserSettings_ServerSettings_EnableExtraStructurePreventionVolumes=False \
              -e CONFIG_GameUserSettings_ServerSettings_PreventTribeAlliances=False \
              -e CONFIG_GameUserSettings_ServerSettings_bAllowSpeedLeveling=False \
              -e CONFIG_GameUserSettings_ServerSettings_bAllowFlyerSpeedLeveling=False \
              -e CONFIG_GameUserSettings_ServerSettings_PreventOfflinePvPInterval=-0 \
              -e CONFIG_GameUserSettings_ServerSettings_CraftingSkillBonusMultiplier=1 \
              -e CONFIG_GameUserSettings_ServerSettings_SupplyCrateLootQualityMultiplier=1 \
              -e CONFIG_GameUserSettings_ServerSettings_ActiveEvent= \
              -e CONFIG_GameUserSettings_ServerSettings_OverrideStartTime=False \
              -e CONFIG_GameUserSettings_ServerSettings_ActiveMapMod=0 \
              -e CONFIG_GameUserSettings_ServerSettings_TheMaxStructuresInRange=10500 \
              -e CONFIG_GameUserSettings_ServerSettings_OxygenSwimSpeedStatMultiplier=1 \
              -e CONFIG_GameUserSettings_ServerSettings_TribeNameChangeCooldown=15 \
              -e CONFIG_GameUserSettings_ServerSettings_PlatformSaddleBuildAreaBoundsMultiplier=1 \
              -e CONFIG_GameUserSettings_ServerSettings_AlwaysAllowStructurePickup=True \
              -e CONFIG_GameUserSettings_ServerSettings_StructurePickupTimeAfterPlacement=30 \
              -e CONFIG_GameUserSettings_ServerSettings_StructurePickupHoldDuration=0.5 \
              -e CONFIG_GameUserSettings_ServerSettings_KickIdlePlayersPeriod=3600 \
              -e CONFIG_GameUserSettings_ServerSettings_AutoSavePeriodMinutes=15 \
              -e CONFIG_GameUserSettings_ServerSettings_MaxTamedDinos=5000 \
              -e CONFIG_GameUserSettings_ServerSettings_ItemStackSizeMultiplier=1 \
              -e CONFIG_GameUserSettings_ServerSettings_RCONServerGameLogBuffer=600 \
              -e CONFIG_GameUserSettings_ServerSettings_ImplantSuicideCD=28800 \
              -e CONFIG_GameUserSettings_ServerSettings_AllowHitMarkers=True \
              -e CONFIG_GameUserSettings_ServerSettings_DayCycleSpeedScale=1.0 \
              -e CONFIG_GameUserSettings_ServerSettings_DayTimeSpeedScale=1.0 \
              -e CONFIG_GameUserSettings_ServerSettings_NightTimeSpeedScale=1.0 \
              -e CONFIG_GameUserSettings_ServerSettings_DinoDamageMultiplier=1.0 \
              -e CONFIG_GameUserSettings_ServerSettings_StructureDamageMultiplier=1.0 \
              -e CONFIG_GameUserSettings_ServerSettings_PlayerResistanceMultiplier=1.0 \
              -e CONFIG_GameUserSettings_ServerSettings_DinoResistanceMultiplier=1.0 \
              -e CONFIG_GameUserSettings_ServerSettings_PvEStructureDecayPeriodMultiplier=1.0 \
              -e GAME_SETTINGS_PATH=${GAME_SETTINGS_PATH} \
              -e ARK_SA_BOOTSTRAP_PATH=${ARK_SA_BOOTSTRAP_PATH} \
              --entrypoint bash \
              johnnyknighten/ark-sa-server:latest \
              -c "$ARK_SA_BOOTSTRAP_PATH > /dev/null 2>&1 && \
                  test -f $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"[ServerSettings]\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"[SessionSettings]\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"[/Script/ShooterGame.ShooterGameMode]\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"DifficultyOffset=0.20\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"PlayerDamageMultiplier=1.0\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"StructureResistanceMultiplier=1.0\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"XPMultiplier=1.0\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"TamingSpeedMultiplier=1.0\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"HarvestAmountMultiplier=1.0\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"PlayerCharacterWaterDrainMultiplier=1.0\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"PlayerCharacterFoodDrainMultiplier=1.0\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"DinoCharacterFoodDrainMultiplier=1.0\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"PlayerCharacterStaminaDrainMultiplier=1.0\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"DinoCharacterStaminaDrainMultiplier=1.0\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"PlayerCharacterHealthRecoveryMultiplier=1.0\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"DinoCharacterHealthRecoveryMultiplier=1.0\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"HarvestHealthMultiplier=1.0\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"StartTimeOverride=False\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"StartTimeHour=10.0\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"ListenServerTetherDistanceMultiplier=1.0\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"RaidDinoCharacterFoodDrainMultiplier=1.0\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"StructurePreventResourceRadiusMultiplier=1.0\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"PvEDinoDecayPeriodMultiplier=1.0\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"AllowRaidDinoFeeding=False\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"PerPlatformMaxStructuresMultiplier=1\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"GlobalVoiceChat=False\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"ProximityChat=False\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"NoTributeDownloads=False\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"AllowThirdPersonPlayer=True\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"AlwaysNotifyPlayerLeft=False\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"DontAlwaysNotifyPlayerJoined=False\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"ServerHardcore=False\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"ServerCrosshair=True\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"ServerForceNoHUD=False\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"ShowMapPlayerLocation=True\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"EnablePvPGamma=True\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"DisableStructureDecayPvE=False\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"AllowFlyerCarryPvE=False\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"OnlyAllowSpecifiedEngrams=False\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"AllowHideDamageSourceFromLogs=True\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"RandomSupplyCratePoints=False\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"DisableWeatherFog=False\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"PreventDownloadSurvivors=False\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"PreventDownloadItems=False\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"PreventDownloadDinos=False\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"DisablePvEGamma=False\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"DisableDinoDecayPvE=False\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"AdminLogging=False\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"AllowCaveBuildingPvE=False\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"ForceAllowCaveFlyers=False\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"PreventOfflinePvP=False\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"PvPDinoDecay=False\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"OverrideStructurePlatformPrevention=False\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"AllowAnyoneBabyImprintCuddle=False\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"DisableImprintDinoBuff=False\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"ShowFloatingDamageText=False\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"PreventDiseases=False\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"NonPermanentDiseases=False\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"EnableExtraStructurePreventionVolumes=False\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"PreventTribeAlliances=False\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"bAllowSpeedLeveling=False\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"bAllowFlyerSpeedLeveling=False\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"PreventOfflinePvPInterval=-0\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"CraftingSkillBonusMultiplier=1\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"SupplyCrateLootQualityMultiplier=1\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"ActiveEvent=\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"OverrideStartTime=False\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"ActiveMapMod=0\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"TheMaxStructuresInRange=10500\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"OxygenSwimSpeedStatMultiplier=1\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"TribeNameChangeCooldown=15\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"PlatformSaddleBuildAreaBoundsMultiplier=1\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"AlwaysAllowStructurePickup=True\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"StructurePickupTimeAfterPlacement=30\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"StructurePickupHoldDuration=0.5\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"KickIdlePlayersPeriod=3600\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"AutoSavePeriodMinutes=15\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"MaxTamedDinos=5000\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"ItemStackSizeMultiplier=1\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"RCONServerGameLogBuffer=600\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"ImplantSuicideCD=28800\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"AllowHitMarkers=True\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"DayCycleSpeedScale=1.0\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"DayTimeSpeedScale=1.0\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"NightTimeSpeedScale=1.0\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"DinoDamageMultiplier=1.0\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"StructureDamageMultiplier=1.0\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"PlayerResistanceMultiplier=1.0\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"DinoResistanceMultiplier=1.0\" $GAME_SETTINGS_PATH/GameUserSettings.ini && \
                  grep -q \"PvEStructureDecayPeriodMultiplier=1.0\" $GAME_SETTINGS_PATH/GameUserSettings.ini"'

log_failed_tests
