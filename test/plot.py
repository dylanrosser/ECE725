import pandas as pd
import matplotlib.pyplot as plt
path = "A/01_15_2020/"
filename = "logic_data.csv"
data = pd.read_csv(path+filename)

# specific data point:
# data.iloc[0]

# range
# data[0:100]

plt.figure()
plt.plot(data['Time (s)'], data['Bus'])
#plt.plot(data['Time (s)'][1000:10000], data['DIN 9'][1000:10000]*1024)
plt.title("Output Code for a 1kHz Triangle Wave")
plt.xlabel("time (s)")
plt.ylabel("Code")
plt.savefig(path+"figure.png")
plt.show()







