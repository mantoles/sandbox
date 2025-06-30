// Tegam4040CDriver.h:
// Header file containing exported functions for Tegam 4040
// Built with National Instrument's VISA 4.0

#pragma once

#ifdef TEGAM4040CDRIVER_EXPORTS
#define TEGAM4040_API __declspec(dllexport)
#else
#define TEGAM4040_API __declspec(dllimport)
#endif

#include "visatype.h"
#include "visa.h"

namespace Tegam4040CDriver
{
#define STRING_BUF_SIZE				1024		// size for string bufs
#define TEGAM_MANUFACTURER_ID		0x1A79
#define TEGAM_MODEL_4040_ID			0x0FC8
#define TEGAM_ADDRESS_SPACE			11			// 4040 address space
#define TEGAM_CONTROL_REG_OFFSET	0x0100		// 4040 control reg offset
#define TEGAM_DAC_REG_OFFSET		0x0140		// 4040 DAC reg offset

	// statics to hold the default register values
	static ViUInt16 controlRegDefaultVal	= 0x0000;
	static ViUInt16 dacRegDefaultVal		= 0x7FFF;

	// Driver error code enumeration
	enum eTegam4040Errors : int
	{
		TEGAM4040_NO_ERROR,
		TEGAM4040_NULL_SESSION_HANDLE,
		TEGAM4040_INSTRUMENT_NOT_TEGAM4040,
		TEGAM4040_INVALID_INPUT_IMPEDANCE_SET,
		TEGAM4040_INVALID_COUPLING_MODE_SET,
		TEGAM4040_INVALID_CALIBRATION_MODE_SET,
		TEGAM4040_INVALID_CALIBRATION_MODE_GET,
		TEGAM4040_INVALID_GAIN_MODE_SET,
		TEGAM4040_INVALID_GAIN_MODE_GET,
		TEGAM4040_INVALID_ATTENUATION_MODE_SET,
		TEGAM4040_INVALID_ATTENUATION_MODE_GET,
		TEGAM4040_INVALID_FILTER_MODE_SET,
		TEGAM4040_INVALID_FILTER_MODE_GET
	};

	// Input Impedance enumeration
	enum eInputImpedance : unsigned short
	{
		INPUT_IMPEDANCE_1MEG = 0,
		INPUT_IMPEDANCE_50 = 1
	};

	// Calibration Mode enumeration
	enum eCalibrationMode : unsigned short
	{
		DISABLE_CALIBRATION = 0,
		ENABLE_CALIBRATION = 1
	};

	// Gain mode enumeration
	enum eGainMode : unsigned short
	{
		GAIN_1 = 0,
		GAIN_10 = 1,
		GAIN_100 = 2
	};

	// Attenuation mode enumeration
	enum eAttenuationMode : unsigned short
	{
		ATTENUATION_INFINITE = 0,
		ATTENUATION_1 = 1,
		ATTENUATION_10 = 2,
		ATTENUATION_100 = 3
	};

	// Coupling mode enumeration
	enum eCouplingMode : unsigned short
	{
		COUPLING_DC = 0,
		COUPLING_AC = 1,
	};

	// Filter mode enumeration
	enum eFilterMode : unsigned short
	{
		FILTER_NONE = 0,
		FILTER_1MEG = 1,
		FILTER_100K = 2
	};


	// Exported function declarations
	extern "C"
	{
		// Function name:  GetDriverVersion()
		// Use:  returns the driver version as a string
		// Function return type, value:  void
		// Function args:
		//		char* stringBuf (IN):  buffer to hold version string
		//		int bufLength (IN):  length of buffer
		TEGAM4040_API void GetDriverVersion(char* stringBuf, int bufLength);

		/************ Open / Close 4040 functions ************/

		//	Function name:  Open4040()
		//	Use:  Function to open a session to the 4040
		//	Function return type, value:  ViStatus, VISA error code
		//	Function args:
		//		const char* visaResourceString (IN):  resource to open
		//		ViUInt32 timeout (IN):  open/read/write timeouts in msecs
		//		ViUInt32 resetInstrument (IN):  non-zero value forces instrument reset
		//		int* tegam4040Error (OUT):  contains a driver-specific (i.e. non-VISA) error code
		//		ViPSession* instrSessionPtr (OUT):  pointer to instrument visa session
		//		
		//  NOTE:  this function is written in dataflow style to avoid complex logic at the (slight) cost of
		//  execution speed.  All error checks are done on _both_ VISA errors ('status') and driver errors
		//  ('driverError').  This simplifies the if/else logic, again at the expense of speed.  As a result of
		//  this, it should be impossible for both error codes to be set to something other than zero (for both
		//  VISA and driver errors, a zero indicates no error occurred)
		TEGAM4040_API ViStatus Open4040(const char* visaResourceString, ViUInt32 timeout, ViUInt32 resetInstrument, eTegam4040Errors* tegam4040Error, ViSession* instrSessionPtr);

		//	Function name:  Close4040()
		//	Use:  Function to close a session to the 4040
		//	Function return type, value:  ViStatus, VISA error code
		//	Function args:
		//		ViSession instrSession:  handle to the instrument session
		//		int* tegam4040Error (OUT):  contains a driver-specific (i.e. non-VISA) error code
		TEGAM4040_API ViStatus Close4040(ViSession instrSession, eTegam4040Errors* tegam4040Error);


		/************ Set / Get Input Impedance functions ************/

		//	Function name:  SetInputImpedance()
		//	Use:  Function to set the input impedance on the 4040
		//	Function return type, value:  ViStatus, VISA error code
		//	Function args:
		//		ViSession instrSession (IN):  instrument session handle
		//		eInputImpedance inputImpedance (IN):  input impedance (enum)
		//		int* tegam4040Error (OUT):  contains a driver-specific (i.e. non-VISA) error code
		TEGAM4040_API ViStatus SetInputImpedance(ViSession session, eInputImpedance inputImpedance, eTegam4040Errors* tegam4040Error);

		//	Function name:  GetInputImpedance()
		//	Use:  Function to get the input impedance on the 4040
		//	Function return type, value:  ViStatus, VISA error code
		//	Function args:
		//		ViSession instrSession (IN):  instrument session handle
		//		eInputImpedance* inputImpedance (OUT):  input impedance (enum)
		//		eTegam4040Errors* tegam4040Error (OUT):  contains a driver-specific (i.e. non-VISA) error code
		TEGAM4040_API ViStatus GetInputImpedance(ViSession session, eInputImpedance* inputImpedance, eTegam4040Errors* tegam4040Error);


		/************ Set / Get Calibration Mode functions ************/

		//	Function name:  SetCalibrationMode()
		//	Use:  Function to set the calibration mode on the 4040
		//	Function return type, value:  ViStatus, VISA error code
		//	Function args:
		//		ViSession instrSession (IN):  instrument session handle
		//		eCalibrationMode calibrationMode (IN):  calibration mode (enum)
		//		eTegam4040Errors* tegam4040Error (OUT):  contains a driver-specific (i.e. non-VISA) error code
		TEGAM4040_API ViStatus SetCalibrationMode(ViSession session, eCalibrationMode calibrationMode, eTegam4040Errors* tegam4040Error);

		//	Function name:  GetCalibrationMode()
		//	Use:  Function to get the calibration mode on the 4040
		//	Function return type, value:  ViStatus, VISA error code
		//	Function args:
		//		ViSession instrSession (IN):  instrument session handle
		//		eCalibrationMode* calibrationMode (OUT):  calibration mode (enum)
		//		eTegam4040Errors* tegam4040Error (OUT):  contains a driver-specific (i.e. non-VISA) error code
		TEGAM4040_API ViStatus GetCalibrationMode(ViSession session, eCalibrationMode* calibrationMode, eTegam4040Errors* tegam4040Error);


		/************ Set / Get Attenuation Mode functions ************/

		//	Function name:  SetAttenuationMode()
		//	Use:  Function to set the attenuation mode on the 4040
		//	Function return type, value:  ViStatus, VISA error code
		//	Function args:
		//		ViSession instrSession (IN):  instrument session handle
		//		eGainMode attenuationMode (IN):  attenuation mode (enum)
		//		eTegam4040Errors* tegam4040Error (OUT):  contains a driver-specific (i.e. non-VISA) error code
		TEGAM4040_API ViStatus SetAttenuationMode(ViSession session, eAttenuationMode attenuationMode, eTegam4040Errors* tegam4040Error);

		//	Function name:  GetAttenuationMode()
		//	Use:  Function to get the attenuation mode on the 4040
		//	Function return type, value:  ViStatus, VISA error code
		//	Function args:
		//		ViSession instrSession (IN):  instrument session handle
		//		eAttenuationMode* attenuationMode (OUT):  Gain mode (enum)
		//		eTegam4040Errors* tegam4040Error (OUT):  contains a driver-specific (i.e. non-VISA) error code
		TEGAM4040_API ViStatus GetAttenautionMode(ViSession session, eAttenuationMode* attenuationMode, eTegam4040Errors* tegam4040Error);


		/************ Set / Get Gain Mode functions ************/

		//	Function name:  SetGainMode()
		//	Use:  Function to set the gain mode on the 4040
		//	Function return type, value:  ViStatus, VISA error code
		//	Function args:
		//		ViSession instrSession (IN):  instrument session handle
		//		eGainMode gainMode (IN):  gain mode (enum)
		//		eTegam4040Errors* tegam4040Error (OUT):  contains a driver-specific (i.e. non-VISA) error code
		TEGAM4040_API ViStatus SetGainMode(ViSession session, eGainMode gainMode, eTegam4040Errors* tegam4040Error);

		//	Function name:  GetGainMode()
		//	Use:  Function to get the gain mode on the 4040
		//	Function return type, value:  ViStatus, VISA error code
		//	Function args:
		//		ViSession instrSession (IN):  instrument session handle
		//		eGainMode* gainMode (OUT):  Gain mode (enum)
		//		eTegam4040Errors* tegam4040Error (OUT):  contains a driver-specific (i.e. non-VISA) error code
		TEGAM4040_API ViStatus GetGainMode(ViSession session, eGainMode* gainMode, eTegam4040Errors* tegam4040Error);


		/************ Set / Get Coupling Mode functions ************/

		//	Function name:  SetCouplingMode()
		//	Use:  Function to set the coupling mode on the 4040
		//	Function return type, value:  ViStatus, VISA error code
		//	Function args:
		//		ViSession instrSession (IN):  instrument session handle
		//		eCouplingMode couplingMode (IN):  coupling mode (enum)
		//		eTegam4040Errors* tegam4040Error (OUT):  contains a driver-specific (i.e. non-VISA) error code
		TEGAM4040_API ViStatus SetCouplingMode(ViSession session, eCouplingMode couplingMode, eTegam4040Errors* tegam4040Error);
		
		//	Function name:  GetCouplingMode()
		//	Use:  Function to get the coupling mode on the 4040
		//	Function return type, value:  ViStatus, VISA error code
		//	Function args:
		//		ViSession instrSession (IN):  instrument session handle
		//		eCouplingMode* couplingMode (OUT):  couplingMode (enum)
		//		eTegam4040Errors* tegam4040Error (OUT):  contains a driver-specific (i.e. non-VISA) error code
		TEGAM4040_API ViStatus GetCouplingMode(ViSession session, eCouplingMode* couplingMode, eTegam4040Errors* tegam4040Error);


		/************ Set / Get Filter Mode functions ************/

		//	Function name:  SetFilterMode()
		//	Use:  Function to set the filter mode on the 4040
		//	Function return type, value:  ViStatus, VISA error code
		//	Function args:
		//		ViSession instrSession (IN):  instrument session handle
		//		eFilterMode filterMode (IN):  filterMode mode (enum)
		//		eTegam4040Errors* tegam4040Error (OUT):  contains a driver-specific (i.e. non-VISA) error code
		TEGAM4040_API ViStatus SetFilterMode(ViSession session, eFilterMode FilterMode, eTegam4040Errors* tegam4040Error);

		//	Function name:  GetFilterMode()
		//	Use:  Function to get the filter mode on the 4040
		//	Function return type, value:  ViStatus, VISA error code
		//	Function args:
		//		ViSession instrSession (IN):  instrument session handle
		//		eFilterMode* filterMode (OUT):  filter mode (enum)
		//		eTegam4040Errors* tegam4040Error (OUT):  contains a driver-specific (i.e. non-VISA) error code
		TEGAM4040_API ViStatus GetFilterMode(ViSession session, eFilterMode* FilterMode, eTegam4040Errors* tegam4040Error);

				/************ Set / Get DAC Value functions ************/

		//	Function name:  SetDacValue()
		//	Use:  Function to set the DAC value on the 4040
		//	Function return type, value:  ViStatus, VISA error code
		//	Function args:
		//		ViSession instrSession (IN):  instrument session handle
		//		ViUInt16 dacValue (IN):  DAC value to set
		//		eTegam4040Errors* tegam4040Error (OUT):  contains a driver-specific (i.e. non-VISA) error code
		TEGAM4040_API ViStatus SetDacValue(ViSession session, ViUInt16 dacValue, eTegam4040Errors* tegam4040Error);

		//	Function name:  GetDacValue()
		//	Use:  Function to get the DAC value on the 4040
		//	Function return type, value:  ViStatus, VISA error code
		//	Function args:
		//		ViSession instrSession (IN):  instrument session handle
		//		ViUInt16* dacValue (OUT):  the current DAC value
		//		eTegam4040Errors* tegam4040Error (OUT):  contains a driver-specific (i.e. non-VISA) error code
		TEGAM4040_API ViStatus GetDacValue(ViSession session, ViUInt16* dacValue, eTegam4040Errors* tegam4040Error);


		/************ Misc functions ************/
	
		//	Function name:  GetErrorString()
		//	Use:  Function to translate a VISA or driver error code to a readable string.  Note that only one
		//		  or the other error should be non-zero for this function to work correctly.
		//	Function return value:  int, a non-zero value indicates the passed handle is zero (error)
		//	Function args:
		//		const char* visaResourceString (IN):  the resource string the error code applies to
		//		ViStatus visaErrorCode (IN):  the VISA error code to translate
		//		eTegam4040Errors tegam4040Error (IN):  the Tegam 4040 error code to translate
		//		int errStringBufLen (IN):  size of error string buffer passed in
		//		char* errStringBuf (OUT):  buffer containing the translated error string
		TEGAM4040_API eTegam4040Errors GetErrorString(ViSession session, ViStatus visaErrorCode, eTegam4040Errors tegam4040Error, int errStringBufLen, char* errStringBuf);
	}
}

 


