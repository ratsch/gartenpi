#!/usr/bin/python
# -*- coding:utf-8 -*-


import time
import ADS1256
import RPi.GPIO as GPIO


try:
    ADC = ADS1256.ADS1256()
    Ipre_n=0
    Ipre_S=0.0
    I2pre_n=0
    I2pre_S=0.0
    Vpre_n=0
    Vpre_S=0.0
    if (ADC.ADS1256_init() == -1):
        exit()
    for i in xrange(1,10):
    
        # t=time.time()
        ADC_Value = ADC.ADS1256_GetAll()
        # print "  rint " + str((time.time()-t)*1000)+" mS in reading only channel 0\n                          "

        Ipre_avg=2.5 #2213 
        Ipre=(ADC_Value[1]*5.0/0x7fffff)-Ipre_avg
        Ipre_S=Ipre+Ipre_S
        Ipre_n=Ipre_n+1 
        Iest=Ipre_S/Ipre_n*30/2.5

        I2pre_avg=2.5 #2213 
        I2pre=(ADC_Value[0]*5.0/0x7fffff)-I2pre_avg
        I2pre_S=I2pre+I2pre_S
        I2pre_n=I2pre_n+1 
        I2est=I2pre_S/I2pre_n*30/2.5

        Vpre_avg=-0.2
        Vpre=(ADC_Value[2]*5.0/0x7fffff)-Vpre_avg
        Vpre_S=Vpre+Vpre_S
        Vpre_n=Vpre_n+1 
        Vest=Vpre_S/Vpre_n*25/5
        
#        print ("0 ADC = %.5f"%(ADC_Value[0]*5.0/0x7fffff))
        #print ("3 ADC = %.5f"%(ADC_Value[3]*5.0/0x7fffff))
        #print ("4 ADC = %.5f"%(ADC_Value[4]*5.0/0x7fffff))
        #print ("5 ADC = %.5f"%(ADC_Value[5]*5.0/0x7fffff))
        #print ("6 ADC = %.5f"%(ADC_Value[6]*5.0/0x7fffff))
        #print ("7 ADC = %.5f"%(ADC_Value[7]*5.0/0x7fffff)) 
        
        # print "0 ADC = ",(ADC_Value[0])
        # print "1 ADC = ",(ADC_Value[1])
        # print "2 ADC = ",(ADC_Value[2])
        # print "3 ADC = ",(ADC_Value[3])
        # print "4 ADC = ",(ADC_Value[4])
        # print "5 ADC = ",(ADC_Value[5])
        # print "6 ADC = ",(ADC_Value[6])
        # print "7 ADC = ",(ADC_Value[7])

#        print ("\33[4A")

    print ("0-ADC\t%.5f\t%0.5f\t%0.5f"%(ADC_Value[0]*5.0/0x7fffff, I2pre_S/I2pre_n, I2est))
    print ("1-ADC\t%.5f\t%0.5f\t%0.5f"%(ADC_Value[1]*5.0/0x7fffff, Ipre_S/Ipre_n, Iest))
    print ("2-ADC\t%.5f\t%0.5f\t%0.5f"%(ADC_Value[2]*5.0/0x7fffff, Vpre_S/Vpre_n, Vest))
        
except :
    GPIO.cleanup()
    print "\r\nProgram end     "
    exit()
