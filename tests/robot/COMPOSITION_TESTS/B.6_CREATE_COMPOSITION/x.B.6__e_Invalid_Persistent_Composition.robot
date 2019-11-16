*** Settings ***
Documentation     Alternative Flow 4: Create New Invalid Persistent Composition (XML)
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
${OPT_FILE}    minimal_persistent/persistent_minimal.opt
${XML_FILE}    minimal_persistent/persistent_minimal.composition.extdatetime.invalid.xml

*** Test Cases ***
Alternative Flow 4: Create New Invalid Persistent Composition (XML)
    Upload OPT    ${OPT_FILE}    XML
    Create EHR    XML
    TRACE JIRA BUG    EHR-414    not-ready
    Commit Invalid Composition (XML)    ${XML_FILE}
    [Teardown]    Restart SUT