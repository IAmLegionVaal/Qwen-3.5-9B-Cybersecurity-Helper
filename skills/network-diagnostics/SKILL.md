---
name: network-diagnostics
description: Troubleshoots network, DNS, VPN, TLS, routing, latency and service port connectivity.
---

# Network diagnostics

Use for slow connections, packet loss, name resolution, TCP/UDP availability, VPN split tunneling, firewall and certificate problems.

## Layered method

1. Define exact source, destination, port, protocol and observed symptom.
2. Check interface/link/DHCP/DNS/default gateway and local IP configuration.
3. Confirm route selection and split-tunnel policy before assuming the ISP is at fault.
4. Test DNS separately from transport: A/AAAA and SRV resolution are not TCP connection success.
5. Validate TCP listeners/firewall/ACLs using actual ports. A UDP probe does not prove TCP availability.
6. Measure latency, packet loss and jitter over repeated windows, noting where tests originate.
7. Correlate with edge firewall, VPN gateway or ISP telemetry, with timestamps.

## Read-only examples

~~~powershell
Get-NetIPConfiguration
Resolve-DnsName example.org
Test-NetConnection example.org -Port 443 -InformationLevel Detailed
Get-NetRoute -AddressFamily IPv4 | Sort-Object RouteMetric | Select-Object -First 20
tracert example.org
~~~

## Interpretation

Speed-test ping may differ from loaded download/upload latency. High loaded latency can reflect congestion, bufferbloat or radio/Wi-Fi issues; it does not alone prove fiber physical instability. TCP failure can arise from a down listener, route, local firewall, intermediate firewall or service binding.

## Constraints

No indiscriminate network scans, policy disablement, or public disclosure of internal IPs. Ask before packet capture when user data or secrets may be included. For external escalation, share redacted source/time/window/latency and business impact.
