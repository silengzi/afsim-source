**CUI**

# launcher demo

This demo is meant to be a simple way of 
demonstrating a build up of tactics processor
and launch computer to fire a sam.
All launchers, sensors, and weapons are made up for this example.

Four different tactic processors / launch computers are used to shoot a sam.
The tactics_processor (in the platforms directory) is changed out for each of the demos.

* 1st_run.txt  
   The first one has all the logic to fire the missile within the task processor.
   Very little checks are done to fire the sam.
* 2nd_run.txt  
   The second removes the logic for the launch criteria and places it in a 
   separate launch computer script.
* 3rd_run.txt  
   The third adds more criteria to the launch computer and adds additional state machine logic.
* 4th_run.txt  
   The fourth processor separates the launch platform script and missile launch computer calls so 
   other launchers/missiles can be added.  This allows the same tactics processor to be used for 
   other launchers and missiles. Also, additional checks are done prior to launching a
   sam missile. 

## CUI Designation Indicator
* Controlled by: Air Force Research Laboratory
* Controlled by: Aerospace Systems Directorate
* CUI Categories: CTI, EXPT
* LDC/Distribution Statement: DIST-C
* POC: afrl.rq.afsim@us.af.mil

## Notices and Warnings

### DISTRIBUTION STATEMENT C
Distribution authorized to US Government agencies and their contractors;
Critical Technology, Export Controlled; (2021 Mar 10). Other requests for this
information shall be referred to AFRL Aerospace Systems Directorate.

### NOTICE TO ACCOMPANY FOREIGN DISCLOSURE
This content is furnished on the condition that it will not be released to
another nation without specific authority of the Department of the Air Force of
the United States, that it will be used for military purposes only, that
individual or corporate rights originating in the information, whether patented
or not, will be respected, that the recipient will report promptly to the
United States any known or suspected compromise, and that the information will
be provided substantially the same degree of security afforded it by the
Department of Defense of the United States. Also, regardless of any other
markings on the document, it will not be downgraded or declassified without
written approval from the originating U.S. agency.

### WARNING - EXPORT CONTROLLED
This content contains technical data whose export is restricted by the Arms
Export Control Act (Title 22, U.S.C. Sec 2751 et seq.) or the Export
Administration Act of 1979, as amended, Title 50 U.S.C., App. 2401 et seq.
Violations of these export laws are subject to severe criminal penalties.
Disseminate in accordance with provisions of DoD Directive 5230.25.

### HANDLING AND DESTRUCTION NOTICE
Handle this information in accordance with DoDI 5200.48. Destroy by any
approved method that will prevent unauthorized disclosure or reconstruction of
this information in accordance with NIST SP 800-88 and 32 C.F.R 2002.14
(Safeguarding Controlled Unclassified Information).

**CUI**
