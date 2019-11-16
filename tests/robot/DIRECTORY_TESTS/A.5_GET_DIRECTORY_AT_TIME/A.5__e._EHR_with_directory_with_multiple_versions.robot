*** Settings ***
Documentation    Alternative flow 4: get directory at time on EHR with directory with multiple versions
...
...     Preconditions:
...         An EHR with ehr_id exists and has directory with two versions.
...
...     Flow:
...         1. Invoke the get directory at time service for the ehr_id and current time
...         2. The service should return the current latest directory
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
Alternative flow 4: get directory at time on EHR with directory with multiple versions

    Create EHR

    create DIRECTORY (JSON)    empty_directory.json

    update DIRECTORY (JSON)    subfolders_in_directory_with_details_items.json

    get DIRECTORY at current time (JSON)
    
    validate GET-version@time response - 200 retrieved
