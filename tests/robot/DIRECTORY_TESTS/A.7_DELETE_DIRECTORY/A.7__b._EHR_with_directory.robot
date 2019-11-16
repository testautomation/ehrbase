*** Settings ***
Documentation    Alternative flow 1: delete directory from EHR with directory
...
...     Preconditions:
...         An EHR with ehr_id exists and has directory.
...
...     Flow:
...         1. Invoke the delete directory service for the ehr_id
...         2. The service should return a positive result related with the deleted directory
...
...     Postconditions:
...         The EHR ehr_id doesn't have directory


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
Alternative flow 1: delete directory from EHR with directory

    Create EHR

    create DIRECTORY (JSON)    subfolders_in_directory_items.json

    delete DIRECTORY (JSON)

    validate DELETE response - 204 deleted
