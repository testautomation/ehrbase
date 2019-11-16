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
Documentation    CONTRIBUTION Specific Keywords
Library          XML
Library          String

Resource    ${CURDIR}${/}../suite_settings.robot
Resource    generic_keywords.robot
Resource    template_opt1.4_keywords.robot
Resource    ehr_keywords.robot
Resource    composition_keywords.robot



*** Variables ***
${VALID CONTRI DATA SETS}     ${PROJECT_ROOT}/tests/robot/_resources/test_data_sets/valid_templates
${INVALID CONTRI DATA SETS}   ${PROJECT_ROOT}/tests/robot/_resources/test_data_sets/invalid_templates



*** Keywords ***
# 1) High Level Keywords
commit CONTRIBUTION (JSON)
    [Arguments]         ${valid_test_data_set}
                        Set Test Variable  ${KEYWORD NAME}  COMMIT CONTRIBUTION 1 (JSON)

                        load valid test-data-set    ${valid_test_data_set}

                        POST /ehr/ehr_id/contribution    JSON

                        Should Be Equal As Strings   ${response.status_code}   201
                        Set Test Variable   ${contribution_uid}    ${resp.json()['uid']['value']}
                        Log To Console      ${contribution_uid}


check response: is positive - returns version id
        Fail    msg=brake it till you make it!


check content of committed CONTRIBUTION
                        retrieve EHR by ehr_id


# TODO: better name --> `commit another CONTRIBUTION` ???
#                       `commit next CONTRIBUTION`    ???
#                       `commit (valid) modification to CONTRIBUTION`
commit CONTRIBUTION - with preceding_version_uid (JSON)
    [Arguments]         ${test_data_set}
                        Set Test Variable  ${KEYWORD NAME}  COMMIT CONTRIBUTION 2 (JSON)

                        load valid test-data-set    ${test_data_set}

                        inject preceding_version_uid into test-data-set

                        POST /ehr/ehr_id/contribution    JSON


check response: is positive - contribution has new version
        Fail    msg=brake it till you make it!


check change_type of new version is
    [Arguments]         ${change_type}
    [Documentation]     :change_type: creation, amendment, modification, deleted

        Fail    msg=brake it till you make it!



# VARIATIONS OF COMMITTING INVALID CONTRIBUTIONS
commit invalid CONTRIBUTION (JSON)
    [Arguments]         ${test_data_set}
                        Set Test Variable  ${KEYWORD NAME}  COMMIT CONTRIBUTION 3 (JSON)

                        # TODO: chage that to `load invalid test-data-set` after test-data was mv to proper folder
                        load valid test-data-set    ${test_data_set}

                        POST /ehr/ehr_id/contribution    JSON

# commit CONTRIBUTION - no version compo (JSON)
#     [Arguments]         ${test_data_set}
#                         Set Test Variable  ${KEYWORD NAME}  COMMIT CONTRIBUTION 3 (JSON)
#
#                         # TODO: chage that to `load invalid test-data-set` after test-data was mv to proper folder
#                         load valid test-data-set    ${test_data_set}
#
#                         POST /ehr/ehr_id/contribution    JSON
#
# commit CONTRIBUTION - multiple in/valid version compo (JSON)
#     [Arguments]         ${test_data_set}
#                         Set Test Variable  ${KEYWORD NAME}  COMMIT CONTRIBUTION 5 (JSON)
#
#                         # TODO: chage that to `load invalid test-data-set` after test-data was mv to proper folder
#                         load valid test-data-set    ${test_data_set}
#
#                         POST /ehr/ehr_id/contribution    JSON
#
#                         Should Be Equal As Strings   ${response.status_code}   400


# VARIATIONS OF RESULTS FROM INVALID CONTRIBUTIONS
# TODO: check if some of them can be consolidated
check response: is negative indicating errors in committed data
                          Should Be Equal As Strings   ${response.status_code}   400
        Fail    msg=brake it till you make it!


check response: is negative indicating empty versions list
                          Should Be Equal As Strings   ${response.status_code}   400
        Fail    msg=brake it till you make it!


check response: is negative indicating invalid version_composition
        Fail    msg=brake it till you make it!


check response: is negative indicating wrong change_type
                          Should Be Equal As Strings   ${response.status_code}   400
        Fail    msg=brake it till you make it!


check response: is negative indicating non-existent OPT
                          Should Be Equal As Strings   ${response.status_code}   400
        Fail    msg=brake it till you make it!


commit COMTRIBUTION(S) (JSON)
                        Set Test Variable  ${KEYWORD NAME}  COMMIT COMTRIBUTION(S) (JSON)

        TRACE JIRA BUG    NO-JIRA-ID    not-ready    message=endpoint not implemented
        # TODO: does that mean committing multiple CONTRIS ???


# check response: commit COMTRIBUTION(S) (JSON)
#                         Should Be Equal As Strings   ${response.status_code}   201



retrieve CONTRIBUTION by contribution_uid (JSON)
    [Documentation]     DEPENDENCY ${ehr_id} & ${contribution_uid} in test scope
                        Set Test Variable  ${KEYWORD NAME}  GET CONTRI BY CONTRI_UID

                        GET /ehr/ehr_id/contribution/contribution_uid    JSON


check response: is positive - contribution_uid exists
                        Should Be Equal As Strings    ${response.status_code}    200
        Fail    msg=brake it till you make it!


check content of retrieved CONTRIBUTION (JSON)
                        check response: is positive - contribution_uid exists
        # TODO: implement data checks
        Fail    msg=brake it till you make it!



retrieve CONTRIBUTION by fake contri_uid (JSON)
                        Set Test Variable  ${KEYWORD NAME}  GET CONTRI BY FAKE CONTRI_UID

                        generate random contribution_uid

                        GET /ehr/ehr_id/contribution/contribution_uid    JSON



retrieve CONTRIBUTION by fake ehr_id & contri_uid (JSON)
                        Set Test Variable  ${KEYWORD NAME}  GET CONTRI BY FAKE U/IDs

                        Generate Random EHR ID
                        generate random contribution_uid

                        GET /ehr/ehr_id/contribution/contribution_uid    JSON



retrieve CONTRIBUTION(S) by ehr_id (JSON)
                        Set Test Variable  ${KEYWORD NAME}  GET CONTRI(S) BY EHR_ID

                        GET /ehr/ehr_id/contributions    JSON



retrieve CONTRIBUTION(S) by fake ehr_id (JSON)
                        Set Test Variable  ${KEYWORD NAME}  GET CONTRI(S) BY EHR_ID

                        Generate Random EHR ID
                        GET /ehr/ehr_id/contributions    JSON



check response: is negative indicating non-existent ehr_id
                        Should Be Equal As Strings    ${response.status_code}    404
        Fail    msg=fake it till you make it!



check response: is negative indicating non-existent contribution_uid
                        Should Be Equal As Strings    ${response.status_code}    404
        Fail    msg=fake it till you make it!



check response: is negative indicating non-existent contribution_uid on ehr_id
                        Should Be Equal As Strings    ${response.status_code}    404
        Fail    msg=fake it till you make it!



check response: is positive with list of ${x} contribution(s)
                        Should Be Equal As Strings    ${response.status_code}    200
        Fail    msg=fake it till you make it!





# 2) HTTP Methods

# POST

POST /ehr/ehr_id/contribution
    [Arguments]         ${format}
    [Documentation]     DEPENDENCY any keyword that exposes a `${test_data}` variable
    ...                 to test level scope e.g. `load valid test-data-set`

                        # JSON format: defaults apply
                        Run Keyword If      $format=='JSON'    prepare request session
                        ...                 Prefer=return=representation

                        # XML format: overriding defaults
                        Run Keyword If      $format=='XML'    prepare request session
                        ...                 content=application/xml
                        ...                 accept=application/xml
                        ...                 Prefer=return=representation

        TRACE JIRA BUG    NO-JIRA-ID    not-ready    message=endpoint not implemented

    ${resp}=            Post Request        ${SUT}   /ehr/${ehr_id}/contribution
                        ...                 data=${test_data}
                        ...                 headers=${headers}

                        Set Test Variable   ${response}    ${resp}
                        Output Debug Info:    POST /ehr/ehr_id/contribution





# PUT
# DELETE





# GET

GET /ehr/ehr_id/contribution/contribution_uid
    [Arguments]         ${format}
    [Documentation]     DEPENDENCY ${ehr_id} & ${contribution_uid} in test scope

                        Run Keyword If      $format=='JSON'    prepare request session
                        ...                 Prefer=return=representation

                        Run Keyword If      $format=='XML'    prepare request session
                        ...                 content=application/xml
                        ...                 accept=application/xml
                        ...                 Prefer=return=representation

            TRACE JIRA BUG    NO-JIRA-ID    not-ready    message=endpoint not implemented

    ${resp}=            Get Request         ${SUT}   /ehr/${ehr_id}/contribution/${contribution_uid}
                        ...                 headers=${headers}

                        Set Test Variable   ${response}    ${resp}
                        Output Debug Info:    GET /ehr/ehr_id/contribution/contribution_uid



GET /ehr/ehr_id/contributions
    [Arguments]         ${format}
    [Documentation]     DEPENDENCY ${ehr_id} in test scope

                        Run Keyword If      $format=='JSON'    prepare request session
                        ...                 Prefer=return=representation

                        Run Keyword If      $format=='XML'    prepare request session
                        ...                 content=application/xml
                        ...                 accept=application/xml
                        ...                 Prefer=return=representation

            TRACE JIRA BUG    NO-JIRA-ID    not-ready    message=endpoint not implemented

    ${resp}=            Get Request         ${SUT}   /ehr/${ehr_id}/contributions
                        ...                 headers=${headers}

                        Set Test Variable   ${response}    ${resp}
                        Output Debug Info:    GET /ehr/ehr_id/contributions





# 3) HTTP Headers
prepare request session
    [Arguments]         ${content}=application/json  ${accept}=application/json  &{others}
    [Documentation]     Prepares request settings for RequestLib
    ...                 :content: application/json (default) / application/xml
    ...                 :accept: application/json (default) / application/xml
    ...                 :others: optional e.g. If-Match={ehrstatus_uid}
    ...                                   e.g. Prefer=return=representation

                        Log Many            ${content}  ${accept}  ${others}

    &{headers}=         Create Dictionary   Content-Type=${content}
                        ...                 Accept=${accept}

                        Run Keyword If      ${others}    Set To Dictionary    ${headers}    &{others}

                        Create Session      ${SUT}    ${${SUT}.URL}
                        ...                 auth=${${SUT}.CREDENTIALS}    debug=2    verify=True

                        Set Test Variable   ${headers}    ${headers}





# 4) FAKE Data
create fake CONTRIBUTION
                        generate random contribution_uid


generate random contribution_uid
    [Documentation]     Generates a random UUIDv4 spec conform `contribution_uid`
    ...                 and exposes it as Test Variable

    ${contri_uid}=      Evaluate    str(uuid.uuid4())    uuid
                        Set Test Variable    ${contribution_uid}    ${contri_uid}





# 5) HELPERS
extract contribution_uid from response (JSON)
        Fail    msg=brake it till you make it!


load valid test-data-set
    [Arguments]        ${valid_test_data_set}

    ${file}=            Get File            ${VALID CONTRI DATA SETS}/${valid_test_data_set}

                        Set Test Variable    ${test_data}    ${file}


load invalid test-data-set
    [Arguments]        ${invalid_test_data_set}

    ${file}=            Get File            ${INVALID CONTRI DATA SETS}/${invalid_test_data_set}

                        Set Test Variable    ${test_data}    ${file}


inject preceding_version_uid into test-data-set
        Fail    msg=brake it till you make it!

                        Set Test Variable    ${test_data}    ${file}


Output Debug Info:
    [Arguments]         ${KW NAME}
                        ${KEYWORD NAME}=    Set Variable    ${KEYWORD NAME} / ${KW NAME}
                        ${l}=               Evaluate    len('${KEYWORD NAME}')
                        ${line}=               Evaluate    ${l} * '-'
                        Log To Console      \n${line}\n${KEYWORD NAME}\n${line}\n
                        Log To Console      request headers: \n${response.request.headers} \n
                        Log To Console      request body: \n${response.request.body} \n
                        Log To Console      response status code: \n${response.status_code} \n
                        Log To Console      response headers: \n${response.headers} \n
                        Log To Console      response body: \n${response.content} \n






# oooooooooo.        .o.         .oooooo.   oooo    oooo ooooo     ooo ooooooooo.
# `888'   `Y8b      .888.       d8P'  `Y8b  `888   .8P'  `888'     `8' `888   `Y88.
#  888     888     .8"888.     888           888  d8'     888       8   888   .d88'
#  888oooo888'    .8' `888.    888           88888[       888       8   888ooo88P'
#  888    `88b   .88ooo8888.   888           888`88b.     888       8   888
#  888    .88P  .8'     `888.  `88b    ooo   888  `88b.   `88.    .8'   888
# o888bood8P'  o88o     o8888o  `Y8bood8P'  o888o  o888o    `YbodP'    o888o
#
# [ BACKUP ]
#
# # VARIANTS
#
# # commit valid CONTRIBUTION
#
# # commit valid CONTRIBUTION modification
#     - versioning
#     - deleting
#
# # commit invalid CONTRIBUTION
#     - invalid version compo (JSON)
#     - no version compo (JSON)
#     - mix of in/valid version compo (JSON)
#     - ref non-existent OPT
#
# # commit invalid CONTRIBUTION modification
#     - incomplete modification
#     - incorrect modification (e.g. wrong change_type)
