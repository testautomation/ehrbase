*** Settings ***
Documentation    Main flow: delete directory on empty EHR
...
...     Preconditions:
...         An EHR with ehr_id exists and doesn't have directory.
...
...     Flow:
...         1. Invoke the delete directory service for the ehr_id
...         2. The service should return an error related to the non existent directory
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
Main flow: delete directory on empty EHR

    Create EHR

    delete DIRECTORY - fake version_uid (JSON)

    validate DELETE response - 412 precondition failed
