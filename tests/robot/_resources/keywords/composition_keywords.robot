# Copyright (c) 2019 Wladislaw Wagner (Vitasystems GmbH), Pablo Pazos (Hannover Medical School).
#
# This file is part of Project EHRbase
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.



*** Settings ***
Documentation    COMPOSITION Specific Keywords
Library          XML
Library          String

Resource    ${CURDIR}${/}../suite_settings.robot
Resource    generic_keywords.robot
Resource    template_opt1.4_keywords.robot
Resource    ehr_keywords.robot



*** Variables ***
${VALID DATA SETS}     ${PROJECT_ROOT}${/}tests${/}robot${/}_resources${/}test_data_sets${/}valid_templates
${INVALID DATA SETS}   ${PROJECT_ROOT}${/}tests${/}robot${/}_resources${/}test_data_sets${/}invalid_templates



*** Keywords ***
# 1) High Level Keywords
#
# 2) HTTP Methods
#    POST
#    PUT
#    DELETE
#    GET
#
# 3) HTTP Headers
#
# 4) FAKE Data




Start Request Session
    [Arguments]         ${content}=application/json  ${accept}=application/json  &{others}
    [Documentation]     Prepares request settings for RESTistance & RequestLib
    ...                 :content: application/json (default) / application/xml
    ...                 :accept: application/json (default) / application/xml
    ...                 :others: optional e.g. If-Match={ehrstatus_uid}

                        Log Many            ${content}  ${accept}  ${others}

    # for RESTinstance
    &{headers}=         Create Dictionary   Content-Type=${content}
                        ...                 Accept=${accept}

                        Run Keyword If      ${others}    Set To Dictionary    ${headers}    &{others}

                        Set Headers         ${authorization}
                        Set Headers         ${headers}

    # for RequestLibrary
                        Create Session      ${SUT}    ${${SUT}.URL}
                        ...                 auth=${${SUT}.CREDENTIALS}    debug=2    verify=True

                        Set Test Variable   ${headers}    ${headers}


# TODO: rename to `generate random versioned_object_uid`
Generate Random Composition UID
    [Documentation]     Generates a random UUIDv4 spec conform `versioned_object_uid`,
    ...                 an OpenEHR spec conform `version_uid` (alias `preceding_version_uid`).

    ${uid}=             Evaluate    str(uuid.uuid4())    uuid
                        Set Test Variable   ${composition_uid}    ${uid}    # TODO: remove
                        Set Test Variable   ${versioned_object_uid}    ${uid}
                        Set Test Variable   ${version_uid}    ${uid}::local.ehrbase.org::1    # TODO: get `local.ehrbase.org` from a variable
                        Set Test Variable   ${preceding_version_uid}    ${version_uid}


generate random version_uid
    [Documentation]     Generates a random COMPOSITION `version_uid` and exposes it
    ...                 also as `preceding_version_uid` to test level scope

    ${uid}=             Evaluate    str(uuid.uuid4())    uuid
                        Set Test Variable   ${version_uid}    ${uid}::local.ehrbase.org::1
                        Set Test Variable   ${preceding_version_uid}    ${version_uid}


Commit Invalid Composition (JSON)
    [Arguments]         ${opt_file}
    [Documentation]     Creates the first version of a new COMPOSITION
    ...                 DEPENDENCY: `upload OPT`, `Create EHR`
    ...
    ...                 ENDPOINT: POST /ehr/${ehr_id}/composition

                        get invalid OPT file    ${opt_file}

    &{headers}=         Create Dictionary   Content-Type=application/xml
                        ...                 Accept=application/json
                        ...                 Prefer=return=representation

    ${resp}=            Post Request        ${SUT}   /ehr/${ehr_id}/composition   data=${file}   headers=${headers}
                        log to console      ${resp.content}
                        Should Be Equal As Strings   ${resp.status_code}   400


Commit Invalid Composition (XML)
    [Arguments]         ${opt_file}
    [Documentation]     Creates the first version of a new COMPOSITION
    ...                 DEPENDENCY: `upload OPT`, `Create EHR`
    ...
    ...                 ENDPOINT: POST /ehr/${ehr_id}/composition

                        get invalid OPT file    ${opt_file}

    &{headers}=         Create Dictionary   Content-Type=application/xml
                        ...                 Accept=application/json
                        ...                 Prefer=return=representation

    ${resp}=            Post Request        ${SUT}   /ehr/${ehr_id}/composition   data=${file}   headers=${headers}
                        log to console      ${resp.content}
                        Should Be Equal As Strings   ${resp.status_code}   400


Commit Composition - No Referenced OPT
    [Arguments]         ${opt_file}
    [Documentation]     Creates a new COMPOSITION with missing referenced OPT
    ...                 DEPENDENCY: `Create EHR`, `Start Request Session` with proper args!!!
    ...                 ENDPOINT: POST /ehr/${ehr_id}/composition

                        get valid OPT file  ${opt_file}

        TRACE JIRA BUG    EHR-434    not-ready

    ${resp}=            Post Request        ${SUT}   /ehr/${ehr_id}/composition   data=${file}   headers=${headers}
                        # log to console      ${resp.content}
                        Should Be Equal As Strings   ${resp.status_code}   400


Commit Composition - No Referenced EHR
    [Arguments]         ${opt_file}
    [Documentation]     Creates a new COMPOSITION with missing referenced EHR
    ...                 DEPENDENCY: `Create EHR`, `Start Request Session` with proper args!!!
    ...                             e.g. content-type must be application/xml
    ...                 ENDPOINT: POST /ehr/${ehr_id}/composition

                        get valid OPT file  ${opt_file}

                        composition_keywords.Start Request Session    application/xml    Prefer=return\=representation

    ${resp}=            Post Request        ${SUT}   /ehr/${ehr_id}/composition   data=${file}   headers=${headers}
                        log to console      ${resp.content}
                        Should Be Equal As Strings   ${resp.status_code}   404


Commit Composition (JSON)
    [Arguments]         ${opt_file}
    [Documentation]     Creates the first version of a new COMPOSITION
    ...                 DEPENDENCY: `upload OPT`, `Create EHR`
    ...
    ...                 ENDPOINT: POST /ehr/${ehr_id}/composition

                        get valid OPT file  ${opt_file}

    &{headers}=         Create Dictionary   Content-Type=application/xml
                        ...                 Accept=application/json
                        ...                 Prefer=return=representation

    ${resp}=            Post Request        ${SUT}   /ehr/${ehr_id}/composition   data=${file}   headers=${headers}
                        log to console      ${resp.content}
                        Should Be Equal As Strings   ${resp.status_code}   201

                        Set Test Variable   ${composition_uid}    ${resp.json()['uid']['value']}    # TODO: remove
                        Set Test Variable   ${version_uid}    ${resp.json()['uid']['value']}    # full/long compo uid
                        Set Test Variable   ${version_uid_v1}    ${version_uid}                  # different namesfor full uid
                        Set Test Variable   ${preceding_version_uid}    ${version_uid}          # for usage in other steps

    ${short_uid}=       Remove String       ${version_uid}    ::local.ehrbase.org::1
                        Set Test Variable   ${compo_uid_v1}    ${short_uid}                      # TODO: rmv
                        Set Test Variable   ${versioned_object_uid}    ${short_uid}

                        Set Test Variable   ${response}    ${resp}
                        Capture Point In Time    1


Check Content Of Composition (JSON)
                        # Should Be Equal As Strings    ${response.status_code}    200
    ${text}=            Set Variable        ${response.json()['content'][0]['data']['events'][0]['data']['items'][0]['value']['value']}
                        Should Be Equal     ${text}    original value


Commit Composition (XML)
    [Arguments]         ${opt_file}
    [Documentation]     POST /ehr/${ehr_id}/composition

                        get valid OPT file  ${opt_file}

    &{headers}=         Create Dictionary   Content-Type=application/xml
                        ...                 Accept=application/xml
                        ...                 Prefer=return=representation

    ${resp}=            Post Request        ${SUT}   /ehr/${ehr_id}/composition   data=${file}   headers=${headers}
                        log to console      ${resp.content}
                        Should Be Equal As Strings   ${resp.status_code}   201

    ${xresp}=           Parse Xml           ${resp.text}
                        Log Element         ${xresp}
                        # Log Element        ${xresp}  xpath=composition

    ${long_uid}=        Get Element         ${xresp}      uid/value
                        Set Test Variable   ${composition_uid}    ${long_uid.text}          # TODO: rmv
                        Set Test Variable   ${version_uid}    ${long_uid.text}                  # full/long compo uid
                        Set Test Variable   ${version_uid_v1}    ${version_uid}                  # different namesfor full uid
                        Set Test Variable   ${preceding_version_uid}    ${version_uid}          # for usage in other steps

    ${short_uid}=       Remove String       ${version_uid}    ::local.ehrbase.org::1
                        Set Test Variable   ${compo_uid_v1}    ${short_uid}                 # TODO; rmv
                        Set Test Variable   ${versioned_object_uid}    ${short_uid}

                        Set Test Variable   ${response}    ${resp}
                        Capture Point In Time    1


Check Content Of Updated Composition (XML)
                        # Should Be Equal As Strings    ${response.status_code}    200
    ${xml}=             Parse Xml           ${response.text}
    # ${text}=            Get Element         ${xml}    composition/content/data/events/data/items/value/value     # This works, but is not spec conform!  TODO: remove
    ${text}=            Get Element         ${xml}    content/data/events/data/items/value/value
                        Element Text Should Be    ${text}    original value

Commit Same Composition Again
    [Arguments]         ${opt_file}
    [Documentation]     Commits a COMPOSITION a second time
    ...                 DEPENDENCY: `commit composition (JSON/XML)`
    ...                 ENDPOINT: POST /ehr/${ehr_id}/composition

                        get valid OPT file  ${opt_file}

    &{headers}=         Create Dictionary   Content-Type=application/xml
                        ...                 Accept=application/json
                        ...                 Prefer=return=representation

        TRACE JIRA BUG    EHR-412    not-ready

    ${resp}=            Post Request        ${SUT}   /ehr/${ehr_id}/composition   data=${file}   headers=${headers}
                        log to console      ${resp.content}
                        Should Be Equal As Strings   ${resp.status_code}   400


Update Composition (JSON)
    [Arguments]         ${new_version_of_composition}
    [Documentation]     Commit a new version for the COMPOSITION
    ...                 DEPENDENCY: `commit composition (JSON/XML)` keyword
    ...                 ENDPOINT: PUT /ehr/${ehr_id}/composition/${versioned_object_uid}

                        get valid OPT file  ${new_version_of_composition}

    &{headers}=         Create Dictionary   Content-Type=application/xml
                        ...                 Accept=application/json
                        ...                 Prefer=return=representation
                        ...                 If-Match=${preceding_version_uid}

    ${resp}=            Put Request         ${SUT}   /ehr/${ehr_id}/composition/${compo_uid_v1}   data=${file}   headers=${headers}
                        log to console      ${resp.content}
                        Set Test Variable   ${composition_uid_v2}    ${resp.json()['uid']['value']}    # TODO: remove
                        Set Test Variable   ${version_uid_v2}    ${resp.json()['uid']['value']}

    ${short_uid}=       Remove String       ${version_uid_v2}    ::local.ehrbase.org::1
                        Set Test Variable   ${versioned_object_uid_v2}    ${short_uid}

                        Set Test Variable   ${response}    ${resp}
                        Capture Point In Time    2


Check Composition Update Succeeded
    [Documentation]     the uids without the version should be the same
    ...                 DEPENDENCY: `update composition (JSON/XML)` keyword

                        Should Be Equal As Strings    ${response.status_code}   200

    ${compo_uid_v1}=    Get Substring       ${composition_uid}    0    -1       # TODO: rmv
    ${compo_uid_v2}=    Get Substring       ${composition_uid_v2}    0    -1    # TODO: rmv
                        Should Be Equal     ${compo_uid_v1}    ${compo_uid_v2}  # TODO: rmv

    ${uid_v1}=          Get Substring       ${version_uid_v1}    0    -1
    ${uid_v2}=          Get Substring       ${version_uid_v2}    0    -1
                        Should Be Equal     ${uid_v1}    ${uid_v2}


Check Content Of Updated Composition (JSON)
                        Should Be Equal As Strings    ${response.status_code}    200
    ${text}=            Set Variable    ${response.json()['content'][0]['data']['events'][0]['data']['items'][0]['value']['value']}
                        Should Be Equal     ${text}    modified value


Update Composition (XML)
    [Arguments]         ${new_version_of_composition}
    [Documentation]     Commit a new version for the COMPOSITION
    ...                 DEPENDENCY: `commit composition (JSON/XML)` keyword
    ...                 PUT /ehr/${ehr_id}/composition/${versioned_object_uid}

                        get valid OPT file  ${new_version_of_composition}
    &{headers}=         Create Dictionary   Content-Type=application/xml
                        ...                 Accept=application/xml
                        ...                 Prefer=return=representation

                        ...                 If-Match=${preceding_version_uid}   # TODO: must be ${preceding_version_uid} - has same format as `version_uid`
    ${resp}=            Put Request         ${SUT}   /ehr/${ehr_id}/composition/${compo_uid_v1}   data=${file}   headers=${headers}
                        log to console      ${resp.content}

    # compo.uid.value has the version_uid
    ${xresp}=           Parse Xml           ${resp.text}

    ${long_uid}=        Get Element         ${xresp}      uid/value

                        Set Test Variable   ${composition_uid_v2}     ${long_uid.text}    # TODO: remove
                        Set Test Variable   ${version_uid_v2}     ${long_uid.text}

    ${short_uid}=       Remove String       ${version_uid_v2}    ::local.ehrbase.org::1
                        Set Test Variable   ${versioned_object_uid_v2}    ${short_uid}

                        Set Test Variable   ${response}    ${resp}
                        Capture Point In Time    2


Check Content Of Updated Composition (XML)
                        Should Be Equal As Strings    ${response.status_code}    200
    ${xml}=             Parse Xml           ${response.text}

    ${text}=            Get Element         ${xml}    content/data/events/data/items/value/value
    # ${text}=            Get Element         ${xml}    composition/content/data/events/data/items/value/value    # TODO: remove

                        Element Text Should Be    ${text}    modified value


Update Non-Existent Composition (JSON)
    [Arguments]         ${new_version_of_composition}
    [Documentation]     Commit a new version for a non-existent COMPOSITION
    ...                 DEPENDENCY: `generate random composition uid(s)` keyword
    ...                 ENDPOINT: PUT /ehr/${ehr_id}/composition/${versioned_object_uid}

                        get valid OPT file  ${new_version_of_composition}

    &{headers}=         Create Dictionary   Content-Type=application/xml
                        ...                 Accept=application/json
                        ...                 Prefer=return=representation

                        ...                 If-Match=${preceding_version_uid}
    ${resp}=            Put Request         ${SUT}   /ehr/${ehr_id}/composition/${versioned_object_uid}   data=${file}   headers=${headers}
                        log to console      ${resp.content}
                        Should Be Equal As Strings   ${resp.status_code}   404


update non-existent composition (XML)
    [Arguments]         ${new_version_of_composition}
    [Documentation]     Commit a new version for a non-existent COMPOSITION
    ...                 DEPENDENCY: `generate random composition uid(s)` keyword
    ...                 ENDPOINT: PUT /ehr/${ehr_id}/composition/${versioned_object_uid}

                        get valid OPT file  ${new_version_of_composition}

    &{headers}=         Create Dictionary   Content-Type=application/xml
                        ...                 Accept=application/xml
                        ...                 Prefer=return=representation

                        ...                 If-Match=${preceding_version_uid}
    ${resp}=            Put Request         ${SUT}   /ehr/${ehr_id}/composition/${versioned_object_uid}   data=${file}   headers=${headers}
                        log to console      ${resp.content}
                        Should Be Equal As Strings   ${resp.status_code}   404


# TODO: rename keyword properly e.g. by version_uid
Get Composition By Composition UID
    [Arguments]         ${uid}
    [Documentation]     :uid: version_uid
    ...                 DEPENDENCY: `Start Request Session` with proper Headers
    ...                     e.g. Content-Type=application/xml  Accept=application/xml  Prefer=return\=representation
    ...                     and `commit composition (JSON/XML)` keywords

    # the uid param in the doc is verioned_object.uid but is really the version.uid,
    # because the response from the create compo has this endpoint in the Location header

    # &{headers}=         Create Dictionary   Content-Type=application/xml   Prefer=return=representation

    ${resp}=            Get Request         ${SUT}    /ehr/${ehr_id}/composition/${uid}    headers=${headers}
                        log to console      ${resp.content}
                        Set Test Variable   ${response}    ${resp}


Get Versioned Composition By UID
    [Arguments]         ${uid}
    [Documentation]     :uid: versioned_object_uid
    ...                 DEPENDENCY: `Start Request Session`
    ...                     and `commit composition (JSON/XML)` keywords
    ...
    ...                 ENDPOINT: /ehr/${ehr_id}/versioned_composition/${versioned_object_uid}

        TRACE JIRA BUG    EHR-364    not-ready

    ${resp}=            Get Request         ${SUT}    /ehr/${ehr_id}/versioned_composition/${uid}    headers=${headers}
                        log to console      ${resp.content}
                        Set Test Variable   ${response}    ${resp}


# get versioned composition by version_uid
#     [Documentation]     ENDPOINT: /ehr/{ehr_id}/versioned_composition/{versioned_object_uid}/version/{version_uid}
#                         Pass Execution    TODO    PLACEHOLDER


Check Content Of Versioned Composition (JSON)
                        Should Be Equal As Strings   ${response.status_code}   200
                        Should Be Equal   ${response.json()['uid']['value']}    ${versioned_object_uid}


Check Content Of Versioned Composition (XML)
                        Should Be Equal As Strings    ${response.status_code}   200
    ${xml}=             Parse Xml           ${response.text}
    ${uid}=             Get Element         ${xml}    uid/value
                        Element Text Should Be    ${uid}    ${versioned_object_uid}


Get Composition - Latest Version

                        composition_keywords.Start Request Session    Prefer=return\=representation
    # The way to return the latest version is using the versioned_composition with
    # the versioned_object_uid and without the version_at_time param.

    # &{headers}=         Create Dictionary     Prefer=return=representation

        ####### TODO: @WLAD/PABLO - remove when fixed!!!!! #####################
        TRACE JIRA BUG  EHR-363    not-ready
        ########################################################################

    ${resp}=            Get Request           ${SUT}   /ehr/${ehr_id}/versioned_composition/${versioned_object_uid}/version    headers=${headers}
                        log to console        ${resp.content}
                        Set Test Variable     ${response}    ${resp}


Get Composition - Latest Version (XML)
    [Documentation]     ENDPOINT: /ehr/${ehr_id}/versioned_composition/${versioned_object_uid}/version

                        composition_keywords.Start Request Session    application/xml    application/xml    Prefer=return\=representation

    # The way to return the latest version is using the versioned_composition with
    # the versioned_object_uid and without the version_at_time param.

    # &{headers}=         Create Dictionary     Prefer=return=representation  Accept=application/xml

        ####### TODO: @WLAD/PABLO - remove when fixed!!!!! #####################
        TRACE JIRA BUG  EHR-363    not-ready
        ########################################################################

    ${resp}=            Get Request           ${SUT}   /ehr/${ehr_id}/versioned_composition/${versioned_object_uid}/version   headers=${headers}
                        log to console        ${resp.content}
                        Set Test Variable     ${response}    ${resp}


Check Content Of Compositions Latest Version (JSON)
    [Documentation]     DEPENDENCY: `Get Composition - Latest Version` keyword
                        Should Be Equal As Strings   ${response.status_code}   200
                        Set Test Variable     ${version_uid_latest}    ${resp.json()['uid']['value']}

                        # Check the latest version uid is equal to the second committed compo uid
                        Should Be Equal       ${version_uid_latest}    ${composition_uid_v2}

                        # check content of the latest version is equal to the content committed on the second compo
                        # should be the content in the 2nd committed compo "modified value"
                        Set Test Variable     ${text}    ${resp.json()['data']['content'][0]['data']['events'][0]['data']['items'][0]['value']['value']}
                        Should Be Equal       ${text}    modified value


check content of compositions latest version (XML)
    [Documentation]     DEPENDENCY: `get compostion - latest version (XML)`
                        Should Be Equal As Strings   ${response.status_code}   200
                        ${xresp}=           Parse Xml             ${response.text}
                        ${xversion_uid_latest}=  Get Element      ${xresp}      uid/value

                        # Check the latest version uid is equal to the second committed compo uid
                        Element Text Should Be    ${xversion_uid_latest}    ${version_uid_v2}

                        # check content of the latest version is equal to the content committed on the second compo
                        # should be the content in the 2nd committed compo "modified value"
    ${xtext}=           Get Element      ${xresp}      data/content[1]/data/events[1]/data/items[1]/value/value
                        Element Text Should Be    ${xtext}    modified value


Get Versioned Composition - Version At Time
    [Arguments]         ${time_x}
    [Documentation]     DEPENDENCY: `Commit Composition (JSON)`
    ...                 :time_x: variable w. DateTime-TimeZone (like returned from `Capture Point In Time` kw)
    ...
    ...                 ENDPOINT: /ehr/{ehr_id}/versioned_composition/{versioned_object_uid}/version{?version_at_time}

    # # extract the versioned_object_uid
    # ${v_object_uid}=    Fetch From Left       ${composition_uid}    ::
    # #
    # #                     Sleep    5s
    # # # time after first commit
    # # ${time1}=           Get Current Date      UTC    result_format=%Y-%m-%dT%H:%M:%S
    # # ${time1_tz}=        Catenate              SEPARATOR=${EMPTY}    ${time1}   +00:00
    # #                     log to console        ${time1_tz}


    # Get version at time 1, should exist and be COMPO 1
    &{params}=          Create Dictionary     version_at_time=${time_x}

        ####### TODO: @WLAD/PABLO - remove when fixed!!!!! #####################
        TRACE JIRA BUG  EHR-363    not-ready
        ########################################################################

    ${resp}=            Get Request           ${SUT}   /ehr/${ehr_id}/versioned_composition/${versioned_object_uid}/version
                        ...                   params=${params}

                        log to console        ${resp.content}
                        log to console        ${resp.request.path_url}
                        log to console        ${resp.request}

                        Set Test Variable     ${response}    ${resp}


Get Composition - Version At Time (XML)
    [Arguments]         ${time_x}
    [Documentation]     DEPENDENCY: `Commit Composition (XML)`
    ...                 :time_x: variable w. DateTime-TimeZone (like returned from `Capture Point In Time` kw)
    ...                 ENDPOINT: /ehr/{ehr_id}/versioned_composition/{versioned_object_uid}/version{?version_at_time}

    &{params}=          Create Dictionary     version_at_time=$${time_x}
    &{headers}=         Create Dictionary     Accept=application/xml

        ####### TODO: @WLAD/PABLO - remove when fixed!!!!! #####################
        TRACE JIRA BUG  EHR-363    not-ready
        ########################################################################

    ${resp}=            Get Request           ${SUT}   /ehr/${ehr_id}/versioned_composition/${versioned_object_uid}/version
                        ...                   params=${params}   headers=${headers}

                        log to console        ${resp.content}
                        log to console        ${resp.request.path_url}
                        log to console        ${resp.request}

                        Set Test Variable     ${response}    ${resp}


Check Content Of Compositions Version At Time (JSON)
    [Arguments]         ${time_x_nr}
    [Documentation]     DEPENDENCY: `get compostion - version at time`
    ...                 :time_x_nr:  a string like `time_1`

                        Should Be Equal As Strings   ${response.status_code}   200
    ${version_uid}=     Set Variable    ${resp.json()['uid']['value']}

    Run Keyword If      '${time_x_nr}'=='time_1'   Should Be Equal       ${version_uid}    ${composition_uid}
    Run Keyword If      '${time_x_nr}'=='time_2'   Should Be Equal       ${version_uid}    ${composition_uid_v2}


                        # check content of the latest version is equal to the content committed on the first compo
                        Set Test Variable     ${text}    ${resp.json()['data']['content'][0]['data']['events'][0]['data']['items'][0]['value']['value']}
                        Should Be Equal       ${text}    original value


Check Content Of Compositions Version At Time (XML)
    [Arguments]         ${time_x_nr}
    [Documentation]     DEPENDENCY: `get compostion - version at time (XML)`
    ...                 :time_x_nr:  a string like `time_1`
                        Should Be Equal As Strings   ${response.status_code}   200

    # compo.uid.value has the version_uid
    ${xresp}=           Parse Xml             ${resp.text}
    ${version_uid}=     Get Element           ${xresp}      uid/value

    Run Keyword If      '${time_x_nr}'=='time_1'    Element Text Should Be    ${version_uid}    ${composition_uid}
    Run Keyword if      '${time_x_nr}'=='time_2'    Element Text Should Be    ${version_uid}    ${composition_uid_v2}

    # check content of the latest version is equal to the content committed on the first compo
    ${xtext}=           Get Element           ${xresp}      data/content[1]/data/events[1]/data/items[1]/value/value
                        Element Text Should Be    ${xtext}    original value


Check Composition Exists
    [Documentation]     DEPENDENCY: `get composition` keywords

                        Should Be Equal As Strings   ${response.status_code}   200


Check Composition Does Not Exist
    [Documentation]     DEPENDENCY: `get composition` keywords

                        Should Be Equal As Strings   ${response.status_code}   404


Check Composition Does Not Exist - Version At Time
    [Documentation]     DEPENDENCY: `get composition - version at time` keywords

                        Should Be Equal As Strings   ${response.status_code}   404


Check Versioned Composition Does Not Exist
    [Documentation]     DEPENDENCY: `get versioned composition`

                        Should Be Equal As Strings   ${response.status_code}   404


Delete Composition
    [Arguments]         ${uid}
    [Documentation]     :uid: preceding_version_uid (format of version_uid)

    ${resp}=            Delete Request          ${SUT}   /ehr/${ehr_id}/composition/${uid}
                        log to console          ${resp.headers}
                        log to console          ${resp.content}

                        Should Be Equal As Strings    ${resp.status_code}    204

                        # the ETag comes with quotes, this removes them
    ${del_version_uid}=    Get Substring        ${resp.headers['ETag']}    1    -1
                        log to console          \ndeleted version uid: ${del_version_uid}
                        Set Test Variable       ${del_version_uid}    ${del_version_uid}


Get Deleted Composition
    [Documentation]     The deleted compo should not exist
    ...                 204 is the code for deleted - as per OpenEHR spec

    ${resp}=            Get Request           ${SUT}   /ehr/${ehr_id}/composition/${del_version_uid}
                        log to console        ${resp.content}
                        Should Be Equal As Strings   ${resp.status_code}   204


Delete Non-Existent Composition
    [Documentation]     DEPENDENCY `Start Request Session`, `Generate Random Composition UID`

                        composition_keywords.Start Request Session
    ${resp}=            Delete Request        ${SUT}   /ehr/${ehr_id}/composition/${preceding_version_uid}
                        log to console    ${resp.content}
                        Should Be Equal As Strings   ${resp.status_code}   404


upload OPT
    [Arguments]     ${opt_file}   ${accept-header}=JSON

    # setting proper Accept=application/xxx header
    Run Keyword If    '${accept-header}'=='JSON'   template_opt1.4_keywords.Start Request Session
    Run Keyword If    '${accept-header}'=='XML'    Start Request Session (XML)

    get valid OPT file    ${opt_file}
    upload OPT file
    server accepted OPT


Create EHR
    [Arguments]     ${accept-header}=JSON

    Run Keyword If  '${accept-header}'=='JSON'
    ...             Run Keywords    ehr_keywords.Start Request Session    JSON
    ...             AND             create new EHR
    ...             AND             extract ehr_id from response (JSON)
    ...             AND             extract ehrstatus_uid (JSON)

    Run Keyword If  '${accept-header}'=='XML'
    ...             Run Keywords    ehr_keywords.Start Request Session    XML
    ...             AND             create new EHR (XML)
    ...             AND             extract ehr_id from response (XML)
    ...             AND             extract ehrstatus_uid (XML)


Capture Time Before First Commit
    Capture Point In Time   0
    # Sleep                   1


Capture Point In Time
    [Arguments]         ${point_in_time}
    [Documentation]     :point_in_time: integer [0, 1, 2]
    ...                 exposes to test level scope a variable e.g. `${time_1}`
    ...                 which's value is a given time in the extended ISO8601 format
    ...                 e.g. 2015-01-20T19:30:22.765+01:00

    ${time}=            Get Current Date    UTC    result_format=%Y-%m-%dT%H:%M:%S
    # ${time_tz}=         Catenate            SEPARATOR=${EMPTY}    ${time}   +00:00
                        Set Test Variable   ${time_${point_in_time}}   ${time}+00:00
                        Sleep               1







# oooooooooo.        .o.         .oooooo.   oooo    oooo ooooo     ooo ooooooooo.
# `888'   `Y8b      .888.       d8P'  `Y8b  `888   .8P'  `888'     `8' `888   `Y88.
#  888     888     .8"888.     888           888  d8'     888       8   888   .d88'
#  888oooo888'    .8' `888.    888           88888[       888       8   888ooo88P'
#  888    `88b   .88ooo8888.   888           888`88b.     888       8   888
#  888    .88P  .8'     `888.  `88b    ooo   888  `88b.   `88.    .8'   888
# o888bood8P'  o88o     o8888o  `Y8bood8P'  o888o  o888o    `YbodP'    o888o
#
# [ BACKUP ]

# Commit Composition (XML)
#     [Arguments]         ${xml_composition}
#     [Documentation]     Creates a composition by using POST method and XML file
#     ...                 from `/test_data_sets/xml_compositions/` folder
#     ...                 DEPENDENCY: use it right after `Create EHR XML` which
#     ...                             provides the `ehr_id`.
#
#     ${file}=            Get File           ${CURDIR}/../test_data_sets/xml_compositions/${xml_composition}
#     &{headers}=         Create Dictionary  Content-Type=application/xml  Prefer=return=representation  Accept=application/xml
#     ${resp}=            Post Request       ${SUT}   /ehr/${ehr_id}/composition   data=${file}   headers=${headers}
#                         Should Be Equal As Strings   ${resp.status_code}   201
#
#     ${xresp}=           Parse Xml          ${resp.text}
#                         Log Element        ${xresp}
#                         Log Element        ${xresp}  xpath=composition
#     ${xcompo_version_uid}=     Get Element        ${xresp}      composition/uid/value
#                         Set Test Variable  ${compo_version_uid}     ${xcompo_version_uid.text}
#                         # Log To Console     ${compo_version_uid}

# Get Composition By Composition UID (XML)
#     [Arguments]         ${uid}
#     [Documentation]     DEPENDENCY: `commit composition (JSON/XML)` keywords
#
#     # the uid param in the doc is verioned_object.uid but is really the version.uid,
#     # because the response from the create compo has this endpoint in the Location header
#
#     &{headers}=         Create Dictionary   Content-Type=application/xml   Accept=application/xml    Prefer=return=representation
#     ${resp}=            Get Request         ${SUT}   /ehr/${ehr_id}/composition/${uid}    headers=${headers}
#                         log to console      ${resp.content}
#                         Set Test Variable   ${response}    ${resp}

# capture time after first commit
#     ${time}=            Get Current Date    UTC    result_format=%Y-%m-%dT%H:%M:%S
#     ${time_tz}=         Catenate            SEPARATOR=${EMPTY}    ${time}   +00:00
#                         Set Test Variable   ${time_1}    ${time_tz}

# capture time after second commit
#     ${time}=            Get Current Date    UTC    result_format=%Y-%m-%dT%H:%M:%S
#     ${time_tz}=         Catenate            SEPARATOR=${EMPTY}    ${time}   +00:00
#                         Set Test Variable   ${time_2}    ${time_tz}
