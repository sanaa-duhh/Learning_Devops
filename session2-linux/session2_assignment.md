# Session 2 - Linux Assignment

---

## Task 1: Soft Links & Hard Links

### What are they?

| | Hard Link | Soft Link (Symbolic Link) |
|---|---|---|
| Points to | The actual data (inode) on disk | The file path/name |
| Works across filesystems | No | Yes |
| Works on directories | No (generally) | Yes |
| Original deleted | File data still accessible | Link breaks (dangling link) |
| Command | `ln` | `ln -s` |

**Key concept:** Every file on Linux has an inode (a unique ID pointing to actual data on disk). A hard link is just another name pointing to the same inode. A soft link is a shortcut that points to a file path — if that path disappears, the soft link breaks.

### Commands

```bash
# Create a hard link
ln original.txt hardlink.txt

# Create a soft link
ln -s original.txt softlink.txt

# Verify — check inode numbers (hard links share the same inode)
ls -li original.txt hardlink.txt softlink.txt

# Delete a link (same command for both types)
rm softlink.txt
rm hardlink.txt
```

### Practice

```bash
# 1. Create a test file
echo "hello devops" > original.txt

# 2. Create both link types
ln original.txt hardlink.txt
ln -s original.txt softlink.txt

# 3. Check inodes — original and hardlink will share the same number
ls -li

# 4. Delete the original and see what happens
rm original.txt
cat hardlink.txt   # still works — data survives
cat softlink.txt   # broken link — file not found
```

### Interview Answer

> **"What is the difference between a hard link and a soft link?"**
>
> A hard link points directly to the inode (the actual data on disk), so even if the original file is deleted, the data remains accessible through the hard link. A soft link (symlink) points to the file path — if the original is deleted, the symlink breaks. Soft links can cross filesystems and point to directories; hard links cannot.

---

## Task 2: `adduser` vs `useradd`

### Difference

| | `useradd` | `adduser` |
|---|---|---|
| Type | Low-level binary | High-level script (Perl/shell wrapper) |
| Home directory | Not created by default | Created automatically |
| Password prompt | No | Yes (interactive) |
| User-friendly | No | Yes |
| Available on | All Linux distros | Debian/Ubuntu-based distros |

**On Ubuntu/Debian: prefer `adduser`** — it handles everything in one go (home dir, password, default shell, user group). `useradd` is the POSIX-standard low-level tool and requires manual flags to do the same thing.

### Commands

```bash
# The verbose, manual way with useradd (what you'd need to match adduser behavior)
sudo useradd -m -s /bin/bash -G sudo testuser1
sudo passwd testuser1

# The easy way with adduser (recommended on Ubuntu)
sudo adduser testuser2
# It will interactively prompt for password and user info

# Verify user was created
id testuser2
cat /etc/passwd | grep testuser2

# Check home directory was created
ls /home/

# Delete test user when done
sudo deluser --remove-home testuser2
```

### Interview Answer

> **"What is the difference between adduser and useradd?"**
>
> `useradd` is a low-level binary available on all Linux distributions. It does not create a home directory or set a password by default — you need to pass flags explicitly. `adduser` is a user-friendly script (on Debian/Ubuntu) that wraps `useradd` and automatically creates the home directory, sets up default shell, and prompts for a password interactively. On Ubuntu, `adduser` is the recommended command for creating users.

---

## Task 3: `journalctl`

### What is it?

`journalctl` is the command-line tool to query and read logs from **systemd's journal** — the centralized logging system on modern Linux distros. It collects logs from the kernel, services, and applications all in one place.

### Common Commands

```bash
# View all logs (newest at bottom)
journalctl

# View logs in real time (like tail -f)
journalctl -f

# View logs for a specific service
journalctl -u nginx
journalctl -u ssh
journalctl -u docker

# View logs for a service in real time
journalctl -u nginx -f

# View logs since last boot
journalctl -b

# View logs from a specific time range
journalctl --since "2024-01-01 10:00:00" --until "2024-01-01 11:00:00"
journalctl --since "1 hour ago"

# Show only errors and above
journalctl -p err

# Show last N lines
journalctl -n 50

# Show logs for the current boot, errors only
journalctl -b -p err
```

### Practice — Check logs for the SSH service

```bash
# Check if SSH service is running
sudo systemctl status ssh

# View its logs
journalctl -u ssh -n 20

# Watch live as you try to connect
journalctl -u ssh -f
```

### Interview Answer

> **"What is journalctl used for?"**
>
> `journalctl` is used to query logs from systemd's journal — the centralized log management system on modern Linux. Unlike older systems that scattered logs across multiple files in `/var/log/`, the systemd journal collects everything (kernel messages, service logs, application output) in a structured binary format. You can filter by service (`-u`), time range (`--since`/`--until`), priority level (`-p`), or follow logs in real time (`-f`).

---

## Task 4: Linux Command Cheat Sheet

Key commands reviewed and practiced from the cheat sheet:

### File & Directory Operations

```bash
ls -la              # list all files with permissions and hidden files
pwd                 # print current directory
cd /path/to/dir     # change directory
mkdir -p a/b/c      # create nested directories
rm -rf dirname      # remove directory and contents
cp -r src/ dest/    # copy directory recursively
mv old new          # move or rename
touch file.txt      # create empty file
```

### File Content

```bash
cat file.txt        # print file contents
less file.txt       # paginated view
head -n 10 file     # first 10 lines
tail -n 10 file     # last 10 lines
tail -f file        # follow file in real time (great for logs)
grep "pattern" file # search for pattern in file
grep -r "pattern" . # recursive search in current directory
```

### Permissions

```bash
chmod 755 file      # rwxr-xr-x
chmod +x script.sh  # make executable
chown user:group file  # change owner
ls -l               # view permissions
```

### Process Management

```bash
ps aux              # list all running processes
top                 # live process monitor
htop                # interactive process monitor (if installed)
kill -9 PID         # force kill a process
pkill processname   # kill by name
```

### Disk & System Info

```bash
df -h               # disk usage (human readable)
du -sh *            # size of each item in current dir
free -h             # RAM usage
uname -a            # kernel and system info
uptime              # how long system has been running
```

### Networking

```bash
ip a                # show IP addresses
ping google.com     # test connectivity
curl -I url         # fetch HTTP headers
netstat -tuln       # show open ports
ss -tuln            # modern replacement for netstat
```

### User & Group Management

```bash
whoami              # current user
id username         # user ID and group memberships
sudo command        # run as root
su - username       # switch user
passwd username     # change password
```

### Package Management (Ubuntu/Debian)

```bash
sudo apt update           # refresh package list
sudo apt install package  # install a package
sudo apt remove package   # remove a package
sudo apt upgrade          # upgrade all packages
```
