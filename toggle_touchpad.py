#!/usr/bin/python
'''
Toggle touchpad function.
If enabled, disable. 
If disabled, enablde.
Depends on synclient binary.
'''
import sys, subprocess

def debug(msg):
    if '-v' in sys.argv:
        print '%s: %s' % (sys.argv[0], msg)
    return None

def getStatus():
    '''
    Returns True if enabled, False if disabled
    '''
    cmd = ['synclient', '-l']
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE,
                              stderr=subprocess.PIPE)
    output = p.communicate()
    if 'TouchpadOff             = 0' in output[0]:
        debug('Touchpad seems to be enabled')
        return True

    elif 'TouchpadOff             = 1' in output[0]:
        debug('Touchpad seems to be disabled')
        return False

    else:
        raise RuntimeError('Unable to detect state!')
        return None

def disableTouchpad():
    '''
    Disables the touchpad.
    '''
    cmd = ['synclient', 'TouchpadOff=1']
    p = subprocess.Popen(cmd)
    p.wait()
    if p.returncode == 0:
        debug('Seems I disabled the touchpad')
        return True
    else:
        debug('Seems I did not disable the touchpad')
        return False

def enableTouchpad():
    '''
    Enables the touchpad.
    '''
    cmd = ['synclient', 'TouchpadOff=0']
    p = subprocess.Popen(cmd)
    p.wait()
    if p.returncode == 0:
        debug('Seems I enabled the touchpad')
        return True
    else:
        debug('Seems I did not enable the touchpad')
        return False

if __name__ == '__main__':
    status = getStatus()
    if status == True: 
        if disableTouchpad() == True:
            debug('Done')
        else:
            debug('PENIS!!')
    elif status == False:
        if enableTouchpad() == True:
            debug('Done')
        else:
            debug('PENIS!!!') 
    # This shouldn't happen
    else: 
        raise RuntimeError('Unable to do my job. Sorry')
