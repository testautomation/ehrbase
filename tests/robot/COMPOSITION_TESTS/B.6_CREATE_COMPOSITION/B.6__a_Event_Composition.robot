*** Settings ***
Documentation     Main Flow: Get Existing Versioned Composition
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

*** Variables ***
${OPT_FILE}    nested/nested.opt
${XML_FILE}    nested/nested.composition.extdatetimes.xml

*** Test Cases ***
Main Flow: Create New Event Composition
    Upload OPT    ${OPT_FILE}
    Create EHR
    Commit Composition (JSON)    ${XML_FILE}
    Validate Template ID Data
    Validate Composer Data
    Validate Setting Data
    [Teardown]    Restart SUT

*** Keywords ***
Validate Template ID Data
    Set Test Variable    ${template_id}    ${response.json()['archetype_details']['template_id']['value']}
    Should Be Equal    ${template_id}    nested.en.v1

Validate Composer Data
    Set Test Variable    ${composer}    ${response.json()['composer']['name']}
    Should Be Equal    ${composer}    Dr. House

Validate Setting Data
    Set Test Variable    ${setting}    ${response.json()['context']['setting']['value']}
    TRACE JIRA BUG  EHR-445  not-ready
    Should Be Equal    ${setting}    Hospital B