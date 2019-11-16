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
Documentation   Contribution Integration Tests
...
...     Main flow: get CONTRIBUTIONS of existing EHR with a just committed CONTRIBUTION
...
...     Preconditions:
...         An EHR with known ehr_id exists and has a CONTRIBUTION with known uid.
...
...     Flow:
...         1. Invoke get CONTRIBUTIONS service by the existing ehr_id
...         2. The result should be positive and retrieve a list of CONTRIBUTIONS with one item
...
...     Postconditions:
...         None


Resource    ${EXECDIR}${/}tests${/}robot${/}_resources${/}suite_settings.robot
Resource    ${EXECDIR}${/}tests${/}robot${/}_resources${/}keywords${/}generic_keywords.robot
Resource    ${EXECDIR}${/}tests${/}robot${/}_resources${/}keywords${/}contribution_keywords.robot
Resource    ${EXECDIR}${/}tests${/}robot${/}_resources${/}keywords${/}composition_keywords.robot
Resource    ${EXECDIR}${/}tests${/}robot${/}_resources${/}keywords${/}template_opt1.4_keywords.robot
Resource    ${EXECDIR}${/}tests${/}robot${/}_resources${/}keywords${/}ehr_keywords.robot

#Suite Setup  Startup SUT
# Test Setup  start openehr server
# Test Teardown  restore clean SUT state
#Suite Teardown  Shutdown SUT

Force Tags    refactor



*** Test Cases ***
Main flow: get CONTRIBUTIONS of existing EHR with a just committed CONTRIBUTION

    Upload OPT    minimal/minimal_evaluation.opt

    Create EHR

    commit CONTRIBUTION (JSON)    minimal/minimal_evaluation.contribution.json

    retrieve CONTRIBUTION(S) by ehr_id (JSON)

    check response: is positive with list of 1 contribution(s)

    # check response: is positive with list of "1" contribution(s)

    [Teardown]    Restart SUT



*** Keywords ***
check response: is positive with list of 1 contribution(s)
    Fail    msg=break it till you make it!
