package world.ssafy.tourtalk.model.dto.response;

import lombok.Getter;
import org.springframework.http.HttpStatus;

@Getter
public class ApiResponse<T> {

    private final String status;
    private final T data;
    private final String message;

    public ApiResponse(String status, T data, String message) {
        this.status = status;
        this.data = data;
        this.message = message;
    }

    public static <T> ApiResponse<T> of(HttpStatus httpStatus, T data, String message) {
        return new ApiResponse<>(String.valueOf(httpStatus.value()), data, message);
    }

    public static <T> ApiResponse<T> of(HttpStatus httpStatus, T data) {
	return of(httpStatus, data, httpStatus.getReasonPhrase());
    }

    public static <T> ApiResponse<T> success(T data) {
        return of(HttpStatus.OK, data);
    }

    public static <T> ApiResponse<T> success(T data, String message) {
        return of(HttpStatus.OK, data, message);
    }

    public static <T> ApiResponse<T> created(T data) {
        return of(HttpStatus.CREATED, data);
    }
}
