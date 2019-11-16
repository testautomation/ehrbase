*** Settings ***
Metadata    Version    0.2.0
Metadata    Author     *Pablo Pazos*
Metadata    Author     *Wladislaw Wagner*

Documentation     COMPOSITION SERVICE TEST SUITE
...
...               Test documentation: https://docs.google.com/document/d/1rR9KZ-hz_LUSyp0qdADtYydnDIgUqOHs532NvNipyzg

Resource          ${EXECDIR}${/}tests${/}robot${/}_resources${/}suite_settings.robot
Resource          ${EXECDIR}${/}tests${/}robot${/}_resources${/}keywords${/}generic_keywords.robot
Resource          ${EXECDIR}${/}tests${/}robot${/}_resources${/}keywords${/}aql_query_keywords.robot
Resource          ${EXECDIR}${/}tests${/}robot${/}_resources${/}keywords${/}ehr_keywords.robot
Resource          ${EXECDIR}${/}tests${/}robot${/}_resources${/}keywords${/}contribution_keywords.robot
Resource          ${EXECDIR}${/}tests${/}robot${/}_resources${/}keywords${/}composition_keywords.robot
Resource          ${EXECDIR}${/}tests${/}robot${/}_resources${/}keywords${/}template_opt1.4_keywords.robot
Suite Setup       Startup SUT
Suite Teardown    Shutdown SUT
Force Tags        COMPOSITION