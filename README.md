![image](https://github.com/user-attachments/assets/5ac4f2af-2f01-45e4-8771-2421484fdc06)

``` Because.. one morning I woke in a panic wondering if I got hacked :3```

# DaraHaTa
Lazy Windows event logs fast forensics timeline generator and threat hunting script.

The project name is a wordplay on "Dara" which means Lazy, "Ha" for Hayabusa, and "Ta" for Takajo.

I created this project to scan my Windows laptop for threats lazily. Please refer to https://github.com/Yamato-Security for anything regarding Hayabusa and Takajo or using these tools in any production setting. 




## Setup
It is recommended to apply the [Yamato Security's Windows Event Log Configuration Guide For DFIR And Threat Hunting](https://github.com/Yamato-Security/EnableWindowsLogSettings) to capture most of the required events for analysis. A sample YamatoSecurityConfigureWinEventLogs.bat is included in this project. Please be advised that using this will allow your Event Logs to grow up to ~1 Gigabyte, so make sure you have enough disk space!
