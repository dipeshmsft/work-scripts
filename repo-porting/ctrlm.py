import pyautogui as pg
import time

def run_ctrlm():
    pg.moveTo(1000,500)
    pg.click(1000,500)
    for i in range(380):
        pg.keyDown('ctrl')
        pg.press('m')
        pg.keyUp('ctrl')
        # time.sleep(0.5)
    
run_ctrlm()