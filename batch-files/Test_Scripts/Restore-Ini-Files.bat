@echo off
REM --------------------------------------------------------------
REM Restore ini-files after modifications for Validation.
REM Sophronis Mantoles
REM REV. 2.0.0
REM DATE: June 05 2014
REM --------------------------------------------------------------
REM copy original run-in-config.ini and default-parameters.ini to the proper directory
@echo on
@echo restoring test ini files
copy C:\_SJM\OPS-PD\test_apps\production\release\Ampere_Run_in\Test_Scripts\Ini_Files\run-in-config.ini C:\_SJM\OPS-PD\test_apps\production\release\Ampere_Run_in\run-in-config.ini > NUL
copy C:\_SJM\OPS-PD\test_apps\production\release\Ampere_Run_in\Test_Scripts\Ini_Files\default-parameters.ini C:\_SJM\OPS-PD\test_apps\production\release\Ampere_Run_in\default-parameters.ini > NUL
@echo change the attributes of the ini files to read only:
attrib +r C:\_SJM\OPS-PD\test_apps\production\release\Ampere_Run_in\run-in-config.ini >NUL
attrib +r C:\_SJM\OPS-PD\test_apps\production\release\Ampere_Run_in\default-parameters.ini >NUL
@echo completed running script