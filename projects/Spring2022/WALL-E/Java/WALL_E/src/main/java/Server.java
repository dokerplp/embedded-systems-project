import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.ServerSocket;
import java.net.Socket;
import java.net.SocketTimeoutException;

public class Server {
    private final ServerSocket serverSocket;

    public Server(int port) throws IOException {
        serverSocket = new ServerSocket(port);
    }

    public void start() throws IOException {
        while(true) {
            try (Socket socket = serverSocket.accept()){
                socket.setSoTimeout(1000);
                try (BufferedReader in = new BufferedReader(new InputStreamReader(socket.getInputStream()))){
                    String s = in.readLine();
                    System.out.println(s);
                }
            } catch (SocketTimeoutException s) {
                System.out.println("Connection time out!");
            } catch (IOException e) {
                e.printStackTrace();
                break;
            }
        }
    }
}
