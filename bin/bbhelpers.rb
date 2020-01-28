#!/usr/bin/env ruby
#
# Copyright 2016 Joe Block <jpb@unixorn.net>
#
# License: Apache 2.0, see LICENSE in this repository.
#
# Helper functions that are common across the git-bb-* scripts. Admittedly
# not very pretty.

def git_branch
  `git rev-parse --abbrev-ref HEAD`.chomp
end

def git_commit
  `git rev-parse HEAD`.chomp
end

def git_remote
  `git config --get remote.origin.url`.chomp
end

SSH_REGEX = /ssh:\/\/git@(?<host>[^\/]*)\/(?<project>[^\/]*)\/(?<repo>[^\.]*).git/
HTTPS_REGEX = /https:\/\/(?<host>[^\/]*)\/scm\/(?<project>[^\/]*)\/(?<repo>[^\.]*).git/

def git_base_url
  matches = git_remote().match(SSH_REGEX)
  matches ||= git_remote().match(HTTPS_REGEX)
  return "https://#{matches[:host]}/projects/#{matches[:project]}/repos/#{matches[:repo]}/"
end

def git_root
  `git rev-parse --show-toplevel`.chomp
end

def openURL(url)
  if RUBY_PLATFORM.index('darwin')
    open_command = 'open'
  end
  if RUBY_PLATFORM.index('linux')
    open_command = 'xdg-open'
  end
  system("#{open_command} #{url}")
end
