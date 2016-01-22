#!/bin/sh
pip3 install $(cat pip_list | sed "/^#/d")
