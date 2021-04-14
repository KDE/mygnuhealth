####################################################################
#   Copyright (C) 2020-2021 Luis Falcon <falcon@gnuhealth.org>
#   Copyright (C) 2020-2021 GNU Solidario <health@gnusolidario.org>
#   License: GPL v3+
#   Please read the COPYRIGHT and LICENSE files of the package
####################################################################

import requests


def test_federation_connection(protocol, host, port, acct, passwd):
    """
    Connection test to Thalamus Server
    """
    conn = ''

    url = f'{protocol}://{host}:{port}/people/{acct}'

    try:
        conn = requests.get(url, auth=(acct, passwd), verify=False)

    except Exception as e:
        print(f"Connection error: {e}")
        login_status = -2

    if conn:
        print("***** Connection to Thalamus Server OK !******")
        login_status = 0
    else:
        print("##### Wrong credentials ####")
        login_status = -1

    print(login_status)
    return login_status

