*** Settings ***
Documentation    Main flow: get versioned directory from existent and empty EHR
...
...     Preconditions:
...         An empty EHR with known ehr_id exists in the server.
...
...     Flow:
...         1. Invoke the get versioned directory service for the ehr_id
...         2. The service should return an error because the versioned directory doesn't exist
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
Main flow: get versioned directory from existent and empty EHR

    Create EHR

    get DIRECTORY at version - fake version_uid (JSON)

    validate GET-@version response - 404 unknown version_uid
