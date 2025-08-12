"""
Jain University Attendance Checker Configuration
==============================================

This file contains all the configuration settings for the attendance checker.
Modify these values as needed for your specific setup.
"""

# URLs
LOGIN_URL = "https://student.jgianveshana.com"
ATTENDANCE_URL = "https://student.jgianveshana.com/ui/Academics/js_Class_Attendance_for_a_Week.aspx"

# Timeouts and delays (in seconds)
WAIT_TIMEOUT = 20
INTERACTION_DELAY = 0.5

# Browser settings
WINDOW_SIZE = "1920,1080"

# Attendance thresholds (percentages)
GOOD_ATTENDANCE_THRESHOLD = 75
WARNING_ATTENDANCE_THRESHOLD = 65

# XPath selectors for web elements
PLUS_ICON_XPATH = "//i[contains(@class, 'bx-plus-circle')]"
CONDUCTED_TEXT_XPATH = "//span[contains(@id, 'lblClsCondID')]"
TOTAL_TEXT_XPATH = "//span[contains(@id, 'lblClsAttID')]"
