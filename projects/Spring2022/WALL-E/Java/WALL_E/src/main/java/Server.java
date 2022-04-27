import java.io.*;
import java.net.ServerSocket;
import java.net.Socket;

public class Server {

    private static final int PORT = 2113;

    public static void main(String[] args) throws IOException {
        try (
                ServerSocket serverSocket = new ServerSocket(PORT);
        ) {
            while (true) {
                try (
                        Socket socket = serverSocket.accept();
                        BufferedReader in = new BufferedReader(new InputStreamReader(socket.getInputStream()))
                ) {
                    String s = in.readLine();
                    System.out.println(s);
                }
            }
        }
    }
}