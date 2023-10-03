# Backup configuration

<!-- content start -->
Create a [systemd.service](https://www.freedesktop.org/software/systemd/man/systemd.service.html) file to back up to the mount point.

Copy the following content and save as `/usr/local/lib/systemd/system/unipi-config-backup.service`.
With the `ExecStartPost` all backups older than 7 days are deleted.

```ini
[Unit]
Description=Unipi Config Backup
After=network.target media-backup.mount
Requires=media-backup.mount
RequiresMountsFor=/media/backup

[Service]
ExecStart=/usr/local/bin/unipi-config-backup -c /usr/local/etc/unipi /media/backup
ExecStartPost=/bin/find /media/backup -name "config-*.tar.gz" -type f -mtime +7 -delete

[Install]
WantedBy=multi-user.target
```

Create a [systemd.timer](https://www.freedesktop.org/software/systemd/man/systemd.timer.html) file to automaticly start the systemd service.

Copy the following content and save as `/usr/local/lib/systemd/system/unipi-config-backup.timer`.
With `OnCalendar` you can change the timer interval.

```ini
[Unit]
Description=Unipi Config Backup

[Timer]
OnCalendar=*-*-* 4:00:00

[Install]
WantedBy=timers.target
```

## Mount point

Create a [systemd.mount](https://www.freedesktop.org/software/systemd/man/systemd.mount.html) file to mount the samba or nfs share.

### Samba

Copy the following content and save as `/etc/systemd/system/media-backup.mount`.

```ini
[Unit]
Description=Backup partition
StopWhenUnneeded=true

[Mount]
What=//HOSTNAME/SHARE
Where=/media/backup
Type=cifs
Options=username=USERNAME,password=PASSWORD,workgroup=WORKGROUP,rw

[Install]
WantedBy=local-fs.target
```
> The mount point is automatically unmount when not needed.

### NFS

Copy the following content and save as `/etc/systemd/system/media-backup.mount`.

```ini
[Unit]
Description=Backup partition
StopWhenUnneeded=true

[Mount]
What=HOSTNAME:/SHARE
Where=/media/backup
Type=nfs

[Install]
WantedBy=local-fs.target
```

### Automount

Enable systemd automount to mount the share on access.
Copy the following content and save as `/etc/systemd/system/media-backup.automount`.

```ini
[Unit]
Description=Backup partition (automount)

[Automount]
Where=/media/backup

[Install]
WantedBy=local-fs.target
```

Enable the systemd automount:

```bash
systemctl enable --now media-backup.automount
```

## Enable backup

Enable the systemd timer:

```bash
systemctl enable unipi-config-backup.timer
```

<!-- content end -->
