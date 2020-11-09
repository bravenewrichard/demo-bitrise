import requests
import semver
from requests.exceptions import HTTPError


ALL_STACK_INFO = 'https://app.bitrise.io/app/6c06d3a40422d10f/all_stack_info'
SYSTEM_REPORTS = 'https://github.com/bitrise-io/bitrise.io/tree/master/system_reports'
pattern = 'osx-xcode-'

# jq ' . | keys'
#[
#  "available_stacks",
#  "project_types_with_default_stacks",
#  "running_builds_on_private_cloud"
#]

resp = requests.get(ALL_STACK_INFO)
resp.raise_for_status()
resp_json = resp.json()


def parse_semver(raw_str):
    parsed = raw_str.split(pattern)[1]
    if parsed[-1] == 'x':
        p = parsed.split('.x')[0]
        return '{0}.0'.format(p)
    else:
        return False


def largest_version(resp):
    count = 0
    for item in resp:
        if pattern in item:
            p = parse_semver(item)
            if p:
                if count == 0 or semver.compare(largest, p) == -1:
                    largest = p 
                count += 1
    return largest


try:
    resp = requests.get(ALL_STACK_INFO)
    resp.raise_for_status()
    resp_json = resp.json()
    r = resp_json['available_stacks']
except HTTPError as http_error:
    print('An HTTP error has occurred: {http_error}')

except Exception as err:
    print('An exception has occurred: {err}')

l = largest_version(r)
print(l)


