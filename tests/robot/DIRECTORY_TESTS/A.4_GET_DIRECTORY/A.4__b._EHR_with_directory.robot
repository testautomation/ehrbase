*** Settings ***
Documentation    Alternative flow 1: get directory on EHR with just a root directory
...
...     Preconditions:
...         An EHR with ehr_id exists and has an empty directory.
...
...     Flow:
...         1. Invoke the get directory service for the ehr_id
...         2. The service should return the structure of the empty directory for the EHR
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
Alternative flow 1: get directory on EHR with just a root directory

    Create EHR

    create DIRECTORY (JSON)    empty_directory.json

    get DIRECTORY at version (JSON)
    
    validate GET-@version response - 200 retrieved
