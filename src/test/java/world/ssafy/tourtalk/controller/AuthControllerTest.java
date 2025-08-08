package world.ssafy.tourtalk.controller;

import static org.assertj.core.api.Assertions.assertThat;

import java.time.LocalDate;
import java.util.Arrays;
import java.util.Optional;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.ResponseEntity;
import org.springframework.mock.web.MockHttpServletResponse;
import org.springframework.transaction.annotation.Transactional;

import jakarta.servlet.http.Cookie;
import world.ssafy.tourtalk.model.dto.enums.Gender;
import world.ssafy.tourtalk.model.dto.request.MemberRequest;
import world.ssafy.tourtalk.model.service.MemberService;

@SpringBootTest(properties = {
		  "jwt.secret=this_is_a_very_secure_and_long_enough_secret_key_for_hs256"
		})
@Transactional
public class AuthControllerTest {

	@Autowired
	private MemberService mService;
	
	@Autowired
	private AuthController authController;
	
	private MemberRequest makeMemberRequest(String id) {
	    return MemberRequest.builder()
	        .id(id)
	        .password("1234")
	        .nickname("test")
	        .email("test@user.com")
	        .phone("01012348756")
	        .gender(Gender.MAN)
			.address("광주광역시")
			.postalCode("12345")
			.birthDate(LocalDate.of(2025, 5, 5))
	        .build();
	}
	
	@Test
	void regist_success() {
	    // given
	    String id = "TestUser2";
	    MemberRequest request = makeMemberRequest(id);

	    // when
	    int result = mService.regist(request);

	    // then
	    assertThat(result).isEqualTo(1);
	}

	@Test
	void logout_sets_token_cookie_null() {
	    MockHttpServletResponse response = new MockHttpServletResponse();

	    // when
	    ResponseEntity<?> result = authController.logout(response);

	    // then
	    Cookie[] cookies = response.getCookies();
	    assertThat(cookies).isNotEmpty();

	    Optional<Cookie> tokenCookie = Arrays.stream(cookies)
	        .filter(c -> c.getName().equals("token"))
	        .findFirst();

	    assertThat(tokenCookie).isPresent();
	    assertThat(tokenCookie.get().getValue()).isEqualTo("");
	    assertThat(tokenCookie.get().getMaxAge()).isEqualTo(0); // 삭제 확인
	}

}
