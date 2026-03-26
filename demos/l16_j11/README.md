**CUI//REL TO USA ONLY**

# l16_j11 demo

This directory contains the files necessary to run a weapon server
demo with Link-16 network-enabled weapons.

The jtids.txt file contains the JTIDS terminal and Link-16 computer
definitions for both the weapon fighter platform and the network-enabled
weapon.

The platform.txt file contains the network-enabled weapon definition
and the fighter and weapon fighter definition.

For this scenario, three platforms are created a red fighter, a bogus point,
and a blue weapon fighter (see j11_out.txt). At T=15s, a network-enabled
weapon is fired. The blue weapon fighter then
begins sending J11.1 In-Flight Target Updates (IFTUs) to the weapon.

The weapon server is defined in the j11_in.txt file. The client is defined in the
j11_out.txt file.

Steps to run:
* Ensure the DIS multicast address and port are acceptable (see dis_network.txt line 38).
* Update the IP address for the weapon server (see j11_out.txt line 103).
* If the port is changed, it must be modified on the server side as well (see j11_in.txt line 76).
* Open two command prompt windows or two instances of Wizard.
* If using Wizard, set the j11_in.txt file as the startup file in one instance and the j11_out.txt as the startup in the other instance.
* Start the weapon server first (j11_in.txt).
* Start the client (j11_out.txt).

If viewing in a DIS viewer the weapon is launched and immediately turns toward
the red fighter if it is receiving IFTUs from the client-side blue fighter. If
there are issues with the connection settings the weapon will fly in a straight 
line until detonating due to max time of flight exceeded.

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
