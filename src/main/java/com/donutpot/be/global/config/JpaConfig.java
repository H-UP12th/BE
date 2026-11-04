package com.donutpot.be.global.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;

// BeApplication 대신 여기에 둬야 @WebMvcTest 같은 슬라이스 테스트가 안 깨짐
@Configuration
@EnableJpaAuditing
public class JpaConfig {
}
