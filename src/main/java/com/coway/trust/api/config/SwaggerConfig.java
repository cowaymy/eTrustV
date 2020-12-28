package com.coway.trust.api.config;

import static com.coway.trust.AppConstants.*;
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
		return new Docket(DocumentationType.SWAGGER_2).groupName("SAMPLE").apiInfo(getMobileApiInfo())
				// .useDefaultResponseMessages(false)
				.select().paths(includePath(PATH_API)).paths(includePath("sample")).paths(excludePath(CALLCENTER))
				.paths(excludePath(MOBILE)).build();
		// return new Docket(DocumentationType.SWAGGER_2).select().paths(paths()).build().apiInfo(getMobileApiInfo());
	}

	@Bean
	public Docket confMobileDocContext() {
		return new Docket(DocumentationType.SWAGGER_2).groupName(MOBILE).apiInfo(getMobileApiInfo())
				// .useDefaultResponseMessages(false)
				// .pathMapping(MOBILE)
				.select().paths(includePath(MOBILE)).paths(includePath(PATH_API)).paths(excludePath(CALLCENTER)).build();
	}

	@Bean
	public Docket confCallcenterDocContext() {
		return new Docket(DocumentationType.SWAGGER_2).groupName(CALLCENTER).apiInfo(getCallcenterApiInfo())
				// .useDefaultResponseMessages(false)
				// .pathMapping(CALLCENTER)
				.select().paths(includePath(CALLCENTER)).paths(includePath(PATH_API)).paths(excludePath(MOBILE)).build();
	}

	 @Bean
	  public Docket confWebApiDocContext() {
	    return new Docket(DocumentationType.SWAGGER_2).groupName(WEB).apiInfo(getWebApiInfo())
	        .select().paths(includePath(WEB)).paths(includePath(PATH_API)).paths(excludePath(MOBILE)).paths(excludePath(CALLCENTER)).build();
	  }

	private ApiInfo getMobileApiInfo() {
		ApiInfo apiInfo = new ApiInfo("Mobile Api", "Api Spec/Test Tool", "1.0", "", "", "", "");
		return apiInfo;
	}

	private ApiInfo getCallcenterApiInfo() {
		ApiInfo apiInfo = new ApiInfo("Callcenter Api", "Api Spec/Test Tool", "1.0", "", "", "", "");
		return apiInfo;
	}

	 private ApiInfo getWebApiInfo() {
	    ApiInfo apiInfo = new ApiInfo("Web Api", "Api Spec/Test Tool", "1.0", "", "", "", "");
	    return apiInfo;
	  }

//	private Predicate<String> getCallcenterPaths() {
//		return or(containsPattern(SLASH + CALLCENTER + PATH_API + "/*"));
//	}
//
//	private Predicate<String> getMobilePaths() {
//		return or(containsPattern(SLASH + MOBILE + PATH_API + "/*"));
//	}

	private Predicate<String> excludePath(final String path) {
		return input -> !input.contains(path);
	}

	private Predicate<String> includePath(final String path) {
		return input -> input.contains(path);
	}
}
