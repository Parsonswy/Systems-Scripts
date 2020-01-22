import requests, json, netmiko, paramiko, 
from pydactyl import PterodactylClient


def crawl(option, listnumber):
	client = PterodactylClient('http://gamehosting.ncsa.tech', 'OfkA2s1eNBLLdu71vUirneAROXuyLoojLQN8KVslDSCI1wJb')
	if option = "servers":
		data = client.client.list_servers()
		for x in data:
			servers.append(data[0]['name'])
		print servers
		return servers

	elif option = "all":
		data = client.client.list_servers()
		return data


def ssh(host, gameport, user, password):
	client = paramiko.SSHClient()
	client.connect(host, username=user, password=password)
	command = "sudo ufw allow" + gameport + "/tcp"
	client.exec_command(command)
	client.close()
	return

def main():
	#Import File
	rawList = open("host.txt", "rw")
	localList = rawlist.readlines()
	
	#Grab Server API Details
	serverData = crawl(option=servers)
	webList = serverData.values(object)

	#Sort Lists
	localList.sort() 
	webList.sort()

	for x in localList:
		if localList[x] = webList[x]:
			continue
		else: 
			newHost = webList[x]
			localList.append(newHost)
			localList.sort()
			newHostlist.append(newHost)

	for x in newHostlist:
		serverData = crawl(option="all")
		pos = serverData.find(newHostlist[x])
		print (pos)
		print (serverData)












	









	