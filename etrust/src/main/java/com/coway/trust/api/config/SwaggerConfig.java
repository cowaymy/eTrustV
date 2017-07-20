package com.coway.trust.api.config;

import static com.google.common.base.Predicates.containsPattern;
import static com.google.common.base.Predicates.or;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import com.google.common.base.Predicate;

import springfox.documentation.service.ApiInfo;
import springfox.documentation.spi.DocumentationType;
import springfox.documentation.spring.web.plugins.Docket;
import springfox.documentation.swagger2.annotations.EnableSwagger2;

@Configuration
@EnableSwagger2
public class SwaggerConfig {
	@Bean
	public Docket customImplementation() {
		return new Docket(DocumentationType.SWAGGER_2).select().paths(paths()).build().apiInfo(apiInfo());
		// .pathMapping( AppConstants.PATH_API );
	}

	private ApiInfo apiInfo() {
		ApiInfo apiInfo = new ApiInfo("Mobile Api", "Api Spec/Test Tool", "1.0", "", "", "", "");
		return apiInfo;
	}

	private Predicate<String> paths() {
		return or(containsPattern("/api/*"));
	}
}
