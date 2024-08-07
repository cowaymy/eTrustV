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
import com.coway.trust.biz.payment.payment.service.UnpaidCustomerApiService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;


/**
 * @ClassName : UnpaidCustomerApiServiceImpl.java
 * @Description : UnpaidCustomerApiServiceImpl
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 11. 8.   KR-HAN        First creation
 * </pre>
 */
@Service("unpaidCustomerApiService")
public class UnpaidCustomerApiServiceImpl extends EgovAbstractServiceImpl implements UnpaidCustomerApiService {

	@Resource(name = "unpaidCustomerApiMapper")
	private UnpaidCustomerApiMapper unpaidCustomerApiMapper;

	@Autowired
	private LoginMapper loginMapper;

	private static final Logger logger = LoggerFactory.getLogger(UnpaidCustomerApiServiceImpl.class);

	/**
	 * selectUnpaidCustomerList
	 * @Author KR-HAN
	 * @Date 2019. 11. 8.
	 * @param params
	 * @return
	 * @see com.coway.trust.biz.payment.payment.service.UnpaidCustomerApiService#selectUnpaidCustomerList(java.util.Map)
	 */
	@Override
	public List<EgovMap> selectUnpaidCustomerList(Map<String, Object> params) {

		Map<String, Object> sParams = new HashMap<String, Object>();

		return unpaidCustomerApiMapper.selectUnpaidCustomerList(params);
	}


	/**
	 * selectUnpaidCustomerDetailList
	 * @Author KR-HAN
	 * @Date 2019. 11. 8.
	 * @param params
	 * @return
	 * @see com.coway.trust.biz.payment.payment.service.UnpaidCustomerApiService#selectUnpaidCustomerDetailList(java.util.Map)
	 */
	@Override
	public List<EgovMap> selectUnpaidCustomerDetailList(Map<String, Object> params) {

		Map<String, Object> sParams = new HashMap<String, Object>();

		return unpaidCustomerApiMapper.selectUnpaidCustomerDetailList(params);
	}



}
