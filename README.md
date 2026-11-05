# IT Support Toolkit

Small, safe PowerShell helpers for common Windows support tasks, from my day-to-day work in desktop IT support. Each script explains what it does before it runs, changes nothing silently, and can be read in full before use.

## Scripts

| Script | What it does | When to use it |
|---|---|---|
| `Clear-PrintQueue.ps1` | Stops the Print Spooler, clears stuck jobs, restarts it | A document is stuck and nothing will print |
| `Check-DiskSpace.ps1` | Shows free space on all drives and the largest folders in the user profile | "My computer is so slow" / disk almost full |
| `Reset-Network.ps1` | Renews the IP address, flushes DNS and shows the new configuration | Wi-Fi/LAN connected but no internet |
| `Get-SystemInfo.ps1` | Collects PC name, Windows version, RAM, CPU and disk facts for a support ticket | Opening a ticket and support asks "which PC / which Windows?" |

## How to run

1. Right-click Start → **Terminal (Admin)** or **Windows PowerShell (Admin)**
2. Allow local scripts for this session only:
   `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass`
3. Run a script, e.g. `.\Clear-PrintQueue.ps1`

## Notes

- Free to use and adapt. Test in your own environment first.
- Written by Md. Mamun Or Rashid — IT Support Specialist.
