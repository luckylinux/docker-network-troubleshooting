# docker-network-troubleshoot

# Setup
You need to first clone the Common https://github.com/luckylinux/container-build-tools somewhere in your System first, as I didn't want to over-complicate the Setup with `git subtree` or `git submodule`).

Then Symlink the Directory within this Repository to the "includes" Target:
```
git clone https://github.com/luckylinux/docker-network-troubleshooting
cd docker-network-troubleshooting
ln -s /path/to/container-build-tools includes
```

# Build
The Container can simply be built using:
```
./build.sh
```

Edit the Options to your liking.
