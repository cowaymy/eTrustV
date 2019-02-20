package com.coway.trust.biz.sales.order.impl;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
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
import org.springframework.util.StringUtils;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.sales.mambership.impl.MembershipRSMapper;
import com.coway.trust.biz.sales.order.OrderInvestService;
import com.coway.trust.util.CommonUtils;
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

	@Resource(name = "orderCancelMapper")
	private OrderCancelMapper orderCancelMapper;

	@Resource(name = "membershipRSMapper")
	private MembershipRSMapper membershipRSMapper;

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
	public EgovMap orderInvestInfo(Map<String, Object> params)  {

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
	public EgovMap orderCustomerInfo(Map<String, Object> params) {

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
	public EgovMap orderNoChk(Map<String, Object> params) {

		return orderInvestMapper.orderNoChk(params);
	}


	@Override
	public EgovMap orderNoInfo(Map<String, Object> params) {

		return orderInvestMapper.orderNoInfo(params);
	}


	@Override
	public EgovMap singleInvestView(Map<String, Object> params) {

		return orderInvestMapper.singleInvestView(params);
	}


	@Override
	public void insertNewRequestSingleOk(Map<String, Object> params) {

		Map<String, Object> insertMap = new HashMap<String, Object>();

		//put Code Id = 73
		insertMap.put("docNoId", SalesConstants.INVEST_CODEID	);
		String docNo = "";
		docNo = orderInvestMapper.getDocNo(insertMap);

//		int invReqId = orderInvestMapper.seqSAL0050D();


		logger.debug("##### callDt #####" +params.toString());

		// parameter setting (investigationM)
		String targetFolder = "~/WebShare/Investigation/";
		String filename = "InvesNo_" + docNo + ".zip";
//		params.put("seqSAL0050D", invReqId);
		params.put("invReqNo", docNo);
		params.put("soId", params.get("salesOrdId"));
		params.put("invReqStusId", 1);
		params.put("invReqPartyId", 770);
//		params.put("invReqRem", params.get("invReqRem"));
//		params.put("invReqCrtUserId", params.get("userId"));
//		params.put("invReqUpdUserId", params.get("userId"));
		params.put("invReqUserIdAuto", 0);
		params.put("invReqTypeId", params.get("cmbInvType"));
		//params.put("invReqHasAttach", params.get("attachInvest") != null ? "1" : "0");
		params.put("invReqHasAttach", params.get("atchFileGrpId").toString().isEmpty() ? 0 : params.get("atchFileGrpId"));
		params.put("invReqAttachFile", params.get("atchFileGrpId").toString().isEmpty() ? null : targetFolder + filename);
		params.put("invReqRejctResnId", 0);

		// parameter setting (SalesOrderLog)
		params.put("prgrsId", 8);
		params.put("refId", 0);
		params.put("isLok", 1);
		orderInvestMapper.insertInvestReqM(params);

		orderInvestMapper.insertSalesOrdLog(params);

	}


	@Override
	public int searchBSScheduleM(Map<String, Object> params){

		return orderInvestMapper.searchBSScheduleM(params);
	}


	@Override
	public void saveOrderInvestOk(Map<String, Object> params) {


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
	public EgovMap investCallResultInfo(Map<String, Object> params) {

		return orderInvestMapper.investCallResultInfo(params);
	}


	@Override
	public EgovMap investCallResultCust(Map<String, Object> params){

		return orderInvestMapper.investCallResultCust(params);
	}


	@Override
	public List<EgovMap> investCallResultLog(Map<String, Object> params) {
		return orderInvestMapper.investCallResultLog(params);
	}


	@Override
	public void saveCallResultOk(Map<String, Object> params){

		Map<String, Object> saveParam = new HashMap<String, Object>();
		saveParam.put("salesOrdId", params.get("saveSalesOrdId"));
		saveParam.put("userId", params.get("userId"));
		// INV : 29, REG : 28, SUS : 2
		int callResultStus = Integer.parseInt((String)params.get("callResultStus"));

		//INV, REG, SUS 공통
			int getCallResultIdMaxSeq = orderExchangeMapper.getCallResultIdMaxSeq();
			saveParam.put("getCallResultIdMaxSeq", getCallResultIdMaxSeq);
			saveParam.put("callEntryId", params.get("invCallEntryId"));
			saveParam.put("callStusId", 1);
			saveParam.put("callDt", SalesConstants.DEFAULT_DATE);
			saveParam.put("callActnDt", SalesConstants.DEFAULT_DATE);
			saveParam.put("callFdbckId", 0);
			saveParam.put("callCtId", 0);
			saveParam.put("callRem", params.get("callResultSusRem"));
			saveParam.put("callCrtUserId", params.get("userId"));
			saveParam.put("callCrtUserIdDept", 0);
			saveParam.put("callHcId", 0);
			saveParam.put("callRosAmt", 0);
			saveParam.put("callSms", 0);
			saveParam.put("callSmsRem", " ");
			saveParam.put("updUserId", params.get("userId"));
			orderExchangeMapper.insertCCR0007D(saveParam);	// Call Result

			EgovMap callEntry = orderInvestMapper.saveCallResultSearchSecond(saveParam);

			EgovMap callResult = orderInvestMapper.saveCallResultSearchThird(saveParam);
			saveParam.put("resultId", callResult.get("callResultId"));

			saveParam.put("soExchgUpdUserId", params.get("userId"));
			saveParam.put("soExchgNwCallEntryId", params.get("invCallEntryId"));
			orderExchangeMapper.updateCCR0006D(saveParam);	//Call Entry
		//INV, REG, SUS 공통

		if(callResultStus == 2){//SUS
			EgovMap rentalSchemeInfo = orderInvestMapper.saveCallResultSearchFourth(saveParam);
			saveParam.put("renSchId", rentalSchemeInfo.get("renSchId"));
			saveParam.put("rentalSchemeStusId", "SUS");
			orderInvestMapper.updateSAL0071D(saveParam);	//RentalScheme

			saveParam.put("callResultInvId", params.get("callResultInvId"));
			EgovMap investigateInfo = orderInvestMapper.saveCallResultSearchFifth(saveParam);
			saveParam.put("callResultStus", callResultStus);
			orderInvestMapper.updateSAL0049D(params);

			saveParam.put("docNoId", 77);
			String getDocId = orderInvestMapper.getDocNo(saveParam);

			int getSusIdSeq = orderInvestMapper.getSusIdSeq();

			saveParam.put("getSusIdSeq", getSusIdSeq);
			saveParam.put("susStusId", 33);
			saveParam.put("susCallEntryId", 0);
			saveParam.put("refAmt", 0);
			saveParam.put("susNo", getDocId);
			saveParam.put("susLastBillMonth", 0);
			saveParam.put("susLastBillYear", 0);
			saveParam.put("susLastBillNo", 0);
			saveParam.put("susCurrBillInstNo", 0);
			saveParam.put("susFromFb", 0);
			orderInvestMapper.insertSusSAL0096D(saveParam);

			int getSusInPersonIdSeq = orderInvestMapper.getSusInPersonIdSeq();
			saveParam.put("getSusInPersonIdSeq", getSusInPersonIdSeq);
			saveParam.put("susInPersonStusId", 1);
			saveParam.put("susUserId", params.get("inchargeNm"));
			orderInvestMapper.insertSusSAL0097D(saveParam);

			int getCallEntryIdMaxSeq = orderExchangeMapper.getCallEntryIdMaxSeq();
			saveParam.put("getCallEntryIdMaxSeq", getCallEntryIdMaxSeq);
			saveParam.put("typeId", 767);
			saveParam.put("stusCodeId", 33);
			saveParam.put("resultId", 0);
			saveParam.put("docId", getSusIdSeq);
			saveParam.put("isWaitForCancl", 0);
			saveParam.put("hapyCallerId", null);
			saveParam.put("callDt", SalesConstants.DEFAULT_DATE);
			saveParam.put("callActnDt", SalesConstants.DEFAULT_DATE);
			saveParam.put("callCrtUserId", params.get("userId"));
			orderCancelMapper.insertCancelCCR0006D(saveParam);

			EgovMap CCR0006DInfo = orderInvestMapper.callResultSearchCCR0006D(saveParam);
			saveParam.put("infoCallEntryId", CCR0006DInfo.get("callEntryId"));
			orderInvestMapper.updateEntIdSAL0096D(saveParam);


			int getCallResultIdMaxSeq2 = orderExchangeMapper.getCallResultIdMaxSeq();
			saveParam.put("getCallResultIdMaxSeq", getCallResultIdMaxSeq2);
			saveParam.put("callEntryId", CCR0006DInfo.get("callEntryId"));
			saveParam.put("callStusId", 33);
			saveParam.put("callDt", SalesConstants.DEFAULT_DATE);
			saveParam.put("callActnDt", SalesConstants.DEFAULT_DATE);
			saveParam.put("callFdbckId", 0);
			saveParam.put("callCtId", 0);
			saveParam.put("callRem", params.get("callResultSusRem"));
			saveParam.put("callCrtUserId", params.get("userId"));
			saveParam.put("callCrtUserIdDept", 0);
			saveParam.put("callHcId", 0);
			saveParam.put("callRosAmt", 0);
			saveParam.put("callSms", 0);
			saveParam.put("callSmsRem", " ");
			saveParam.put("updUserId", params.get("userId"));
			orderExchangeMapper.insertCCR0007D(saveParam);

			saveParam.put("prgrsId", 10);
			saveParam.put("refId", 0);
			saveParam.put("isLok", 1);
			orderInvestMapper.insertSalesOrdLog(saveParam);
		}else if(callResultStus == 28){//REG
			EgovMap rentalSchemeInfo = orderInvestMapper.saveCallResultSearchFourth(saveParam);
			saveParam.put("renSchId", rentalSchemeInfo.get("renSchId"));
			saveParam.put("rentalSchemeStusId", "REG");
			orderInvestMapper.updateSAL0071D(saveParam);	//RentalScheme

			//ticket null이 아니면 해야하는 로직이 있는것 같음. null인 데이터만 있어서 못함.
			//EgovMap ticketInfo = orderInvestMapper.callResultSearchCCTicket(saveParam);

			saveParam.put("callResultInvId", params.get("callResultInvId"));
			EgovMap investigateInfo = orderInvestMapper.saveCallResultSearchFifth(saveParam);
			saveParam.put("callResultStus", callResultStus);
			orderInvestMapper.updateSAL0049D(params);

			saveParam.put("prgrsId", 5);
			saveParam.put("refId", 0);
			saveParam.put("isLok", 0);
			orderInvestMapper.insertSalesOrdLog(saveParam);
		}


	}

	@Override
	public int bsMonthCheck(Map<String, Object> params) {
		int BSStatusID = 0;
        int BSFailReasonID = 0;
        int hidIsBSMonth = 0;

        Calendar cal = Calendar.getInstance();
        SimpleDateFormat transFormatYY = new SimpleDateFormat("yyyymmdd");
        String ddMMCurDate =  transFormatYY.format(new Date());


        EgovMap getInvId = orderInvestMapper.saveCallResultSearchFirst(params);

        params.put("salesOrdId", getInvId.get("salesOrdId"));

		if(params.get("callResultStus") == "28"){

			EgovMap getBSMonth = orderInvestMapper.getBSMonth(params);

			if(getBSMonth != null){
				BSStatusID = (int)getBSMonth.get("stusCodeId");
                BSFailReasonID = (int)getBSMonth.get("failResnId");
			}

			if (BSStatusID == 1 || BSStatusID == 4 || BSStatusID == 21) {
				hidIsBSMonth = 0;
            } else if (BSStatusID == 10 && BSFailReasonID == 1770) {
            	hidIsBSMonth = 1;
            } else if (BSStatusID == 10 && BSFailReasonID != 1770) {
            	hidIsBSMonth = 0;
            } else {
            	EgovMap getBSScheduleStusCodeId = orderInvestMapper.getBSScheduleStusCodeId(params);
            	if(getBSScheduleStusCodeId != null){

            		int CheckExistLastBSStatusID = (int)getBSScheduleStusCodeId.get("stusCodeId");

            		if(CheckExistLastBSStatusID == 21){
            			hidIsBSMonth = 1;
            		}else if(CheckExistLastBSStatusID == 0){
            			EgovMap monthYearChk = orderInvestMapper.monthYearChk(params);
            			String srvStartDt = (String)monthYearChk.get("srvStartDt");
            			String srvExprDt = (String)monthYearChk.get("srvExprDt");
            			if(srvStartDt != null && srvExprDt != null){
            				String srvStartDtre = srvStartDt.substring(1,4) + srvStartDt.substring(6, 7) + srvStartDt.substring(9, 10);
            				String srvExprDtre = srvExprDt.substring(1,4) + srvExprDt.substring(6, 7) + srvExprDt.substring(9, 10);
            				if((Integer.parseInt(srvStartDtre) <= Integer.parseInt(ddMMCurDate))&&(Integer.parseInt(srvExprDtre) >= Integer.parseInt(ddMMCurDate))){
            					hidIsBSMonth = 1;
            				}
            			}
            		}else{
            			EgovMap monthYearChk = orderInvestMapper.monthYearChk(params);
            			String srvStartDt = (String)monthYearChk.get("srvStartDt");
            			String srvExprDt = (String)monthYearChk.get("srvExprDt");
            			String srvFreq = (String)monthYearChk.get("srvFreq");
            			String year = (String)monthYearChk.get("year");
            			String month = (String)monthYearChk.get("month");

            			params.put("EX_YYYY", monthYearChk.get("year"));
            			params.put("EX_MM", monthYearChk.get("month"));

            			int monthBetweenCnt = orderInvestMapper.monthBetween(params);

            			if(srvStartDt != null && srvExprDt != null){
            				String srvStartDtre = srvStartDt.substring(1,4) + srvStartDt.substring(6, 7) + srvStartDt.substring(9, 10);
            				String srvExprDtre = srvExprDt.substring(1,4) + srvExprDt.substring(6, 7) + srvExprDt.substring(9, 10);
            				String srvFreqre = srvFreq.substring(1,4) + srvFreq.substring(6, 7) + srvFreq.substring(9, 10);
            				if((Integer.parseInt(srvStartDtre) <= Integer.parseInt(ddMMCurDate))&&(Integer.parseInt(srvExprDtre) >= Integer.parseInt(ddMMCurDate)) && (Integer.parseInt(srvFreqre) >= (Integer.parseInt(year)+ Integer.parseInt(month)+01)) ){
            					hidIsBSMonth = 1;
            				}
            			}
            		}

            	}

            }

		}

		return hidIsBSMonth;
	}


	@Override
	public void saveInvest(Map<String, Object> params) {

		int studId = 0;	// Pending : 44, Approve : 5, reject : 6
		if((String)params.get("statusPop") != null && !"".equals((String)params.get("statusPop")) ){
			studId = Integer.parseInt((String)params.get("statusPop"));
		}

		Map<String, Object> saveInvestMap = new HashMap<String, Object>();
		saveInvestMap.put("userId", params.get("userId"));
		saveInvestMap.put("callCrtUserId", params.get("userId"));
		//active
		//Pendig
		saveInvestMap.put("statusPop", studId);
		saveInvestMap.put("gridInvReqId", params.get("gridInvReqId"));
		saveInvestMap.put("statusRem", params.get("statusRem"));
		saveInvestMap.put("salesOrdId", params.get("salesOrdId"));

		String cancelBsChk = (String)params.get("cancelBsChk");

		if(studId == 44){
			orderInvestMapper.updatePendingInvestReqM(saveInvestMap);
			orderInvestMapper.insertInvestigateReqD(saveInvestMap);
		}else if(studId == 5){
			int searchBSScheduleMCnt = orderInvestMapper.searchBSScheduleM(saveInvestMap);

			orderInvestMapper.updatePendingInvestReqM(saveInvestMap);
			orderInvestMapper.insertInvestigateReqD(saveInvestMap);

			saveInvestMap.put("docNoId", 74);
			String getDocId = orderInvestMapper.getDocNo(saveInvestMap);	//INV1134256

			saveInvestMap.put("invNo", getDocId);
			saveInvestMap.put("invStusId", 1);
			if(searchBSScheduleMCnt == 0){
				saveInvestMap.put("invToCanclActBs", 0);
			}else{
				saveInvestMap.put("invToCanclActBs", 1);
			}
			EgovMap getBSScheduleStusCodeId = orderInvestMapper.getBSScheduleStusCodeId(saveInvestMap);
			saveInvestMap.put("invCanclBsSchdulId", getBSScheduleStusCodeId.get("schdulId"));
			saveInvestMap.put("invToActvtBs", 0);
			saveInvestMap.put("invReqTicketId", 0);
			saveInvestMap.put("invCallEntryId", 0);
			saveInvestMap.put("invDtAuto", 0);
			String seqSAL0049D = orderInvestMapper.seqSAL0049D();
			saveInvestMap.put("seqSAL0049D", seqSAL0049D);
			orderInvestMapper.insertInvestigate(saveInvestMap);

			saveInvestMap.put("invReqId", params.get("gridInvReqId"));
			EgovMap saveSearchSAL0049D = orderInvestMapper.saveSearchSAL0049D(saveInvestMap);
			String seqSAL0052D = orderInvestMapper.seqSAL0052D();
			saveInvestMap.put("inchargeNmId", params.get("inchargeNmId"));
			saveInvestMap.put("invInPersonStusId", 1);
			saveInvestMap.put("invEntryId", saveSearchSAL0049D.get("invId"));
			saveInvestMap.put("seqSAL0052D", seqSAL0052D);
			orderInvestMapper.insertInvestInchargePerson(saveInvestMap);

			saveInvestMap.put("typeId", 766);
			saveInvestMap.put("stusCodeId", 1);
			saveInvestMap.put("resultId", 0);
			saveInvestMap.put("docId", saveSearchSAL0049D.get("invId"));
			saveInvestMap.put("callDt", SalesConstants.DEFAULT_DATE);
			saveInvestMap.put("isWaitForCancl", 0);
			saveInvestMap.put("hapyCallerId", params.get("userId"));
			int getCallEntryIdMaxSeq = orderExchangeMapper.getCallEntryIdMaxSeq();
			saveInvestMap.put("getCallEntryIdMaxSeq", getCallEntryIdMaxSeq);
			orderCancelMapper.insertCancelCCR0006D(saveInvestMap);

			EgovMap getCallEntryId = orderInvestMapper.saveSearchCCR0006DdocId(saveInvestMap);
			saveInvestMap.put("invCallEntryId", getCallEntryId.get("callEntryId"));
			saveInvestMap.put("invId", saveSearchSAL0049D.get("invId"));
			orderInvestMapper.updateSAL0049DEntryId(saveInvestMap);

			int getCallResultIdMaxSeq = orderExchangeMapper.getCallResultIdMaxSeq();
			saveInvestMap.put("getCallResultIdMaxSeq", getCallResultIdMaxSeq);
			saveInvestMap.put("soExchgNwCallEntryId", getCallEntryId.get("callEntryId"));
			saveInvestMap.put("callStusId", 1);
			saveInvestMap.put("callActnDt", SalesConstants.DEFAULT_DATE);
			saveInvestMap.put("callFdbckId", 0);
			saveInvestMap.put("callCtId", 0);
			saveInvestMap.put("callRem", params.get("statusRem"));
			saveInvestMap.put("callCrtUserId", params.get("userId"));
			saveInvestMap.put("callCrtUserIdDept", 0);
			saveInvestMap.put("callHcId", 0);
			saveInvestMap.put("callRosAmt", 0);
			saveInvestMap.put("callSms", 0);
			saveInvestMap.put("callSmsRem", "");
			orderExchangeMapper.insertCCR0007D(saveInvestMap);	//CallResult

			saveInvestMap.put("callEntryId", getCallEntryId.get("callEntryId"));
			EgovMap getCallResultId = orderInvestMapper.saveCallResultSearchThird(saveInvestMap);
			saveInvestMap.put("resultId", getCallResultId.get("callResultId"));
			saveInvestMap.put("getCallEntryIdMaxSeq", getCallEntryId.get("callEntryId"));
			orderExchangeMapper.updateResultIdCCR0006D(saveInvestMap);

			EgovMap getRentalScheme = orderInvestMapper.saveCallResultSearchFourth(saveInvestMap);
			saveInvestMap.put("renSchId", getRentalScheme.get("renSchId"));
			saveInvestMap.put("rentalSchemeStusId", "INV");
			orderInvestMapper.updateSAL0071D(saveInvestMap);

			saveInvestMap.put("prgrsId", 9);
			saveInvestMap.put("isLok", 1);
			saveInvestMap.put("refId", 0);
			orderInvestMapper.insertSalesOrdLog(saveInvestMap);

		}else if(studId == 6){
			saveInvestMap.put("invReqStusParam", params.get("cmbRejReason"));
			orderInvestMapper.updateInvestReqM(saveInvestMap);
			orderInvestMapper.insertInvestigateReqD(saveInvestMap);

			saveInvestMap.put("prgrsId", 5);
			saveInvestMap.put("isLok", 0);
			saveInvestMap.put("refId", 0);
			orderInvestMapper.insertSalesOrdLog(saveInvestMap);

			int searchBSScheduleMCnt = orderInvestMapper.searchBSScheduleM(saveInvestMap);

			if("true".equals(cancelBsChk) && searchBSScheduleMCnt > 0){
				EgovMap getBSScheduleId = orderInvestMapper.getBSScheduleId(saveInvestMap);
				saveInvestMap.put("schdulId", getBSScheduleId.get("schdulId"));
				saveInvestMap.put("stusCodeId", 10);
				orderInvestMapper.updateSVC0008DBSSchd(saveInvestMap);

				saveInvestMap.put("docNoId", 11);
				String getDocIdRej = orderInvestMapper.getDocNo(saveInvestMap);	//INV1134256
				String seqSVC0006D = orderInvestMapper.seqSVC0006D();
				saveInvestMap.put("seqSVC0006D", seqSVC0006D);
				saveInvestMap.put("bsNo", getDocIdRej);
				saveInvestMap.put("typeId", 306);
				saveInvestMap.put("codyId", 0);
				saveInvestMap.put("setlDt", SalesConstants.DEFAULT_DATE);
				saveInvestMap.put("resultStusCodeId", 10);
				saveInvestMap.put("failResnId", 1770);
				saveInvestMap.put("renColctId", 0);
				saveInvestMap.put("whId", 0);
				saveInvestMap.put("resultRem", "ORDER TO INVESTIGATE");
				saveInvestMap.put("resultIsSync", 0);
				saveInvestMap.put("resultIsEdit", 0);
				saveInvestMap.put("resultStockUse", 0);
				saveInvestMap.put("resultIsCurr", 1);		// setting - query profiler
				saveInvestMap.put("resultMtchId", 0);		// setting - query profiler
				saveInvestMap.put("resultIsAd", 0);			// setting - query profiler
				orderInvestMapper.insertSVC0006DBSSchd(saveInvestMap);

				String seqSVC0007D = orderInvestMapper.seqSVC0007D();
				EgovMap saveSearchSVC0006D = orderInvestMapper.saveSearchSVC0006D(saveInvestMap);
				saveInvestMap.put("seqSVC0007D", seqSVC0007D);
				saveInvestMap.put("bsResultId", saveSearchSVC0006D.get("resultId"));
				saveInvestMap.put("bsResultPartId", 0);
				saveInvestMap.put("bsResultPartDesc", "");
				saveInvestMap.put("bsResultPartQty", 0);
				saveInvestMap.put("bsResultRem", "ORDER TO INVESTIGATE");
				saveInvestMap.put("bsResultFilterClm", 0);
				orderInvestMapper.insertSVC0007DBSSchd(saveInvestMap);
			}

		}

	}


	public int seqSAL0050D(){
		int seqSAL0050D = orderInvestMapper.seqSAL0050D();
		return seqSAL0050D;
	};


	@Override
	public Map<String, Object> chkNewFileList(Map<String, Object> params) {

		List<Object> list = (List<Object>) params.get(AppConstants.AUIGRID_ALL);
		Map<String, Object> formData =  (Map<String, Object>) params.get("form");

		EgovMap result = new EgovMap();

		String msg = null;

		Map<String, Object> rtnmap =new HashMap<String, Object>();

		List<Object> checkList = new ArrayList<Object>();

		for (Object obj : list)
		{
			((Map<String, Object>) obj).put("userId", params.get("userId"));
			((Map<String, Object>) obj).put("userFullname", params.get("userFullname"));

			logger.debug(" OrderNo : {}", ((Map<String, Object>) obj).get("0"));
			params.put("salesOrdNo", ((Map<String, Object>) obj).get("0"));

			Date date = new Date();

			if(!StringUtils.isEmpty(params.get("salesOrdNo"))){
				((Map<String, Object>) obj).put("salesOrdNo",  ((Map<String, Object>) obj).get("0"));

				int batchOrderREGChk = orderInvestMapper.batchOrderREGChk(params);
				if(batchOrderREGChk == 0){
					rtnmap.put("regMsg", "* Only REGULAR rental order is allow to request for investigation.  -  " + ((Map<String, Object>) obj).get("0"));
					rtnmap.put("regYN", "Y");
					break;
				}else{
					int batchOrderExistChk = orderInvestMapper.batchOrderExistChk(params);
					if(batchOrderExistChk > 0){
						rtnmap.put("existYN", "Y");
						rtnmap.put("existMsg", "* This order has ACTIVE investigation request. Request number : " + ((Map<String, Object>) obj).get("0"));
						break;
					}else{
						params.put("salesOrderNo",  ((Map<String, Object>) obj).get("0"));

						EgovMap info = orderInvestMapper.fileOrderInfo(params);

						((Map<String, Object>) obj).put("ordId", info.get("salesOrdId"));
						((Map<String, Object>) obj).put("ordNo", info.get("salesOrdNo"));
						((Map<String, Object>) obj).put("invReqRemark", "Batch Investigation Upload");
						((Map<String, Object>) obj).put("invReqCreated", date);
						((Map<String, Object>) obj).put("invReqCreatorId", params.get("userId"));
						((Map<String, Object>) obj).put("invReqCreatorNm", params.get("userFullname"));
						logger.debug("info ================>>  " + info.get("salesOrdNo"));
						logger.debug("info ================>>  " + date);
						logger.debug("info ================>>  " + info.get("salesOrdId"));
						checkList.add(obj);


						logger.debug("fffffffffffff ================>>  " +checkList);
					}
				}

				continue;
			}

		}
		rtnmap.put("checkList", checkList);
		logger.debug("checkList ================>>  " + checkList);
		logger.debug("info ================>>  " + rtnmap.get("checkList"));

		return rtnmap;
	}

	public void saveNewFileList(Map<String, Object> params) {

		List<Object> list = (List<Object>) params.get(AppConstants.AUIGRID_ALL);
		Map<String, Object> formData =  (Map<String, Object>) params.get("form");

		logger.debug("gridData ============>> " + list);

		for (Object obj : list)
		{
    		params.put("docNoId", 73);
    		String invReqNo = membershipRSMapper.getDocNo(params);

    		int seqSAL0050D = orderInvestMapper.seqSAL0050D();

    		params.put("seqSAL0050D", seqSAL0050D);
    		params.put("invReqNo", invReqNo);
    		params.put("soId", ((Map<String, Object>) obj).get("ordId"));
    		params.put("invReqStusId", 1);
    		params.put("invReqPartyId", 770);
    		params.put("invReqRem", ((Map<String, Object>) obj).get("invReqRemark"));
    		params.put("invReqUserIdAuto", 0);
    		params.put("invReqTypeId", 933);
    		params.put("invReqHasAttach", 0);
    		params.put("invReqAttachFile", " ");
    		params.put("invReqRejctResnId", 0);

    		orderInvestMapper.insertFileInvestReqM(params);

    		params.put("salesOrdId", ((Map<String, Object>) obj).get("ordId"));
    		params.put("prgrsId", 8);
    		params.put("refId", 0);
    		params.put("isLok", 1);
    		orderInvestMapper.insertSalesOrdLog(params);

		}

	}
}
