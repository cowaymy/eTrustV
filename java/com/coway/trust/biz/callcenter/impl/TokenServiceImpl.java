package com.coway.trust.biz.callcenter.impl;

import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.callcenter.TokenService;

@Service("tokenService")
public class TokenServiceImpl implements TokenService {

	@Autowired
	private TokenMapper tokenMapper;

	@Override
	public boolean isValidToken(Map<String, Object> params) {
		String token = tokenMapper.selectToken(params);
		return StringUtils.isNotEmpty(token);
	}
}
