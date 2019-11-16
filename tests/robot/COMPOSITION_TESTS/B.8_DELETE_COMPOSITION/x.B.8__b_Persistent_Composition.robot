*** Settings ***
Documentation     Alternative Flow 1: Delete Persistent Composition (XML)
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
${OPT_FILE}       minimal_persistent/persistent_minimal.opt
${V2_XML_FILE}    minimal_persistent/persistent_minimal.composition.extdatetime.xml

*** Test Cases ***
Alternative Flow 1: Delete Persistent Composition (XML)
    Upload OPT    ${OPT_FILE}    XML
    Create EHR    XML
    Commit Composition (XML)    ${OPT_FILE}
    Delete Composition    ${preceding_version_uid}
    TRACE JIRA BUG    EHR-413    not-ready
    TRACE JIRA BUG    EHR-436    not-ready
    Get Deleted Composition
    # [Teardown]    Restart SUT