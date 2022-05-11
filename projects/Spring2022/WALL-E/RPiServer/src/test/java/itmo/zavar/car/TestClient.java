package itmo.zavar.car;

import java.io.*;
import java.net.Socket;
import java.util.Scanner;

public class TestClient {

    public static void main(String[] args) throws IOException, InterruptedException {
        Socket socket = new Socket("localhost", 25565);

        BufferedReader clientReader = new BufferedReader(new InputStreamReader(socket.getInputStream()));
        BufferedWriter clientWriter = new BufferedWriter(new OutputStreamWriter(socket.getOutputStream()));
        Scanner console = new Scanner(System.in);

        float[] values = new float[100];

        for(int i = 1; i < values.length; i++) {
            values[i] = values[i - 1] + 0.01f;
        }

        int j = 0;
        while(true) {
            if(j >= values.length)
                j = 0;
            clientWriter.write(values[j] + ":" + values[j]);
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
