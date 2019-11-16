*** Settings ***
Documentation     Alternative Flow 3: Get Composition At Version Cover Different Versions (XML)
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
${OPT_FILE}       minimal/minimal_observation.opt
${XML_FILE}       minimal/minimal_observation.composition.participations.extdatetimes.xml
${V2_XML_FILE}    minimal/minimal_observation.composition.participations.extdatetimes.v2.xml

*** Test Cases ***
Alternative Flow 3: Get Composition At Version Cover Different Versions (XML)
    Upload OPT    ${OPT_FILE}    XML
    Create EHR    XML
    Commit Composition (XML)    ${XML_FILE}
    Update Composition (XML)    ${V2_XML_FILE}
    Check Composition Update Succeeded

    # Check COMPO v1 exist and has correct content
    Get Composition By Composition UID    ${version_uid_v1}
    TRACE JIRA BUG  NO-JIRA-ID  not-ready  unreported bug: {"error":null,"status":"Internal Server Error"}
    Check Content Of Updated Composition (XML)

    # Check COMPO v2 exist and has correct content
    Get Composition By Composition UID    ${version_uid_v2}
    Check Content Of Updated Composition (XML)