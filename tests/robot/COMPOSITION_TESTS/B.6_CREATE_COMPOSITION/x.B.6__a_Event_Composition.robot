*** Settings ***
Documentation     Main Flow: Get Existing Versioned Composition (XML)
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

*** Variables ***
${OPT_FILE}    nested/nested.opt
${XML_FILE}    nested/nested.composition.extdatetimes.xml

*** Test Cases ***
Main Flow: Create New Event Composition (XML)
    Upload OPT    ${OPT_FILE}    XML
    Create EHR    XML
    Commit Composition (XML)    ${XML_FILE}
    TRACE JIRA BUG    EHR-445    not-ready
    Validate xTemplate ID Data
    Validate xComposer Data
    Validate xSetting Data
    [Teardown]    Restart SUT

*** Keywords ***
Validate xTemplate ID Data
    ${xresp}=    Parse Xml    ${response.text}
    ${xtemplate_id}=    Get Element    ${xresp}    archetype_details/template_id/value
    Element Text Should Be    ${xtemplate_id}    nested.en.v1

Validate xComposer Data
    ${xcomposer}=    Get Element    ${xresp}    composer/name
    Element Text Should Be    ${xcomposer}    Dr. House

Validate xSetting Data
    ${xsetting}=    Get Element    ${xresp}    context/setting/value
    Should Be Equal    ${setting}    Hospital B