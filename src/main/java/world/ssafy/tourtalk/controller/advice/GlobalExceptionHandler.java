package world.ssafy.tourtalk.controller.advice;

import lombok.extern.slf4j.Slf4j;
import org.springframework.dao.DataAccessException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import world.ssafy.tourtalk.model.dto.response.ApiResponse;

@Slf4j
@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(DataAccessException.class)
    public ResponseEntity<ApiResponse<?>> handleDataAccessException(DataAccessException e) {
        log.error("Database error occurred: {}", e.getMessage(), e);
        ApiResponse<?> response = ApiResponse.of(HttpStatus.INTERNAL_SERVER_ERROR, null, "서버 데이터베이스 오류가 발생했습니다.");
        return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ApiResponse<?>> handleGlobalException(Exception e) {
        log.error("An unexpected error occurred: {}", e.getMessage(), e);
        ApiResponse<?> response = ApiResponse.of(HttpStatus.INTERNAL_SERVER_ERROR, null, "서버에서 예상치 못한 오류가 발생했습니다.");
        return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
    }
}
