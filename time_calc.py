# SAR ADC Timing calculations

import numpy as np 

class time_calc:
	def __init__(self, fs):
		self.T = 1/fs
		self.f_clk = 12*fs
		self.T_clk = 1/self.f_clk
		self.T_sample_high = 1.5*self.T_clk
		self.T_sample_low = 10.5*self.T_clk