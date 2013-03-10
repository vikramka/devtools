#!/usr/bin/python
import subprocess
def get_password(account):
  program ='/Users/jp/repositories/developwithpassion/devtools/automation/keychain/get_keychain_password'

  command = "{0} --account:{1}".format(program, account)

  output = subprocess.check_output(command, shell=True)

  return output.rstrip()
