//jTCPClient7


import java.net.*; 
import java.io.*; 
public class jTCPClient7 
{ 
public static void main(String[] args) throws Exception 
{ 
Socket sock=new Socket("127.0.01",4000); //loopback address, Port number 0-65535(beyond 1023)

System.out.println("Enter the filename"); 

BufferedReader keyRead=new BufferedReader(new InputStreamReader(System.in)); // reading the filename from keyboard, send the filename to server. then server read the filename and send back the contents of filename back to client. InputStreamReader converts the filename to stream then moves to Buffer.

String fname=keyRead.readLine(); 

OutputStream ostream=sock.getOutputStream(); 

PrintWriter pwrite=new PrintWriter(ostream,true); //it enables you to write a formatted data to underlying writer

pwrite.println(fname); //sending a filename to server

InputStream istream=sock.getInputStream(); 

BufferedReader socketRead=new BufferedReader(new InputStreamReader(istream)); // read the contents of the file sent by the server i.e istream below

String str; 
while((str=socketRead.readLine())!=null) 
{ 
System.out.println(str); 
} 

pwrite.close(); 
socketRead.close(); 
keyRead.close(); 
} 
}

/*Open Terminal 1
Execution StepsStep 1: 
1. javac severfilename.java
2. java serverfilename

Step 2:
Create file sample.java
Welcome to tcp client and Server communication!!!

Open Terminal 2
Step 3:
1. javac clientfilename.java
2. java clientfilename

Enter the filename
sample.java
Welcome to tcp client and Server communication!!!

Server disconnects the connection once client read the contents of file */
