package com.coway.trust.biz.payment.payment.service.impl;

import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;
import com.coway.trust.biz.payment.payment.service.AutodebitAndCreditCardService;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @Class Name : EgovSampleServiceImpl.java
 * @Description : Sample Business Implement Class
 * @Modification Information
 * @ @ 수정일 수정자 수정내용 @ --------- --------- ------------------------------- @ 2009.03.16 최초생성
 *
 * @author 개발프레임웍크 실행환경 개발팀
 * @since 2009. 03.16
 * @version 1.0
 * @see
 *
 * 	 Copyright (C) by MOPAS All right reserved.
 */

@Service("autodebitAndCreditCardService")
public class AutodebitAndCreditCardServiceImpl extends EgovAbstractServiceImpl implements AutodebitAndCreditCardService {

	private static final Logger logger = LoggerFactory.getLogger(SearchPaymentServiceImpl.class);

	@Value("${app.name}")
	private String appName;

	@Resource(name = "autodebitAndCreditCardMapper")
	private AutodebitAndCreditCardMapper autodebitAndCreditCardMapper;

	@Autowired
	private MessageSourceAccessor messageSourceAccessor;

	
	
	/**
	 * SearchPayment Order List(Master Grid) 조회
	 * @param params
	 * @return
	 */
	@Override
	public List<EgovMap> selectOrderList(Map<String, Object> params) {
		return autodebitAndCreditCardMapper.selectOrderList(params);
	}
}
