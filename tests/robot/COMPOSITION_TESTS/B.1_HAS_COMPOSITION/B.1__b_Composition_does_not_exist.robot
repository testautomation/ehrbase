*** Settings ***
Documentation     Alternative Flow 1: Has Composition, Composition Does Not Exist (JSON)
Resource          ${EXECDIR}${/}tests${/}robot${/}_resources${/}suite_settings.robot
Resource          ${EXECDIR}${/}tests${/}robot${/}_resources${/}keywords${/}generic_keywords.robot
Resource          ${EXECDIR}${/}tests${/}robot${/}_resources${/}keywords${/}aql_query_keywords.robot
Resource          ${EXECDIR}${/}tests${/}robot${/}_resources${/}keywords${/}ehr_keywords.robot
Resource          ${EXECDIR}${/}tests${/}robot${/}_resources${/}keywords${/}contribution_keywords.robot
Resource          ${EXECDIR}${/}tests${/}robot${/}_resources${/}keywords${/}composition_keywords.robot
Resource          ${EXECDIR}${/}tests${/}robot${/}_resources${/}keywords${/}template_opt1.4_keywords.robot
Force Tags        JSON
# Suite Setup       Startup SUT
# Suite Teardown    Shutdown SUT

*** Test Cases ***
Alternative Flow 1: Has Composition, Composition Does Not Exist (JSON)
    Create EHR
    Generate Random Composition UID
    composition_keywords.Start Request Session
    Get Composition By Composition UID    ${version_uid}
    Check Composition Does Not Exist