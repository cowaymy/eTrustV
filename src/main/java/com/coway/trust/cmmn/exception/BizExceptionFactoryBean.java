package com.coway.trust.cmmn.exception;

import org.springframework.beans.factory.InitializingBean;
import org.springframework.util.Assert;
import com.coway.trust.cmmn.model.BizMsgVO;

public class BizExceptionFactoryBean implements InitializingBean {
	private static BizExceptionFactoryBean instance;

	public static BizExceptionFactoryBean getInstance() {
		return instance;
	}

	public BizException createBizException(String errorCode, BizMsgVO bizMsgVO) {
		return new BizException(errorCode, bizMsgVO, null);
	}

	public BizException createBizException(String errorCode, BizMsgVO bizMsgVO, Throwable cause) {
		return new BizException(errorCode, bizMsgVO, cause);
	}

	@Override
	public void afterPropertiesSet() throws Exception {
		instance = this;
	}
}
