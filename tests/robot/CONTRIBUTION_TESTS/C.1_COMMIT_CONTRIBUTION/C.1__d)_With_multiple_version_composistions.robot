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
...     Alternative flow 3: commit CONTRIBUTION with multiple valid and invalid VERSION<COMPOSITION>
...
...     Preconditions:
...         An EHR with known ehr_id exists, and OPTs should be loaded for each case.
...
...     Flow:
...         1. Invoke commit CONTRIBUTION service with an existing ehr_id and multiple VERSION<COMPOSITION>,
...            some valid, some invalid, that reference existing OPTs in the system.
...         2. The result should be negative and retrieve an error related invalid VERSION<COMPOSITION>
...
...         Note: the whole commit should behave like a transaction and fail, no CONTRIBUTIONS or VERSIONS should be
...               created on the system.
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
Alternative flow 3: commit CONTRIBUTION with multiple valid and invalid VERSION<COMPOSITION>

    Upload OPT    minimal/minimal_instruction.opt

    Create EHR

    commit invalid CONTRIBUTION (JSON)    invalid_contributions/multiple_valid_and_invalid_compos.json

    check response: is negative indicating invalid version_composition
