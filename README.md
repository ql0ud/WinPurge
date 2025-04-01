# WinPurge

WinPurge is a **PowerShell script** designed to optimize and maintain Windows by **automating deep cleanup tasks**. This script helps to reclaim disk space, enhance system responsiveness, and remove unnecessary clutter efficiently.

It is particularly well-suited for *System Administrators*, *IT Professionals*, and *Power Users* who manage multiple systems or want to maintain their machines in top condition with minimal manual effort. WinPurge consolidates a wide range of cleanup operations into a single, reliable, and repeatable tool.

---

## Key Features

- **System Cleanup:**
  - Removes Windows temporary files
  - Cleans user temporary folders
  - Clears Prefetch data
  - Empties Windows Update cache and DataStore
  - Clears browser caches including Microsoft Edge, Google Chrome, Mozilla Firefox, Brave, and Opera
  - Deletes crash dump files, log files, and thumbnail/icon caches
  - Removes orphaned `.tmp`, `.bak`, and `.old` files
  - Empties Recycle Bin
  - Cleans Windows Error Reporting logs
  - Performs Windows Component Store cleanup using DISM
  - Clears Delivery Optimization cache
  - Clears print spooler queues
  - Removes broken shortcuts from the Start Menu
  - Deletes temporary user profiles

- **Network Maintenance:**
  - Flushes DNS cache
  - Resets TCP/IP stack and Winsock

- **Security & Maintenance:**
  - Clears Windows Defender protection history
  - Removes previous Windows installation files (Windows.old)

- **Advanced Optimization:**
  - Performs disk defragmentation on system drives
  - Runs Compact OS to reduce system footprint

---

## Usage

Open **PowerShell as Administrator** and run:

```
iwr -useb https://raw.githubusercontent.com/ql0ud/WinPurge/main/WinPurge.ps1 | iex
```
This will download and execute the latest version of the script directly from GitHub.

---

## Important

- This script executes operations that permanently delete data. Ensure you have appropriate backups.
- Certain actions, such as clearing event logs or resetting network settings, may affect logging systems or active network connections.
- Administrator privileges are required to execute most cleanup and optimization tasks.

---

## Author

**Qloud**  
[https://github.com/ql0ud](https://github.com/ql0ud)

---

## License

This project is licensed under the [MIT License](LICENSE).
