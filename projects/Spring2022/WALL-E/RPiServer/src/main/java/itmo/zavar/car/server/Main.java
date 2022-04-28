package itmo.zavar.car.server;

import java.io.IOException;

@Deprecated
public class Main {

    public static void main(String[] args) throws IOException {
        Server server = new Server(2113);
        server.start();
    }
}