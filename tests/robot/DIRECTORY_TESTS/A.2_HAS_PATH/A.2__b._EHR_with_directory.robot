*** Settings ***
Documentation    Alternative flow 1: has path on EHR with just root directory
...
...     Preconditions:
...         An EHR with known ehr_id exists and has an empty directory (no subfolders or items).
...
...     Flow:
...         1. Invoke the has path service for the ehr_id and the path $path from the data set
...         2. The result must be $result from the data set
...
...     Postconditions:
...         None
...
...     Data set
...         DS   | $path                   | $result |
...         -----+-------------------------+---------+
...         DS 1 | /                       | true    |
...         DS 2 | _any_other_random_path_ | false   |


Resource    ${EXECDIR}${/}tests${/}robot${/}_resources${/}suite_settings.robot
Resource    ${EXECDIR}${/}tests${/}robot${/}_resources${/}keywords${/}generic_keywords.robot
Resource    ${EXECDIR}${/}tests${/}robot${/}_resources${/}keywords${/}contribution_keywords.robot
Resource    ${EXECDIR}${/}tests${/}robot${/}_resources${/}keywords${/}directory_keywords.robot
Resource    ${EXECDIR}${/}tests${/}robot${/}_resources${/}keywords${/}template_opt1.4_keywords.robot
Resource    ${EXECDIR}${/}tests${/}robot${/}_resources${/}keywords${/}ehr_keywords.robot

#Suite Setup  Startup SUT
# Test Setup  start openehr server
# Test Teardown  restore clean SUT state
#Suite Teardown  Shutdown SUT

Force Tags



*** Test Cases ***
Alternative flow 1: has path on EHR with just root directory (DS 1)

    Create EHR

    create DIRECTORY (JSON)    empty_directory.json

    get FOLDER in DIRECTORY at version (JSON)    /

    validate GET-@version response - 200 retrieved



Alternative flow 1: has path on EHR with just root directory (DS 2)

    Create EHR

    create DIRECTORY (JSON)    empty_directory.json

    generate random path

    get FOLDER in DIRECTORY at version (JSON)    ${path}

        TRACE GITHUB ISSUE  36  not-ready  DISCOVERED ISSUE: `path` URI parameter is ignored(?)

    validate GET-@version response - 404 unknown path
