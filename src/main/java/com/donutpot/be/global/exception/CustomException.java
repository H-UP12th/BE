package com.donutpot.be.global.exception;

import lombok.Getter;
import org.springframework.http.HttpStatus;

// 사용 예: throw new CustomException(HttpStatus.NOT_FOUND, "메뉴를 찾을 수 없습니다.");
@Getter
public class CustomException extends RuntimeException {

    private final HttpStatus status;

    public CustomException(HttpStatus status, String message) {
        super(message);
        this.status = status;
    }
}
