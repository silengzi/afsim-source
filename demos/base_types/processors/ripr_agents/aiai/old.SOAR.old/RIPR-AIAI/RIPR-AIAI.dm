# ****************************************************************************
# CUI
#
# The Advanced Framework for Simulation, Integration, and Modeling (AFSIM)
#
# The use, dissemination or disclosure of data in this file is subject to
# limitation or restriction. See accompanying README and LICENSE for details.
# ****************************************************************************

81
SOAR_ID 0
SOAR_ID 1
SOAR_ID 2
SOAR_ID 3
ENUMERATION 4 2 operator state
ENUMERATION 5 1 none
ENUMERATION 6 4 conflict constraint-failure no-change tie
SOAR_ID 7
FLOAT_RANGE 8 -Infinity Infinity
FLOAT_RANGE 9 -Infinity Infinity
FLOAT_RANGE 10 -Infinity Infinity
FLOAT_RANGE 11 -Infinity Infinity
FLOAT_RANGE 12 -Infinity Infinity
FLOAT_RANGE 13 -Infinity Infinity
SOAR_ID 14
FLOAT_RANGE 15 -Infinity Infinity
SOAR_ID 16
ENUMERATION 17 1 initialize-RIPR-AIAI
ENUMERATION 18 1 elaboration
SOAR_ID 19
STRING 20
SOAR_ID 21
INTEGER_RANGE 22 -2147483648 2147483647
STRING 23
SOAR_ID 24
SOAR_ID 25
ENUMERATION 26 1 pursue-target
SOAR_ID 27
STRING 28
STRING 29
STRING 30
SOAR_ID 31
ENUMERATION 32 1 wait
SOAR_ID 33
INTEGER_RANGE 34 -2147483648 2147483647
SOAR_ID 35
STRING 36
STRING 37
FLOAT_RANGE 38 -Infinity Infinity
FLOAT_RANGE 39 -Infinity Infinity
FLOAT_RANGE 40 -Infinity Infinity
FLOAT_RANGE 41 -Infinity Infinity
FLOAT_RANGE 42 -Infinity Infinity
STRING 43
SOAR_ID 44
STRING 45
ENUMERATION 46 1 nil
FLOAT_RANGE 47 -Infinity Infinity
FLOAT_RANGE 48 -Infinity Infinity
FLOAT_RANGE 49 -Infinity Infinity
SOAR_ID 50
STRING 51
FLOAT_RANGE 52 -Infinity Infinity
FLOAT_RANGE 53 -Infinity Infinity
FLOAT_RANGE 54 -Infinity Infinity
FLOAT_RANGE 55 -Infinity Infinity
FLOAT_RANGE 56 -Infinity Infinity
SOAR_ID 57
SOAR_ID 58
STRING 59
INTEGER_RANGE 60 -2147483648 2147483647
STRING 61
INTEGER_RANGE 62 -2147483648 2147483647
FLOAT_RANGE 63 -Infinity Infinity
FLOAT_RANGE 64 -Infinity Infinity
FLOAT_RANGE 65 -Infinity Infinity
INTEGER_RANGE 66 -2147483648 2147483647
INTEGER_RANGE 67 -2147483648 2147483647
FLOAT_RANGE 68 -Infinity Infinity
FLOAT_RANGE 69 -Infinity Infinity
SOAR_ID 70
SOAR_ID 71
ENUMERATION 72 2 attack recon
STRING 73
FLOAT_RANGE 74 -Infinity Infinity
FLOAT_RANGE 75 -Infinity Infinity
SOAR_ID 76
FLOAT_RANGE 77 -Infinity Infinity
STRING 78
STRING 79
STRING 80
86
0 attribute 4
0 choices 5
0 impasse 6
0 io 1
0 item 44
0 name 36
0 operator 16
0 operator 25
0 operator 31
0 stale-time 47
0 superstate 46
0 top-state 7
1 input-link 2
1 output-link 3
2 current-time 15
2 orders-root 57
2 ownship-ammo 9
2 ownship-closing-speed-max 48
2 ownship-closing-speed-min 49
2 ownship-corner-speed 12
2 ownship-engagement-range-max 11
2 ownship-engagement-range-min 10
2 ownship-speed 8
2 ownship-speed-max 13
2 ownship-threat-tolerance 63
2 ownship-weapons-incoming 67
2 point-root 70
2 track-root 14
2 weight-closing-speed-of 54
2 weight-current-target 56
2 weight-others-targeting 65
2 weight-patrol-attack 74
2 weight-patrol-recon 75
2 weight-slant-range-to 53
2 weight-weapons-in-flight 69
3 do-nothing 21
3 pursue-point 76
3 pursue-target 24
14 target 19
16 name 17
16 random 18
19 closing-speed-of 40
19 currently-targeted 55
19 others-targeting 66
19 positioning 43
19 relative-bearing-to 38
19 slant-range-to 42
19 speed 41
19 target-name 20
19 target-type 61
19 threat-level 64
19 update-time 39
19 weapons-in-flight 62
21 nothing 22
21 status 23
24 job-bid 68
24 pursuit-mode 29
24 status 30
24 target-name 28
25 actions 35
25 counted 50
25 name 26
25 target 19
27 do-nothing 33
31 actions 27
31 name 32
33 nothing 34
33 status 37
35 pursue-target 24
44 actions 35
44 name 45
44 target 19
50 name 51
50 value 52
57 prefer-target-type 58
58 target-type 59
58 weight 60
70 point 71
71 point-name 73
71 point-patrol-type 72
71 relative-bearing-to 38
71 slant-range-to 42
76 job-bid 77
76 point-name 80
76 pursuit-mode 78
76 status 79
