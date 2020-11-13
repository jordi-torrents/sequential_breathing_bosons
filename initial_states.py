import numpy as np
import os
if not os.path.exists('initial_states'):
    os.makedirs('initial_states')

N=10000

dx=0.99998/np.sqrt(4*N/np.pi)
array=np.arange(-0.5,0.5,dx)
r = np.zeros((N,2))
n=0
for i in range(len(array)):
    for j in range(len(array)):
        pos=np.array([array[i], array[j]])
        if np.sqrt(pos[0]**2+pos[1]**2)<0.5 :
            r[n]=pos
            n+=1
r=r[:n]
r-=np.mean(r, axis=0)
np.savetxt('initial_states/Square_Disc_10k.dat',r)
print('Done! Square_Disc_10k.dat')
print(len(r))


dx = 1.074465/np.sqrt(4*N/np.pi)
dy = dx*np.sqrt(3)/2
arrayx=np.arange(-0.5,0.5,dx)
arrayy=np.arange(-0.5,0.5,dy)
r = np.zeros((2*N,2))
n=0
for i in range(len(arrayx)):
    for j in range(len(arrayy)):
        if j%2 == 0:
            pos=np.array([arrayx[i],arrayy[j]])+(0.25*dx,0.0)
        else:
            pos=np.array([arrayx[i],arrayy[j]])-(0.25*dx,0.0)
        if np.sqrt(pos[0]**2+pos[1]**2)<0.5 :
            r[n]=pos
            n+=1
r=r[:n]
r-=np.mean(r, axis=0)
np.savetxt('initial_states/Hexagonal_Disc_10k.dat',r)
print('Done! Hexagonal_Disc_10k.dat')
print(len(r))


n=int(np.sqrt(N))
array=np.linspace(0,1,n)
r = np.empty((n**2,2))
for i in range(n):
    for j in range(n):
        r[n*i+j]=(array[i], array[j])
r-=np.mean(r, axis=0)
np.savetxt('initial_states/Square_Square_10k.dat',r)
print('Done! Square_Square_10k.dat')
print(len(r))

n_gran=np.sqrt(N/np.sqrt(0.75))
n=int(round(n_gran*np.sqrt(0.75)))
n_gran=int(round(n_gran))
arrayx=np.linspace(0,1,n)
arrayy=np.linspace(0,1,n_gran)
r = np.empty((n*n_gran,2))
for i in range(len(arrayx)):
    for j in range(len(arrayy)):
        r[n*j+i]=(arrayx[i], arrayy[j])
        if j%2 == 0:
            r[n*j+i] += (+0.25/(n-1), 0.0)
        else:
            r[n*j+i] += (-0.25/(n-1), 0.0)
r-=np.mean(r, axis=0)
np.savetxt('initial_states/Hexagonal_Square_10k.dat',r)
print('Done! Hexagonal_Square_10k.dat')
print(len(r))


n=141
arrayy=np.linspace(-np.sqrt(3)/6,np.sqrt(3)*4/12,n)
arrayx=np.linspace(-0.5,0.5,n)
r = np.zeros((N+300,2))
k=0
for j in range(len(arrayy)):
    for i in range(len(arrayx)-j):
        r[k]=(arrayx[i]+j*0.5/(n-1), arrayy[j])
        k+=1
r = r[:k]-np.mean(r[:k], axis=0)
np.savetxt('initial_states/Hexagonal_Triangle_10k.dat',r)
print('Done! Hexagonal_Triangle_10k.dat')
print(len(r))


arrayx=np.linspace(0,1,int(1.52*np.sqrt(N)))
r = np.zeros((N,2), order='F')
h=np.sqrt(0.75)
k=0
for j in arrayx:
    for i in arrayx:
        pos=np.array([i-0.5,j])
        if abs(pos[0])<(0.5-pos[1]*0.5/np.sqrt(0.75)):
            r[k]=pos
            k+=1
r = r[:k]-np.mean(r[:k], axis=0)
np.savetxt('initial_states/Square_Triangle_10k.dat',r)
print('Done! Square_Triangle_10k.dat')
print(len(r))


r = np.empty((N,2))
r[0]=np.random.random(2)
n=1
while n<N:
    pos=np.random.random(2)
    if np.min(np.sum((r[:n,:]-pos)**2, axis=1))>0.00006:
        r[n]=pos
        n+=1
        if n%100==0: print('{:.1f}%'.format(100*n/N), end="\r")
r-=np.mean(r, axis=0)
np.savetxt('initial_states/Random_Square_10k.dat',r)
print('Done! Random_Square_10k.dat')


r = np.empty((N,2))
r[0]=(0.0,0.0)
n=1
while n<N:
    pos=np.random.random(2)-0.5
    if np.sqrt(pos[0]**2+pos[1]**2)<0.5 :
        if np.min(np.sum((r[:n,:]-pos)**2, axis=1))>0.00005:
            r[n]=pos
            n+=1
            if n%100==0: print('{:.1f}%'.format(100*n/N), end="\r")
r-=np.mean(r, axis=0)
np.savetxt('initial_states/Random_Disc_10k.dat',r)
print('Done! Random_Disc_10k.dat')
print(len(r))


r = np.empty((N,2))
r[0]=(0.0,0.0)
n=1
while n<N:
    pos=np.random.random(2)-(0.5,0)
    if abs(pos[0])<(0.5-pos[1]*0.5/np.sqrt(0.75)):
        if np.min(np.sum((r[:n,:]-pos)**2, axis=1))>0.000025:
            r[n]=pos
            n+=1
            if n%100==0: print('{:.1f}%'.format(100*n/N), end="\r")
r-=np.mean(r, axis=0)
np.savetxt('initial_states/Random_Triangle_10k.dat',r)
print('Done! Random_Triangle_10k.dat')
print(len(r))
