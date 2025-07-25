package world.ssafy.tourtalk.model.dto.enums;

import com.fasterxml.jackson.annotation.JsonCreator;

public enum ProductStatus {
    DRAFT("대기"),
    OPEN("모집"),
    CLOSED("마감"),
    CANCELLED("취소"),
    DELETED("삭제");

    private final String desc;

    ProductStatus(String desc) {
        this.desc = desc;
    }

    public String getDesc() {
        return desc;
    }
    
    @JsonCreator
    public static ProductStatus from(String value) {
        return ProductStatus.valueOf(value.toUpperCase());
    }
}