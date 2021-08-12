package com.coway.trust.biz.payment.mobileAppTicket.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.coway.trust.biz.common.MobileAppTicketApiCommonService;
import com.coway.trust.biz.payment.mobileAppTicket.service.MobileAppTicketService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : MobileAppTicketServiceImpl.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 16.   KR-HAN        First creation
 * </pre>
 */
@Service("mobileAppTicketService")
public class MobileAppTicketServiceImpl extends EgovAbstractServiceImpl implements MobileAppTicketService{

	@Resource(name = "mobileAppTicketMapper")
	private MobileAppTicketMapper mobileAppTicketMapper ;

	// 테스트
//	@Resource(name = "mobileAppTicketApiCommonService")
//	private MobileAppTicketApiCommonService mobileAppTicketApiCommonService;

	 /**
	 * selectMobileAppTicketList
	 * @Author KR-HAN
	 * @Date 2019. 10. 16.
	 * @param params
	 * @return
	 */
	@Override
	public List<EgovMap> selectMobileAppTicketList(Map<String, Object> params) {

//		List<Map<String, Object>> arrParams  = new ArrayList<Map<String,Object>>();
//		Map<String, Object> sParams = new HashMap<String, Object>();
//
//		sParams.put("salesOrdNo", "2");
//		sParams.put("ticketTypeId", "3");
//		sParams.put("ticketStusId", "5");
//		sParams.put("userId", "CD105291");
//
//		arrParams.add(sParams);
//		mobileAppTicketApiCommonService.saveMobileAppTicket(arrParams);

		return mobileAppTicketMapper.selectMobileAppTicketList(params);
	}


	/**
	 * selectMobileAppTicketStatus
	 * @Author KR-HAN
	 * @Date 2019. 10. 21.
	 * @param params
	 * @return
	 * @see com.coway.trust.biz.payment.mobileAppTicket.service.MobileAppTicketService#selectMobileAppTicketStatus(java.util.Map)
	 */
	@Override
	public List<EgovMap> selectMobileAppTicketStatus(Map<String, Object> params) {

		return mobileAppTicketMapper.selectMobileAppTicketStatus(params);
	}

}
