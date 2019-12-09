import numpy as np

#np.set_printoptions(formatter={'float16':lambda x:float16(x).hex()})
#inp = np.random.uniform(-100, 100, size=(4,4)).astype('float16')
#print(inp)

#H = hex(inp[0,0])
#print(H)
#define numpy array
#np_arr = np.array([1.2,3.4,2.6,2.1,15,10], dtype = np.float16)
#
##convert numpy array to hex
#np_arr_hex = np.array([float.hex(float(x)) for x in np_arr])
#
##back to float with upto 4 decimal places
#np_arr_float = np.array([round(float.fromhex(x),1) for x in np_arr_hex])
#
##print both arrays
#print(np_arr_hex,np_arr_float)

arr1 = np.array([[8.2, 0.3, -7.3, 3.04], [3.3, 1.56, -5.2, 1.11], [-5.1, 9.2, -1.1, 2.12], [9.0, 3.34, 0.21, -0.31]], dtype=np.float16)
print(arr1)
arr1_hex = np.array([float.bin(float(y)) for x in arr1 for y in x])
print(arr1_hex)
arr2 = np.array([[1.2, -3.0, 4.1, -0.5], [-3.4, -4.12, 11.2, -0.25], [1.01, -5.02, 19.3, 0.625], [4.7, 2.3, 20.4, 1.23]], dtype=np.float16)
print(arr2)
res = np.dot(arr1, arr2)
print(res)
