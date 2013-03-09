#!/usr/bin/python
import re, subprocess
def get_keychain_password(account=None):
    params = {
        'security': '/usr/bin/security',
        'command': 'find-internet-password',
        'account': account,
        'keychain': '/Users/jp/Library/Keychains/login.keychain',
    }
    command = "sudo -u jp %(security)s -v %(command)s -g -a %(account)s %(keychain)s" % params

    output = subprocess.check_output(command, shell=True, stderr=subprocess.STDOUT)
    password_line = [line for line in output.splitlines()
               if line.startswith('password: ')][0]

    return re.match(r'password: "(.*)"', password_line).group(1)
