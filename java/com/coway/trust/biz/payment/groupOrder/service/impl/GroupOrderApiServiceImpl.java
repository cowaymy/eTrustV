package com.coway.trust.biz.payment.groupOrder.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import com.coway.trust.api.mobile.payment.groupOrder.GroupOrderForm;
import com.coway.trust.biz.common.AdaptorService;
import com.coway.trust.biz.common.MobileAppTicketApiCommonService;
import com.coway.trust.biz.login.impl.LoginMapper;
import com.coway.trust.biz.payment.groupOrder.service.GroupOrderApiService;
import com.coway.trust.cmmn.model.LoginVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : BillingGroupApiServiceImpl.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 9. 20.   KR-HAN        First creation
 * </pre>
 */
@Service("groupOrderApiService")
public class GroupOrderApiServiceImpl extends EgovAbstractServiceImpl implements GroupOrderApiService {

	@Resource(name = "groupOrderApiMapper")
	private GroupOrderApiMapper groupOrderApiMapper;

	@Autowired
	private AdaptorService adaptorService;

	@Autowired
	private LoginMapper loginMapper;

	@Value("${autodebit.email.receiver}")
	private String emailReceiver;

	@Value("${billing.type.confirm.url}")
	private String billingTypeConfirmUrl;

	// 티켓 서비스
	@Resource(name = "mobileAppTicketApiCommonService")
	private MobileAppTicketApiCommonService mobileAppTicketApiCommonService;

	private static final Logger logger = LoggerFactory.getLogger(GroupOrderApiServiceImpl.class);

	/**
	 * TO-DO Description
	 * @Author KR-HAN
	 * @Date 2019. 9. 20.
	 * @param params
	 * @return
	 * @see com.coway.trust.biz.payment.billinggroup.service.BillingGroupApiService#selectBasicInfo(java.util.Map)
	 */
	@Override
	public List<EgovMap> selectGroupOrder(Map<String, Object> params) {
		return groupOrderApiMapper.selectGroupOrder(params);
	}

	/**
	 * TO-DO Description
	 * @Author KR-HAN
	 * @Date 2019. 9. 24.
	 * @param params
	 * @return
	 * @see com.coway.trust.biz.payment.groupOrder.service.GroupOrderApiService#selectGroupOrderList(java.util.Map)
	 */
	@Override
	public List<EgovMap> selectGroupOrderList(Map<String, Object> params) {
		return groupOrderApiMapper.selectGroupOrderList(params);
	}


	 /**
	 * TO-DO Description
	 * @Author KR-HAN
	 * @Date 2019. 9. 25.
	 * @param params
	 * @return
	 */
	@Override
	public List<EgovMap> selectGroupOrderDetailList(Map<String, Object> params) {
		return groupOrderApiMapper.selectGroupOrderDetailList(params);
	}

	/**
	 * TO-DO Description
	 * @Author KR-HAN
	 * @Date 2019. 9. 27.
	 * @param groupOrderForm
	 * @throws Exception
	 * @see com.coway.trust.biz.payment.groupOrder.service.GroupOrderApiService#saveGroupOrderMove(com.coway.trust.api.mobile.payment.groupOrder.GroupOrderForm)
	 */
	@Override
	public void saveGroupOrderMove(GroupOrderForm  groupOrderForm) throws Exception {

		Map<String, Object> params = GroupOrderForm.createMap(groupOrderForm);

		params.put("_USER_ID", groupOrderForm.getUserId());
		LoginVO loginVO = loginMapper.selectLoginInfoById(params);
		params.put("userId",  loginVO.getUserId());


		EgovMap groupOrderReqStusYn =  groupOrderApiMapper.selectGroupOrderReqStusYn (params);

		List<Map<String, Object>> arrParams  = null;
		Map<String, Object> sParams = null;

		// Ticket 기존 티켓 업데이트
		if( !StringUtils.isEmpty( groupOrderReqStusYn.get("mobTicketNo") ) ){

			arrParams  = new ArrayList<Map<String,Object>>();
			sParams = new HashMap<String, Object>();

			sParams.put("mobTicketNo",  groupOrderReqStusYn.get("mobTicketNo"));
			sParams.put("ticketStusId", "10" ); // 10 : Cancelled
			sParams.put("userId", params.get("userId") );

			arrParams.add(sParams);

			int rtnCnt = mobileAppTicketApiCommonService.updateMobileAppTicket(arrParams);
		}

		// Ticket 신규 저장
		arrParams  = new ArrayList<Map<String,Object>>();
		sParams = new HashMap<String, Object>();

		sParams.put("salesOrdNo",  params.get("salesOrdNo"));
		sParams.put("ticketTypeId", "5674" );
		sParams.put("ticketStusId", "1" );
		sParams.put("userId", groupOrderForm.getUserId() );

		arrParams.add(sParams);

		int mobTicketNo = mobileAppTicketApiCommonService.saveMobileAppTicket(arrParams);

		// 1. group order 변경 신청 유무 확인
//		EgovMap selectGroupOrderReqStusYn =  groupOrderApiMapper.selectGroupOrderReqStusYn (params);

		params.put("custBillIdOld",   groupOrderReqStusYn.get("custBillId")  );
		params.put("custBillIdNw",   params.get("custBillId") );

		// 2. 기존 변경건이 있을 경우 취소(10) 업데이트
		if( "Y".equals( groupOrderReqStusYn.get("reqStusYn") ) ){

			params.put("reqStusId",  "10"  );
			groupOrderApiMapper.updateGroupOrderMove(params);
		}

		// 3. 변경건 저장
		params.put("reqStusId",  "1"  );
		params.put("mobTicketNo", mobTicketNo);
		groupOrderApiMapper.insertGroupOrderMove(params);

	/*	EgovMap memMap = CourseApiMapper.memInfo(params);

		int memId = CommonUtils.intNvl(memMap.get("memId"));
		String memName = (String) memMap.get("name");
		String memNric = (String) memMap.get("nric");

		params.put("_USER_ID", saveCourseForm.getUserId());

		LoginVO loginVO = loginMapper.selectLoginInfoById(params);

		params.put("memId",   memId);
		params.put("memName", memName);
		params.put("memNric", memNric);
		params.put("userId",  loginVO.getUserId());

		if( 1 == saveCourseForm.getRequestType()) {
			CourseApiMapper.registerCourse(params);
		}
		else if(2 == saveCourseForm.getRequestType()) {
			CourseApiMapper.cancelCourse(params);
		}*/
	}

	@Override
	public void saveGroupOrderCancel(GroupOrderForm  groupOrderForm) throws Exception {

		Map<String, Object> params = GroupOrderForm.createMap(groupOrderForm);

		params.put("_USER_ID", groupOrderForm.getUserId());
		LoginVO loginVO = loginMapper.selectLoginInfoById(params);
		params.put("userId",  loginVO.getUserId());

		System.out.println("++++ params.toString() ::" + params.toString() );

		// Ticket 저장
		// 1. group order 변경 신청 유무 확인
		EgovMap selectGroupOrderReqStusYn =  groupOrderApiMapper.selectGroupOrderReqStusYn (params);

		List<Map<String, Object>> arrParams  = new ArrayList<Map<String,Object>>();
		Map<String, Object> sParams = new HashMap<String, Object>();

		sParams.put("mobTicketNo",  selectGroupOrderReqStusYn.get("mobTicketNo"));
		sParams.put("ticketStusId", "10" ); // 10 : Cancelled
		sParams.put("updUserId", groupOrderForm.getUserId() );

		arrParams.add(sParams);

		int rtnCnt = mobileAppTicketApiCommonService.updateMobileAppTicket(arrParams);

		// 그룹 오더 상태값 변경
		params.put("reqStusId",  "10"  );
		groupOrderApiMapper.updateGroupOrderMove(params);
	}

	/**
	 * selectCustBillId 조회
	 *
	 * @param params
	 * @return
	 */
	@Override
	public String selectCustBillId(Map<String, Object> params) {
		return groupOrderApiMapper.selectCustBillId(params);
	}

}
