package com.coway.trust.biz.payment.payment.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.payment.mobileTicket.MobileTicketForm;
import com.coway.trust.biz.common.MobileAppTicketApiCommonService;
import com.coway.trust.biz.login.impl.LoginMapper;
import com.coway.trust.biz.payment.payment.service.MobileTicketApiService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.LoginVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : MobileTicketApiServiceImpl.java
 * @Description : MobileTicketApiServiceImpl
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 11. 12.   KR-HAN        First creation
 * </pre>
 */
@Service("mobileTicketApiService")
public class MobileTicketApiServiceImpl extends EgovAbstractServiceImpl implements MobileTicketApiService {

	@Resource(name = "mobileTicketApiMapper")
	private MobileTicketApiMapper mobileTicketApiMapper;

	@Resource(name = "mobileAppTicketApiCommonService")
	private MobileAppTicketApiCommonService mobileAppTicketApiCommonService;

	@Autowired
	private LoginMapper loginMapper;

	private static final Logger logger = LoggerFactory.getLogger(MobileTicketApiServiceImpl.class);

	/**
	 * selectMobileTicketList
	 * @Author KR-HAN
	 * @Date 2019. 11. 12.
	 * @param params
	 * @return
	 * @see com.coway.trust.biz.payment.payment.service.MobileTicketApiService#selectMobileTicketList(java.util.Map)
	 */
	@Override
	public List<EgovMap> selectMobileTicketList(Map<String, Object> params) {

		Map<String, Object> sParams = new HashMap<String, Object>();
	   	params.put("_USER_ID", params.get("userId") );
		LoginVO loginVO = loginMapper.selectLoginInfoById(params);
		params.put("userId",  loginVO.getUserId());

		return mobileTicketApiMapper.selectMobileTicketList(params);
	}


	/**
	 * saveMobileTicketCancel
	 * @Author KR-HAN
	 * @Date 2019. 11. 12.
	 * @param mobileTicketForm
	 * @throws Exception
	 * @see com.coway.trust.biz.payment.payment.service.MobileTicketApiService#saveMobileTicketCancel(com.coway.trust.api.mobile.payment.mobileTicket.MobileTicketForm)
	 */
	@Override
	public void saveMobileTicketCancel(MobileTicketForm  mobileTicketForm) throws Exception {

		Map<String, Object> params = MobileTicketForm.createMap(mobileTicketForm);

		params.put("_USER_ID", mobileTicketForm.getUserId());
		LoginVO loginVO = loginMapper.selectLoginInfoById(params);
		params.put("userId",  loginVO.getUserId());

		// 1. Ticket 상태값 확인
		EgovMap mobileTicketStus =  mobileTicketApiMapper.selectMobileTicketReqStus (params);

		if( StringUtils.isEmpty((String)mobileTicketStus.get("mobTicketNo")) )
		{
			throw new ApplicationException(AppConstants.FAIL, "Please check the status value of the suggestion."); // 해당 건의 상태값을 확인하세요.
		}
		int updateCnt = 0;
		// 2. 기준 테이블 상태값 업데이트

		String ticketTypeId = String.valueOf( mobileTicketStus.get("ticketTypeId") );
		if( "5674".equals( ticketTypeId ) ){ // 5674 : Request Billing Group ( 공통코드 : 435 )

			updateCnt = mobileTicketApiMapper.updateMobileTicketGroupOrderCancel(params);

		}else if( "5673".equals( ticketTypeId ) ){ // 5673 : Request Invoice ( 공통코드 : 435 )

			updateCnt = mobileTicketApiMapper.updateMobileTicketInvoiceCancel(params);

		}else{
			throw new ApplicationException(AppConstants.FAIL, "Please check the Ticket type."); // 티켓 타입을 확인하세요.
		}

		// 3. Ticket 상태값 업데이트
		int rtnCnt = 0;
		if( updateCnt == 1 ){
			List<Map<String, Object>> arrParams  = new ArrayList<Map<String,Object>>();
			Map<String, Object> sParams = new HashMap<String, Object>();

			sParams.put("mobTicketNo",  params.get("mobTicketNo"));
			sParams.put("ticketStusId", "10" ); // 10 : Cancelled
			sParams.put("userId", params.get("userId") );

			arrParams.add(sParams);

			rtnCnt = mobileAppTicketApiCommonService.updateMobileAppTicket(arrParams);
		}else{
			throw new ApplicationException(AppConstants.FAIL, "Please check again later."); // 잠시후 다시 확인하세요.
		}

	}

	/**
	 * selectMobileTicketDetail
	 * @Author KR-HAN
	 * @Date 2019. 11. 12.
	 * @param params
	 * @return
	 * @see com.coway.trust.biz.payment.payment.service.MobileTicketApiService#selectMobileTicketDetail(java.util.Map)
	 */
	@Override
	public EgovMap 	selectMobileTicketDetail(Map<String, Object> params) {

		EgovMap rtnMap = null;

		String ticketTypeId = String.valueOf (params.get("ticketTypeId"));

		if( "5674".equals(ticketTypeId) ){ // Request Billing Group

			rtnMap = mobileTicketApiMapper.selectMobileTicketBillingGroupDetail(params);

		}else if( "5673".equals(ticketTypeId) ){ // Request Invoice

			rtnMap = mobileTicketApiMapper.selectMobileTicketInvoiceDetail(params);

		}else if( "5677".equals(ticketTypeId) ){ // Mobile Payment Key-in

			rtnMap = mobileTicketApiMapper.selectMobileTicketPaymentKeyInDetail(params);

		}else if( "5676".equals(ticketTypeId) ){ // Request Refund

			rtnMap = mobileTicketApiMapper.selectMobileTicketRefundDetail(params);

		}else if( "5675".equals(ticketTypeId) ){ // Request Fund Transfer

			rtnMap = mobileTicketApiMapper.selectMobileTicketFundTransferDetail(params);

		}

		return rtnMap;
	}

}
