*** Settings ***
Documentation     Alternative Flow 2: Get Versioned Composition EHR Does Not Exist (XML)
Resource          ${EXECDIR}${/}tests${/}robot${/}_resources${/}suite_settings.robot
Resource          ${EXECDIR}${/}tests${/}robot${/}_resources${/}keywords${/}generic_keywords.robot
Resource          ${EXECDIR}${/}tests${/}robot${/}_resources${/}keywords${/}aql_query_keywords.robot
Resource          ${EXECDIR}${/}tests${/}robot${/}_resources${/}keywords${/}ehr_keywords.robot
Resource          ${EXECDIR}${/}tests${/}robot${/}_resources${/}keywords${/}contribution_keywords.robot
Resource          ${EXECDIR}${/}tests${/}robot${/}_resources${/}keywords${/}composition_keywords.robot
Resource          ${EXECDIR}${/}tests${/}robot${/}_resources${/}keywords${/}template_opt1.4_keywords.robot
Force Tags        XML
# Suite Setup       Startup SUT
# Suite Teardown    Shutdown SUT

*** Test Cases ***
Alternative Flow 2: Get Versioned Composition EHR Does Not Exist (XML)
    Generate Random EHR ID
    Generate Random Composition UID
    composition_keywords.Start Request Session    application/xml    application/xml
    Get Composition By Composition UID    ${versioned_object_uid}
    Check Versioned Composition Does Not Exist