package com.coway.trust.biz.payment.payment.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.login.impl.LoginMapper;
import com.coway.trust.biz.payment.payment.service.PaymentListApiService;
import com.coway.trust.cmmn.model.LoginVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : PaymentListApiServiceImpl.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 21.   KR-HAN        First creation
 * </pre>
 */
@Service("paymentListApiService")
public class PaymentListApiServiceImpl extends EgovAbstractServiceImpl implements PaymentListApiService {

	@Resource(name = "paymentListApiMapper")
	private PaymentListApiMapper paymentListApiMapper;

	@Autowired
	private LoginMapper loginMapper;

	private static final Logger logger = LoggerFactory.getLogger(PaymentApiServiceImpl.class);

	/**
	 * TO-DO Description
	 * @Author KR-HAN
	 * @Date 2019. 10. 21.
	 * @param params
	 * @return
	 * @see com.coway.trust.biz.payment.payment.service.PaymentListApiService#selectPaymentList(java.util.Map)
	 */
	@Override
	public List<EgovMap> selectPaymentList(Map<String, Object> params) {

    	params.put("_USER_ID", params.get("userId") );
		LoginVO loginVO = loginMapper.selectLoginInfoById(params);
		params.put("userId",  loginVO.getUserId());

		return paymentListApiMapper.selectPaymentList(params);
	}

}
