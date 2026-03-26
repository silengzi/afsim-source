**CUI**

# orwaca_iads demo

There are two start up files.
The startup file "orwaca_northern_area.txt"  only has the sams in the states of Washington and Oregon.
The startup file "orwaca_full_area.txt" has the additional SAMs located in the state of California.

You must use the new icons that have "_icon" in the name or all of the platforms will look like stop signs when looking at replay files.

The "orwaca_full_iads_coverage.JPG" image file (located in jpg subdirectory) shows the geographical locations of the sam sites.
The extremely long range sams (ELR_SAMS) are 175 nautical mile missiles (RED rings).
The long range sams (LR_SAMS) are 100 nautical mile missiles (ORANGE rings).
The medium range sams (MR_SAMS) are  50 nautical mile missiles (GREEN rings).
The  SR_SAMS are  10 nautical mile missiles (VIOLET rings) (max alt of 15kft).
    (they don't do so well past 7 nautical miles so can be defeated at longer kinematic ranges)
The SR_SAMS (telars) are self commanded and do not do cooperative engagements like the longer range sams.

The TBM shooting at Denver can be adjusted to shoot at any time during the simulation run.
This can be accomplished by adjusting the times in platforms/tbm_launcher_vehicle.txt (for every tbm launcher) OR
adjusting the platform variables in the scenario file "tbm_route_launch.txt".
This is just an example to show some scripting capability.  The pause time in the route has to be adjusted accordingly.

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
