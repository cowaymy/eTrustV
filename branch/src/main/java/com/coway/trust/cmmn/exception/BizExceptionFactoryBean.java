package com.coway.trust.cmmn.exception;

import org.springframework.beans.factory.InitializingBean;
import org.springframework.util.Assert;
import com.coway.trust.cmmn.model.BizMsgVO;

public class BizExceptionFactoryBean implements InitializingBean {
	private static BizExceptionFactoryBean instance;

	public static BizExceptionFactoryBean getInstance() {
		return instance;
	}

	public BizException createBizException(String errorCode, String procTransactionId, String procName, String procKey, String procMsg, String errorMsg) {
		return new BizException(errorCode, procTransactionId, procName, procKey, procMsg, errorMsg, null);
	}

	public BizException createBizException(String errorCode, String procTransactionId, String procName, String procKey, String procMsg, String errorMsg, Exception cause) {
		return new BizException(errorCode, procTransactionId, procName, procKey, procMsg, errorMsg, cause);
	}

	@Override
	public void afterPropertiesSet() throws Exception {
		instance = this;
	}
}
