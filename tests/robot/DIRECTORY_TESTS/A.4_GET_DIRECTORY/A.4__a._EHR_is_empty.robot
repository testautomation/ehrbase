*** Settings ***
Documentation    Main flow: get directory on empty EHR
...
...     Preconditions:
...         An EHR with ehr_id exists.
...
...     Flow:
...         1. Invoke the get directory service for the ehr_id
...         2. The service should return an error, related to the directory that doesn't exist
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
Main flow: get directory on empty EHR

    Create EHR

    get DIRECTORY (JSON)

    validate GET-version@time response - 404 unknown folder-version@time
