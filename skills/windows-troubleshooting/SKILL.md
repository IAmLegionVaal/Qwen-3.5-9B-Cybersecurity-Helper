---
name: windows-troubleshooting
description: Investigates Windows boot, application, services, updates and endpoint health issues.
---

# Windows troubleshooting

Use for Windows 10/11 and Windows Server issues involving boot, system services, policies, event logs, disk and client application failures.

## Triage

1. Capture symptoms, build, onset, affected users/devices, update history and evidence of a wider outage.
2. Establish whether the failure is local, profile-specific, domain-related or service-wide.
3. Collect read-only evidence first: Event Viewer channels, service state, reliability history, performance counters, storage and security telemetry.
4. Check dependencies and recent changes before restarting services or removing components.
5. Propose smallest reversible remediation, record the change, verify and establish rollback.

## Read-only examples

~~~powershell
Get-ComputerInfo | Select-Object WindowsProductName,WindowsVersion,OsBuildNumber
Get-Service | Where-Object Status -eq 'Stopped' | Select-Object -First 20 Name,DisplayName
Get-WinEvent -FilterHashtable @{LogName='System';StartTime=(Get-Date).AddHours(-4)} -MaxEvents 30
Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3" | Select-Object DeviceID,FreeSpace,Size
~~~

Avoid dumping event payloads that contain personal or credential material into public artifacts.

## OS repair decision

Use component integrity tools such as DISM and SFC when evidence points to corruption. Capture return codes and the relevant log path. Do not run destructive repair, reset or account deletion as a first-line approach.

## Security boundary

Preserve EDR, BitLocker and audit telemetry. Treat unknown scheduled tasks, Run keys and new services as possible persistence until investigated, not automatically malicious. Prefer snapshots/backups before high-impact operations.

## Completion

Document symptom, evidence, diagnosis confidence, exact commands, observed result and outstanding risk. Never claim repair succeeded solely because a command was submitted.
