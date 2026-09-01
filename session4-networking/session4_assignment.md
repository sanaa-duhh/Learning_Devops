# Session 4 - Networking Assignment

Practiced networking commands and documented the output with explanations.

---

## 1. `ping`

Tests connectivity to a host by sending packets and measuring response time.

```bash
ping -c 4 google.com
```

![session4_1](../.screenshots/session4_1.png)

---

## 2. `ifconfig` / `ip a`

Shows all network interfaces and their IP addresses assigned to your machine.

```bash
ifconfig
```

![session4_2](../.screenshots/session4_2.png)

---

## 3. `traceroute`

Shows the path packets take to reach a destination, hop by hop.

```bash
traceroute google.com
```

![session4_3](../.screenshots/session4_3.png)

---

## 4. `nslookup`

Queries DNS to find the IP address of a domain name.

```bash
nslookup google.com
```

![session4_4](../.screenshots/session4_4.png)

---

## 5. `dig`

Like nslookup but more detailed. Shows the full DNS response including TTL, record type, and which DNS server answered.

```bash
dig google.com
```

![session4_5](../.screenshots/session4_5.png)

---

## 6. `netstat`

Shows active network connections, open ports, and routing info.

```bash
netstat -an | head -20
```

![session4_6](../.screenshots/session4_6.png)

---

## 7. `curl`

Makes HTTP requests from the terminal. Useful for testing APIs and checking if a URL is reachable.

```bash
curl -I https://google.com
```

![session4_7](../.screenshots/session4_7.png)

---

## 8. `arp -a`

Shows the ARP table — the mapping of IP addresses to MAC addresses on the local network.

```bash
arp -a
```

![session4_8](../.screenshots/session4_8.png)

---

## 9. `ss`

Modern replacement for netstat. Shows socket connections and open ports faster and with more detail.
(ss doesn't work on mac)
```bash
netstat -an | grep LISTEN
```

![session4_9](../.screenshots/session4_9.png)
