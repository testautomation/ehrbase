*** Settings ***
Documentation    Main flow: create directory on empty EHR
...
...     Preconditions:
...         An EHR with ehr_id exists and doesn't have directory
...
...     Flow:
...         1. Invoke the create directory service for a random ehr_id
...         2. The service should return a a positive result related with the
...            directory just created for the EHR
...
...     Postconditions:
...         The EHR ehr_id has directory


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
Main flow: create directory on empty EHR

    Create EHR

    create DIRECTORY (JSON)    empty_directory.json

    validate POST response - 201 created
