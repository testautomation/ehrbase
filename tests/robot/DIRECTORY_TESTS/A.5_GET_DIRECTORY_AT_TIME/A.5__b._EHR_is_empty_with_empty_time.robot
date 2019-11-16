*** Settings ***
Documentation    Alternative flow 1: get directory at time on empty EHR with empty time
...
...     Preconditions:
...         An EHR with ehr_id exists and doesn't have directory.
...
...     Flow:
...         1. Invoke the get directory at time service for the ehr_id and empty time
...         2. The service should return feedback related to the non existent directory
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
Alternative flow 1: get directory at time on empty EHR with empty time

    Create EHR

    get DIRECTORY at time (JSON)    ${EMPTY}

    validate GET-version@time response - 404 unknown folder-version@time
