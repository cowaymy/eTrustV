package com.coway.trust.biz.sales.order.impl;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.sales.mambership.impl.MembershipQuotationMapper;
import com.coway.trust.biz.sales.order.OrderSuspensionService;
import com.coway.trust.web.sales.SalesConstants;
import com.ibm.icu.text.NumberFormat;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("orderSuspensionService")
public class OrderSuspensionServiceImpl extends EgovAbstractServiceImpl implements OrderSuspensionService{

	private static final Logger logger = LoggerFactory.getLogger(OrderSuspensionServiceImpl.class);

	@Resource(name = "orderSuspensionMapper")
	private OrderSuspensionMapper orderSuspensionMapper;

	@Resource(name = "orderInvestMapper")
	private OrderInvestMapper orderInvestMapper;

	@Resource(name = "membershipQuotationMapper")
	private MembershipQuotationMapper membershipQuotationMapper;

	@Resource(name = "orderExchangeMapper")
	private OrderExchangeMapper orderExchangeMapper;

	@Autowired
	private MessageSourceAccessor messageSourceAccessor;

	/**
	 * 글 목록을 조회한다.
	 *
	 * @param
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	public List<EgovMap> orderSuspensionList(Map<String, Object> params) {
		return orderSuspensionMapper.orderSuspensionList(params);
	}


	/**
	 * Suspension Information.
	 *
	 * @param REQ_ID
	 * @return 글 상세
	 * @exception Exception
	 */
	@Override
	public EgovMap orderSuspendInfo(Map<String, Object> params) {
		return orderSuspensionMapper.orderSuspendInfo(params);
	}


	/**
	 * 글 목록을 조회한다.
	 *
	 * @param
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	@Override
	public List<EgovMap> suspendInchargePerson(Map<String, Object> params) {
		return orderSuspensionMapper.suspendInchargePerson(params);
	}

	@Override
	public void saveReAssign(Map<String, Object> params) {

		EgovMap reAssignIncharge = orderSuspensionMapper.reAssignIncharge(params);
		params.put("susInPersonId", reAssignIncharge.get("susInPersonId"));
		params.put("susInPersonStusId", 8);
		orderSuspensionMapper.updateSusInchargePerson(params);

		params.put("susUserId", params.get("inchargeNm"));
		EgovMap reAssignSusUserId = orderSuspensionMapper.reAssignSusUserId(params);

		int getSusInPersonIdSeq = orderInvestMapper.getSusInPersonIdSeq();
		params.put("getSusInPersonIdSeq", getSusInPersonIdSeq);
		params.put("getSusIdSeq", params.get("susId"));
		params.put("susInPersonStusId", 1);
		orderInvestMapper.insertSusSAL0097D(params);
	}


	/**
	 * 글 목록을 조회한다.
	 *
	 * @param
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	@Override
	public List<EgovMap> suspendCallResult(Map<String, Object> params) {
		return orderSuspensionMapper.suspendCallResult(params);
	}


	/**
	 * 글 목록을 조회한다.
	 *
	 * @param
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	@Override
	public List<EgovMap> callResultLog(Map<String, Object> params) {
		return orderSuspensionMapper.callResultLog(params);
	}


	@Override
	public void newSuspendResult(Map<String, Object> params) {

		int saveStatus = Integer.parseInt((String)params.get("newSuspResultStus"));	// Suspend , Regular

		Map<String, Object> saveParam = new HashMap<String, Object>();
		Map<String, Object> saveRagularParam = new HashMap<String, Object>();
		Calendar cal = Calendar.getInstance();
		String currYear = Integer.toString(cal.get(cal.YEAR));
		String currMonth =Integer.toString(cal.get(cal.MONTH)+1);
		saveRagularParam.put("salesOrdId", params.get("ordId"));

		if(saveStatus == 2){
			EgovMap newSuspendSearch1 = orderSuspensionMapper.newSuspendSearch1(params);
			int getCallResultIdMaxSeq = orderExchangeMapper.getCallResultIdMaxSeq();
			saveParam.put("getCallResultIdMaxSeq", getCallResultIdMaxSeq);
			saveParam.put("callEntryId", newSuspendSearch1.get("callEntryId"));
			saveParam.put("callStusId", params.get("newSuspResultStus"));
			saveParam.put("callDt", SalesConstants.DEFAULT_DATE);
			saveParam.put("callActnDt", SalesConstants.DEFAULT_DATE);
			saveParam.put("callFdbckId", 0);
			saveParam.put("callCtId", 0);
			saveParam.put("callRem", params.get("newSuspResultRem"));
			saveParam.put("callCrtUserId", params.get("userId"));
			saveParam.put("callCrtUserIdDept", 0);
			saveParam.put("callHcId", 0);
			saveParam.put("callRosAmt", 0);
			saveParam.put("callSms", 0);
			saveParam.put("callSmsRem", " ");
			orderSuspensionMapper.insertCCR0007DSuspend(saveParam);

			EgovMap newSuspendSearch2 = orderSuspensionMapper.newSuspendSearch2(saveParam);
			saveParam.put("stusCodeId", params.get("newSuspResultStus"));
			saveParam.put("resultId", getCallResultIdMaxSeq);
			saveParam.put("updUserId", params.get("userId"));
			orderSuspensionMapper.updateCCR0006DSuspend(saveParam);
			saveParam.put("susId", params.get("susId"));
			orderSuspensionMapper.updateSAL0096DSuspend(saveParam);

		}if(saveStatus == 28){	// 28번은 Regular. 프로시저 오류로 일단 막아둠.
			// getOderOutsInfo 프로시저 현재 오류.. 수정되면 적용해야함.
			saveRagularParam.put("ORD_ID", params.get("ordId"));
			membershipQuotationMapper.getOderOutsInfo(saveRagularParam);
			EgovMap spOrdInfo = (EgovMap) ((ArrayList)saveRagularParam.get("p1")).get(0);
			EgovMap newSuspendSearch1 = orderSuspensionMapper.newSuspendSearch1(params);
			int getCallResultIdMaxSeq = orderExchangeMapper.getCallResultIdMaxSeq();
			saveRagularParam.put("getCallResultIdMaxSeq", getCallResultIdMaxSeq);
			saveRagularParam.put("callEntryId", newSuspendSearch1.get("callEntryId"));
			saveRagularParam.put("callStusId", params.get("newSuspResultStus"));
			saveRagularParam.put("callDt", SalesConstants.DEFAULT_DATE);
			saveRagularParam.put("callActnDt", SalesConstants.DEFAULT_DATE);
			saveRagularParam.put("callFdbckId", 0);
			saveRagularParam.put("callCtId", 0);
			saveRagularParam.put("callRem", params.get("newSuspResultRem"));
			saveRagularParam.put("callCrtUserId", params.get("userId"));
			saveRagularParam.put("callCrtUserIdDept", 0);
			saveRagularParam.put("callHcId", 0);
			saveRagularParam.put("callRosAmt", 0);
			saveRagularParam.put("callSms", 0);
			saveRagularParam.put("callSmsRem", " ");
			orderSuspensionMapper.insertCCR0007DSuspend(saveRagularParam);

			saveRagularParam.put("stusCodeId", params.get("newSuspResultStus"));
			saveRagularParam.put("resultId", getCallResultIdMaxSeq);
			saveRagularParam.put("updUserId", params.get("userId"));
			orderSuspensionMapper.updateCCR0006DSuspend(saveRagularParam);

			EgovMap rentalSchemeInfo = orderInvestMapper.saveCallResultSearchFourth(saveRagularParam);

			saveRagularParam.put("userId", params.get("userId"));
			orderSuspensionMapper.spInsertOrderReactiveFees(saveRagularParam);

			saveRagularParam.put("rentalSchemeStusId", "REG");
			saveRagularParam.put("renSchId", rentalSchemeInfo.get("renSchId"));
			orderInvestMapper.updateSAL0071D(saveRagularParam);

			NumberFormat format = NumberFormat.getInstance(Locale.US);
			Number amt = null;
			try {
				amt = format.parse((String) spOrdInfo.get("ordUnbillAmt"));
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			saveRagularParam.put("susId", params.get("susId"));
			saveRagularParam.put("rafAmt", amt);
			saveRagularParam.put("billMonth", currMonth);
			saveRagularParam.put("billYear", currYear);
			saveRagularParam.put("lastBillInstNo", spOrdInfo.get("lastBillMth"));
			saveRagularParam.put("currBillInstNo", spOrdInfo.get("currBillMth"));
			orderSuspensionMapper.updateAmtSAL0096D(saveRagularParam);

			saveRagularParam.put("salesOrdId", params.get("ordId"));
			saveRagularParam.put("prgrsId", 5);
			saveRagularParam.put("refId", 0);
			saveRagularParam.put("isLok", 0);
			orderInvestMapper.insertSalesOrdLog(saveRagularParam);
		}

	}

}
