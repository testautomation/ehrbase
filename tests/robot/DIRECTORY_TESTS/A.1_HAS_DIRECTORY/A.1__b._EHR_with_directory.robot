*** Settings ***
Documentation    Alternative flow 1: has directory on existing EHR with directory
...
...     Preconditions:
...         An EHR with known ehr_id exists and has directory.
...
...     Flow:
...         1. Invoke the has DIRECTORY service for the ehr_id
...         2. The result must be true
...
...     Postconditions:
...         None


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
Alternative flow 1: has directory on existing EHR with directory

    Create EHR

    create DIRECTORY (JSON)    subfolders_in_directory.json

    get DIRECTORY (JSON)

    validate GET response - 200 retrieved
