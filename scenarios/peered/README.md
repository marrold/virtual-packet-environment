# Peered

This scenario runs 7 Packet Stations on a single shared frequency. The channel will be quite busy owing to the number of stations and you'll probably find you get a lot of collisions and waiting for a free channel. To reduce the number of stations, comment out the BPQ and Dire Wolf services for the node in `docker-compose.yaml` and restart the containers.

## Topology

7 nodes are configured with dedicated links between each of them. In this instance they're audio links but you could imaging each node has a VHF and UHF connecting to the node either side of it.

    Q7EIV <-> Q1UBS <-> Q3GOS <-> Q3ZXG <-> Q7LWP <-> Q7LJK <-> Q6XED 

## Ports

Ports are forward to each node so you should be able to access the admin interface and connect to the node from a Telnet or FBB client. Ports for each node are as follows:

| Node | Web Port | FBB Port | Telnet Port |
|--|--|--|--|
| Q7EIV | 8180 | 8111 | 8110 | 
| Q1UBS | 8280 | 8211 | 8210 | 
| Q3GOS | 8380 | 8311 | 8310 | 
| Q3ZXG | 8480 | 8411 | 8410 | 
| Q7LWP | 8580 | 8511 | 8510 | 
| Q7LJK | 8680 | 8611 | 8610 | 
| Q6XED | 8780 | 8711 | 8710 |
