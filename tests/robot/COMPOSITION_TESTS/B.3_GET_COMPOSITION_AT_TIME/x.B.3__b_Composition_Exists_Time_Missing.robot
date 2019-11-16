*** Settings ***
Documentation     Alternative Flow 1: Get Existing Composition At Time, Without Given Time (XML)
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
Alternative Flow 1: Get Existing Composition At Time, Without Given Time (XML)
    Upload OPT    ${OPT_FILE}    XML
    Create EHR    XML
    Commit Composition (XML)    ${XML_FILE}
    Update Composition (XML)    ${V2_XML_FILE}
    Check Composition Update Succeeded
    # NOTE: Following keyword equals to `Get Composition - Verstion At Time`  without time parameter
    Get Composition - Latest Version (XML)
    Check Content Of Compositions Latest Version (XML)
    [Teardown]    Restart SUT