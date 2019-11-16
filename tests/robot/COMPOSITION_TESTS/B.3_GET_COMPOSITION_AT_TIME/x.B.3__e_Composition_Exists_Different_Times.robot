*** Settings ***
Documentation     Alternative Flow 4: Get Existing Composition At Time, Cover Different Times (XML)
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
Alternative Flow 4: Get Existing Composition At Time, Cover Different Times (XML)
    Upload OPT    ${OPT_FILE}    XML
    Create EHR    XML
    Capture Time Before First Commit
    Commit Composition (XML)    ${XML_FILE}
    Update Composition (XML)    ${V2_XML_FILE}
    Check Composition Update Succeeded

    Log To Console    ${time_0}
    Log To Console    ${time_1}
    Log To Console    ${time_2}

    # Get version at time 0, should not exist
    Get Composition - Version At Time (XML)    ${time_0}
    Check Composition Does Not Exist - Version At Time
    # Get version at time 1, should exist and be COMPO 1
    Get Composition - Version At Time (XML)    ${time_1}
    Check Content Of Compositions Version At Time (XML)    time_1
    # Get version at time 2, should exist and be COMPO 2
    Get Composition - Version At Time (XML)    ${time_2}
    Check Content Of Compositions Version At Time (XML)    time_2
    [Teardown]    Restart SUT