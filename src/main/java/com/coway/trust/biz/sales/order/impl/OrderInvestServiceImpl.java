package com.coway.trust.biz.sales.order.impl;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.sales.order.OrderInvestService;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("orderInvestService")
public class OrderInvestServiceImpl extends EgovAbstractServiceImpl implements OrderInvestService{

	private static final Logger logger = LoggerFactory.getLogger(OrderInvestServiceImpl.class);
	
	@Resource(name = "orderInvestMapper")
	private OrderInvestMapper orderInvestMapper;
	
	@Resource(name = "orderSuspensionMapper")
	private OrderSuspensionMapper orderSuspensionMapper;
	
	@Resource(name = "orderExchangeMapper")
	private OrderExchangeMapper orderExchangeMapper;
	
	@Autowired
	private MessageSourceAccessor messageSourceAccessor;
	
	
	/**
	 * 글 목록을 조회한다.
	 * 
	 * @param OrderInvestVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	@Override
	public List<EgovMap> orderInvestList(Map<String, Object> params) {
		return orderInvestMapper.orderInvestigationList(params);
	}
	
	
	/**
	 * 상세화면 조회한다.(Basic Info)
	 * @param 
	 * @return 
	 * @exception Exception
	 * @author 이석희 2017.07.20
	 */
	@Override
	public EgovMap orderInvestInfo(Map<String, Object> params) throws Exception{
		
		return orderInvestMapper.orderInvestInfo(params);
	}
	
	
	/**
	 * 상세화면 customer info
	 * @param 
	 * @return 
	 * @exception Exception
	 * @author 이석희 2017.07.20
	 */
	@Override
	public EgovMap orderCustomerInfo(Map<String, Object> params) throws Exception{
		
		return orderInvestMapper.orderCustomerInfo(params);
	}
	
	
	/**
	 * 글 목록을 조회한다.
	 * 
	 * @param OrderInvestVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	public List<EgovMap> orderInvestInfoGrid(Map<String, Object> params) {
		return orderInvestMapper.orderInvestInfoGrid(params);
	}
	
	/**
	 * Investigation Reject Reason combo box
	 * 
	 * @param OrderInvestVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	public List<EgovMap> cmbRejReasonList(Map<String, Object> params) {
		return orderInvestMapper.cmbRejReasonList(params);
	}
	
	
	/**
	 * Investigation Reject Reason combo box
	 * 
	 * @param OrderInvestVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	public List<EgovMap> inchargeList(Map<String, Object> params) {
		return orderInvestMapper.inchargeList(params);
	}
	
	
	/**
	 * Investigation Reject Reason combo box
	 * 
	 * @param OrderInvestVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	public int orderInvestClosedDateChk() {
		return orderInvestMapper.orderInvestClosedDateChk();
	}
	
	
	/**
	 * 상세화면 조회한다.(Single Investigation Request)
	 * @param 
	 * @return 
	 * @exception Exception
	 * @author 이석희 2017.07.20
	 */
	@Override
	public EgovMap orderNoChk(Map<String, Object> params) throws Exception{
		
		return orderInvestMapper.orderNoChk(params);
	}

	
	@Override
	public EgovMap orderNoInfo(Map<String, Object> params) throws Exception{
		
		return orderInvestMapper.orderNoInfo(params);
	}

	
	@Override
	public EgovMap singleInvestView(Map<String, Object> params) throws Exception{
		
		return orderInvestMapper.singleInvestView(params);
	}
	
	
	@Override
	public void insertNewRequestSingleOk(Map<String, Object> params) throws Exception{
		
		Map<String, Object> insertMap = new HashMap<String, Object>();
		
		//put Code Id = 73
		insertMap.put("docNoId", SalesConstants.INVEST_CODEID	);
		String docNo = "";
		docNo = orderInvestMapper.getDocNo(insertMap);
		
		// parameter setting (investigationM)
		String targetFolder = "~/WebShare/Investigation/";
		String filename = "InvesNo_" + docNo + ".zip";
		params.put("invReqNo", docNo);
		params.put("soId", params.get("salesOrdNo"));
		params.put("invReqStusId", 1);
		params.put("invReqPartyId", 770);
//		params.put("invReqRem", params.get("invReqRem"));
//		params.put("invReqCrtUserId", params.get("userId"));
//		params.put("invReqUpdUserId", params.get("userId"));
		params.put("invReqUserIdAuto", 0);
//		params.put("callDt", docNo);
//		params.put("visitDt", docNo);
		params.put("invReqTypeId", params.get("cmbInvType"));
		params.put("invReqHasAttach", params.get("attachInvest") != null ? "1" : "0");
		params.put("invReqAttachFile", targetFolder + filename);
		params.put("invReqRejctResnId", 0);
		
		// parameter setting (investigationM)
		params.put("prgrsId", 8);
		params.put("refId", 0);
		params.put("isLok", 1);
		orderInvestMapper.insertInvestReqM(params);
		
		orderInvestMapper.insertSalesOrdLog(params);
		
	}
	
	
	@Override
	public int searchBSScheduleM(Map<String, Object> params) throws Exception{
		
		return orderInvestMapper.searchBSScheduleM(params);
	}
	
	
	@Override
	public void saveOrderInvestOk(Map<String, Object> params) throws Exception{
		
		
		// parameter setting (investigationM)
		params.put("invReqStusParam", params.get("statusPop") == "6" ? params.get("cmbRejReason") : "0");
		
		orderInvestMapper.updateInvestReqM(params);
		orderInvestMapper.insertInvestigateReqD(params);
		
		if(params.get("statusPop") == "5"){
			// parameter setting (Log)
			params.put("prgrsId", 9);
			params.put("refId", 0);
			params.put("isLok", 1);
			
			orderInvestMapper.insertSalesOrdLog(params);
		}else if(params.get("statusPop") == "6"){
			// parameter setting (Log)
			params.put("prgrsId", 5);
			params.put("refId", 0);
			params.put("isLok", 0);
			orderInvestMapper.insertSalesOrdLog(params);
		}
		
	}
	
	
	/**
	 * Investigation Investigation Call/Result Search
	 * 
	 * @param OrderInvestVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	@Override
	public List<EgovMap> orderInvestCallRecallList(Map<String, Object> params) {
		return orderInvestMapper.orderInvestCallRecallList(params);
	}
	
	
	@Override
	public EgovMap investCallResultInfo(Map<String, Object> params) throws Exception{
		
		return orderInvestMapper.investCallResultInfo(params);
	}

	
	@Override
	public EgovMap investCallResultCust(Map<String, Object> params) throws Exception{
		
		return orderInvestMapper.investCallResultCust(params);
	}
	
	
	@Override
	public List<EgovMap> investCallResultLog(Map<String, Object> params) {
		return orderInvestMapper.investCallResultLog(params);
	}
	
	
	@Override
	public void saveCallResultOk(Map<String, Object> params) throws Exception{
		
		EgovMap getInvId = orderInvestMapper.saveCallResultSearchFirst(params);
		params.put("salesOrdId", getInvId.get("salesOrdId"));
		
		// parameter setting (investigationM)
		params.put("callEntryId", getInvId.get("invCallEntryId"));
		params.put("callStusId", 1);
		params.put("callFdbckId", 0);
		params.put("callCtId", 0);
		params.put("callRem", params.get("callResultSusRem"));
		//params.put("callCrtUserId", params.get("userId"));
		params.put("callCrtUserId", 999999);
		params.put("callCrtUserIdDept", 0);
		params.put("callHcId", 0);
		params.put("callRosAmt", 0);
		params.put("callSms", 0);
		params.put("callSmsRem", " ");
		//params.put("updUserId", params.get("userId"));
		params.put("updUserId", 999999);
		
		orderSuspensionMapper.insertCCR0007DSuspend(params);
		
		EgovMap callEntry = orderInvestMapper.saveCallResultSearchSecond(params);
		
		EgovMap callResult = orderInvestMapper.saveCallResultSearchThird(params);
		params.put("resultId", callResult.get("callResultId"));
		
		orderExchangeMapper.updateCCR0006D(params);
		
		if(params.get("callResultStus") == "28"){
			EgovMap rentalSchemeInfo = orderInvestMapper.saveCallResultSearchFourth(params);
			params.put("renSchId", rentalSchemeInfo.get("renSchId"));
			params.put("rentalSchemeStusId", "REG");
			orderInvestMapper.updateSAL0071D(params);
			
			EgovMap investigateInfo = orderInvestMapper.saveCallResultSearchFifth(params);
			orderInvestMapper.updateSAL0049D(params);
			
			
			params.put("prgrsId", 5);
			params.put("refId", 0);
			params.put("isLok", 0);
			orderInvestMapper.insertSalesOrdLog(params);
		}
	}
	
	@Override
	public String bsMonthCheck(Map<String, Object> params) throws Exception{
		int BSStatusID = 0;
        int BSFailReasonID = 0;
        String hidIsBSMonth = null;
		
        EgovMap getInvId = orderInvestMapper.saveCallResultSearchFirst(params);
        
        params.put("salesOrdId", getInvId.get("salesOrdId"));
		
		if(params.get("callResultStus") == "28"){
			
			EgovMap getBSMonth = orderInvestMapper.getBSMonth(params);
			
			if(getBSMonth != null){
				BSStatusID = (int)getBSMonth.get("stusCodeId");
                BSFailReasonID = (int)getBSMonth.get("failResnId");
			}
			
			if (BSStatusID == 1 || BSStatusID == 4 || BSStatusID == 21) {
				hidIsBSMonth = "0";
            } else if (BSStatusID == 10 && BSFailReasonID == 1770) {
            	hidIsBSMonth = "1";
            } else if (BSStatusID == 10 && BSFailReasonID != 1770) {
            	hidIsBSMonth = "0";
            } else {
            	EgovMap getBSScheduleStusCodeId = orderInvestMapper.getBSScheduleStusCodeId(params);
            	if(getBSScheduleStusCodeId != null){
            		
            		int CheckExistLastBSStatusID = (int)getBSScheduleStusCodeId.get("stusCodeId");
            		
            		if(CheckExistLastBSStatusID == 21){
            			hidIsBSMonth = "1";
            		}else if(CheckExistLastBSStatusID == 0){
            			EgovMap monthYearChk = orderInvestMapper.monthYearChk(params);
            			params.put("EX_YYYY", monthYearChk.get("year"));
            			params.put("EX_MM", monthYearChk.get("month"));
            			int monthBetweenCnt = orderInvestMapper.monthBetween(params);
            			
            			// Visual Studio -- module.GetServiceViewByOrderID 로직하기.
            			
            			String todayYY = new SimpleDateFormat("yyyy").format(new Date());
            			String todayMM = new SimpleDateFormat("mm").format(new Date());
            			
            		}
            		
            	}
            	
            }
			
		}
		
		return hidIsBSMonth;
	}
}
