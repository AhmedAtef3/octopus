![Image](https://github.com/AyaHamedd/OctopusDB/blob/main/images/octopusdb.jpeg)

# What is OctopusDB ?

OctopusDB ia a simple database engine written from scratch in bash shell commands. It supports basic CRUD ( Create , Read , Update , Delete ) commands.

# Installation
Clone the repository in your home directory.

`$cd`

`$git clone https://github.com/AyaHamedd/octopus.git`

`$chmod +x 755 $HOME/octopus/*.sh`

`sudo cp $HOME/octopus/octopus /usr/bin`


To start using the database:

`$bash octopus.sh`

# Features
- Supports Int and text datatypes

    INT : -2147483648 to 2147483647
.
    TEXT : Any kind of text data.

- Supports primary key constrain.
- Validates databases and tables names as they can't contain any characters or spaces and can't contain only numbers. 
- Reading, Deleting and Updating records by applying multiple conditions.

# Database Architecture
The main directory that holds all databases is called octopusdb, located in your home directory. Each database has a directory under  octopusdb with its name. Then each database has two directories;
- data : Contains tables data files , where records of each table is stored.
- metadata : Contains tables metadata , where columns, datatypes and constrains are stored.

![Image1](https://github.com/AyaHamedd/OctopusDB/blob/main/images/dbArchitectue.png)

# Software Architecture
The main script that receives inputs from user is octopus. Each command has its own script. Octopus starts calling the corresponding script based on user’s requirements.

![Image2](https://github.com/AyaHamedd/OctopusDB/blob/main/images/swArchitecture.png)

# API Documentation

Refer to the following file : 
[API_Documentation.pdf](https://github.com/AyaHamedd/octopus/blob/main/OctopuDB%20-%20API%20Documentation.pdf).

# Tutorial

You can find a tutorial on using the engine in the following file : 
[Tutorial.pdf](https://github.com/AyaHamedd/octopus/blob/main/OctopusDBTutorial.pdf).

## Platforms
Linux x86_64


