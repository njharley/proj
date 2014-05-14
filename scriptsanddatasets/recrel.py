import numpy as np
import math

primeor = np.loadtxt("protoprimeOrdered.txt", delimiter=',')
#allpncvs = np.loadtxt("allpncvs.txt", delimiter=',')

print primeor
top = np.array([1,7,26,69,135,215,281,324,343,349,350,351])

class relnxy:

	def getPNCV(self,x,n):
		#pncv = allpncvs[x,top[n-1]:top[n]-1]
		pncv = np.array([0,33,33,33,0,0,0])
		return pncv

	def getDV(self,pnCVx,pnCVy):
		dvxy = np.subtract(pnCVx,pnCVy)
		dvyx = np.subtract(pnCVy,pnCVx)
		for i in range(len(dvxy)):
			if dvxy[i] < 0:
				dvxy[i] = 0
			if dvyx[i] < 0:
				dvyx[i] = 0
		dv = np.array([dvxy,dvyx])

		print dv
		return dv

	def getWDV(self,dv):
		wDV = np.array([dv[0,:],dv[1,:]])
		wDV[0,:] = np.divide(wDV[0,:],float(sum(dv[0,:])))*100
		wDV[1,:] = np.divide(wDV[1,:],float(sum(dv[1,:])))*100
		print wDV
		return wDV


	def __init__(self,x,y,n,weight):
		self.x = x
		self.y = y
		self.n = n
		self.weight = weight
		self.pnCVx = np.array([10,24,19,14,29,5])#self.getPNCV(self.x, self.n)
		self.pnCVy = np.array([0,33,17,17,33,0])#self.getPNCV(self.y, self.n)
		self.dv = self.getDV(self.pnCVx, self.pnCVy)
		self.wDV = self.getWDV(self.dv)
		self.value = sum(self.dv[0,:]+self.dv[1,:])*(weight/100)

x = np.array([0,1,2,3,4])
y = np.array([0,2,4,6,8])

cla = relnxy(x,y,2,1)



