# H3C_inode
a h3c inode client for openwrt or other arm device by using docker 

Because **h3c inode client arm version only support a bit kind of devices** So，
🙂if you use arm device build with musl as default gcc, it is a good choice to use docker.

# How to use
1. download the Dockerfile and run.sh
2. copy *inode client linux arm version* to the directory, and rename it to *iNodeClient.tar.gz*
   ```bash
   ls -l
  ```
> -rwxrwxrwx 1 holden holden      598 May  5 14:34  Dockerfile
> -r-xr-xr-x 1 holden holden 24913699 Mar  3 14:23  iNodeClient.tar.gz
> -rwxrwxrwx 1 holden holden     1349 May 15 09:31  run.sh 
4. use docker build it
   ```bash
   docker build -t <build_name>:<build_tag> .
   ```
5. run docker (use --network host if you use portal)
   ```bash
   docker run -d --name inode --network host <build_name>:<build_tag> /bin/bash /iNode/run.sh
   ```
6. use your vnc client to connect the docker and set up your inode profile
