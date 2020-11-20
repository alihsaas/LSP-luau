all: \
	out/windows-x64/release.zip \
	out/osx-x64/release.zip \
	out/linux-x64/release.zip

BINDIR_windows-x64 = Windows
BINDIR_osx-x64 = macOS
BINDIR_linux-x64 = Linux

VSCODE_LUA = vscode-robloxluau

SOURCE = \
	plugin.py \
	LSP-robloxluau.sublime-commands \
	LSP-robloxluau.sublime-settings \
	NOTICE \
	LICENSE

FILES = \
	$(VSCODE_LUA)/server/libs \
	$(VSCODE_LUA)/server/locale \
	$(VSCODE_LUA)/server/script \
	$(VSCODE_LUA)/server/rbx \
	$(VSCODE_LUA)/server/main.lua \
	$(VSCODE_LUA)/server/platform.lua \
	$(SOURCE)

out/%/release.zip: $(VSCODE_LUA) $(SOURCE) patch.diff
	mkdir -p out/$*/bin/$(BINDIR_$*)
	rsync -a $(FILES) out/$*/
	rsync -a $(VSCODE_LUA)/server/bin/$(BINDIR_$*)/ out/$*/bin/$(BINDIR_$*)
	chmod +x out/$*/bin/$(BINDIR_$*)/*
	patch out/$*/main.lua patch.diff
	touch out/$*/.no-sublime-package
	cd out/$* && zip -q -r release.zip .

$(VSCODE_LUA):
	git clone --depth=1 --recursive https://github.com/NightrainsRbx/RobloxLsp.git $(VSCODE_LUA)

clean:
	rm -rf out $(VSCODE_LUA)

.PHONY: all clean
