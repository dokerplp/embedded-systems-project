package itmo.zavar.car;

import java.io.*;
import java.net.Socket;
import java.util.Scanner;

public class TestClient {

    public static void main(String[] args) throws IOException, InterruptedException {
        Socket socket = new Socket("192.168.0.103", 25565);

        BufferedReader clientReader = new BufferedReader(new InputStreamReader(socket.getInputStream()));
        BufferedWriter clientWriter = new BufferedWriter(new OutputStreamWriter(socket.getOutputStream()));
        Scanner console = new Scanner(System.in);

        int j = 0;
        while(true) {

            while (!console.hasNextLine());
            clientWriter.write(console.nextLine());
            clientWriter.newLine();
            clientWriter.flush();

            String input;
            if((input = clientReader.readLine()) != null) {
                System.out.println(input);
            }
            j++;

//            Thread.sleep(3000);
        }

    }

}
