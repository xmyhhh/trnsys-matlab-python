In TRNSYS 16, Type 90 uses the file format from HYDROGEMS Type 190.
The TRNSYS 15 Type 90 format is obsolete. 
To convert your files, you just have to change the order of some data lines, as illustrated here under:

Lines 9:12 become lines 3:6 (Len_Unit, Spd_Unit, Pwr_unit)



NEW FORMAT
----------

WECS_Typ Bonus 2MW (60)                ! Wind Turbine type --- NOTE: This is the NEW Type 90 data file format (HYDROGEMS Type 190 format)
WECS_REF www.bonus.dk                  ! Data source
Len_Unit m                             ! Length unit, must be m (do NOT edit)
Spd_Unit m/s                           ! Speed unit, must be m/s (do NOT edit)
Pwr_Unit kW                            ! Power unit, must be m (do NOT edit)
Ctl_mode P                             ! Control mode: S=stall; P=pitch; V=variable speed !! EXACTLY 1 SPACE BEFORE THE 'S', 'P' or 'V' character !!
Rotor_Ht   60.00                       ! Rotor center height, meters
Rotor_Di   76.0                        ! Rotor diameter, meters
Sensr_Ht   60.00                       ! Sensor Height for data pairs given here below, meters (often rotor center height)
Sher_Exp    0.16                       ! Power-law exponent for vertical wind profile
Turb_Int    0.10                       ! Turbulence intensity valid for this curve
Air_Dens    1.225                      ! Power curve air density, kg/m3
Pwr_Ratd 2000.00                       ! Rated power of the turbine, kW
Spd_Ratd   15.00                       ! Rated wind speed, m/s
Num_Pair   26                          ! Number of (wind speed, power) data pairs in the file
   0	0.00                           ! First data pair (wind speed, power) - Free format - ALWAYS START AT 0.0 !!!
   1	0.00                           ! Second data pair - Free format
   2	0.00                           ! ...


OLD FORMAT
----------


File_Nam VestasV39-500kW.pwr     * File name --- NOTE: This is the OLD Type 90 data file format (Version 15 Type 90 format)
Test_Ref WINDSTATS               * Source of data
Rotor_Ht   39.00                 * Rotor center height, meters
Rotor_Di   39.00                 * Rotor diameter, meters
Sensr_Ht   39.00                 * Sensor Height for data, meters
Sher_Exp    0.14                 * Power-law exponant for speed-up calculation
Turb_Int    0.10                 * Turbulence intensity valid for this curve
Air_Dens    1.23                 * Power curve air density, kg/m3
Len_Unit     m                   * Length unit - MUST be m !! DO NOT EDIT
Spd_Unit   m/s                   * Wind speed units - MUST be m/s !! DO NOT EDIT
Pwr_Unit    kW                   * Power output units - MUST be kW !! DO NOT EDIT
Ctl_mode     P                   * Control mode: S=stall; P=pitch; V=variable speed !! RESPECT THE NB OF SPACES !! 5 SPACES BEFORE THE 'S', 'P' or 'V' character !!
Pwr_Ratd  500.00                 * Rated power of the turbine, kW
Spd_Ratd   18.00                 * Wind speed at rated power, m/s
Num_Pair   20                    * The number of power vs. windspeed pairs in the power curve
  0.00   0.00                    * first point (wind speed, power) - Start at 0.0