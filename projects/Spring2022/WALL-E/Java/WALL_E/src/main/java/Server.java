import java.io.*;
import java.net.ServerSocket;
import java.net.Socket;
import java.net.SocketTimeoutException;
import java.nio.ByteBuffer;
import java.nio.charset.StandardCharsets;
import java.util.Arrays;

public class Server {
    private final ServerSocket serverSocket;

    public Server(int port) throws IOException {
        serverSocket = new ServerSocket(port);
        serverSocket.setSoTimeout(10000);
    }

    public void start() {
        while(true) {
            try (Socket socket = serverSocket.accept()){
                socket.setSoTimeout(1000);
                try (
                        BufferedReader in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
                        DataOutputStream daos = new DataOutputStream(socket.getOutputStream())
                ){
                    String s = in.readLine();
                    System.out.println(s);

                    daos.writeInt(2113);
                    daos.flush();
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
