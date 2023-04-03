import java.time.*;

public class TimeZone {
  public static void main(String args[]) {
    System.out.println(String.format("MX %s", ZonedDateTime.now(ZoneId.of("America/Mexico_City")).toString()));
    System.out.println(String.format("NY %s", ZonedDateTime.now(ZoneId.of("America/New_York")).toString()));
    System.out.println(String.format("SP %s", ZonedDateTime.now(ZoneId.of("America/Sao_Paulo")).toString()));
  }
}
