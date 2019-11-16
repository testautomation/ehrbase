*** Settings ***
Documentation     Alternative Flow 2: Get Composition At Time, Composition Does not exist (XML)
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
${OPT_FILE}    minimal/minimal_observation.opt

*** Test Cases ***
Alternative Flow 2: Get Composition At Time, Composition Does not exist (XML)
    Upload OPT    ${OPT_FILE}    XML
    Create EHR    XML
    Generate Random Composition UID
    Capture Point In Time    1
    Get Composition - Version At Time (XML)    ${time_1}
    Check Composition Does Not Exist - Version At Time
    [Teardown]    Restart SUT