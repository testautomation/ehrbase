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
Documentation   EHR Integration Tests
...

Resource    ${CURDIR}${/}../_resources/suite_settings.robot
Resource    ${CURDIR}${/}../_resources/keywords/ehr_keywords.robot

Suite Setup    Startup SUT
Suite Teardown    Shutdown SUT

Force Tags      composition    obsolete



*** Test Cases ***
Retrieve composition XML
    [Tags]   composition  not-ready
    Create EHR  1234-556  namespace_555
    extract ehrId
    create composition  ${template_id}  FLAT  composition_001.json
    extract composition_id
    retrieve composition xml    ${composition_id}   XML
    # Output    response
    # TODO @ Wlad - make keyword --> verify response body is XML
    expect response status  200
    Clear Expectations



*** Keywords ***
