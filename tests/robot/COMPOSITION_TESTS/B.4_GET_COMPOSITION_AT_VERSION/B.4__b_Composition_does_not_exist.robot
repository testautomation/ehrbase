*** Settings ***
Documentation     Main Flow: Get Existing Composition At Version, Version Does not Exists
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
Main Flow: Get Existing Composition At Version, Version Does not Exists
    Upload OPT    ${OPT_FILE}
    Create EHR
    Generate Random Composition UID
    composition_keywords.Start Request Session
    Get Composition By Composition UID    ${version_uid}
    Check Composition Does Not Exist
    [Teardown]    Restart SUT