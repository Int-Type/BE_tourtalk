package world.ssafy.tourtalk.model.service;

import java.util.List;

import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;
import world.ssafy.tourtalk.model.dto.Page;
import world.ssafy.tourtalk.model.dto.enums.CommentStatus;
import world.ssafy.tourtalk.model.dto.request.CommentRequest;
import world.ssafy.tourtalk.model.dto.request.SearchConditionRequest;
import world.ssafy.tourtalk.model.dto.response.CommentResponse;
import world.ssafy.tourtalk.model.dto.response.PageResponse;
import world.ssafy.tourtalk.model.mapper.BoardMapper;
import world.ssafy.tourtalk.model.mapper.CommentMapper;

@Service
@RequiredArgsConstructor
public class CommentService {
	
	private final CommentMapper commentMapper;
	private final BoardMapper boardMapper;

	// 댓글 작성
	public boolean write(CommentRequest request, Integer mno) {
		request = CommentRequest.builder()
				.postId(request.getPostId())
				.writerId(mno)
				.content(request.getContent())
				.status(request.getStatus())
				.build();
		
		
		return commentMapper.insert(request) == 1 && boardMapper.updateCommentCount(request.getPostId());
	}

	// 댓글 수정
	public boolean update(CommentRequest request, Integer mno) {
		CommentResponse origin = commentMapper.selectByCommentId(request.getCommentId());
		if(origin.getWriterId() != mno) return false;
		
		CommentRequest toUpdate = CommentRequest.builder()
				.commentId(request.getCommentId())
				.writerId(mno)
				.content(request.getContent())
				.status(request.getStatus())
				.build();
		
		return commentMapper.update(toUpdate) == 1;
	}

	// 댓글 삭제
	public boolean softDelete(int commentId) {
		return commentMapper.softDelete(commentId) == 1;
	}

	// 댓글 작성자 mno 조회
	public int selectByWriterId(int commentId) {
		return commentMapper.selectByWriterId(commentId);
	}

	// 게시글에 작성된 댓글 조회
	public List<CommentResponse> selectAllByPostId(int postId) {
		return commentMapper.selectAllByPostId(postId);
	}

	// 마이페이지 : 작성자 댓글 전체 조회
	public PageResponse<CommentResponse> getMyComments(SearchConditionRequest cond) {
		cond.setDefaults();
		int offset = cond.getOffset();
		
		List<CommentResponse> list = commentMapper.selectMyComments(cond, offset, cond.getPageSize());
		
		long total = commentMapper.countMyComments(cond);
		
		int totalPages = (int) Math.ceil((double) total / cond.getPageSize());
		boolean first = cond.getPageNumber() == 1;
		boolean last = cond.getPageNumber() >= totalPages;
		
		Page<CommentResponse> page = new Page<>(list, cond.getPageNumber(), cond.getPageSize(), total, totalPages, first, last);
		page.calculatePageInfo(5);
		
		System.out.println(page.toString());
		return PageResponse.from(page);
	}

}
