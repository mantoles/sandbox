@echo off
REM --------------------------------------------------------------
REM one short cycle bat script
REM Sophronis Mantoles
REM REV. 2.0.0
REM DATE: June 19 2014
REM --------------------------------------------------------------
@echo on
@echo change the attributes of the ini files:
attrib -r C:\_SJM\OPS-PD\test_apps\production\release\Ampere_Run_in\run-in-config.ini >NUL
attrib -r C:\_SJM\OPS-PD\test_apps\production\release\Ampere_Run_in\default-parameters.ini >NUL
@echo copying  test files over the original ini files for one cycle.
copy C:\_SJM\OPS-PD\test_apps\production\release\Ampere_Run_in\Test_Scripts\Ini_Files\run-in-config-three-short-cycles.ini C:\_SJM\OPS-PD\test_apps\production\release\Ampere_Run_in\run-in-config.ini > NUL
copy C:\_SJM\OPS-PD\test_apps\production\release\Ampere_Run_in\Test_Scripts\Ini_Files\default-parameters-short-cycle.ini C:\_SJM\OPS-PD\test_apps\production\release\Ampere_Run_in\default-parameters.ini > NUL
@echo completed running script
@echo off