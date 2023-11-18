# escape=`
ARG BASETAG=20H2
FROM mcr.microsoft.com/windows:${BASETAG} AS full
#FROM  mcr.microsoft.com/windows/server:${BASETAG} AS full

# Gather the system DLLs that we need from the full Windows base image
RUN xcopy /y C:\Windows\System32\dsound.dll C:\GatheredDlls\ && `
	xcopy /y C:\Windows\System32\opengl32.dll C:\GatheredDlls\ && `
	xcopy /y C:\Windows\System32\glu32.dll C:\GatheredDlls\ && `
	xcopy /y C:\Windows\System32\MF.dll C:\GatheredDlls\ && `
	xcopy /y C:\Windows\System32\MFPlat.dll C:\GatheredDlls\ && `
	xcopy /y C:\Windows\System32\MFReadWrite.dll C:\GatheredDlls\ && `
	xcopy /y C:\Windows\System32\msdmo.dll C:\GatheredDlls\ && `
	xcopy /y C:\Windows\System32\dxva2.dll C:\GatheredDlls\

# Retrieve the DirectX runtime files required by the Unreal Engine,
# since even the full Windows base image does not include them
RUN curl -L "https://download.microsoft.com/download/8/4/A/84A35BF1-DAFE-4AE8-82AF-AD2AE20B6B14/directx_Jun2010_redist.exe" --output %TEMP%\directx_redist.exe && `
	start /wait %TEMP%\directx_redist.exe /Q /T:%TEMP%\DirectX && `
	expand %TEMP%\DirectX\APR2007_xinput_x64.cab -F:xinput1_3.dll C:\GatheredDlls\ && `
	expand %TEMP%\DirectX\Jun2010_D3DCompiler_43_x64.cab -F:D3DCompiler_43.dll C:\GatheredDlls\ && `
	expand %TEMP%\DirectX\Feb2010_X3DAudio_x64.cab -F:X3DAudio1_7.dll C:\GatheredDlls\ && `
	expand %TEMP%\DirectX\Jun2010_XAudio_x64.cab -F:XAPOFX1_5.dll C:\GatheredDlls\ && `
	expand %TEMP%\DirectX\Jun2010_XAudio_x64.cab -F:XAudio2_7.dll C:\GatheredDlls\

# Retrieve the DirectX shader compiler files needed for DirectX Raytracing (DXR)
RUN curl -L "https://github.com/microsoft/DirectXShaderCompiler/releases/download/v1.6.2104/dxc_2021_04-20.zip" --output %TEMP%\dxc.zip && `
	powershell -Command "Expand-Archive -Path \"$env:TEMP\dxc.zip\" -DestinationPath $env:TEMP" && `
	xcopy /y %TEMP%\bin\x64\dxcompiler.dll C:\GatheredDlls\ && `
	xcopy /y %TEMP%\bin\x64\dxil.dll C:\GatheredDlls\

# Copy the required DLLs from the full Windows base image into a smaller Windows Server Core base image
ARG BASETAG
FROM mcr.microsoft.com/windows/servercore:${BASETAG}
COPY --from=full C:\GatheredDlls\ C:\Windows\System32\

ENV DEBUG=false `
    CONTAINER_BIN_DIR="C:\Program Files\ark-sa-container\bin" `
    TEST_DRY_RUN=False `
    STEAMCMD_ARK_SA_APP_ID=2430930 `
    STEAMCMD_SKIP_VALIDATION=False `
    ARK_SERVER_DIR="C:\Program Files\ark-sa-container\primary-volume" `
    ARK_MAP="TheIsland_WP" `
    ARK_GAME_PORT=7777 `
    ARK_QUERY_PORT=27015 `
    ARK_EXTRA_LAUNCH_OPTIONS= `
    ARK_SERVER_PASSWORD= `
    ARK_SERVER_ADMIN_PASSWORD=adminpassword `
    ARK_ENABLE_RCON=True `
    ARK_RCON_PORT=27020 `
    ARK_MAX_PLAYERS=70 `
    ARK_SERVER_NAME="Ark Server" `
    ARK_PREVENT_AUTO_UPDATE=False `
    ARK_MOD_LIST= `
    ARK_NO_BATTLEYE=True `
    ARK_EPIC_PUBLIC_IP= `
    ARK_MULTI_HOME= `
    ARK_ENABLE_PVE=False

# Install the Visual C++ runtime files using Chocolatey
RUN powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"
RUN choco install -y vcredist-all

RUN mkdir "C:\steamcmd" && `
    curl -L "https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip" -o C:\steamcmd\steamcmd.zip && `
    tar -xf C:\steamcmd\steamcmd.zip -C C:\steamcmd && `
    del C:\steamcmd\steamcmd.zip

COPY bin/ ${CONTAINER_BIN_DIR}

VOLUME [ "${ARK_SERVER_DIR}" ]
WORKDIR ${ARK_SERVER_DIR}

EXPOSE 7777/udp
EXPOSE 7778/udp
EXPOSE 27015/udp
EXPOSE 27020/tcp

ENTRYPOINT ["powershell.exe", "-Command", "& \"C:\\Program Files\\ark-sa-container\\bin\\docker-entrypoint.ps1\""]
CMD []
