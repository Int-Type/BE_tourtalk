package world.ssafy.tourtalk.controller;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import lombok.RequiredArgsConstructor;
import world.ssafy.tourtalk.model.dto.request.BoardRequest;
import world.ssafy.tourtalk.model.dto.response.ApiResponse;
import world.ssafy.tourtalk.model.service.BoardService;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/v1/board")
public class BoardController {

    private final BoardService bService;

    @PostMapping
    public ResponseEntity<ApiResponse<Integer>> write(@RequestBody BoardRequest request, @AuthenticationPrincipal Integer mno) {
        int result = bService.write(request, mno);
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.of(HttpStatus.CREATED, result, "게시글 작성 성공!"));
    }

    @PutMapping
    public ResponseEntity<ApiResponse<Integer>> update(@RequestBody BoardRequest request, @AuthenticationPrincipal Integer mno) {
        int result = bService.update(request, mno);
        return ResponseEntity.ok(ApiResponse.success(result, "게시글 수정 성공!"));
    }

    @DeleteMapping("/{postId}")
    public ResponseEntity<ApiResponse<Integer>> softDelete(@PathVariable int postId, @AuthenticationPrincipal Integer mno) {
        int result = bService.delete(postId, mno);
        return ResponseEntity.ok(ApiResponse.success(result, "게시글 삭제 성공!"));
    }

}
