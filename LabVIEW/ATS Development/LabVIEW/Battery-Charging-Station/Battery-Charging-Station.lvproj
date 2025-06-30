<?xml version='1.0' encoding='UTF-8'?>
<Project Type="Project" LVVersion="20008000">
	<Item Name="My Computer" Type="My Computer">
		<Property Name="server.app.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="server.control.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="server.tcp.enabled" Type="Bool">false</Property>
		<Property Name="server.tcp.port" Type="Int">0</Property>
		<Property Name="server.tcp.serviceName" Type="Str">My Computer/VI Server</Property>
		<Property Name="server.tcp.serviceName.default" Type="Str">My Computer/VI Server</Property>
		<Property Name="server.vi.callsEnabled" Type="Bool">true</Property>
		<Property Name="server.vi.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="specify.custom.address" Type="Bool">false</Property>
		<Item Name="Battery-Charging-Station" Type="Folder" URL="..">
			<Property Name="NI.DISK" Type="Bool">true</Property>
		</Item>
		<Item Name="Dependencies" Type="Dependencies">
			<Item Name="vi.lib" Type="Folder">
				<Item Name="Acquire Semaphore.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/semaphor.llb/Acquire Semaphore.vi"/>
				<Item Name="AddNamedSemaphorePrefix.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/semaphor.llb/AddNamedSemaphorePrefix.vi"/>
				<Item Name="BuildHelpPath.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/BuildHelpPath.vi"/>
				<Item Name="Check Special Tags.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Check Special Tags.vi"/>
				<Item Name="Clear Errors.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Clear Errors.vi"/>
				<Item Name="Convert property node font to graphics font.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Convert property node font to graphics font.vi"/>
				<Item Name="Details Display Dialog.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Details Display Dialog.vi"/>
				<Item Name="DialogType.ctl" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/DialogType.ctl"/>
				<Item Name="DialogTypeEnum.ctl" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/DialogTypeEnum.ctl"/>
				<Item Name="Error Cluster From Error Code.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Error Cluster From Error Code.vi"/>
				<Item Name="Error Code Database.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Error Code Database.vi"/>
				<Item Name="ErrWarn.ctl" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/ErrWarn.ctl"/>
				<Item Name="eventvkey.ctl" Type="VI" URL="/&lt;vilib&gt;/event_ctls.llb/eventvkey.ctl"/>
				<Item Name="ex_CorrectErrorChain.vi" Type="VI" URL="/&lt;vilib&gt;/express/express shared/ex_CorrectErrorChain.vi"/>
				<Item Name="Find Tag.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Find Tag.vi"/>
				<Item Name="Format Message String.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Format Message String.vi"/>
				<Item Name="FormatTime String.vi" Type="VI" URL="/&lt;vilib&gt;/express/express execution control/ElapsedTimeBlock.llb/FormatTime String.vi"/>
				<Item Name="General Error Handler Core CORE.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/General Error Handler Core CORE.vi"/>
				<Item Name="General Error Handler.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/General Error Handler.vi"/>
				<Item Name="Get String Text Bounds.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Get String Text Bounds.vi"/>
				<Item Name="Get Text Rect.vi" Type="VI" URL="/&lt;vilib&gt;/picture/picture.llb/Get Text Rect.vi"/>
				<Item Name="GetHelpDir.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/GetHelpDir.vi"/>
				<Item Name="GetNamedSemaphorePrefix.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/semaphor.llb/GetNamedSemaphorePrefix.vi"/>
				<Item Name="GetRTHostConnectedProp.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/GetRTHostConnectedProp.vi"/>
				<Item Name="Longest Line Length in Pixels.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Longest Line Length in Pixels.vi"/>
				<Item Name="LVBoundsTypeDef.ctl" Type="VI" URL="/&lt;vilib&gt;/Utility/miscctls.llb/LVBoundsTypeDef.ctl"/>
				<Item Name="LVDateTimeRec.ctl" Type="VI" URL="/&lt;vilib&gt;/Utility/miscctls.llb/LVDateTimeRec.ctl"/>
				<Item Name="LVRectTypeDef.ctl" Type="VI" URL="/&lt;vilib&gt;/Utility/miscctls.llb/LVRectTypeDef.ctl"/>
				<Item Name="Not A Semaphore.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/semaphor.llb/Not A Semaphore.vi"/>
				<Item Name="Not Found Dialog.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Not Found Dialog.vi"/>
				<Item Name="Obtain Semaphore Reference.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/semaphor.llb/Obtain Semaphore Reference.vi"/>
				<Item Name="Release Semaphore Reference.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/semaphor.llb/Release Semaphore Reference.vi"/>
				<Item Name="Release Semaphore.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/semaphor.llb/Release Semaphore.vi"/>
				<Item Name="RemoveNamedSemaphorePrefix.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/semaphor.llb/RemoveNamedSemaphorePrefix.vi"/>
				<Item Name="Search and Replace Pattern.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Search and Replace Pattern.vi"/>
				<Item Name="Semaphore RefNum" Type="VI" URL="/&lt;vilib&gt;/Utility/semaphor.llb/Semaphore RefNum"/>
				<Item Name="Semaphore Refnum Core.ctl" Type="VI" URL="/&lt;vilib&gt;/Utility/semaphor.llb/Semaphore Refnum Core.ctl"/>
				<Item Name="Set Bold Text.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Set Bold Text.vi"/>
				<Item Name="Set String Value.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Set String Value.vi"/>
				<Item Name="subDisplayMessage.vi" Type="VI" URL="/&lt;vilib&gt;/express/express output/DisplayMessageBlock.llb/subDisplayMessage.vi"/>
				<Item Name="subElapsedTime.vi" Type="VI" URL="/&lt;vilib&gt;/express/express execution control/ElapsedTimeBlock.llb/subElapsedTime.vi"/>
				<Item Name="TagReturnType.ctl" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/TagReturnType.ctl"/>
				<Item Name="Three Button Dialog CORE.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Three Button Dialog CORE.vi"/>
				<Item Name="Three Button Dialog.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Three Button Dialog.vi"/>
				<Item Name="Trim Whitespace.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/Trim Whitespace.vi"/>
				<Item Name="Validate Semaphore Size.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/semaphor.llb/Validate Semaphore Size.vi"/>
				<Item Name="VISA Configure Serial Port" Type="VI" URL="/&lt;vilib&gt;/Instr/_visa.llb/VISA Configure Serial Port"/>
				<Item Name="VISA Configure Serial Port (Instr).vi" Type="VI" URL="/&lt;vilib&gt;/Instr/_visa.llb/VISA Configure Serial Port (Instr).vi"/>
				<Item Name="VISA Configure Serial Port (Serial Instr).vi" Type="VI" URL="/&lt;vilib&gt;/Instr/_visa.llb/VISA Configure Serial Port (Serial Instr).vi"/>
				<Item Name="whitespace.ctl" Type="VI" URL="/&lt;vilib&gt;/Utility/error.llb/whitespace.ctl"/>
				<Item Name="Write Spreadsheet String.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/file.llb/Write Spreadsheet String.vi"/>
				<Item Name="Write To Spreadsheet File (DBL).vi" Type="VI" URL="/&lt;vilib&gt;/Utility/file.llb/Write To Spreadsheet File (DBL).vi"/>
				<Item Name="Write To Spreadsheet File (I64).vi" Type="VI" URL="/&lt;vilib&gt;/Utility/file.llb/Write To Spreadsheet File (I64).vi"/>
				<Item Name="Write To Spreadsheet File (string).vi" Type="VI" URL="/&lt;vilib&gt;/Utility/file.llb/Write To Spreadsheet File (string).vi"/>
				<Item Name="Write To Spreadsheet File.vi" Type="VI" URL="/&lt;vilib&gt;/Utility/file.llb/Write To Spreadsheet File.vi"/>
			</Item>
			<Item Name="Append Time String.vi" Type="VI" URL="../../Generic/Append Time String.vi"/>
			<Item Name="Atof.vi" Type="VI" URL="../../Generic/Numeric/Atof.vi"/>
			<Item Name="Button Disabled and Grayed Out.vi" Type="VI" URL="../../Generic/Button Disabled and Grayed Out.vi"/>
			<Item Name="Button Enabled.vi" Type="VI" URL="../../Generic/Button Enabled.vi"/>
			<Item Name="Charger_Action.vi" Type="VI" URL="../../Drivers/Charger Test Set/Charger_Action.vi"/>
			<Item Name="Charger_Close.vi" Type="VI" URL="../../Drivers/Charger Test Set/Charger_Close.vi"/>
			<Item Name="Charger_Command Write.vi" Type="VI" URL="../../Drivers/Charger Test Set/Charger_Command Write.vi"/>
			<Item Name="Charger_Disable.vi" Type="VI" URL="../../Drivers/Charger Test Set/Charger_Disable.vi"/>
			<Item Name="Charger_Enable.vi" Type="VI" URL="../../Drivers/Charger Test Set/Charger_Enable.vi"/>
			<Item Name="Charger_Input Control.ctl" Type="VI" URL="../../Drivers/Charger Test Set/Charger_Input Control.ctl"/>
			<Item Name="Charger_IPG Charging Status.vi" Type="VI" URL="../../Drivers/Charging/Charger_IPG Charging Status.vi"/>
			<Item Name="Charger_IPG VBAT Status.vi" Type="VI" URL="../../Drivers/Charging/Charger_IPG VBAT Status.vi"/>
			<Item Name="Charger_Open.vi" Type="VI" URL="../../Drivers/Charger Test Set/Charger_Open.vi"/>
			<Item Name="Charger_Telem with Retries.vi" Type="VI" URL="../../Drivers/Charger Test Set/Charger_Telem with Retries.vi"/>
			<Item Name="Charger_Wake-Up All IPGs.vi" Type="VI" URL="../../Drivers/Charger Test Set/Charger_Wake-Up All IPGs.vi"/>
			<Item Name="Charging_Choose MICS Channel.vi" Type="VI" URL="../../Drivers/Charging/Charging_Choose MICS Channel.vi"/>
			<Item Name="Charging_Extract Charging Status From String.vi" Type="VI" URL="../../Drivers/Charging/Charging_Extract Charging Status From String.vi"/>
			<Item Name="Charging_Extract VBAT Status from String.vi" Type="VI" URL="../../Drivers/Charging/Charging_Extract VBAT Status from String.vi"/>
			<Item Name="Charging_Find IPG MICS IDs.vi" Type="VI" URL="../../Drivers/Charging/Charging_Find IPG MICS IDs.vi"/>
			<Item Name="Charging_MICS Retry Count.vi" Type="VI" URL="../../Drivers/Charging/Charging_MICS Retry Count.vi"/>
			<Item Name="Charging_Set MICS Globals.vi" Type="VI" URL="../../Drivers/Charging/Charging_Set MICS Globals.vi"/>
			<Item Name="Delay with Stopwatch.vi" Type="VI" URL="../../Generic/Time Functions/Delay with Stopwatch.vi"/>
			<Item Name="Delay, Seconds with Reference.vi" Type="VI" URL="../../Generic/Time Functions/Delay, Seconds with Reference.vi"/>
			<Item Name="Delay, Seconds.vi" Type="VI" URL="../../Generic/Time Functions/Delay, Seconds.vi"/>
			<Item Name="Error Code and Source Clear.vi" Type="VI" URL="../../Generic/Error Code and Source Clear.vi"/>
			<Item Name="Error Source Overwrite.vi" Type="VI" URL="../../Generic/Error Source Overwrite.vi"/>
			<Item Name="Filter String, Pass Floating Point.vi" Type="VI" URL="../../Generic/String Functions/Filter String, Pass Floating Point.vi"/>
			<Item Name="If Error, then NaN.vi" Type="VI" URL="../../Generic/If Error, then NaN.vi"/>
			<Item Name="Is Not Error.vi" Type="VI" URL="../../Generic/Is Not Error.vi"/>
			<Item Name="MICS Command Lookup.vi" Type="VI" URL="../../Drivers/Telemetry/MICS Command Lookup.vi"/>
			<Item Name="MICS Parameters Global.vi" Type="VI" URL="../../Drivers/Telemetry/MICS Parameters Global.vi"/>
			<Item Name="MICS Response Lookup.vi" Type="VI" URL="../../Drivers/Telemetry/MICS Response Lookup.vi"/>
			<Item Name="MICS_Channel Global.vi" Type="VI" URL="../../Drivers/Telemetry/MICS_Channel Global.vi"/>
			<Item Name="MICS_ID Global.vi" Type="VI" URL="../../Drivers/Telemetry/MICS_ID Global.vi"/>
			<Item Name="MICSD Abort.vi" Type="VI" URL="../../Drivers/Telemetry/MICS Dongle Drivers/MICSD Abort.vi"/>
			<Item Name="MICSD Calibrate.vi" Type="VI" URL="../../Drivers/Telemetry/MICS Dongle Drivers/MICSD Calibrate.vi"/>
			<Item Name="MICSD Config.vi" Type="VI" URL="../../Drivers/Telemetry/MICS Dongle Drivers/MICSD Config.vi"/>
			<Item Name="MICSD Do CCA.vi" Type="VI" URL="../../Drivers/Telemetry/MICS Dongle Drivers/MICSD Do CCA.vi"/>
			<Item Name="MICSD Downlink MICS.vi" Type="VI" URL="../../Drivers/Telemetry/MICSD Downlink MICS.vi"/>
			<Item Name="MICSD Get Info.vi" Type="VI" URL="../../Drivers/Telemetry/MICS Dongle Drivers/MICSD Get Info.vi"/>
			<Item Name="MICSD Receive MICS Data.vi" Type="VI" URL="../../Drivers/Telemetry/MICS Dongle Drivers/MICSD Receive MICS Data.vi"/>
			<Item Name="MICSD Reset Serial Port.vi" Type="VI" URL="../../Drivers/Telemetry/MICS Dongle Drivers/MICSD Reset Serial Port.vi"/>
			<Item Name="MICSD Reset.vi" Type="VI" URL="../../Drivers/Telemetry/MICS Dongle Drivers/MICSD Reset.vi"/>
			<Item Name="MICSD Search for Implant.vi" Type="VI" URL="../../Drivers/Telemetry/MICS Dongle Drivers/MICSD Search for Implant.vi"/>
			<Item Name="MICSD Send MICS Data.vi" Type="VI" URL="../../Drivers/Telemetry/MICS Dongle Drivers/MICSD Send MICS Data.vi"/>
			<Item Name="MICSD Serial Read.vi" Type="VI" URL="../../Drivers/Telemetry/MICS Dongle Drivers/MICSD Serial Read.vi"/>
			<Item Name="MICSD Serial Write.vi" Type="VI" URL="../../Drivers/Telemetry/MICS Dongle Drivers/MICSD Serial Write.vi"/>
			<Item Name="MICSD Set 2.45 GHz TX Power.vi" Type="VI" URL="../../Drivers/Telemetry/MICS Dongle Drivers/MICSD Set 2.45 GHz TX Power.vi"/>
			<Item Name="MICSD Set Attenuator.vi" Type="VI" URL="../../Drivers/Telemetry/MICS Dongle Drivers/MICSD Set Attenuator.vi"/>
			<Item Name="MICSD Set Register.vi" Type="VI" URL="../../Drivers/Telemetry/MICS Dongle Drivers/MICSD Set Register.vi"/>
			<Item Name="MICSD Start Session.vi" Type="VI" URL="../../Drivers/Telemetry/MICS Dongle Drivers/MICSD Start Session.vi"/>
			<Item Name="MICSD Status String.vi" Type="VI" URL="../../Drivers/Telemetry/MICS Dongle Drivers/MICSD Status String.vi"/>
			<Item Name="MICSD Status.vi" Type="VI" URL="../../Drivers/Telemetry/MICS Dongle Drivers/MICSD Status.vi"/>
			<Item Name="MICSD Uplink MICS.vi" Type="VI" URL="../../Drivers/Telemetry/MICSD Uplink MICS.vi"/>
			<Item Name="Numeric String to Bytes.vi" Type="VI" URL="../../Drivers/Telemetry/Numeric String to Bytes.vi"/>
			<Item Name="Open Session with Retires and Error Clearing.vi" Type="VI" URL="../../Drivers/Telemetry/Open Session with Retires and Error Clearing.vi"/>
			<Item Name="Overflow-Safe Millis Elapsed.vi" Type="VI" URL="../../Miscellaneous/Overflow-Safe Millis Elapsed.vi"/>
			<Item Name="Parse Downlink.vi" Type="VI" URL="../../Drivers/Telemetry/Parse Downlink.vi"/>
			<Item Name="Parse Uplink.vi" Type="VI" URL="../../Drivers/Telemetry/Parse Uplink.vi"/>
			<Item Name="Poll Button until Pressed.vi" Type="VI" URL="../../Generic/Poll Button until Pressed.vi"/>
			<Item Name="Process Data In 2 Byte Chunks.vi" Type="VI" URL="../../Drivers/Telemetry/Process Data In 2 Byte Chunks.vi"/>
			<Item Name="Set Attenuation, 400 MHz Power, and 2.45 GHz Power.vi" Type="VI" URL="../../Drivers/Telemetry/Set Attenuation, 400 MHz Power, and 2.45 GHz Power.vi"/>
			<Item Name="Set Error Message.vi" Type="VI" URL="../../Generic/Set Error Message.vi"/>
			<Item Name="Set Telemetry Parameters.vi" Type="VI" URL="../../Drivers/Telemetry/Set Telemetry Parameters.vi"/>
			<Item Name="Simple Wait.vi" Type="VI" URL="../../Drivers/JTAG/GP Library/Simple Wait.vi"/>
			<Item Name="Stopwatch, Popup.vi" Type="VI" URL="../../Generic/Time Functions/Stopwatch, Popup.vi"/>
			<Item Name="Stopwatch, Reference.vi" Type="VI" URL="../../Generic/Time Functions/Stopwatch, Reference.vi"/>
			<Item Name="String Search And Replace.vi" Type="VI" URL="../../Generic/String Functions/String Search And Replace.vi"/>
			<Item Name="String to Character Array.vi" Type="VI" URL="../../Generic/String Functions/String to Character Array.vi"/>
			<Item Name="stristr.vi" Type="VI" URL="../../Generic/String Functions/stristr.vi"/>
			<Item Name="Strtok, Four Doubles.vi" Type="VI" URL="../../Generic/String Functions/Strtok, Four Doubles.vi"/>
			<Item Name="Table, Find Row in Column.vi" Type="VI" URL="../../Generic/Table Functions/Table, Find Row in Column.vi"/>
			<Item Name="Table, Get Cell Value.vi" Type="VI" URL="../../Generic/Table Functions/Table, Get Cell Value.vi"/>
			<Item Name="Telemetry Session Assurance.vi" Type="VI" URL="../../Drivers/Telemetry/Telemetry Session Assurance.vi"/>
			<Item Name="Toggle Active State of Run-Stop Buttons.vi" Type="VI" URL="../../Generic/Toggle Active State of Run-Stop Buttons.vi"/>
			<Item Name="Tokenize.vi" Type="VI" URL="../../Generic/String Functions/Tokenize.vi"/>
			<Item Name="Typedef Command List.ctl" Type="VI" URL="../../Drivers/Telemetry/Typedef Command List.ctl"/>
			<Item Name="Wait for Run Button.vi" Type="VI" URL="../../Generic/Wait for Run Button.vi"/>
			<Item Name="Wait For Session Status.vi" Type="VI" URL="../../Drivers/Telemetry/Wait For Session Status.vi"/>
			<Item Name="Zarlink Telemetry.vi" Type="VI" URL="../../Drivers/Telemetry/Zarlink Telemetry.vi"/>
		</Item>
		<Item Name="Build Specifications" Type="Build"/>
	</Item>
</Project>
