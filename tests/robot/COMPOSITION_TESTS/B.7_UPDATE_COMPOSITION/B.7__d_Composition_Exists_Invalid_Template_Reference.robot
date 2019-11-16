*** Settings ***
Documentation     Alternative Flow 3: Update An Existing Persistent Composition Referencing Different Template
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
${OPT_FILE}       minimal_persistent/persistent_minimal.opt
${OPT_FILE_2}     minimal_persistent/persistent_minimal_2.opt
${XML_FILE}       minimal_persistent/persistent_minimal.composition.extdatetime.xml
${V2_XML_FILE}    minimal_persistent/persistent_minimal.composition.extdatetime.v2_2.xml

*** Test Cases ***
Alternative Flow 3: Update An Existing Persistent Composition Referencing Different Template
    Upload OPT    ${OPT_FILE}
    Upload OPT    ${OPT_FILE_2}
    Create EHR
    Commit Composition (JSON)    ${XML_FILE}
    Check Content Of Composition (JSON)
    Update Composition (JSON)    ${V2_XML_FILE}
    TRACE JIRA BUG    EHR-517    not-ready
    Should Be Equal As Strings    ${response.status_code}    400
    [Teardown]    Restart SUT