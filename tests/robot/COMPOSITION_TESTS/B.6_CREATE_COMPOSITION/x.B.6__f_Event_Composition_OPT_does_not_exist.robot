*** Settings ***
Documentation     Alternative Flow 5: Create New Event Composition Referenced Opt Does Not Exist (XML)
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
${XML_FILE}    nested/nested.composition.extdatetimes.optdoesntexist.xml

*** Test Cases ***
Alternative Flow 5: Create New Event Composition Referenced Opt Does Not Exist (XML)
    Create EHR    XML
    composition_keywords.Start Request Session    application/xml    application/json   Prefer=return\=representation
    Commit Composition - No Referenced OPT    ${XML_FILE}