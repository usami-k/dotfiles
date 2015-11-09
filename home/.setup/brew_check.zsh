#!/bin/zsh
diff <(brew leaves | sort) <(cat brew_leaves | sed "/^#/d" | sed "/^$/d" | sort)
