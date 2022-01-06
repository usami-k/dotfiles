#!/usr/bin/env fish

if command --query tlmgr
    tlmgr update --self --all --reinstall-forcibly-removed
end
