![Image](https://github.com/AyaHamedd/OctopusDB/blob/main/octopusdb.jpeg)

# What is OctopusDB ?

OctopusDB ia a simple database engine written from scratch in bash shell commands. It is self contained,serverless,transactional database engine. Supports basic CRUD ( Create , Update , Delete ) commands.

# Installation
Clone the repository in your home directory.

cd
git clone https://
chmod +x 557 $HOME/octopus
sudo cp $HOME/octopus/octopus /usr/bin

To start using the database type
octopus

# Database Architecture
The main directory that holds all databases is called octopusdb, located in your home directory. Each database has a directory under  octopusdb with its name. Then each database has two directories;
- data : Contains tables data files , where records of each table is stored.
- metadata : Contains tables metadata , where columns, datatypes and constrains are stored.


# Software Architecture
The main script that receives inputs from user is octopus. Each command has its own script. Octopus starts calling the corresponding script based on user’s requirements.



## Platforms
Linux x86_64


