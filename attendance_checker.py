#!/usr/bin/env python3
"""
Jain University Attendance Checker
==================================

This script automates the process of checking attendance on the Jain University student portal.
It opens Chrome browser, waits for manual login, then extracts attendance data for all subjects.

Author: Automated Attendance Checker
Date: August 2025
"""

import time
import os
import shutil
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from webdriver_manager.chrome import ChromeDriverManager
from selenium.common.exceptions import TimeoutException, NoSuchElementException
import config


class JainAttendanceChecker:
    """
    A class to handle Jain University attendance checking automation.
    """
    
    def __init__(self):
        self.driver = None
        self.wait = None
        self.conducted_list = []
        self.attended_list = []
    
    def setup_browser(self):
        """
        Initialize Chrome browser with appropriate settings.
        Sets up non-headless mode for manual login interaction.
        """
        print("Setting up Chrome browser...")
        
        # Configure Chrome options
        chrome_options = Options()
        chrome_options.add_argument("--no-sandbox")
        chrome_options.add_argument("--disable-dev-shm-usage")
        chrome_options.add_argument("--disable-web-security")
        chrome_options.add_argument("--disable-features=VizDisplayCompositor")
        chrome_options.add_argument(f"--window-size={config.WINDOW_SIZE}")
        
        try:
            # Use ChromeDriverManager to automatically handle driver installation
            print("Setting up ChromeDriver...")
            
            # Clear webdriver-manager cache to force fresh installation
            cache_dir = os.path.expanduser("~/.wdm")
            if os.path.exists(cache_dir):
                print("Clearing ChromeDriver cache for fresh installation...")
                shutil.rmtree(cache_dir)
            
            # Install compatible ChromeDriver
            driver_path = ChromeDriverManager().install()
            
            # Fix webdriver-manager bug: sometimes it points to wrong file
            if 'THIRD_PARTY_NOTICES' in driver_path or not os.access(driver_path, os.X_OK):
                print("Fixing ChromeDriver path...")
                driver_dir = os.path.dirname(driver_path)
                
                # Look for the actual chromedriver executable
                possible_names = ['chromedriver', 'chromedriver.exe']
                for root, dirs, files in os.walk(driver_dir):
                    for file in files:
                        if file in possible_names:
                            candidate_path = os.path.join(root, file)
                            if os.access(candidate_path, os.X_OK):
                                driver_path = candidate_path
                                print(f"Found working ChromeDriver at: {driver_path}")
                                break
                    if os.access(driver_path, os.X_OK) and 'THIRD_PARTY_NOTICES' not in driver_path:
                        break
                
                # Make sure it's executable
                os.chmod(driver_path, 0o755)
            
            service = Service(driver_path)
            self.driver = webdriver.Chrome(service=service, options=chrome_options)
            
        except Exception as e:
            print(f"ChromeDriverManager failed: {e}")
            print("\nTROUBLESHOOTING STEPS:")
            print("1. Update Chrome browser to the latest version")
            print("2. Try installing ChromeDriver via Homebrew:")
            print("   brew install --cask chromedriver")
            print("3. Or download manually from: https://chromedriver.chromium.org/downloads")
            
            # Try one more approach - use selenium-manager
            try:
                print("Trying selenium-manager as final fallback...")
                # Remove the service parameter to let selenium handle driver management
                self.driver = webdriver.Chrome(options=chrome_options)
            except Exception as e3:
                print(f"Final fallback also failed: {e3}")
                raise
        
        # Configure WebDriverWait with timeout from config
        self.wait = WebDriverWait(self.driver, config.WAIT_TIMEOUT)
        
        print("✓ Browser setup complete")
    
    def navigate_to_login(self):
        """
        Navigate to the Jain University student login page.
        """
        print("Navigating to Jain University login page...")
        
        self.driver.get(config.LOGIN_URL)
        
        print(f"✓ Navigated to: {config.LOGIN_URL}")
        print("\nPlease complete the following steps manually:")
        print("1. Enter your College ID")
        print("2. Enter your Date of Birth")
        print("3. Solve the CAPTCHA")
        print("4. Click the Login button")
    
    def wait_for_manual_login(self):
        """
        Wait for user to complete manual login process.
        Monitors for successful login by checking URL change.
        """
        print("\nWaiting for manual login completion...")
        
        # Wait for URL to change indicating successful login
        try:
            self.wait.until(lambda driver: "login" not in driver.current_url.lower())
            print("✓ Login detected successfully!")
        except TimeoutException:
            print("⚠ Login timeout - continuing anyway...")
        
        # Additional pause for user confirmation
        input("\nPress Enter once you have successfully logged in and are ready to continue...")
    
    def navigate_to_attendance_page(self):
        """
        Navigate to the Class Attendance page after login.
        """
        print("\nNavigating to Class Attendance page...")
        
        self.driver.get(config.ATTENDANCE_URL)
        
        # Wait for page to load
        try:
            self.wait.until(EC.presence_of_element_located((By.TAG_NAME, "body")))
            print("✓ Attendance page loaded successfully")
        except TimeoutException:
            print("⚠ Page load timeout - continuing anyway...")
    
    def extract_attendance_data(self):
        """
        Extract attendance data for all subjects by clicking expand icons.
        Finds plus icons, clicks them, and extracts conducted/attended numbers.
        """
        print("\nExtracting attendance data...")
        print(f"Looking for plus icons with XPath: {config.PLUS_ICON_XPATH}")
        
        # Reset lists for fresh data
        self.conducted_list = []
        self.attended_list = []
        
        try:
            # Wait for page to fully load first
            self.wait.until(EC.presence_of_element_located((By.TAG_NAME, "body")))
            time.sleep(2)  # Give extra time for dynamic content
            
            # Debug: Check what's on the page
            print("Current page URL:", self.driver.current_url)
            print("Page title:", self.driver.title)
            
            # Try to find plus icons with multiple strategies
            plus_icons = []
            
            # Strategy 1: Original selector
            try:
                plus_icons = self.driver.find_elements(By.XPATH, config.PLUS_ICON_XPATH)
                print(f"Strategy 1: Found {len(plus_icons)} plus icons")
            except Exception as e:
                print(f"Strategy 1 failed: {e}")
            
            # Strategy 2: Alternative selectors if first one fails
            if not plus_icons:
                alternative_selectors = [
                    "//i[contains(@class, 'plus')]",
                    "//i[contains(@class, 'bx-plus')]", 
                    "//i[contains(@class, 'fa-plus')]",
                    "//button[contains(@class, 'expand')]",
                    "//*[contains(@class, 'expand')]",
                    "//a[contains(@href, 'expand') or contains(text(), '+')]"
                ]
                
                for i, selector in enumerate(alternative_selectors, 2):
                    try:
                        plus_icons = self.driver.find_elements(By.XPATH, selector)
                        if plus_icons:
                            print(f"Strategy {i}: Found {len(plus_icons)} elements with selector: {selector}")
                            break
                    except Exception as e:
                        print(f"Strategy {i} failed: {e}")
            
            # If still no icons found, let's see what's available
            if not plus_icons:
                print("No plus icons found. Let's debug the page structure...")
                
                # Look for any clickable elements that might be expand buttons
                clickable_elements = self.driver.find_elements(By.XPATH, "//button | //a | //i | //*[@onclick]")
                print(f"Found {len(clickable_elements)} potentially clickable elements")
                
                # Print some of their classes and text for debugging
                for i, elem in enumerate(clickable_elements[:10]):  # Show first 10
                    try:
                        classes = elem.get_attribute("class") or "no-class"
                        text = elem.text[:50] or "no-text"
                        print(f"  Element {i+1}: class='{classes}', text='{text}'")
                    except:
                        pass
                
                print("Please check the page structure and update the PLUS_ICON_XPATH in config.py")
                return
            
            print(f"Found {len(plus_icons)} subjects to process")
            
            # Process each subject
            for index, icon in enumerate(plus_icons, 1):
                try:
                    print(f"\nProcessing subject {index}...")
                    
                    # Scroll to element to ensure it's visible
                    self.driver.execute_script("arguments[0].scrollIntoView(true);", icon)
                    time.sleep(config.INTERACTION_DELAY)
                    
                    # Click the plus icon to expand attendance details
                    self.driver.execute_script("arguments[0].click();", icon)  # Use JS click for better reliability
                    print(f"  ✓ Expanded subject {index}")
                    
                    # Short pause to allow content to load
                    time.sleep(config.INTERACTION_DELAY)
                    
                    # Extract conducted count
                    conducted = self.extract_conducted_count(index)
                    
                    # Extract attended count
                    attended = self.extract_attended_count(index)
                    
                    # Store the data
                    if conducted is not None and attended is not None:
                        self.conducted_list.append(conducted)
                        self.attended_list.append(attended)
                        print(f"  ✓ Subject {index}: Conducted={conducted}, Attended={attended}")
                    else:
                        print(f"  ⚠ Subject {index}: Could not extract data")
                
                except Exception as e:
                    print(f"  ✗ Error processing subject {index}: {str(e)}")
                    continue
        
        except TimeoutException:
            print("✗ Page did not load properly")
        except Exception as e:
            print(f"✗ Error during attendance extraction: {str(e)}")
    
    def extract_conducted_count(self, subject_index):
        """
        Extract the 'Conducted' count for a subject.
        
        Args:
            subject_index (int): The index of the current subject
        
        Returns:
            int: The conducted count, or None if not found
        """
        print(f"    Looking for 'Conducted' count...")
        
        # Multiple strategies to find conducted count based on HTML structure
        strategies = [
            # Strategy 1: Look for span with specific ID pattern (most reliable)
            lambda: self.driver.find_elements(By.XPATH, "//span[contains(@id, 'lblClsCondID')]"),
            
            # Strategy 2: Look for text "Conducted" and get the next span
            lambda: self.driver.find_elements(By.XPATH, "//div[contains(text(), 'Conducted')]/strong/span"),
            
            # Strategy 3: Look for any span after "Conducted" text
            lambda: self.driver.find_elements(By.XPATH, "//*[contains(text(), 'Conducted')]/following::span[1]"),
            
            # Strategy 4: Using config XPath as fallback
            lambda: [self.driver.find_element(By.XPATH, config.CONDUCTED_TEXT_XPATH)],
        ]
        
        for i, strategy in enumerate(strategies, 1):
            try:
                elements = strategy()
                print(f"    Strategy {i} found {len(elements)} conducted elements")
                
                for element in elements:
                    try:
                        conducted_text = element.text.strip()
                        print(f"    Checking conducted text: '{conducted_text}'")
                        
                        # The conducted count should be a simple number
                        if conducted_text.isdigit():
                            result = int(conducted_text)
                            print(f"    ✓ Extracted conducted count: {result}")
                            return result
                        
                        # Try to extract number from text that might have extra content
                        import re
                        numbers = re.findall(r'\d+', conducted_text)
                        if numbers:
                            result = int(numbers[0])  # Take the first number found
                            print(f"    ✓ Extracted conducted count from text: {result}")
                            return result
                            
                    except (ValueError, AttributeError) as e:
                        print(f"    Failed to parse conducted text: {e}")
                        continue
                        
            except Exception as e:
                print(f"    Strategy {i} failed: {e}")
                continue
        
        print(f"    ⚠ Could not find conducted count for subject {subject_index}")
        return None
    
    def extract_attended_count(self, subject_index):
        """
        Extract the 'Attended' count for a subject.
        
        Args:
            subject_index (int): The index of the current subject
        
        Returns:
            int: The attended count, or None if not found
        """
        print(f"    Looking for 'Attended' count...")
        
        # Multiple strategies to find attended count based on HTML structure
        strategies = [
            # Strategy 1: Look for span with specific ID pattern (most reliable)
            lambda: self.driver.find_elements(By.XPATH, "//span[contains(@id, 'lblClsAttID')]"),
            
            # Strategy 2: Look for text "Attended" and get the next span
            lambda: self.driver.find_elements(By.XPATH, "//div[contains(text(), 'Attended')]/strong/span"),
            
            # Strategy 3: Look for any span after "Attended" text
            lambda: self.driver.find_elements(By.XPATH, "//*[contains(text(), 'Attended')]/following::span[1]"),
            
            # Strategy 4: Using config XPath as fallback
            lambda: self.driver.find_elements(By.XPATH, config.TOTAL_TEXT_XPATH),
        ]
        
        for i, strategy in enumerate(strategies, 1):
            try:
                elements = strategy()
                print(f"    Strategy {i} found {len(elements)} attended elements")
                
                for element in elements:
                    try:
                        attended_text = element.text.strip()
                        print(f"    Checking attended text: '{attended_text}'")
                        
                        # Parse the attendance format: "P-12/E-1/L-0/MCR-0/R-0/Total-13"
                        if "Total-" in attended_text:
                            # Extract the number after "Total-"
                            total_part = attended_text.split("Total-")[1]
                            # Get just the number (in case there's more text after)
                            import re
                            numbers = re.findall(r'\d+', total_part)
                            if numbers:
                                result = int(numbers[0])
                                print(f"    ✓ Extracted attended count from Total: {result}")
                                return result
                        
                        # Alternative parsing: look for "Total=" format
                        elif "Total=" in attended_text:
                            total_part = attended_text.split("Total=")[1]
                            import re
                            numbers = re.findall(r'\d+', total_part)
                            if numbers:
                                result = int(numbers[0])
                                print(f"    ✓ Extracted attended count from Total=: {result}")
                                return result
                        
                        # If it's just a number
                        elif attended_text.isdigit():
                            result = int(attended_text)
                            print(f"    ✓ Extracted attended count as number: {result}")
                            return result
                        
                        # Try to find any number in the text as fallback
                        else:
                            import re
                            numbers = re.findall(r'\d+', attended_text)
                            if numbers:
                                # If we have multiple numbers, try to find the total
                                # Look for the last number which is often the total
                                result = int(numbers[-1])
                                print(f"    ✓ Extracted attended count as last number: {result}")
                                return result
                            
                    except (ValueError, AttributeError) as e:
                        print(f"    Failed to parse attended text: {e}")
                        continue
                        
            except Exception as e:
                print(f"    Strategy {i} failed: {e}")
                continue
        
        print(f"    ⚠ Could not find attended count for subject {subject_index}")
        return None
    
    def calculate_and_display_results(self):
        """
        Calculate total attendance statistics and display results.
        """
        print("\n" + "="*50)
        print("ATTENDANCE CALCULATION RESULTS")
        print("="*50)
        
        if not self.conducted_list or not self.attended_list:
            print("✗ No attendance data was extracted successfully")
            return
        
        # Calculate totals
        total_conducted = sum(self.conducted_list)
        total_attended = sum(self.attended_list)
        
        # Calculate percentage
        if total_conducted > 0:
            attendance_percentage = (total_attended / total_conducted) * 100
        else:
            attendance_percentage = 0
        
        # Display detailed breakdown
        print(f"\nSubject-wise Breakdown:")
        for i, (conducted, attended) in enumerate(zip(self.conducted_list, self.attended_list), 1):
            subject_percentage = (attended / conducted) * 100 if conducted > 0 else 0
            print(f"  Subject {i}: {attended}/{conducted} ({subject_percentage:.2f}%)")
        
        # Display final results
        print(f"\nFINAL RESULTS:")
        print(f"Overall Attendance: {attendance_percentage:.2f}%")
        print(f"Total Conducted: {total_conducted}")
        print(f"Total Attended: {total_attended}")
        
        # Attendance status using config thresholds
        if attendance_percentage >= config.GOOD_ATTENDANCE_THRESHOLD:
            print(f"✓ Attendance Status: GOOD (≥{config.GOOD_ATTENDANCE_THRESHOLD}%)")
        elif attendance_percentage >= config.WARNING_ATTENDANCE_THRESHOLD:
            print(f"⚠ Attendance Status: WARNING ({config.WARNING_ATTENDANCE_THRESHOLD}-{config.GOOD_ATTENDANCE_THRESHOLD-1}%)")
        else:
            print(f"✗ Attendance Status: CRITICAL (<{config.WARNING_ATTENDANCE_THRESHOLD}%)")
    
    def cleanup(self):
        """
        Clean up resources and close the browser.
        """
        print("\nCleaning up...")
        if self.driver:
            self.driver.quit()
        print("✓ Browser closed successfully")
    
    def run(self):
        """
        Main execution method that orchestrates the entire attendance checking process.
        """
        try:
            print("Starting Jain University Attendance Checker")
            print("=" * 45)
            
            # Step 1: Setup browser
            self.setup_browser()
            
            # Step 2: Navigate to login page
            self.navigate_to_login()
            
            # Step 3: Wait for manual login
            self.wait_for_manual_login()
            
            # Step 4: Navigate to attendance page
            self.navigate_to_attendance_page()
            
            # Step 5: Extract attendance data
            self.extract_attendance_data()
            
            # Step 6: Calculate and display results
            self.calculate_and_display_results()
            
        except KeyboardInterrupt:
            print("\n\nProcess interrupted by user")
        except Exception as e:
            print(f"\n✗ An error occurred: {str(e)}")
        finally:
            # Always cleanup
            self.cleanup()


def main():
    """
    Entry point of the application.
    Creates an instance of JainAttendanceChecker and runs it.
    """
    print("Jain University Attendance Checker")
    print("==================================")
    print("This tool will help you check your attendance automatically.")
    print("Make sure you have your login credentials ready.\n")
    
    # Create and run the attendance checker
    checker = JainAttendanceChecker()
    checker.run()


if __name__ == "__main__":
    main()
