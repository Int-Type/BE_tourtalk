package world.ssafy.tourtalk;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import io.github.cdimascio.dotenv.Dotenv;

@SpringBootApplication
public class TourtalkApplication {

	public static void main(String[] args) {
		Dotenv dotenv = Dotenv.load();
		System.setProperty("spring.datasource.url", dotenv.get("SPRING_DATASOURCE_URL"));
		System.setProperty("spring.datasource.username", dotenv.get("SPRING_DATASOURCE_USERNAME"));
		System.setProperty("spring.datasource.password", dotenv.get("SPRING_DATASOURCE_PASSWORD"));
		System.setProperty("api.key_sgis_service_id", dotenv.get("API_KEY_SGIS_SERVICE_ID"));
		System.setProperty("api.key_sgis_security", dotenv.get("API_KEY_SGIS_SECURITY"));
		System.setProperty("api.key_vworld", dotenv.get("API_KEY_VWORLD"));
		System.setProperty("api.key_data", dotenv.get("API_KEY_DATA"));
		System.setProperty("jwt.secret", dotenv.get("JWT_SECRET"));

		SpringApplication.run(TourtalkApplication.class, args);
	}

}
