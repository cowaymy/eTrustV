package com.coway.trust.config;

import org.springframework.security.web.util.matcher.RequestMatcher;

import java.util.HashSet;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;

public class CustomCsrfRequestMatcher implements RequestMatcher {

 private final Set<String> protectedUrls = new HashSet<>();

 public CustomCsrfRequestMatcher() {
  protectedUrls.add("/");
        protectedUrls.add("/login/getLoginInfo.do");
    }

    @Override
    public boolean matches(HttpServletRequest request) {
        String path = request.getServletPath();
        return protectedUrls.contains(path);
    }
}