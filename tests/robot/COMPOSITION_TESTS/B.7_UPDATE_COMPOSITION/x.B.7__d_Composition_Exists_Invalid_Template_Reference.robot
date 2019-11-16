*** Settings ***
Documentation     Alternative Flow 3: Update An Existing Persistent Composition Referencing Different Template (XML)
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
${OPT_FILE_2}     minimal_persistent/persistent_minimal_2.opt
${XML_FILE}       minimal_persistent/persistent_minimal.composition.extdatetime.xml
${V2_XML_FILE}    minimal_persistent/persistent_minimal.composition.extdatetime.v2_2.xml

*** Test Cases ***
Alternative Flow 3: Update An Existing Persistent Composition Referencing Different Template (XML)
    Upload OPT    ${OPT_FILE}    XML
    Upload OPT    ${OPT_FILE_2}    XML
    Create EHR    XML
    Commit Composition (XML)    ${XML_FILE}
    Check Content Of Composition (XML)
    Update Composition (XML)    ${V2_XML_FILE}
    TRACE JIRA BUG    EHR-517    not-ready
    Should Be Equal As Strings    ${response.status_code}    400
    [Teardown]    Restart SUT