#!/usr/bin/python
import subprocess
import re

def get_password(account):
  program ='/Users/jp/repositories/developwithpassion/devtools/automation/keychain/get_keychain_password'

  command = "{0} --account:{1}".format(program, account)

  output = subprocess.check_output(command, shell=True)

  return output.rstrip()

def exclusion_patterns():
  return [
  "efax",
  "earth_class_mail",
  "eventbrite",
  "gotomeeting",
  "moshi_monsters",
  "peepcode",
  "raini_fowl",
  "stuart_know",
  "training.*2008",
  "training.*2009",
  "training.*2010",
  "training.*2011",
  "training.*2012",
  "training.*nbdn",
  "training.*nothin_but_bdd",
  "unblock_us",
  "web_hosting",
  "webinars",
  "Gmail.*Spam",
  "Gmail.*Important"
  ]

def is_excluded(folder):
  result = False

  for pattern in exclusion_patterns():
    result = result or (re.search(pattern, folder) != None)

  return result


