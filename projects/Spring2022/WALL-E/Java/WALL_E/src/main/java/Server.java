import java.io.*;
import java.net.ServerSocket;
import java.net.Socket;
import java.nio.charset.StandardCharsets;

public class Server {

    //add logger

    private final ServerSocket serverSocket;

    public Server(int port) throws IOException {
        serverSocket = new ServerSocket(port);
        serverSocket.setSoTimeout(1000);
    }
    public void start() {
        try (
                Socket socket = serverSocket.accept();
                BufferedReader in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
                OutputStream outStream = socket.getOutputStream();
        ) {
            //log car connected
            socket.setSoTimeout(10000);

            while (true) {
                try {
                    String s = in.readLine();
                    if (s == null) continue;
                    System.out.println(s);

                    long battery1 = Math.round(Math.random() * 100);
                    long battery2 = Math.round(Math.random() * 100);
                    String msg = battery1 + "-" + battery2 + "\n";

                    outStream.write(msg.getBytes(StandardCharsets.UTF_8));
                    outStream.flush();
                } catch (IOException e) {
                    throw new IOException(e);
                }
            }
        } catch (IOException e) {
            System.out.println("close");
            start();
        }
    }
}
