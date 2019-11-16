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
${OPT_FILE}    minimal/minimal_observation.opt
${XML_FILE}    minimal/minimal_observation.composition.participations.extdatetimes.xml

*** Test Cases ***
Main Flow: Get Existing Versioned Composition (XML)
    Upload OPT    ${OPT_FILE}    XML
    Create EHR    XML
    Commit Composition (XML)    ${XML_FILE}
    Get Versioned Composition By UID    ${versioned_object_uid}
    Check Content Of Versioned Composition (XML)
    # [Teardown]    Restart SUT