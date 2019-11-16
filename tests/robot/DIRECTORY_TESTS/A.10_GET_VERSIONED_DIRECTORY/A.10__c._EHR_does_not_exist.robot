*** Settings ***
Documentation    Alternative flow 2: get versioned directory from non existent EHR
...
...     Preconditions:
...         None
...
...     Flow:
...         1. Invoke the GET directory service for a random ehr_id
...         2. The service should return an error related with the non existence of the EHR
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
Alternative flow 2: get versioned directory from non-existent EHR

    Create Fake EHR

    get DIRECTORY at version - fake ehr_id (JSON)

    validate GET-@version response - 404 unknown ehr_id
