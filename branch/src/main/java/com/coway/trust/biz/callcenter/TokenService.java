package com.coway.trust.biz.callcenter;

import java.util.Map;

public interface TokenService {
	boolean isValidToken(Map<String, Object> params);
}
