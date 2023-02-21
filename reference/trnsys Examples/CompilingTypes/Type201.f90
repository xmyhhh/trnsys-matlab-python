Subroutine Type201
!***********************************************************************************************************************
! This subroutine models an auxiliary heater. Whenever the input control function igam is 1, heat is added as a rate 
!  less than or equal to qmax in order to bring the flowstream temperature to tset.
!
!   Revision History 
!   2/28/93  -- JWT - new features for TRNSYS 14.0
!   12/14/98 -- DEB - moved setpoint temp from parameter 2 to input 4 for Trnsys 15.0
!   7/19/02  -- DEB - prepared for TRNSYS 16.0
!   5/29/06  -- DAA/JWT - changed INFO(9) to 1, because at small time steps a small change in the inputs 
!                         (smaller than tolerance) results in the component not being called
!   6/00/09  -- TPM - conversion to TRNSYS 17 coding standard 
!   1/21/15  -- DEB - added SSR code     
!***********************************************************************************************************************
! Copyright � 2015 Solar Energy Laboratory, University of Wisconsin-Madison. All rights reserved.

!-----------------------------------------------------------------------------------------------------------------------
 Use TrnsysConstants
 Use TrnsysFunctions
!-----------------------------------------------------------------------------------------------------------------------

!export this subroutine for its use in external DLLs.
!DEC$ATTRIBUTES DLLEXPORT :: TYPE201

!Variable Declarations
Implicit None !force explicit declaration of local variables
Double Precision Timestep,Time
Integer igam
Double Precision tin    !temperature of fluid at heater inlet [C]
Double Precision tout   !temperature of fluid at heater outlet [C]
Double Precision tbar   !average temperature of fluid in heater [C]
Double Precision tamb   !ambient temperature of heater surroundings [C]
Double Precision tset   !heater setpoint temperature [C]
Double Precision ton    !set temporarily to outlet temperature before check on TOUT>TSET [C]
Double Precision qmax   !heater capacity [kJ/hr]
Double Precision qaux   !required heating rate [kJ/hr]
Double Precision qloss  !rate of thermal losses to surroundings [kJ/hr]
Double Precision flow   !fluid flow rate through heater [kg/hr]
Double Precision cp     !fluid specific heat [kJ/kg.K] 
Double Precision htreff !heater efficiency [-]
Double Precision ua     !overall loss coefficienct for heater during operation [kJ/hr.K] 
Double Precision qfluid !rate of energy delivered to fluid [kJ/hr]

!-----------------------------------------------------------------------------------------------------------------------
!Get the Global Trnsys Simulation Variables
 Time = getSimulationTime()
 Timestep = getSimulationTimeStep()
!-----------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------
!Set the Version Number for This Type
 If (getIsVersionSigningTime()) Then
     Call SetTypeVersion(17)
     Return
 Endif
!-----------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------
!Do All of the Last Call Manipulations Here
 If (getIsLastCallofSimulation()) Then
    Return
 Endif
!-----------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------
!Perform Any "End of Timestep" Manipulations That May Be Required
 If (getIsEndOfTimestep()) Then
    ! Update  variables
    If (getIsIncludedInSSR()) Then
       Call updateReportIntegral(1,getOutputValue(3)/3600.d0)  
       Call updateReportIntegral(2,getOutputValue(5)/3600.d0)  
       Call updateReportMinMax(1,getInputValue(4))
    EndIf
	Return
 Endif
!-----------------------------------------------------------------------------------------------------------------------
 
!-----------------------------------------------------------------------------------------------------------------------
!Do All of the "Very First Call of the Simulation Manipulations" Here
 If (getIsFirstCallofSimulation()) Then

!  Tell the TRNSYS Engine How This Type Works
    Call SetNumberofParameters(4)           
    Call SetNumberofInputs(5)           
    Call SetNumberofDerivatives(0)           
    Call SetNumberofOutputs(5)           
    Call SetIterationMode(1)           
    Call SetNumberStoredVariables(0,0)

!  Set up this Type's entry in the 
    If (getIsIncludedInSSR()) Then
       Call setNumberOfReportVariables(2,1,3,0) !(nInt,nMinMax,nPars,nText)
    EndIf

!  Set the Correct Input and Output Variable Types
	Call SetInputUnits(1,'TE1')    
	Call SetInputUnits(2,'MF1')    
	Call SetInputUnits(3,'CF1')    
	Call SetInputUnits(4,'TE1')    
	Call SetInputUnits(5,'TE1')    
    Call SetOutputUnits(1,'TE1')    
    Call SetOutputUnits(2,'MF1')    
    Call SetOutputUnits(3,'PW1')    
    Call SetOutputUnits(4,'PW1')    
    Call SetOutputUnits(5,'PW1')    

    Return

 EndIf
!-----------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------
!Do All of the "Start Time" Manipulations Here - There Are No Iterations at the Intial Time
 If (getIsStartTime()) Then

!  Read in the Values of the Parameters from the Input File
    qmax = getParameterValue(1)
    cp = getParameterValue(2)
    ua = getParameterValue(3)
    htreff = getParameterValue(4)

!  Check the Parameters for Problems
    If (qmax<0.) Call FoundBadParameter(1,'Fatal','The heater capacity must be positive.')
    If (cp<0.) Call FoundBadParameter(2,'Fatal','The fluid specific heat must be positive.')
    If (ua<0.) Call FoundBadParameter(3,'Fatal','The heater UA must be positive.')
	If ((htreff<0.).or.(htreff>1.)) Call FoundBadParameter(4,'Fatal','The heater efficiency must be between 0 and 1.')
    If (ErrorFound()) Return

!  Initialize  variables
    If (getIsIncludedInSSR()) Then
       Call initReportIntegral(1,'Energy Consumed','kW','kWh')  
       Call initReportIntegral(2,'Energy Delivered','kW','kWh')  
       Call initReportMinMax(1,'Heater Set Point','C')
       Call initReportValue(1,'Heater Capacity',qmax/3600.d0,'kW')
       Call initReportValue(2,'Heater Loss Coefficient',ua,'kJ/h.K')
       Call initReportValue(3,'Heater Efficiency',htreff,'0..1')
    EndIf

!  Set the Initial Values of the Outputs
    Call SetOutputValue(1,getInputValue(1))
    Call SetOutputValue(2,getInputValue(2))
    Call SetOutputValue(3,0.d0)
    Call SetOutputValue(4,0.d0)
    Call SetOutputValue(5,0.d0)

    Return

Endif
!-----------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------
!ReRead the Parameters if Another Unit of This Type Has Been Called Last
 If (getIsReReadParameters()) Then
    qmax = getParameterValue(1)
    cp = getParameterValue(2)
    ua = getParameterValue(3)
    htreff = getParameterValue(4)
 Endif
!-----------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------
!Get the Current Inputs to the Model
 tin=getInputValue(1)   
 flow=getInputValue(2)    		
 igam=JFIX(getInputValue(3)+0.1)		
 tset=getInputValue(4)    		
 tamb=getInputValue(5)    	
!-----------------------------------------------------------------------------------------------------------------------

!-----------------------------------------------------------------------------------------------------------------------
!Perform All of the Calculations Here
 If (flow <= 0.0) Then
! No flow
    Call SetOutputValue(1,tin)
    Call SetOutputValue(2,0.d0)
    Call SetOutputValue(3,0.d0)
    Call SetOutputValue(4,0.d0)
    Call SetOutputValue(5,0.d0)
 Else
! Check inlet temperature and control function
    If ((tin<tset).and.(igam==1)) Then 
!   Heater on
       ton=(qmax*htreff+flow*cp*tin+ua*tamb-ua*tin/2.d0)/(flow*cp+ua/2.d0)
       tout = MIN(tset,ton)
       tbar = (tin+tout)/2.d0
       qaux = (flow*cp*(tout-tin)+ua*(tbar-tamb))/htreff
       qloss = ua*(tbar-tamb) + (1.d0-htreff)*qaux
       qfluid = flow*cp*(tout-tin)
    Else
!   Heater off
       tout = tin
       qaux = 0.
       qloss = 0.
       qfluid = 0.   
    EndIf
! Set outputs
    Call SetOutputValue(1,tout)
    Call SetOutputValue(2,flow)
    Call SetOutputValue(3,qaux)
    Call SetOutputValue(4,qloss)
    Call SetOutputValue(5,qfluid)
 End If

 Return

End
