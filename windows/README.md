# Windows Container - ARK Survival Ascended  

I wasted about four days trying to get a Windows Container to work with ARK Survival Ascended, but never got it working completely. I'm pretty sure I have the image working in terms of the game server running, but I could never get the game client to connect to the server. I'm almost 100% sure it has to do with some Windows Container networking issue. 

I rather spend my time working on features that add true value to the project, then working on a niche feature.

There are actually quite a few motivations for pausing/stopping this feature development. Windows Containers are huge (compared to their Linux cousins and ignoring the [mcr.microsoft.com/windows/nanoserver](https://hub.docker.com/_/microsoft-windows-nanoserver) image), are a pain in terms of networking, and permissions can be a struggle to get setup correctly. On top of that we are dealing with Microsoft, so licensing is kind of a thing. In general, Windows 10/11 is only supposed to be used for Dev/Testing purposes, and the server versions can have restriction in terms of the number of containers that can be ran. I'm not sure how heavily this is enforced, but it is something to keep in mind. If you want more details see this [Microsoft FAQ post on the topic](https://learn.microsoft.com/en-us/virtualization/windowscontainers/about/faq#how-are-containers-licensed--is-there-a-limit-to-the-number-of-containers-i-can-run-). On top of all of that, let's be real, the main people looking at this project are probably gamers and homelab owners who want to run a server for themselves and their friends. I don't think many of them are going to have an environment setup for Windows Containers or want to go through the hassle of setting one up. The only demographic I see this being useful for is people who are already running a Windows Container environment setup on a Windows Server they already have a license for. Also, I'm not sure if there is even a tangible benefit for running the game server in a Windows Container. I was never able to run the container successfully (it ran but couldn't connect to the game server) so I could never execute performance testing. When I look at the overhead of the different isolation modes (looking at you Hyper V isolation), it's hard to believe that there will be any performance benefit. This is just an assumption, and I could be wrong, but I don't think it's currently worth the effort to find out.

With all that said I'm still glad I gave it a shot; it was my first foray into Windows Containers and I learned a lot. I'm going to leave this here for anyone who wants to take a stab at it, but I'm not going to be actively working on it. If you do get it working, please submit a PR and I'll merge it in.

## Setting Up an Environment For Windows Containers

**IMPORTANT - Windows Containers can only run on certain Windows OSs. If you are on Win10/11 you're going to need Pro/Enterprise edition. On the Windows Server side you need 2016+ and ideally 2019/2022. See [here](https://learn.microsoft.com/en-us/virtualization/windowscontainers/deploy-containers/version-compatibility?tabs=windows-server-2022%2Cwindows-11) for details about supported OSes**

See the [official Microsoft documentation](https://learn.microsoft.com/en-us/virtualization/windowscontainers/quick-start/set-up-environment?tabs=dockerce) and the [official docker documentation](https://docs.docker.com/desktop/install/windows-install/) for exact details. 

It's worth noting that in "In General"... Windows Container mode you can only run Windows Containers, you cannot mismatch Linux and Windows Containers. You can switch between Windows and Linux Containers by right clicking the Docker icon in the system tray and selecting `Switch to Windows Containers...` or `Switch to Linux Containers...`.

Despite what I just said above, there may be a way to run both at the same time, but it is [messy](https://github.com/microsoft/Windows-Containers/issues/318). The two methods discussed are using [Redpoint Kubernetes Manager](https://src.redpoint.games/redpointgames/rkm) or manually installing and managing two different environments, one for Linux (WSL2) and one for Windows. **I have not tried either method.**

### Setting Up Windows 11 Pro

*This is the environment I used for development and testing.*

1. Install Docker Desktop
2. Install Hyper-V and Windows Container Features
  * Control Panel > Programs and Features > Turn Windows features on or off
  * Turn on `Containers`
  * Turn on `Hyper-V`
  * Restart Computer
3. Right Click Docker Icon in System Tray > `Switch To Windows Containers...`
4. After Docker Desktop Reloads Your Now in Windows Container Mode

### Windows Server 2019+

*Never tested using Windows Server.*

You cannot use Docker Desktop on Windows Server, see [here](https://docs.docker.com/desktop/faqs/windowsfaqs/#can-i-run-docker-desktop-on-windows-server).

#### Docker CE/Moby

The script pulled by the command below is maintained by Microsoft to install Docker CE.

This is the easiest way to get started for Windows Server.

```powershell
Invoke-WebRequest -UseBasicParsing "https://raw.githubusercontent.com/microsoft/Windows-Containers/Main/helpful_tools/Install-DockerCE/install-docker-ce.ps1" -o install-docker-ce.ps1
.\install-docker-ce.ps1
```

## How I Got To The Current Build

My first iteration of the image was based on the [steamcmd/steamcmd:windows-core](https://hub.docker.com/r/steamcmd/steamcmd) image, which is Steam's official Windows image with SteamCMD already installed. I got all the way up to launching the ARK SA server, but it would always error out with little to no feedback. After a little digging it seemed like I was missing some required DLLs/dependencies to start the server. 

I started to look for generic information about launching Unreal based game servers in Windows containers and I stumbled upon [Unreal Containers](https://unrealcontainers.com/). It doesn't look like it's an official Unreal sponsored project, but it has secured funding via EPIC games. I followed the Dockerfile for their ["Enabling vendor-specific graphics APIs in Windows containers" ](https://unrealcontainers.com/blog/enabling-vendor-specific-graphics-apis-in-windows-containers/) blog post and it seemed to fix all the dependency issues I was facing. Also, apparently EPIC has some repos specifically about containers using Unreal Engine, but they are private repos and you need to be a partner to access them.

I did make a modification to their Dockerfile. Their Dockerfile is a two stage build where the first stage is collecting DLLs from the full blown [mcr.microsoft.com/windows](https://hub.docker.com/_/microsoft-windows) image, which besides being 16GB... only goes up to update 20H2. For the more modern ltcs2022 build, you must use the [mcr.microsoft.com/windows/server](https://hub.docker.com/_/microsoft-windows-server) image. Admittedly I was lazy and just commented out the two different `FROM` lines in the Dockerfile, and I just swapped the line depending on the build.

Now it's important to know that Windows Containers have two different Isolation modes: HyperV and Process. In HyperV Isolation a full blown VM is spun up and the container is run inside of it. In Process isolation the container is ran directly on the host system in its own process. One of the key differences is that in Process Isolation, your host OS must match the specific build/kernel of the container you are running; for instance you can't run a Windows Server 2016 container on a Windows 11 Pro host. Now in HyperV Isolation you can run any container on any host OS, because it will spin up a HyperV VM of the targeted OS and run the container inside it. The downside to HyperV Isolation is that it is slower and requires more resources. See [here](https://learn.microsoft.com/en-us/virtualization/windowscontainers/manage-containers/hyperv-container) for more details.

With that being said I was developing on a Windows 11 Pro host, and I had zero luck running it with Process Isolation using a ltcs2022 Windows Server based container. Where I did have success was running it in HyperV Isolation using a 20H2 windows-based container.

In the 20H2 image I was able to get the normal logging I see when I launch the game locally/with the proton/wine container. Like this:
```
Commandline:  start ArkAscendedServer TheIsland_WP?SessionName=TEST?ServerPassword=password?Port=7777?QueryPort=27015?Listen -NoBattlEye exit
Full Startup: 63.87 seconds
Number of cores 8
wp.Runtime.HLOD = "1"
```

When I ran `ps` in an interactive shell in the container its CPU usage and RAM usage matched a normal running ARK SA server. There were no errors logs besides normal bad dino spawn logs. I'm like 95% positive that the game server was up and running normally. I really suspect networking is the issue limiting the game client from connecting to the server.

### Building The Image

To build the 20H2image (that I had success with using HyperV isolation) run the below command:

```powershell
docker build --build-arg="BASETAG=20H2" -t johnnyknighten/ark-sa-container:windows-20h2 .
```

To build the ltcs2022 image (that I had no luck with using Process isolation) first switch the comment in the Dockerfile to look like this:

```dockerfile
# escape=`
ARG BASETAG=20H2
#FROM mcr.microsoft.com/windows:${BASETAG} AS full
FROM  mcr.microsoft.com/windows/server:${BASETAG} AS full
```

Then to build the image:

```powershell
docker build --build-arg="BASETAG=ltcs2022" -t johnnyknighten/ark-sa-container:windows-ltcs2022 .
```

### Windows Container Networking

No matter what I tried, I couldn't get the Windows Container to work from a networking perspective. Without specifying a network (which in Linux world would be a bridged network), I could ping the containers internal IP, but I could never connect to it using any of the exposed ports. When I ran ```netstat -aon``` on the host I never saw the expected port (7777) but when I created an interactive shell in the container and performed ```netstat -aon``` I saw `0.0.0.0:7777` like expected.

In general networking with Windows Containers is a pain; at least in my option when compared to Linux Containers. You need to have some working knowledge of HyperV in terms of vSwitchs (internal and external) and vNICs. Then you need to be aware of various Windows networking services and tools: WinNAT, Windows Firewall, Host Networking Service (HNS), and the Host Compute Service (HCS). See [here](https://docs.microsoft.com/en-us/virtualization/windowscontainers/manage-containers/container-networking) for more details.

#### NAT Network

Running it via HyperV isolation with windows-20H2:

```powershell
docker run --rm `
--isolation=hyperv `
--memory=20g `
--cpus=8 `
--name ark-sa-server `
-p 7777:7777/udp `
-p 7778:7778/udp `
-p 27015:27015/udp `
-p 27020:27020/tcp `
-e ARK_SERVER_NAME='Simple ARK SA Server' `
-e ARK_SERVER_ADMIN_PASSWORD=secretpassword `
-v 'ark-server-data:C:\Program Files\ark-sa-container\primary-volume' `
johnnyknighten/ark-sa-container:windows-20H2
```

Running it via Process Isolation with windows-ltsc2022:

```powershell
docker run --rm `
--isolation=isolation `
--memory=20g `
--cpus=8 `
--name ark-sa-server `
-p 7777:7777/udp `
-p 7778:7778/udp `
-p 27015:27015/udp `
-p 27020:27020/tcp `
-e ARK_SERVER_NAME='Simple ARK SA Server' `
-e ARK_SERVER_ADMIN_PASSWORD=secretpassword `
-v 'ark-server-data:C:\Program Files\ark-sa-container\primary-volume' `
johnnyknighten/ark-sa-container:windows-ltsc2022
```

#### Transparent Network

 I tried using the `transparent` network driver, but that didn't work either. 
 
The static IP assigned didn't work and always grabbed an IP via DHCP. I was able to ping the container's IP, but I could never connect to it using any of the exposed ports.

 ```powershell
docker network create -d `
transparent `
--subnet 192.168.1.0/24 `
--gateway 192.168.1.1 `
-o com.docker.network.windowsshim.dnsservers="192.168.25.100,192.168.25.101,192.168.1.1" `
my_transparent
```

Running it via HyperV isolation with windows-20H2:

```powershell
docker run --rm `
--isolation=hyperv `
--memory=20g `
--cpus=8 `
--network=my_transparent `
--ip=192.168.1.82 `
--name ark-sa-server `
-p 7777:7777/udp `
-p 7778:7778/udp `
-p 27015:27015/udp `
-p 27020:27020/tcp `
-e ARK_SERVER_NAME='Simple ARK SA Server' `
-e ARK_SERVER_ADMIN_PASSWORD=secretpassword `
-v 'ark-server-data:C:\Program Files\ark-sa-container\primary-volume' `
johnnyknighten/ark-sa-container:windows-20H2
```

Running it via Process Isolation with windows-ltsc2022:

```powershell
docker run --rm `
--isolation=isolation `
--memory=20g `
--cpus=8 `
--network=my_transparent `
--ip=192.168.1.82 `
--name ark-sa-server `
-p 7777:7777/udp `
-p 7778:7778/udp `
-p 27015:27015/udp `
-p 27020:27020/tcp `
-e ARK_SERVER_NAME='Simple ARK SA Server' `
-e ARK_SERVER_ADMIN_PASSWORD=secretpassword `
-v 'ark-server-data:C:\Program Files\ark-sa-container\primary-volume' `
johnnyknighten/ark-sa-container:windows-ltsc2022
```

#### l2bridge Network

[Here](https://techcommunity.microsoft.com/t5/networking-blog/l2bridge-container-networking/ba-p/1180923) is a great article on l2bridges.

I tried using the `l2bridge` network driver, but that didn't work either. 

```powershell
docker network create -d `
l2bridge `
--subnet 192.168.1.0/24 `
--gateway 192.168.1.1 `
-o com.docker.network.windowsshim.dnsservers="192.168.1.1" `
-o com.docker.network.windowsshim.enable_outboundnat=true `
my_l2bridge
```

Running it via HyperV isolation with windows-20H2:

```powershell
docker run --rm `
--isolation=hyperv `
--memory=20g `
--cpus=8 `
--network=my_l2bridge`
--ip=192.168.1.82 `
--name ark-sa-server `
-p 7777:7777/udp `
-p 7778:7778/udp `
-p 27015:27015/udp `
-p 27020:27020/tcp `
-e ARK_SERVER_NAME='Simple ARK SA Server' `
-e ARK_SERVER_ADMIN_PASSWORD=secretpassword `
-v 'ark-server-data:C:\Program Files\ark-sa-container\primary-volume' `
johnnyknighten/ark-sa-container:windows-20H2
```

Running it via Process Isolation with windows-ltsc2022:

```powershell
docker run --rm `
--isolation=isolation `
--memory=20g `
--cpus=8 `
--network=my_l2bridge `
--ip=192.168.1.82 `
--name ark-sa-server `
-p 7777:7777/udp `
-p 7778:7778/udp `
-p 27015:27015/udp `
-p 27020:27020/tcp `
-e ARK_SERVER_NAME='Simple ARK SA Server' `
-e ARK_SERVER_ADMIN_PASSWORD=secretpassword `
-v 'ark-server-data:C:\Program Files\ark-sa-container\primary-volume' `
johnnyknighten/ark-sa-container:windows-ltsc2022
```

### Windows Containers and Volumes

Windows Containers are pretty picky when it comes to volumes. If you do a bind mount the permissions of the files/directories on your host system are copied into the container. This can cause numerous issues when it comes time to launch an executable or move/modify files. The main advantage you get is that you can manage your files locally as long as you keep a keen eye on file permissions.

Docker Volumes on the other hand have their permissions and lifecycle managed by Docker. The main downside to this is they are not as straight forward to edit/manage as bind mounts. You can use the `docker volume` command to manage them, but you cannot edit them directly on the host system. The other disadvantage is they can become a huge pain to delete if you are not reusing volumes between runs; mainly in the cause of using `docker run` without specifying details about configuring the volume (omitting the `-v` flag). See the section below for more details about issues with deleting volumes.

If you're comfortable with editing Docker Volume content I highly suggest going that route, it just simplifies everything in my opinion. If you want to use bind mounts you will need to ensure the permissions are correct on the host system before you launch the container. 

#### Issue Deleting Docker Volumes When using Windows Containers

For me, and many others, you cannot delete docker volumes (while in Windows Container mode) even if they are not in use; you will get HTTP 500 error stating you don't have the required permissions. What's worse is even if you uninstall Docker Desktop you still can't delete the volumes. This has been a [known issue](https://github.com/docker/for-win/issues/1544) for years apparently. What did work was a [Powershell script](https://gist.github.com/nicolaskopp/de9fff4889d0ddf4c79da7ebc9e8b918) found on the previously linked issue that kills all Docker processes, then forces ownership/permission for the C:\ProgramData\docker directory, which then allows you to delete the volumes. To ensure a copy of the linked Gist exists even if it is deleted, I put the script below. I did not run the script as is, because its intent is to delete Docker completely, but I did use the ownership/permission commands to fix the issue then manually deleted the volumes.

```powershell
# Leave swarm mode (this will automatically stop and remove services and overlay networks)
docker swarm leave --force
# Stop all running containers
docker ps --quiet | ForEach-Object {docker stop $_}
#just to be sure, sleep 5 seconds
Start-Sleep -s 5
#take ownership of docker files
if (Test-Path "C:\ProgramData\Docker") { takeown.exe /F "C:\ProgramData\Docker" /R /A /D Y }
if (Test-Path "C:\ProgramData\Docker") { icacls "C:\ProgramData\Docker\" /T /C /grant Administrators:F }
#invoke cmd to delete docker files
cmd /c rmdir /s /q "C:\ProgramData\Docker"
```

The commands I modified and used:
```powershell
if (Test-Path "C:\ProgramData\Docker\volumes") { takeown.exe /F "C:\ProgramData\Docker\volumes" /R /A /D Y }
if (Test-Path "C:\ProgramData\Docker\volumes") { icacls "C:\ProgramData\Docker\volumes\" /T /C /grant Administrators:F }
```

## Other Idea to Pursue

Here are a few random thoughts that I didn't explore:
* Other Network Options
  * Do a deeper dive in terms of Windows Firewall especially in the dual firewall you have when using Hyper V Isolation
  * What if we used a Kubernetes  cluster and used a service to expose the ports?
    * Have never used a windows node in a Kubernetes  cluster, but maybe the way ports are handled are different?
    * Grab Rancher Desktop and see if it works?
* Instead of Docker Desktop try a straight Moby install
* Try a Windows Server OS instead of Windows 10/11
* Does Podman support Windows Containers?
* What if we use a dedicated NIC for some of the container networking options?
* Check EPICS repo containing container info
