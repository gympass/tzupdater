import java.time.*;

public class TimeZone {
  public static void main(String args[]) {
    System.out.println(ZonedDatime.now(ZoneId.of("America/Mexico_City")).toString());
  }
}
