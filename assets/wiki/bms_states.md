# BMS States

The core of the BMS consists of a state machine that can be in either one of the following states:

| State | Description |
| --- | --- |
| ESS | Short for _Electrical Safe State_. In this state, the battery is "off", meaning there is no power provided to any component outside of the battery box. ESS is entered when the BMS (or LVC) detects any error. The emergency stop is also regarded as such an error. |
| Startup | In this state, the BMS is preparing to start up. It will power up several components that are required to operate, such as the satellite boards, the IMD and IVT. |
| Pre-charge | In this state, the BMS is pre-charging the HV bus. |
| Active | In this state, the battery is "on"; components outside of the battery receive HV, and (depending on LVC state), LV as well. |

## Errors

When the BMS enters ESS, it always does so due to an error. The possible errors detected by the BMS are:

| Error | Description |
| --- | --- |
| Cell UV | Undervoltage, the voltage of any metacell is too low (2.5 V) |
| Cell OV | Overvoltage, the voltage of any metacell is too high (4.2 V) |
| Cell UT | Undertemperature, the temperature of any battery cell is too low |
| Cell OT | Overtemperature, the temperature of any battery cell is too high |
| PCB OT | PCB overtemperature, the temperature measured by any NTC on the PCB is too high |
| E-stop | The emergency button has been pressed |
| HVIL | The HV interlock isn't correct, probably one of the HV connectors on the battfront isn't connected |
| OC | Overcurrent (detected by BMS software) |
| IVTOCS | Overcurrent (detected by the IVT) |
| Sat fault | Satellite boards detected a fault |
| Sat OT | Satellite overtemperature, the temperature measured by any NTC on any satellite board is too high |
| Cont fault | There is a mismatch between the measured state of a contactor, and the state they should have according to the BMS software |
| IMD fault | There is a fault indicated by the IMD |
| IMD not OK | The IMD OK signal indicates there is a fault detected by the IMD |
| Sat comm fault | There is a timeout in the communication with the satellite boards |
| IVT comm fault | There is a timeout in the communication with the IVT |
| Pre-charge TO | Pre-charge timeout, the HV bus took too long to reach the proper voltage during pre-charging |
| LVC Low | The LVC wake signal is low, indicating the LVC has detected a fault |
| HV UV | The measured total battery voltage is too low |
| UV prot | The battery has entered an undervoltage condition, and has not been charged fast enough after starting up |