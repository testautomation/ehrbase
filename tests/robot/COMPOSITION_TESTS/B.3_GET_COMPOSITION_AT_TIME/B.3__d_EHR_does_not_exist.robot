*** Settings ***
Documentation     Alternative Flow 3: Get Composition At Time, On Non-Existent EHR
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
${OPT_FILE}    minimal/minimal_observation.opt

*** Test Cases ***
Alternative Flow 3: Get Composition At Time, On Non-Existent EHR
    Upload OPT    ${OPT_FILE}
    Generate Random EHR ID
    Generate Random Composition UID
    Capture Point In Time    1
    Get Versioned Composition - Version At Time    ${time_1}
    Check Composition Does Not Exist - Version At Time
    [Teardown]    Restart SUT