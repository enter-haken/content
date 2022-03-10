# CtrlP

Knowing only part of a filename?
When you can use [CtrlP][1] for doing a fuzzy search on the file system.

<!--more-->

## Example

You are looking for a **ufw init script**.
After opening vim in the `etc` folder, you start typing `ini`

```
> 3.0/settings.ini
> /etc/machine-id
> /etc/odbc.ini
> /etc/init.d/dbus
> /etc/init.d/lvm2
> /etc/init.d/udev
> /etc/gdb/gdbinit
> /etc/init.d/sssd
> /etc/init.d/ufw
> /etc/init.d/ssh
[...]
>>> ini_
```

Almost there

```
> /etc/fonts/conf.avail/20-unhint-small-dejavu-sans-mono.conf
> /etc/fonts/conf.avail/20-unhint-small-dejavu-lgc-serif.conf
> /etc/fonts/conf.avail/20-unhint-small-dejavu-lgc-sans.conf
> /etc/fonts/conf.avail/20-unhint-small-dejavu-serif.conf
> /etc/fonts/conf.avail/20-unhint-small-dejavu-sans.conf
> /etc/initramfs-tools/update-initramfs.conf
> /etc/openmpi/openmpi-default-hostfile
> /etc/fonts/conf.avail/10-hinting-medium.conf
> /etc/fonts/conf.avail/10-hinting-full.conf
> /etc/init.d/ufw
[...]
>>> iniuf_
```

Hitting `Enter` will open the last file in the list.

If you want to see sibling files, you can do a **NERDTreeFind**, to open the filesystem at the right place. 

```
[...]
    nfs-common* [RO]           │ 18
    nfs-kernel-server* [RO]    │ 19 . /lib/lsb/init-functions
    openvpn* [RO]              │ 20
    plymouth* [RO]             │ 21 for s in "/lib/ufw/ufw-init-functions" "/etc/ufw/ufw.conf" "/etc/default/ufw" ; do
    plymouth-log* [RO]         │ 22     if [ -s "$s" ]; then
    pppd-dns* [RO]             │ 23         . "$s"
    procps* [RO]               │ 24     else
    pulseaudio-enable-autospawn│ 25         log_failure_msg "Could not find $s (aborting)"
    rpcbind* [RO]              │ 26         exit 1
    rsync* [RO]                │ 27     fi
    rsyslog* [RO]              │ 28 done
    saned* [RO]                │ 29
    screen-cleanup* [RO]       │ 30 error=0
    speech-dispatcher* [RO]    │ 31 case "$1" in
    spice-vdagent* [RO]        │ 32 start)
    ssh* [RO]                  │ 33     if [ "$ENABLED" = "yes" ] || [ "$ENABLED" = "YES" ]; then
    sssd* [RO]                 │ 34         log_action_begin_msg "Starting firewall:" "ufw"
    udev* [RO]                 │ 35         output=`ufw_start` || error="$?"
    ufw* [RO]                  │ 36         if [ "$error" = "0" ]; then
    unattended-upgrades* [RO]  │ 37             log_action_cont_msg "Setting kernel variables ($IPT_SYSCTL)"
    uuidd* [RO]                │ 38         fi
    virtualbox* [RO]           │ 39         if [ ! -z "$output" ]; then
    whoopsie* [RO]             │ 40             echo "$output" | while read line ; do
    x11-common* [RO]           │ 41                 log_action_cont_msg "$:w
[...]
```

**CtrlP** and **NERDTree** play well together.

## configuration

```
" add an artificial anchor to bigger projects to improve search experience
let g:ctrlp_root_markers = ['.ctrlp_anchor']
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif
```

I use the [silver searcher][2] for finding files.
As you can see you can **override** the standard used search method, as soon you can get the output searchable for the plugin.

If you are in a git controlled environment, you can also consider using [git grep][3]. 
This should be a even faster search. 
But `git grep` won't consider newly created files.

## installation

```
Plug 'ctrlpvim/ctrlp.vim'
```

[1]: https://github.com/ctrlpvim/ctrlp.vim
[2]: https://github.com/ggreer/the_silver_searcher
[3]: https://git-scm.com/book/en/v2/Git-Tools-Searching
