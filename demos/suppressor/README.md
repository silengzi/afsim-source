**CUI//REL TO USA ONLY**

# suppressor demo

This directory contains a conversion of a major demonstration case from
Suppressor 6.0 as it was converted by Chris Randolph and others.

The main input files are:

   * bomb_demo.txt           The 'bomb_demo' run input (like the MOD file).
   * bomb_demo_laydown.txt   The 'bomb_demo' laydown (like the SDB file).

The 'type' definitions that would have been present in the Suppressor TDB files
are in the directories

   *  DISRUPTORS
   *  PATTERNS
   *  PLATFORMS
   *  SENSORS
   *  WEAPONS

To run the scenario, set bomb_demo.txt as the startup file.

## Common Conversion Items

* By default a SUPPRESSOR sensor reports IFF (see SNR-CHARACTERISTICS) while
  WSF defaults to not reporting IFF. There every sensor that does not have a
  NO-IFF in the SNR-CHARACTERISTICS should specify 'reports_iff' in the WSF
  sensor definition.

* By default WSF drops the local track when all contributors have dropped
  (either explicitly by track drop messages or implicitly through raw track
  purging).

  On the other hand, SUPPRESSOR continues to maintain the track even in the
  absence of contributors UNTIL the TIME-BEFORE-DROP expires. To prevent WSF
  from dropping the track when it no longer has contributors, we must add the
  the following:
  ```
    track_manager
      uncorrelated_track_drops off
    end_track_manager
  ```

* By default SUPPRESSOR performs velocity changes uniformly over the distance
  between two waypoints. WSF will do the same thing if 'maximum_linear_
  acceleration' is NOT specified. Therefore, if uniform velocity changes are
  desired, do NOT specify a 'maximum_linear_acceleration' for the mover.

## CUI Designation Indicator
* Controlled by: Air Force Research Laboratory
* Controlled by: Aerospace Systems Directorate
* CUI Categories: CTI, EXPT
* LDC/Distribution Statement: DIST-C, REL TO USA ONLY
* POC: afrl.rq.afsim@us.af.mil

## Notices and Warnings

### DISTRIBUTION STATEMENT C
Distribution authorized to US Government agencies and their contractors;
Critical Technology, Export Controlled; (2021 Mar 09). Other requests for this
information shall be referred to AFRL Aerospace Systems Directorate.

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

**CUI//REL TO USA ONLY**
