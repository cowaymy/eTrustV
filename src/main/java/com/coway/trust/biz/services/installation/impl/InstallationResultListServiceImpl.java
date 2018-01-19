package com.coway.trust.biz.services.installation.impl;

import java.text.ParseException;
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
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.organization.organization.impl.MemberListMapper;
import com.coway.trust.biz.sales.mambership.impl.MembershipConvSaleMapper;
import com.coway.trust.biz.services.as.impl.ServicesLogisticsPFCMapper;
import com.coway.trust.biz.services.installation.InstallationResultListService;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.services.installation.InstallationResultListController;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;


@Service("installationResultListService")
public class InstallationResultListServiceImpl extends EgovAbstractServiceImpl implements InstallationResultListService{
	private static final Logger logger = LoggerFactory.getLogger(InstallationResultListController.class);

	@Resource(name = "installationResultListMapper")
	private InstallationResultListMapper installationResultListMapper;

	@Resource(name = "memberListMapper")
	private MemberListMapper memberListMapper;


	@Resource(name = "servicesLogisticsPFCMapper")
	private ServicesLogisticsPFCMapper servicesLogisticsPFCMapper;



	@Resource(name = "membershipConvSaleMapper")
	private MembershipConvSaleMapper membershipConvSaleMapper;


	@Resource(name = "installationReversalMapper")
	private InstallationReversalMapper installationReversalMapper;


	@Override
	public List<EgovMap> selectApplicationType() {
		return installationResultListMapper.selectApplicationType();
	}

	@Override
	public List<EgovMap> selectInstallStatus() {
		return installationResultListMapper.selectInstallStatus();
	}

	@Override
	public List<EgovMap> installationResultList(Map<String, Object> params) {
		List<EgovMap> installationList = null;
		logger.debug("params : {}", params);
		if( ! CommonUtils.isEmpty(params.get("dscCode")) && ! CommonUtils.isEmpty(params.get("customerName"))
				|| ! CommonUtils.isEmpty(params.get("dscCode")) && ! CommonUtils.isEmpty(params.get("customerIc"))
				|| ! CommonUtils.isEmpty(params.get("dscCode")) && ! CommonUtils.isEmpty(params.get("sirimNo"))
				|| ! CommonUtils.isEmpty(params.get("dscCode")) && ! CommonUtils.isEmpty(params.get("serialNo"))
		)
		{
			//installationList = installationResultListMapper.installationResultList2(params);
			installationList = installationResultListMapper.installationResultList(params);
		}else{
			installationList = installationResultListMapper.installationResultList(params);
		}
		return installationList;
	}

	@Override
	public EgovMap getInstallResultByInstallEntryID(Map<String, Object> params) {
		return installationResultListMapper.getInstallResultByInstallEntryID(params);
	}

	@Override
	public EgovMap getOrderInfo(Map<String, Object> params) {
		return installationResultListMapper.getOrderInfo(params);
	}

//	@Override
//	public EgovMap getcustomerInfo(Object cust_id) {
//		return installationResultListMapper.getcustomerInfo(cust_id);
//	}
//	
	

	@Override
	public EgovMap getcustomerInfo(Map<String, Object> params) {
		return installationResultListMapper.getcustomerInfo(params);
	}



	@Override
	public EgovMap getCustomerAddressInfo(Map<String, Object> params) {
		return installationResultListMapper.getCustomerAddressInfo(params);
	}

	@Override
	public EgovMap getCustomerContractInfo(Map<String, Object> params) {
		return installationResultListMapper.getCustomerContractInfo(params);
	}

	@Override
	public EgovMap getInstallationBySalesOrderID(Map<String, Object> params) {
		return installationResultListMapper.getInstallationBySalesOrderID(params);
	}

	@Override
	public EgovMap getInstallContactByContactID(Map<String, Object> params) {
		return installationResultListMapper.getInstallContactByContactID(params);
	}


	@Override
	public EgovMap getSalesOrderMBySalesOrderID(Map<String, Object> params) {
		return installationResultListMapper.getSalesOrderMBySalesOrderID(params);
	}

	@Override
	public EgovMap getMemberFullDetailsByMemberIDCode(Map<String, Object> params) {
		return installationResultListMapper.getMemberFullDetailsByMemberIDCode(params);
	}

	@Override
	public List<EgovMap> selectViewInstallation(Map<String, Object> params) {
		return installationResultListMapper.selectViewInstallation(params);
	}

	@Override
	public EgovMap selectCallType(Map<String, Object> params) {
		return installationResultListMapper.selectCallType(params);
	}

	@Override
	public EgovMap getOrderExchangeTypeByInstallEntryID(Map<String, Object> params) {
		return installationResultListMapper.getOrderExchangeTypeByInstallEntryID(params);
	}

	@Override
	public List<EgovMap> selectFailReason(Map<String, Object> params) {
		return installationResultListMapper.selectFailReason(params);
	}

	@Override
	public EgovMap getStockInCTIDByInstallEntryIDForInstallationView(Map<String, Object> params) {
		return installationResultListMapper.getStockInCTIDByInstallEntryIDForInstallationView(params);
	}

	@Override
	public EgovMap getSirimLocByInstallEntryID(Map<String, Object> params) {
		return installationResultListMapper.getSirimLocByInstallEntryID(params);
	}

	@Override
	public List<EgovMap> checkCurrentPromoIsSwapPromoIDByPromoID(int promotionId) {
		return installationResultListMapper.checkCurrentPromoIsSwapPromoIDByPromoID(promotionId);
	}

	@Override
	public List<EgovMap> selectSalesPromoMs(int promotionId) {
		return installationResultListMapper.selectSalesPromoMs(promotionId);
	}

	/*@Override
	public EgovMap getPromoPriceAndPV(int promotionId, int productId) {
		return installationResultListMapper.getPromoPriceAndPV(param);
	}*/

	@Override
	public EgovMap getAssignPromoIDByCurrentPromoIDAndProductID(int promotionId,int productId,boolean flag) {
		EgovMap resultView= new EgovMap();
		List<EgovMap> list = null;
		logger.debug("promotionId : {}", promotionId);
		logger.debug("productId : {}", productId);
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("promotionId", promotionId);
		param.put("productId", productId);
		if(flag){
			logger.debug("11111111111");
			list = installationResultListMapper.selectSalesPromoMs(promotionId);
			EgovMap swapView = installationResultListMapper.getPromoPriceAndPV(param);

			if(list.size() > 0){
				param.put("promotionId", Integer.parseInt(list.get(0).get("promoMtchId").toString()));
				resultView.put("promoId", list.get(0).get("promoMtchId"));
			}else{
				param.put("promotionId", "0");
				resultView.put("promoId", "0");
			}

			param.put("productId", productId);
			EgovMap defaultView = installationResultListMapper.getPromoPriceAndPV(param);

			resultView.put("swapPormoPrice", CommonUtils.nvl(swapView.get("promoItmPrc")));
			resultView.put("swapPromoPV", CommonUtils.nvl(swapView.get("promoItmPv")));


			if (null != defaultView){
				resultView.put("promoPrice",CommonUtils.nvl(defaultView.get("promoItmPrc")));
				resultView.put("promoPV",CommonUtils.nvl(defaultView.get("promoItmPv")));

			}else{
				resultView.put("promoPrice","0");
				resultView.put("promoPV","0");
			}



		}else{
			logger.debug("22222222222222");
			list =  installationResultListMapper.selectSalesPromoMs(promotionId);
			if(list.size() > 0){
				logger.debug("3333333333333");
				param.put("promotionId", Integer.parseInt(list.get(0).get("promoId").toString()));
				param.put("productId", productId);
				EgovMap swapView = installationResultListMapper.getPromoPriceAndPV(param);

				param.put("promotionId", promotionId);
				param.put("productId", productId);
				EgovMap defaultView = installationResultListMapper.getPromoPriceAndPV(param);



				resultView.put("swapPromoId", Integer.parseInt(list.get(0).get("promoId").toString()));
				resultView.put("promoId",promotionId);

				if(null != swapView){
					resultView.put("swapPormoPrice",CommonUtils.nvl(swapView.get("promoItmPrc")));
					resultView.put("swapPromoPV",CommonUtils.nvl(swapView.get("promoItmPv")));
				}

				if(null !=defaultView ){
					resultView.put("promoPrice",CommonUtils.nvl(defaultView.get("promoItmPrc")));
					resultView.put("promoPV",CommonUtils.nvl(defaultView.get("promoItmPv")));
				}

			}else{
				logger.debug("444444444444444");
				param.put("promotionId", promotionId);
				param.put("productId", productId);
				EgovMap defaultView = installationResultListMapper.getPromoPriceAndPV(param);
				logger.debug("defaultView : {}", defaultView);
				resultView.put("swapPromoId", promotionId);

				if(null !=defaultView ){
					resultView.put("swapPormoPrice", CommonUtils.nvl(defaultView.get("promoItmPrc")));
					resultView.put("swapPromoPV", CommonUtils.nvl(defaultView.get("promoItmPv")));
				}

				resultView.put("promoId", 0);
				resultView.put("promoPrice", 0);
				resultView.put("promoPV", 0);
			}
		}
		return resultView;
	}

	@Override
	public EgovMap selectViewDetail(Map<String, Object> params) {
		EgovMap resultMap = new EgovMap();
		EgovMap installationInfo = new EgovMap();
		EgovMap  assignCt = new EgovMap();
		List<EgovMap> installStatus = installationResultListMapper.selectInstallStatus();
		installationInfo = installationResultListMapper.selectInstallation(params);
		if(installationInfo != null && Integer.parseInt(installationInfo.get("installEntryId").toString()) > 0){
			assignCt = installationResultListMapper.selectAssignCt(params);
			if(assignCt != null){
				installationInfo.put("c1", assignCt.get("memCode"));
				installationInfo.put("c2", assignCt.get("memId"));
				installationInfo.put("c3", assignCt.get("name"));
				installationInfo.put("c4", assignCt.get("nric"));
				installationInfo.put("c5", assignCt.get("whLocId"));
			}
		}
		EgovMap doComplete = installationResultListMapper.selectDoComplete(params);
		if(doComplete != null){
			installationInfo.put("c7", 1);
			installationInfo.put("C9", doComplete.get("movFromLocId"));
			installationInfo.put("C10", doComplete.get("whLocCode"));
		}else{
			installationInfo.put("c7", 0);
			installationInfo.put("C9", 0);
			installationInfo.put("C10", "");
		}

		EgovMap exchangeInfo = installationResultListMapper.selectExchangeInfo(params);

		exchangeInfo.put("soExchgOldPrc", exchangeInfo.get("soExchgOldPrc").toString().equals("") ? "0" :exchangeInfo.get("soExchgOldPrc").toString() );
		exchangeInfo.put("soExchgOldPv", exchangeInfo.get("soExchgOldPv").toString().equals("") ? "0" :exchangeInfo.get("soExchgOldPv").toString() );
		exchangeInfo.put("soExchgOldRentAmt", exchangeInfo.get("soExchgOldRentAmt").toString().equals("") ? "0" :exchangeInfo.get("soExchgOldRentAmt").toString() );
		exchangeInfo.put("soExchgNwPrc", exchangeInfo.get("soExchgNwPrc").toString().equals("") ? "0" :exchangeInfo.get("soExchgNwPrc").toString() );
		exchangeInfo.put("soExchgNwPv", exchangeInfo.get("soExchgNwPv").toString().equals("") ? "0" :exchangeInfo.get("soExchgNwPv").toString() );
		exchangeInfo.put("soExchgNwRentAmt", exchangeInfo.get("soExchgNwRentAmt").toString().equals("") ? "0" :exchangeInfo.get("soExchgNwRentAmt").toString() );
		logger.debug("installationInfo : {}", installationInfo);
		logger.debug("assignCt : {}", assignCt);
		logger.debug("doComplete : {}", doComplete);
		logger.debug("exchangeInfo : {}", exchangeInfo);

		resultMap.put("installationInfo", installationInfo);
		resultMap.put("assignCt", assignCt);
		resultMap.put("doComplete", doComplete);
		resultMap.put("exchangeInfo", exchangeInfo);

		EgovMap basicInfo = installationResultListMapper.selectBasicInfo(params);
		EgovMap tabInstallationInfo = installationResultListMapper.selectinstallationInfo(params);
		EgovMap progressInfo = installationResultListMapper.selectProgressInfo(params);
		EgovMap maillingInfo =  installationResultListMapper.selectMailingInfo(params);
		logger.debug("basicInfo : {}", basicInfo);
		logger.debug("tabInstallationInfo : {}", tabInstallationInfo);
		logger.debug("progressInfo : {}", progressInfo);
		logger.debug("maillingInfo : {}", maillingInfo);

		resultMap.put("basicInfo", basicInfo);
		resultMap.put("tabInstallationInfo", tabInstallationInfo);
		resultMap.put("progressInfo", progressInfo);
		resultMap.put("maillingInfo", maillingInfo);
		resultMap.put("installStatus", installStatus);


		return resultMap;
	}


	public boolean insertInstallationProductExchange(Map<String, Object> params,SessionVO sessionVO) throws ParseException {

		boolean success = false;
		List<EgovMap> sirimList = null;
		EgovMap installResult = this.saveDataInstallResult(params,sessionVO);
		if(Integer.parseInt(params.get("status").toString()) == 4 && (! CommonUtils.isEmpty(params.get("sirimNo")))){
			//sirimList = saveDataSirim(params,sessionVO);
		}
		if(doSaveInstallResult(installResult,sirimList,sessionVO)){

		}


		return false;

	}
	@Transactional
	private boolean doSaveInstallResult(EgovMap installResult, List<EgovMap> sirimList, SessionVO sessionVO) throws ParseException{
			String maxId = "";  //각 테이블에 maxid 값 가져온다(다음 실행할 쿼리에 값을 넣기 위해 사용)
			SimpleDateFormat df = new SimpleDateFormat("MM/dd/yyyy", Locale.getDefault(Locale.Category.FORMAT));
			EgovMap maxIdValue = new EgovMap();
			EgovMap entry = installationResultListMapper.selectEntry(installResult);
			EgovMap exchange = installationResultListMapper.selectExchange(installResult);
			EgovMap salesOrderM = installationResultListMapper.selectSalesOrderM(installResult);
			logger.debug("entry : {}", entry);
			logger.debug("exchange : {}", exchange);
			logger.debug("salesOrderM : {}", salesOrderM);

			if(entry != null && Integer.parseInt(entry.get("installEntryId").toString()) > 0
					 && exchange!= null && Integer.parseInt(exchange.get("soExchgId").toString()) > 0
					 && salesOrderM!= null && Integer.parseInt(salesOrderM.get("salesOrdId").toString()) > 0)
			{
				if(entry.get("stusCodeId").toString().equals("1")  && exchange.get("soExchgStusId").toString().equals("1") ){
					if((int) installResult.get("statusCodeId") == 4)//{
						installResult.put("adjAmount", exchange.get("soExchgOldPrc"));
						maxIdValue.put("value", "resultId");
						installationResultListMapper.insertInstallResult(installResult);

						maxId = installationResultListMapper.selectMaxId(maxIdValue);
						logger.debug("maxId : {}", maxId);
						entry.put("stusCodeId", installResult.get("statusCodeId"));
						entry.put("installResultId", maxId);
						entry.put("updated",  installResult.get("created"));
						entry.put("updator",  installResult.get("creator"));
						installationResultListMapper.updateInstallEntry(entry);

						int orderProgressId = 0;
						boolean orderProgressIsLook = false;
						int orderProgressRefId = 0;
						if((int) installResult.get("statusCodeId") == 4){


    						Map<String, Object> happyCall = new HashMap<String, Object>();
    						//happyCall.put("HCID", 0);
    						happyCall.put("HCSOID", salesOrderM.get("salesOrdId"));
    						happyCall.put("HCCallEntryId", 0);
    						happyCall.put("HCTypeNo", entry.get("installEntryNo"));
    						happyCall.put("HCTypeId", 508);
    						happyCall.put("HCStatusId", 33);
    						happyCall.put("HCRemark", "");
    						happyCall.put("HCCommentTypeId", 0);

    						happyCall.put("HCCommentGId", 0);
    						happyCall.put("HCCommentSId", 0);
    						happyCall.put("HCCommentDId", 0);
    						happyCall.put("creator", sessionVO.getUserId());
    						happyCall.put("created", new Date());
    						happyCall.put("updator", sessionVO.getUserId());
    						happyCall.put("updated", new Date());
    						happyCall.put("HCNoService", false);
    						happyCall.put("HCLock", false);
    						happyCall.put("HCCloseId", 0);
    						logger.debug("happyCall : {}", happyCall);
    						installationResultListMapper.insertHappyCall(happyCall);


							/*//complete
							if(sirimList != null && sirimList.size() > 0){
								for(int i = 0; i< sirimList.size(); i++){
									//installationResultListMapper.insertSirim(sirimList.get(i));
								}
							}

							if((int) exchange.get("soCurStusId") != 25 && (int) exchange.get("soCurStusId") != 26){
								//membership
								int pacId = 0;
								if((int)salesOrderM.get("appTypeId") == 66){
									pacId = 4;
								}else if((int)salesOrderM.get("appTypeId") == 67 && (int)salesOrderM.get("appTypeId") == 68 && (int)salesOrderM.get("appTypeId") == 142){
									pacId = 3;
								}else if((int)salesOrderM.get("appTypeId") == 144){
									pacId = 10;
								}else{
									pacId = 2;
								}
								entry.put("pacId", pacId);
								EgovMap pacSetting = installationResultListMapper.selectPac(entry);

								int membershipDuration = 0;
								int membershipFreq = 0;
								int membershipBSQty = 0;

								if(pacSetting != null){
									membershipDuration = pacSetting.get("srvMemDur") != null ? (int)pacSetting.get("srvMemDur") : 0;
									membershipFreq = pacSetting.get("srvMemItmPriod") != null ? (int)pacSetting.get("srvMemItmPriod") : 0;

									if(membershipDuration > 0 && membershipFreq > 0){
										membershipBSQty = ((membershipDuration / 12) * (12 / membershipFreq));
									}
								}
									Calendar calendar = Calendar.getInstance();

								  	Calendar startDate = getFirstDayOfMonth(calendar);
									Calendar endDate=getLastDayOfMonth(calendar);

									EgovMap membershipNo = getDocNo("12");
									int MembershipDocID = 12;
									String nextDocNo =getNextDocNo("SM",membershipNo.get("docNo").toString());
									membershipNo.put("nextDocNo", nextDocNo);

									logger.debug("membershipNo : {}", membershipNo);

									//memberListServiceImpl.updateDocNo(membershipNo);

									EgovMap membership = new EgovMap();

									membership.put("srvMemId", 0);
									membership.put("srvMemQuotId", 0);
									membership.put("srvSalesOrderId", salesOrderM.get("salesOrdId"));
									membership.put("srvMemNo", membershipNo.get("docNo").toString());
									membership.put("srvMemBillNo", "");
									membership.put("srvMemPacId", pacId);
									membership.put("srvMemPacAmt", 0);
									membership.put("srvMemBSAmt", 0);
									membership.put("srvMemPV",0);
									membership.put("srvFreq",membershipFreq);
									membership.put("srvStartDate",startDate);//수정
									membership.put("srvExpireDate",endDate);//수정
									membership.put("srvDuration",membershipDuration);
									membership.put("srvStatusCodeId",4);
									membership.put("srvRemark","");
									membership.put("srvCreateAt",new Date());
									membership.put("srvCreateBy",installResult.get("creator"));
									membership.put("srvUpdateAt",new Date());
									membership.put("srvUpdateBy",installResult.get("creator"));
									membership.put("srvMemBS12Amt",0);
									membership.put("srvMemIsSynch",false);
									membership.put("srvMemSalesMemId",0);
									membership.put("srvMemCustCntId",salesOrderM.get("custCntId"));
									membership.put("srvMemQty",0);
									membership.put("SrvBSQty",membershipBSQty);
									membership.put("srvMemPromoId",0);
									membership.put("srvMemPVMonth",0);
									membership.put("srvMemPVYear",0);
									membership.put("srvMemIsManual",false);
									membership.put("srvMemBranchId",sessionVO.getUserBranchId());
									membership.put("srvMemPacPromoId",0);

									logger.debug("membership : {}", membership);
									//installationResultListMapper.insertMemberShip(membership);

									//2016 Air Puifier Promotion - Free 1-Yr Outright Membership
									if((int) exchange.get("soExchgNwPromoId") == 31330 || (int) exchange.get("soExchgNwPromoId") == 31331 ||
											(int) exchange.get("soExchgNwPromoId") == 31332 ||(int) exchange.get("soExchgNwPromoId") == 31333 ||
											(int) exchange.get("soExchgNwPromoId") == 31371 || (int) exchange.get("soExchgNwPromoId") == 31372 ||
											(int) exchange.get("soExchgNwPromoId") == 31373 || (int) exchange.get("soExchgNwPromoId") == 31374 ) {

										EgovMap memNoFree = getDocNoNumber("12");
										updateDocNoNumber("12");

										Calendar srvStartDate = endDate;//.add(calendar.DATE,1 );
										srvStartDate.add(calendar.DATE,1 );
										Calendar srvExpireDate = startDate;//.add(calendar.MONTH, 12)
										srvExpireDate.add(calendar.MONTH, 12);
										membership.put("srvMemNo", memNoFree.get("docNo"));
										membership.put("srvMemPacId", 19);
										membership.put("srvStartDate",srvStartDate);//수정해야함
										membership.put("srvExpireDate",srvExpireDate);//수정해야함
										membership.put("srvDuration", 12);//수정해야함

										//installationResultListMapper.insertMemberShip(membership);


									}

									EgovMap list = installationResultListMapper.selectList(salesOrderM);

									if((int) salesOrderM.get("appTypeId") == 66){


										Date salesDate = df.parse(list.get("salesDt").toString());
										Date SalesGSTcutOffDate = df.parse("04/01/2015" );

										if(salesDate.compareTo(SalesGSTcutOffDate) == -1){
											Map<String, Object> rentLedger = new HashMap<String, Object>();
											rentLedger.put("rentRunId", 0);
											rentLedger.put("rentId", 0);
											rentLedger.put("rentSOId", salesOrderM.get("salesOrdId"));
											rentLedger.put("rentDocNo", entry.get("installEntryId"));
											rentLedger.put("rentDocTypeId",161);
											rentLedger.put("rentDateTime", new Date());
											rentLedger.put("rentAmount", exchange.get("soExchgNwPrc"));
											rentLedger.put("rentBatchNo", "");
											rentLedger.put("rentInstNo", 0);
											rentLedger.put("rentUpdateBy", sessionVO.getUserId());
											rentLedger.put("rentUpdateAt", new Date());
											rentLedger.put("rentIsSync", false);
											rentLedger.put("rentBillRunningTotal", 0);
											rentLedger.put("R01", 0);
											rentLedger.put("R02", "");
											logger.debug("rentLedger : {}", rentLedger);
											//insert문 추가

											Map<String, Object> orderbill = new HashMap<String, Object>();
											orderbill.put("accBillTaskId", 0);
											orderbill.put("accBillRefDate", new Date());
											orderbill.put("accBillRefNo", "1000");
											orderbill.put("accBillOrderId", salesOrderM.get("salesOrdId"));
											orderbill.put("accBillOrderNo", salesOrderM.get("salesOrdNo"));
											orderbill.put("accBillTypeId", 1159);
											orderbill.put("accBillModeId",1158);
											orderbill.put("accBillScheduleId",0);
											orderbill.put("accBillSchedulePeriod",0);
											orderbill.put("accBillAdjustmentId",0);
											orderbill.put("accBillScheduleAmount",(int)exchange.get("soExchgNwPrc"));
											orderbill.put("accBillAdjustmentAmount",0);
											orderbill.put("accBillTaxesAmount",(int)exchange.get("soExchgNwPrc") - (int)exchange.get("soExchgNwPrc") * 100/106);
											orderbill.put("accBillNetAmount",(int)exchange.get("soExchgNwPrc"));
											orderbill.put("accBillStatus",1);
											orderbill.put("accBillRemark",entry.get("installEntryNo"));
											orderbill.put("accBillCreateAt", new Date());
											orderbill.put("accBillCreateBy", sessionVO.getUserId());
											orderbill.put("accBillGroupId",0);
											orderbill.put("accBillTaxRate",6);
											orderbill.put("accBillTaxCodeId",32);
											logger.debug("orderbill : {}", orderbill);
											//쿼리 추가

											if(list != null){
												EgovMap invoiceNum = new EgovMap();
												if(list.get("typeId").toString() == "965"){
													//Soo Modified Form GST 2015-01-05

													invoiceNum = getDocNoNumber("120");
													//memberListServiceImpl.updateDocNoNumber("120");

													rentLedger.put("rentDocNo", invoiceNum.get("docNo"));
													//쿼리추가

													orderbill.put("accBillRemark", invoiceNum.get("docNo"));
													//쿼리 추가

													Map<String, Object> taxInvoiceM = new HashMap<String, Object>();
													taxInvoiceM.put("taxInvoiceRefNo", invoiceNum.get("docNo"));
													taxInvoiceM.put("taxInvoiceRefDate", new Date());
													taxInvoiceM.put("taxInvoiceGroupId", (int)list.get("custBillId"));
													taxInvoiceM.put("taxInvoiceGroupNo", list.get("salesOrdId"));
													taxInvoiceM.put("taxInvoiceGroupNo", list.get("salesOrdId"));
													taxInvoiceM.put("taxInvoiceCustName", list.get("name"));
													taxInvoiceM.put("taxInvoiceContactPerson", list.get("name1"));
													taxInvoiceM.put("taxInvoiceAddress1", list.get("add1"));
													taxInvoiceM.put("taxInvoiceAddress2", list.get("add2"));
													taxInvoiceM.put("taxInvoiceAddress3", list.get("add3"));
													taxInvoiceM.put("taxInvoiceAddress4", list.get("add4"));
													taxInvoiceM.put("taxInvoicePostCode", list.get("postCode"));
													taxInvoiceM.put("taxInvoiceStateName", list.get("name2"));
													taxInvoiceM.put("taxInvoiceCountry", list.get("name3"));
													taxInvoiceM.put("taxInvoiceMonth",new Date().getMonth());
													taxInvoiceM.put("taxInvoiceYear",new Date().getYear());
													taxInvoiceM.put("taxInvoiceStatusId",1);
													taxInvoiceM.put("taxInvoiceTaskId",0);
													taxInvoiceM.put("taxInvoiceCreated",new Date());
													taxInvoiceM.put("taxInvoiceRemark",entry.get("installEntryNo"));
													taxInvoiceM.put("taxInvoiceCharges",exchange.get("soExchgNwPrc"));
													taxInvoiceM.put("taxInvoiceOverdue",0);
													taxInvoiceM.put("taxInvoiceAmountDue",exchange.get("soExchgNwPrc"));
													taxInvoiceM.put("taxInvoiceType",1267);
													taxInvoiceM.put("taxInvoiceCreator",sessionVO.getUserId());

													logger.debug("taxInvoiceM : {}", taxInvoiceM);
													//쿼리추가

													Map<String, Object> taxInvoiceD = new HashMap<String, Object>();
													taxInvoiceD.put("taxInvoiceId", "위 쿼리에서 가져와야함");
													taxInvoiceD.put("invoiceItemOrderNo", list.get("salesOrdNo"));
													taxInvoiceD.put("invoiceItem_PONo", "");
													taxInvoiceD.put("invoiceItemGSTRate", 6);
													taxInvoiceD.put("invoiceItemGSTTaxes", (int)exchange.get("soExchgNwPrc") - (int)exchange.get("soExchgNwPrc") * 100/106);
													taxInvoiceD.put("invoiceItemRentalFee", (int)exchange.get("soExchgNwPrc"));
													taxInvoiceD.put("invoiceItemHandlingFee", 0);
													taxInvoiceD.put("invoiceItemHandlingFeeTaxes", 0);
													taxInvoiceD.put("invoiceItemProductCategories", list.get("codeDesc"));
													taxInvoiceD.put("invoiceItemProductModel", list.get("stkDesc"));
													taxInvoiceD.put("invoiceItemProductSerialNo", installResult.get("serialNo"));
													taxInvoiceD.put("invoiceItemAdd1", list.get("add11"));
													taxInvoiceD.put("invoiceItemAdd2", list.get("add21"));
													taxInvoiceD.put("invoiceItemAdd3", list.get("add31"));
													taxInvoiceD.put("invoiceItemPostCode", list.get("postCode1"));
													taxInvoiceD.put("invoiceItemStateName", list.get("name4"));
													taxInvoiceD.put("invoiceItemCountry", list.get("name5"));
													taxInvoiceD.put("invoiceItemInstallationDate", installResult.get("installDate"));
													taxInvoiceD.put("invoiceItemInstallmentNo",0);
													taxInvoiceD.put("invoiceItemInstallmentPeriod",new Date());
													taxInvoiceD.put("invoiceItemPayMode",list.get("description1"));

													logger.debug("taxInvoiceD : {}", taxInvoiceD);
													//쿼리추가

												}else{
													invoiceNum =getDocNoNumber("120");
													updateDocNoNumber("120");

													rentLedger.put("rentDocNo", invoiceNum.get("docNo"));
													//쿼리추가

													orderbill.put("accBillRemark", invoiceNum.get("docNo"));
													//쿼리 추가

													Map<String, Object> taxInvoiceM = new HashMap<String, Object>();
													taxInvoiceM.put("taxInvoiceRefNo", invoiceNum.get("docNo"));
													taxInvoiceM.put("taxInvoiceRefDate", new Date());
													taxInvoiceM.put("taxInvoiceGroupId", (int)list.get("custBillId"));
													taxInvoiceM.put("taxInvoiceGroupNo", list.get("salesOrdId"));
													taxInvoiceM.put("taxInvoiceCustName", list.get("name"));
													taxInvoiceM.put("taxInvoiceContactPerson", list.get("name1"));
													taxInvoiceM.put("taxInvoiceAddress1", list.get("add1"));
													taxInvoiceM.put("taxInvoiceAddress2", list.get("add2"));
													taxInvoiceM.put("taxInvoiceAddress3", list.get("add3"));
													taxInvoiceM.put("taxInvoiceAddress4", list.get("add4"));
													taxInvoiceM.put("taxInvoicePostCode", list.get("postCode"));
													taxInvoiceM.put("taxInvoiceStateName", list.get("name2"));
													taxInvoiceM.put("taxInvoiceCountry", list.get("name3"));
													taxInvoiceM.put("taxInvoiceMonth",new Date().getMonth());
													taxInvoiceM.put("taxInvoiceYear",new Date().getYear());
													taxInvoiceM.put("taxInvoiceStatusId",1);
													taxInvoiceM.put("taxInvoiceTaskId",0);
													taxInvoiceM.put("taxInvoiceCreated",new Date());
													taxInvoiceM.put("taxInvoiceRemark",entry.get("installEntryNo"));
													taxInvoiceM.put("taxInvoiceCharges",exchange.get("soExchgNwPrc"));
													taxInvoiceM.put("taxInvoiceOverdue",0);
													taxInvoiceM.put("taxInvoiceAmountDue",exchange.get("soExchgNwPrc"));
													taxInvoiceM.put("taxInvoiceType",1268);
													taxInvoiceM.put("taxInvoiceCreator",sessionVO.getUserId());

													logger.debug("taxInvoiceM : {}", taxInvoiceM);
													//쿼리추가

													Map<String, Object> taxInvoiceD = new HashMap<String, Object>();
													taxInvoiceD.put("taxInvoiceId", "위 쿼리에서 가져와야함");
													taxInvoiceD.put("invoiceItemOrderNo", list.get("salesOrdNo"));
													taxInvoiceD.put("invoiceItem_PONo", "");
													taxInvoiceD.put("invoiceItemGSTRate", 6);
													taxInvoiceD.put("invoiceItemGSTTaxes", (int)exchange.get("soExchgNwPrc") - (int)exchange.get("soExchgNwPrc") * 100/106);
													taxInvoiceD.put("invoiceItemRentalFee", (int)exchange.get("soExchgNwPrc"));
													taxInvoiceD.put("invoiceItemHandlingFee", 0);
													taxInvoiceD.put("invoiceItemHandlingFeeTaxes", 0);
													taxInvoiceD.put("invoiceItemProductCategories", list.get("codeDesc"));
													taxInvoiceD.put("invoiceItemProductModel", list.get("stkDesc"));
													taxInvoiceD.put("invoiceItemProductSerialNo", installResult.get("serialNo"));
													taxInvoiceD.put("invoiceItemAdd1", list.get("add11"));
													taxInvoiceD.put("invoiceItemAdd2", list.get("add21"));
													taxInvoiceD.put("invoiceItemAdd3", list.get("add31"));
													taxInvoiceD.put("invoiceItemPostCode", list.get("postCode1"));
													taxInvoiceD.put("invoiceItemStateName", list.get("name4"));
													taxInvoiceD.put("invoiceItemCountry", list.get("name5"));
													taxInvoiceD.put("invoiceItemInstallationDate", installResult.get("installDt"));
													taxInvoiceD.put("invoiceItemInstallmentNo",0);
													taxInvoiceD.put("invoiceItemInstallmentPeriod",new Date());
													taxInvoiceD.put("invoiceItemPayMode",list.get("description1"));

													logger.debug("taxInvoiceD : {}", taxInvoiceD);
													//쿼리추가
												}
											}
										}

										EgovMap rentScheme =
										if(rentScheme != null){
											rentScheme.put("renSchDate", new Date());
											rentScheme.put("statusCodeID","REG");
											rentScheme.put("IsSync",false);
											//쿼리 추가
										}

									}
									else if((int)salesOrderM.get("appTypeId") == 67 || (int)salesOrderM.get("appTypeId") == 68){
										double outRightPreBill = getOutRightPreBill(salesOrderM);
										double outRightBalance = (int)exchange.get("soExchgNwPrc") - outRightPreBill;

										if((int)exchange.get("soExchgNwPrc") > outRightPreBill){
											int taxCodeId = 0;
											int taxRate = 0;

											int zrLocationId =  (int)getZRLocationId(salesOrderM);
											int RLCertificateID =  (int)getRSCertificateID(salesOrderM);

											if(zrLocationId != 0){
												 taxCodeId = 39;
												 taxRate = 0;
											}else{
												if(RLCertificateID != 0){
													taxCodeId = 28;
													taxRate = 0;
												}else{
													taxCodeId = 32;
													taxRate = 6;
												}
											}

											Map<String, Object> orderbill = new HashMap<String, Object>();
											orderbill.put("accBillTaskId", 0);
											orderbill.put("accBillRefDate", new Date());
											orderbill.put("accBillRefNo", "1000");
											orderbill.put("accBillOrderId", salesOrderM.get("salesOrdId"));
											orderbill.put("accBillOrderNo", salesOrderM.get("salesOrdNo"));
											orderbill.put("accBillTypeId", 1159);
											orderbill.put("accBillModeId",1164);
											orderbill.put("accBillScheduleId",0);
											orderbill.put("accBillSchedulePeriod",0);
											orderbill.put("accBillAdjustmentId",0);
											orderbill.put("accBillScheduleAmount",(int)exchange.get("soExchgNwPrc"));
											orderbill.put("accBillAdjustmentAmount",0);
											if(taxRate > 0){
												orderbill.put("accBillTaxesAmount",(int)exchange.get("soExchgNwPrc") - (int)exchange.get("soExchgNwPrc") * 100/106);
											}else{
												orderbill.put("accBillTaxesAmount",0);
											}
											orderbill.put("accBillNetAmount",outRightBalance);
											orderbill.put("accBillStatus",1);
											orderbill.put("accBillRemark",entry.get("installEntryNo"));
											orderbill.put("accBillCreateAt", new Date());
											orderbill.put("accBillCreateBy", sessionVO.getUserId());
											orderbill.put("accBillGroupId",0);
											orderbill.put("accBillTaxRate",taxRate);
											orderbill.put("accBillTaxCodeId",taxCodeId);
											orderbill.put("accBillAcctConversion", 0);
											orderbill.put("accBillContractId", 0);
											logger.debug("orderbill : {}", orderbill);
											installationResultListMapper.insertAccOrderBill(orderbill);
											//쿼리

											EgovMap invoiceNum =getDocNoNumber("119");
											updateDocNoNumber("119");

											orderbill.put("accBillRemark", invoiceNum.get("docNo"));
											installationResultListMapper.updateBillRem(orderbill);

											Map<String, Object> taxInvocieOutright = new HashMap<String, Object>();
											taxInvocieOutright.put("taxInvoiceRefNo", invoiceNum.get("docNo"));
											taxInvocieOutright.put("taxInvoiceRefDate", new Date());
											taxInvocieOutright.put("taxInvoiceCustName", list.get("name"));
											taxInvocieOutright.put("taxInvoiceContactPerson", list.get("name1"));
											taxInvocieOutright.put("taxInvoiceAddress1", list.get("add1"));
											taxInvocieOutright.put("taxInvoiceAddress2", list.get("add2"));
											taxInvocieOutright.put("taxInvoiceAddress3", list.get("add3"));
											taxInvocieOutright.put("taxInvoiceAddress4", list.get("add4"));
											taxInvocieOutright.put("taxInvoicePostCode", list.get("postCode"));
											taxInvocieOutright.put("taxInvoiceStateName", list.get("name2"));
											taxInvocieOutright.put("taxInvoiceCountry", list.get("name3"));
											taxInvocieOutright.put("taxInvoiceTaskID",0);
											taxInvocieOutright.put("taxInvoiceCreated",new Date());
											taxInvocieOutright.put("taxInvoiceRemark",entry.get("installEntryNo"));
											if(taxRate > 0){
												taxInvocieOutright.put("taxInvoiceCharges",new DecimalFormat("0.00").format(outRightBalance * 100 / 106));
											}else{
												taxInvocieOutright.put("taxInvoiceCharges",new DecimalFormat("0.00").format(outRightBalance));
											}
											taxInvocieOutright.put("taxInvoiceOverdue",0);
											taxInvocieOutright.put("taxInvoiceAmountDue",new DecimalFormat("0.00").format(outRightBalance));

											logger.debug("taxInvocieOutright : {}", taxInvocieOutright);
											//installationResultListMapper.insertTaxInvocieOutright(taxInvocieOutright);


											Map<String, Object> taxInvocieOutrightD = new HashMap<String, Object>();
											taxInvocieOutrightD.put("taxInvoiceID", "바로 위 테이블에서 값가져오야함");
											taxInvocieOutrightD.put("invoiceItemOrderNo", list.get("salesOrdNo"));
											taxInvocieOutrightD.put("invoiceItem_PONo", "");
											taxInvocieOutrightD.put("invoiceItemGSTRate", taxRate);
											if(taxRate > 0){
												taxInvocieOutrightD.put("invoiceItemGSTTaxes", new DecimalFormat("0.00").format((int)entry.get("soExchgNwPrc") -  (int)entry.get("soExchgNwPrc")));
											}else{
												taxInvocieOutrightD.put("invoiceItemGSTTaxes",0);
											}
											taxInvocieOutrightD.put("invoiceItemAmountDue", outRightBalance);
											taxInvocieOutrightD.put("invoiceItemRentalFee", (int)taxInvocieOutrightD.get("invoiceItemAmountDue") - (int)taxInvocieOutrightD.get("invoiceItemGSTTaxes"));
											taxInvocieOutrightD.put("invoiceItemProductCategories",list.get("codeDesc"));
											taxInvocieOutrightD.put("invoiceItemProductModel", list.get("stkDesc"));
											taxInvocieOutrightD.put("invoiceItemProductSerialNo",installResult.get("sirialNo"));
											taxInvocieOutrightD.put("invoiceItemAdd1",list.get("add11"));
											taxInvocieOutrightD.put("invoiceItemAdd2",list.get("add21"));
											taxInvocieOutrightD.put("invoiceItemAdd3",list.get("add31"));
											taxInvocieOutrightD.put("invoiceItemPostCode",list.get("postCode1"));
											taxInvocieOutrightD.put("invoiceItemStateName", list.get("name4"));
											taxInvocieOutrightD.put("invoiceItemCountry",list.get("name5"));

											logger.debug("taxInvocieOutrightD : {}", taxInvocieOutrightD);
											//installationResultListMapper.insertTaxInvocieOutrightD(taxInvocieOutrightD);


											Map<String, Object> tradeLedger = new HashMap<String, Object>();
											tradeLedger.put("tradeRunID", 0);
											tradeLedger.put("tradeID", 0);
											tradeLedger.put("tradeSOID", salesOrderM.get("salesOrdId"));
											tradeLedger.put("tradeDocNo", invoiceNum.get("docNo"));
											tradeLedger.put("tradeDocTypeID", 164);
											tradeLedger.put("tradeDateTime", new Date());
											tradeLedger.put("tradeAmount", (double)outRightBalance);
											tradeLedger.put("tradeBatchNo", "");
											tradeLedger.put("tradeInstNo", 0);
											tradeLedger.put("tradeUpdateBy", installResult.get("creator"));
											tradeLedger.put("tradeUpdateAt", new Date());
											tradeLedger.put("tradeIsSync", false);
											logger.debug("tradeLedger : {}", tradeLedger);
											//installationResultListMapper.insertTradeLedger(tradeLedger);

										}
									}

									//CONFIG
									Map<String, Object> config = new HashMap<String, Object>();
									config.put("srvConfigId", 0);
									config.put("srvSOId", salesOrderM.get("salesOrdId"));
									config.put("srvCodyId",0);
									config.put("srvPreviousDate",installResult.get("installDate"));
									config.put("srvRemark","");
									config.put("srvBSGen",true);
									config.put("srvCreateAt",new Date());
									config.put("srvCreateBy",sessionVO.getUserId());
									config.put("srvUpdateAt",new Date());
									config.put("srvUpdateBy",sessionVO.getUserId());
									config.put("srvStatusId",1);
									config.put("srvBSWeek",0);
									logger.debug("config : {}", config);
									//installationResultListMapper.insertConfig(config);

									for(int i=279; i<=281;i++){
										Map<String, Object> configSet = new HashMap<String, Object>();
										configSet.put("srvSettId", 0);
										configSet.put("srvConfigId", "위에 쿼리에 시퀀스 가져와야힘");
										configSet.put("srvSettTypeID", i);
										configSet.put("srvSettStatusID", 1);
										configSet.put("srvSettRemark", "");
										configSet.put("srvSettCreateAt", new Date());
										configSet.put("srvSettCreateBy", sessionVO.getUserId());
										logger.debug("configSet : {}", configSet);
										//installationResultListMapper.insertConfigSet(configSet);
									}

									Map<String, Object> configPeriod = new HashMap<String, Object>();
									configPeriod.put("srvPrdId", 0);
									configPeriod.put("srvConfigId", "위에위에 테이블 시퀀스");
									configPeriod.put("srvMembershipId", 0);
									configPeriod.put("srvPrdStartDate", startDate);
									configPeriod.put("srvPrdExpireDate", endDate);
									configPeriod.put("srvPrdDuration", membershipDuration);
									configPeriod.put("srvPrdStatusID", 1);
									configPeriod.put("srvPrdRemark", "");
									configPeriod.put("srvPrdCreateAt", new Date());
									configPeriod.put("srvPrdCreateBy", sessionVO.getUserId());
									configPeriod.put("SrvPrdUpdateAt", new Date());
									configPeriod.put("srvPrdUpdateBy",  sessionVO.getUserId());
									logger.debug("configPeriod : {}", configPeriod);
									//installationResultListMapper.insertConfigPeriod(configPeriod);

									//2016 Air Purifier Promotion = Free 1-Yr Outright Membership
									if((int) exchange.get("soExchgNwPromoId") == 31330 || (int) exchange.get("soExchgNwPromoId") == 31331 ||
											(int) exchange.get("soExchgNwPromoId") == 31332 ||(int) exchange.get("soExchgNwPromoId") == 31333 ||
											(int) exchange.get("soExchgNwPromoId") == 31371 || (int) exchange.get("soExchgNwPromoId") == 31372 ||
											(int) exchange.get("soExchgNwPromoId") == 31373 || (int) exchange.get("soExchgNwPromoId") == 31374 ) {
										configPeriod.put("srvPrdStartDate", configPeriod.get("srvPrdExpireDate"));
										configPeriod.put("srvPrdExpireDate", configPeriod.get("srvPrdStartDate"));
										//쿼리추가
									}

									List<EgovMap> filter = installationResultListMapper.selectFilter(entry);

									if(filter != null && filter.size() > 0){
										for(int i=0; i<filter.size(); i++){
											Map<String, Object> configFilter = new HashMap<String, Object>();
											configFilter.put("srvFilterId", 0);
											configFilter.put("srvConfigId",config.get("시퀀스") );
											configFilter.put("srvFilterStkId", filter.get(i).get(("bomPartId")) != null ? filter.get(i).get(("bomPartId")) : 0 );
											configFilter.put("srvFilterPeriod", filter.get(i).get("bomPartPriod"));
											configFilter.put("srvFilterPrvChgDate",(Date)installResult.get("installDate"));
											configFilter.put("srvFilterStatusId",1);
											configFilter.put("srvFilterRemark","");
											configFilter.put("srvFilterCreateAt",new Date());
											configFilter.put("srvFilterCreateBy",sessionVO.getUserId());
											configFilter.put("srvFilterUpdateAt",new Date());
											configFilter.put("srvFilterUpdateBy",sessionVO.getUserId());
											logger.debug("configFilter : {}", configFilter);
											//installationResultListMapper.insertConfigFilter(configFilter);
										}
									}
								}else{
									//qryCurrentConfig 여기있는곳
								}

								EgovMap salesDet = installationResultListMapper.selectSalesDet(salesOrderM);
								if(salesDet != null){
									salesDet.put("itemStkId", entry.get("installStkId"));
									salesDet.put("itemPrice", exchange.get("soExchgNwPrc"));
									salesDet.put("itemPV", exchange.get("soExchgNwPv"));
									salesDet.put("itemPriceId", exchange.get("soExchgNwPrcId"));
									salesDet.put("updated", new Date());
									salesDet.put("updator", installResult.get("creator"));
									logger.debug("salesDet : {}", salesDet);
									//installationResultListMapper.updateSalesDet(salesDet);
								}

								salesOrderM.put("statusCodeId", 4);
								salesOrderM.put("updated", new Date());
								salesOrderM.put("updator", installResult.get("creator"));
								salesOrderM.put("promoId", exchange.get("soExchgNwPromoId"));
								salesOrderM.put("totalAmt", exchange.get("soExchgNwPrc"));
								salesOrderM.put("totalPV", exchange.get("soExchgNwPv"));
								if((int)salesOrderM.get("appTypeId") == 66) {
									if(df.parse(salesOrderM.get("salesDt").toString()).compareTo(df.parse("08/01/2014")) == 1
											|| df.parse(salesOrderM.get("salesDt").toString()).compareTo(df.parse("08/01/2014")) == 0){
										salesOrderM.put("mthRentAmt", exchange.get("soExchgNwRentAmt"));
										salesOrderM.put("defRentAmt", exchange.get("soExchgNwDefRentAmt"));
									}
								}
								logger.debug("salesOrderM : {}", salesOrderM);
								//installationResultListMapper.updateSalesOrderM(salesOrderM);

								exchange.put("soExchgNwStkId", entry.get("installStkId"));
								exchange.put("soExchgStatusId", 4);
								exchange.put("soExchgUpdateAt", new Date());
								exchange.put("soExchgUpdateBy", sessionVO.getUserId());
								logger.debug("exchange : {}", exchange);
								//installationResultListMapper.updateExchange(exchange);

								Map<String, Object> happyCall = new HashMap<String, Object>();
								happyCall.put("HCID", 0);
								happyCall.put("HCSOID", salesOrderM.get("salesOrdId"));
								happyCall.put("HCCallEntryId", 0);
								happyCall.put("HCTypeNo", entry.get("installEntryNo"));
								happyCall.put("HCTypeId", 508);
								happyCall.put("HCStatusId", 33);
								happyCall.put("HCRemark", "");
								happyCall.put("HCCommentTypeId", 0);
								happyCall.put("HCCommentGId", 0);
								happyCall.put("HCCommentSId", 0);
								happyCall.put("HCCommentDId", 0);
								happyCall.put("creator", sessionVO.getUserId());
								happyCall.put("created", new Date());
								happyCall.put("updator", sessionVO.getUserId());
								happyCall.put("updated", new Date());
								happyCall.put("HCNoService", false);
								happyCall.put("HCLock", false);
								happyCall.put("HCCloseId", 0);
								logger.debug("happyCall : {}", happyCall);
								//installationResultListMapper.insertHappyCall(happyCall);

								EgovMap mobWH = installationResultListMapper.selectMobWh(installResult);

								Map<String, Object> card = new HashMap<String, Object>();
								card.put("SRCardID", 0);
								card.put("locationId", mobWH.get("whLocId"));
								card.put("stockId", entry.get("installStkId"));
								card.put("entryDate", new Date());
								card.put("typeId", 463);
								card.put("refNo", entry.get("installEntryNo"));
								card.put("salesOrderId", salesOrderM.get("salesOrdId"));
								card.put("itemNo", 1);
								card.put("sourceId", 477);
								card.put("projectId", 0);
								card.put("batchNo", 0);
								card.put("Qty", -1);
								card.put("currId", 479);
								card.put("currRate", -1);
								card.put("cost", 0);
								card.put("price", 0);
								card.put("remark", "");
								card.put("serialNo", "");
								card.put("installNo", entry.get("installEntryNo"));
								card.put("costDate", new Date());
								card.put("appTypeId", salesOrderM.get("appTypeId"));
								card.put("stkGrade", "A");
								card.put("installFail", false);
								card.put("isSynch", false);
								card.put("entryMethodId", 0);
								card.put("origin", "");
								logger.debug("card : {}", card);
								//installationResultListMapper.insertRecordCard(card);

								orderProgressIsLook = false;
								orderProgressId = 5;
								orderProgressRefId = 0;*/
						}else{
							//FAIL
							Map<String, Object> callEntry = new HashMap<String, Object>();
							callEntry.put("callEntryId", 0);
							callEntry.put("salesOrderId", salesOrderM.get("salesOrdId"));
							callEntry.put("typeId", 258);
							callEntry.put("statusCodeId", 1);
							callEntry.put("resultId", 0);
							callEntry.put("docId", exchange.get("soExchgId"));
							callEntry.put("creator", sessionVO.getUserId());
							callEntry.put("created", new Date());
							callEntry.put("callDate", installResult.get("nextCallDate"));
							callEntry.put("isWaitForCancel", false);
							callEntry.put("happyCallerId", 0);
							callEntry.put("updated", new Date());
							callEntry.put("updator", sessionVO.getUserId());
							callEntry.put("oriCallDate", installResult.get("nextCallDate"));

							logger.debug("callEntry : {}", callEntry);
							installationResultListMapper.insertCallEntry(callEntry);

							maxIdValue.put("value", "callEntryId");
							maxId = installationResultListMapper.selectMaxId(maxIdValue);

							Map<String, Object> callResult = new HashMap<String, Object>();
							callResult.put("callResultId", 0);
							callResult.put("callEntryId", maxId);
							callResult.put("callStatusId", 1);
							callResult.put("callCallDate", installResult.get("nextCallDate").toString());
							callResult.put("callActionDate", "01/01/1900");
							callResult.put("callFeedBackId", 0);
							callResult.put("callCTID", 0);
							callResult.put("callRemark", installResult.get("remark"));
							callResult.put("callCreateBy", sessionVO.getUserId());
							callResult.put("callCreateAt", new Date());
							callResult.put("callCreateByDept",0);
							callResult.put("callHCID",0);
							callResult.put("callROSAmt",0);
							callResult.put("callSMS",false);
							callResult.put("callSMSRemark","");

							logger.debug("callResult : {}", callResult);
							installationResultListMapper.insertCallResult(callResult);

							maxIdValue.put("value", "callResultId");
							maxId = installationResultListMapper.selectMaxId(maxIdValue);
							maxIdValue.put("value", "callEntryId");
							maxId = installationResultListMapper.selectMaxId(maxIdValue);

							callEntry.put("resultId", maxId);
							callEntry.put("callEntryId", maxId);
							installationResultListMapper.updateCallEntry(callEntry);


							/*EgovMap DO = installationResultListMapper.selectDO(entry);
							if((int)DO.get("movStusId") == 4){
								Map<String, Object> mov = new HashMap<String, Object>();
								mov.put("movId", 0);
								mov.put("installEntryId", entry.get("installEntryId"));
								mov.put("movFromLocId", DO.get("movToLocId"));
								mov.put("movToLocId", 0);
								mov.put("movTypeId", 262);
								mov.put("movStatusId", 1);
								mov.put("movConfirm", 0);
								mov.put("movCreateAt", new Date());
								mov.put("movCreateBy", sessionVO.getUserId());
								mov.put("movUpdateAt", new Date());
								mov.put("movUpdateBy", sessionVO.getUserId());
								mov.put("stkCrdPost", false);
								mov.put("stkCrdPostDate", "1900-01-01");
								mov.put("stkCrdPostToWebOnTime", true);

								logger.debug("mov : {}", mov);
								//installationResultListMapper.insertMovement(mov);//프로시저 호출로 수정*******
							}else if((int)DO.get("movStusId") == 1){
								DO.put("movStusId", 8);
								DO.put("movUpdateAt", new Date());
								DO.put("movUpdateBy",sessionVO.getUserId());
								//쿼리
							}*/

							exchange.put("soExchgNwCallEntryId", callEntry.get("callEntryId"));
							exchange.put("soExchgUpdateAt", new Date());
							exchange.put("soExchgUpdateBy", sessionVO.getUserId());

							logger.debug("exchange : {}", exchange);
							installationResultListMapper.updateSalesOrderExchange(exchange);


						}

					//}
				}
			}
		return true;
	}

	private double getOutRightPreBill(Map<String, Object> params){
		int result = 0;
		List<EgovMap> outRightPreBill = installationResultListMapper.selectOutRightPreBill(params);

		if(outRightPreBill != null){
			for(int i = 0; i< outRightPreBill.size(); i++){

				result += (int)outRightPreBill.get(i).get("tradeAmt");

			}
		}
		return result;

	}

	private double getRSCertificateID(Map<String, Object> params){
		int result = 0;
		List<EgovMap> list = installationResultListMapper.selectRSCertificateID(params);

		if(list != null){
			result = (int)list.get(0).get("eurcId");
		}
		return result;

	}
	private Calendar getFirstDayOfMonth(Calendar calendar){
		 calendar.set(calendar.YEAR, calendar.MONTH, 1);
		return calendar;
	}

	private Calendar getLastDayOfMonth(Calendar calendar){
		Calendar a = getFirstDayOfMonth(calendar);
		 a.getActualMaximum(a.MONTH);

		return a;
	}

	private double getZRLocationId(Map<String, Object> params){
		int result = 0;
		//List<EgovMap> outRightPreBill = installationResultListMapper.selectZRLocation(params);

		/*if(outRightPreBill != null){
			for(int i = 0; i< outRightPreBill.size(); i++){

				result += (int)outRightPreBill.get(i).get("tradeAmt");

			}
		}*/
		return 0;

	}
	private List<EgovMap> saveDataSirim(Map<String, Object> params,SessionVO sessionVO){
		List<EgovMap> sirimList = null;

		EgovMap sirim1 = new EgovMap();
		sirim1.put("sirimId", 0);
		sirim1.put("sirimNo", params.get("sirimNo").toString().trim());
		sirim1.put("sirimTypeId", Integer.parseInt(params.get("hiddenInstallStkCategoryId").toString()));
		sirim1.put("sirimLoc", Integer.parseInt(params.get("hiddenDOWarehouseCode").toString()));
		sirim1.put("sirimQty",-1);
		sirim1.put("sirimDocNo","");
		sirim1.put("sirimRemark","");
		sirim1.put("sirimCreateAt",new Date());
		//sirim1.put("sirimCreateBy" sessionVO.getUserId());
		sirim1.put("sirimSyncCheck", false);
		sirim1.put("sirimEntryPoint", 1);
		sirim1.put("sirimAfterWebSys", true);
		logger.debug("sirim1 : {}", sirim1);
		sirimList.add(sirim1);

		EgovMap sirim2 = new EgovMap();
		sirim2.put("sirimId", 0);
		sirim2.put("sirimNo", params.get("sirimNo").toString().trim());
		sirim2.put("sirimTypeId", Integer.parseInt(params.get("hiddenInstallStkCategoryId").toString()));
		sirim2.put("sirimLoc", params.get("hiddenInstallNo").toString().trim());
		sirim2.put("sirimQty",0);
		sirim2.put("sirimDocNo","");
		sirim2.put("sirimRemark","");
		sirim2.put("sirimCreateAt",new Date());
		//sirim2.put("sirimCreateBy" sessionVO.getUserId());
		sirim2.put("sirimSyncCheck", false);
		sirim2.put("sirimEntryPoint", 1);
		sirim2.put("sirimAfterWebSys", true);
		logger.debug("sirim2 : {}", sirim2);
		sirimList.add(sirim2);



		return sirimList;

	}

	private EgovMap saveDataInstallResult(Map<String, Object> params,SessionVO sessionVO){

		int statusId = Integer.parseInt(params.get("status").toString());
		String sirimNo = "";
		String serialNo = "";
		int failId=0;
		String nextCallDate = "01/01/1900";
		boolean allowComm = false;
		boolean inTradeIn = false;
		boolean reqSms = false;
		String refNo1 = "";
		String refNo2 = "";

		if(statusId == 4){
			sirimNo = params.get("sirimNo").toString();
			serialNo = params.get("serialNo").toString();
			allowComm = params.get("checkCommission") != null ? true : false;
			inTradeIn = params.get("checkTrade")!= null ? true : false;
			reqSms = params.get("reqSms") != null ? true : false;
			refNo1 = params.get("refNo1").toString();
			refNo2 = params.get("refNo2").toString();
		}else{
			failId = Integer.parseInt(params.get("failReason").toString());
			nextCallDate = params.get("nextCallDate").toString();
		}
		EgovMap installResult = new EgovMap();

		installResult.put("resultID", 0);
		installResult.put("entryId", params.get("hiddenInstallEntryId"));
		installResult.put("statusCodeId", statusId);
		installResult.put("CTID", Integer.parseInt(params.get("hiddenAssignCTMemId").toString().trim()));
		installResult.put("installDate", params.get("acInstallDate"));
		installResult.put("remark", params.get("remark").toString().trim());
		installResult.put("GLPost", 0);
		installResult.put("creator", sessionVO.getUserId());
		installResult.put("created", new Date());
		installResult.put("sirimNo", sirimNo);
		installResult.put("serialNo", serialNo);
		installResult.put("failId", failId);
		installResult.put("nextCallDate", nextCallDate);

		installResult.put("allowComm", allowComm  == true ?"1" : "0");
		installResult.put("inTradeIn", inTradeIn == true ?"1" : "0");
		installResult.put("reqSms", reqSms == true ?"1" : "0");

		installResult.put("docRefNo1", refNo1);
		installResult.put("docRefNo2", refNo2);
		installResult.put("updated", new Date());
		installResult.put("updator", sessionVO.getUserId());
		installResult.put("adjAmount", 0);
		logger.debug("installResult : {}", installResult);
		return  installResult;

	}

	public EgovMap getDocNo(String docNoId){
		int tmp = Integer.parseInt(docNoId);
		String docNo = "";
		EgovMap selectDocNo = memberListMapper.selectDocNo(docNoId);
		logger.debug("selectDocNo : {}",selectDocNo);
		String prefix = "";

		if(Integer.parseInt((String) selectDocNo.get("docNoId").toString()) == tmp){

			if(selectDocNo.get("c2") != null){
				prefix = (String) selectDocNo.get("c2");
			}else{
				prefix = "";
			}
			docNo = prefix.trim()+(String) selectDocNo.get("c1");
			//prefix = (selectDocNo.get("c2")).toString();
			logger.debug("prefix : {}",prefix);
			selectDocNo.put("docNo", docNo);
			selectDocNo.put("prefix", prefix);
		}
		return selectDocNo;
	}

	public EgovMap getDocNoNumber(String docNoId){
		int tmp = Integer.parseInt(docNoId);
		String docNo = "";
		EgovMap selectDocNo = memberListMapper.selectDocNo(docNoId);
		logger.debug("selectDocNo : {}",selectDocNo);

		if(docNoId.equals("130") && Integer.parseInt((String) selectDocNo.get("docNoId").toString()) == tmp){
			docNo = (String) selectDocNo.get("c2")+(String) selectDocNo.get("c1");
			logger.debug("docNo : {}",docNo);
			selectDocNo.put("docNo", docNo);
		}
		return selectDocNo;
	}
	public void updateDocNoNumber(String docNoId){//코드값에 따라 자리수 다르게
		EgovMap selectDocNoNumber = memberListMapper.selectDocNo(docNoId);
		logger.debug("selectDocNoNumber : {}",selectDocNoNumber);
		int nextDocNoNumber = Integer.parseInt((String)selectDocNoNumber.get("c1")) + 1;
		String nextDocNo="";
		if(docNoId.equals("145") || docNoId.equals("12")){
			nextDocNo = String.format("%07d", nextDocNoNumber);
		}else{//130일때,120일때,119일때
		nextDocNo = String.format("%08d", nextDocNoNumber);
		}
		selectDocNoNumber.put("nextDocNo", nextDocNo);
		logger.debug("selectDocNoNumber last : {}",selectDocNoNumber);
		memberListMapper.updateDocNo(selectDocNoNumber);
	}

	public String getNextDocNo(String prefixNo,String docNo){
		String nextDocNo = "";
		int docNoLength=0;
		System.out.println("!!!"+prefixNo);
		if(prefixNo != null && prefixNo != ""){
			docNoLength = docNo.replace(prefixNo, "").length();
			docNo = docNo.replace(prefixNo, "");
		}else{
			docNoLength = docNo.length();
		}

		int nextNo = Integer.parseInt(docNo) + 1;
		nextDocNo = String.format("%0"+docNoLength+"d", nextNo);
		logger.debug("nextDocNo : {}",nextDocNo);
		return nextDocNo;
	}

	@Override
	@Transactional
	public Map<String, Object> insertInstallationResult(Map<String, Object> params, SessionVO sessionVO) throws ParseException {
		Map<String, Object> resultValue = new HashMap<String, Object>();
		if(sessionVO != null){
			resultValue= Save(true,params,sessionVO);

		}

		return resultValue;
	}

	private Map<String, Object> Save(boolean isfreepromo,Map<String, Object> params,SessionVO sessionVO) throws ParseException{

		boolean isBillAvb =false;

		Map<String, Object> resultValue = new HashMap<String, Object>();
		Map<String, Object> callEntry = new HashMap<String, Object>();
		Map<String, Object> callResult = new HashMap<String, Object>();
		Map<String, Object> orderLog = new HashMap<String, Object>();
		Map<String, Object> TaxinvoiceCompany = new HashMap<String, Object>();
		Map<String, Object> taxInvoiceCompanySub = new HashMap<String, Object>();
		Map<String, Object> AccTradeLedger = new HashMap<String, Object>();
		Map<String, Object> AccOrderBill = new HashMap<String, Object>();
		Map<String, Object> taxInvoiceOutright = new HashMap<String,Object>();
		Map<String,Object> taxInvoiceOutrightSub = new HashMap<String,Object>();
		Map<String,Object> salesOrderM = new HashMap<String,Object>();

		int statusId =  Integer.parseInt( CommonUtils.nvl( params.get("installStatus")).toString());//
		String sirimNo = CommonUtils.nvl( params.get("sirimNo").toString())!= "" ? CommonUtils.nvl(  params.get("sirimNo")).toString().toUpperCase() : "";
		String serialNo =CommonUtils.nvl(  params.get("serialNo")).toString();
		int failId   = CommonUtils.nvl(  params.get("failReason")) != ""  ? Integer.parseInt( CommonUtils.nvl( params.get("failReason")).toString()) : 0;
		String nextCallDate =CommonUtils.nvl(  params.get("nextCallDate")).toString();
		boolean allowComm = CommonUtils.nvl( params.get("checkCommission")) != ""  ? true : false;
		boolean inTradeIn =CommonUtils.nvl(  params.get("checkTrade"))!= "" ? true : false;
		boolean reqSms =CommonUtils.nvl(  params.get("reqSms")) != "" ? true : false;
		String refNo1 = CommonUtils.nvl( params.get("refNo1"));
		String refNo2 = CommonUtils.nvl( params.get("refNo2"));
		String nextDateCall = (String) CommonUtils.nvl( params.get("nextCallDate"));
		String ApptypeID =CommonUtils.nvl(  params.get("hidAppTypeId")).toString();
		String  strOutrightTotalPrice =   CommonUtils.nvl(params.get("hidOutright_Price") );
		String callTypeId = CommonUtils.nvl(params.get("hidCallType"));


		Map tradeamount= new HashMap();
		tradeamount.put("TRADE_SO_ID", Integer.parseInt(params.get("hidSalesOrderId").toString()));
		Map outRightAmount35d = installationResultListMapper.getTradeAmount(tradeamount);   //35d amt


		Map ordTamtPram= new HashMap();

		String  t_hidEntryId ="";
		if(null == CommonUtils.nvl( params.get("hidEntryId")).toString()){
			t_hidEntryId = CommonUtils.nvl( params.get("installEntryId")).toString();
		}else{
			t_hidEntryId  =CommonUtils.nvl( params.get("hidEntryId")).toString();
		}

		ordTamtPram.put("INSTALL_ENTRY_ID",    t_hidEntryId);

		EgovMap   ordInfo =installationResultListMapper.getOrderByInstallEntryID(ordTamtPram);

		String tAmt = "0";  // String.valueOf( CommonUtils.intNvl( outRightAmount.get("SUMTRADE_AMT")));

		if(null !=ordInfo){
			tAmt = String.valueOf( CommonUtils.intNvl( ordInfo.get("totAmt")));   //
		}

		double outright35dAmount =  Double.parseDouble(String.valueOf(CommonUtils.intNvl( outRightAmount35d.get("SUMTRADE_AMT"))));

		double outrightTotalPrice = Double.parseDouble(tAmt ==""?"0" : tAmt);
		double outrightBalance = outrightTotalPrice - outright35dAmount;

        double outrightSubProcessing = 0;
        double outrightSubBalance = 0;

		//get outright refno
		Map invoiceNum = new HashMap();
		invoiceNum.put("DocNo", "119");
		String invoiceNo = installationResultListMapper.getInvoiceNum(invoiceNum);
		//set Date params
		Date today = new Date();
		Calendar cal =Calendar.getInstance();
		cal.setTime(today);

		int month = cal.get(Calendar.MONTH);

		EgovMap installResult = new EgovMap();

    		installResult.put("resultID", 0);
    		installResult.put("entryId", Integer.parseInt(CommonUtils.nvl( params.get("hidEntryId")).toString()));
    		installResult.put("statusCodeId", Integer.parseInt(CommonUtils.nvl( params.get("installStatus")).toString()));
    		installResult.put("CTID", Integer.parseInt(CommonUtils.nvl( params.get("CTID")).toString()));
    		installResult.put("installDate", CommonUtils.nvl( params.get("installDate")));
    		installResult.put("remark",CommonUtils.nvl(  params.get("remark")).toString().trim());
    		installResult.put("GLPost", 0);
    		installResult.put("creator", sessionVO.getUserId());
    		installResult.put("created", new Date());
    		installResult.put("sirimNo", sirimNo);
    		installResult.put("serialNo", serialNo);
    		installResult.put("failId", failId);
    		installResult.put("nextCallDate", nextCallDate);

    		installResult.put("allowComm", allowComm  ==  true ? "1" :"0");
    		installResult.put("inTradeIn", inTradeIn ==  true ? "1" :"0");
    		installResult.put("reqSms", reqSms  ==  true ? "1" :"0");

    		installResult.put("docRefNo1", refNo1);
    		installResult.put("docRefNo2", refNo2);
    		installResult.put("updated", new Date());
    		installResult.put("updator", sessionVO.getUserId());
    		installResult.put("adjAmount", 0);
    		logger.debug("installResult : {}", installResult);

    		//update salesorderM status(SAL0001D)
    		if (callTypeId.equals("258")){

    		}else{
    			salesOrderM.put("salesOrdId", CommonUtils.nvl( params.get("hidSalesOrderId")).toString());
    			salesOrderM.put("statusCodeId", CommonUtils.nvl( params.get("installStatus")).toString().equals("4") ? 4 : 1 );
    		}

    		///////////////////////add by jgkim     get addr  //////////////////
    		// PAY0033D
    		EgovMap addrM   =null;
    		// PAY0034D
    		EgovMap addrD   =null;

    		  	addrM = installationResultListMapper.getUsePAY0033D_addr(params);
    		  	addrD = installationResultListMapper.getUsePAY0034D_addr(params);
    		  	logger.debug("Prepared addrM:{}",addrM);
    		  	logger.debug("Prepared addrD:{}",addrD);
    		///////////////////////add by hgham     get taxRate  //////////////////


    		///////////////////////add by hgham     get taxRate  //////////////////
    		int  TAXRATE   =0;

    		  	  params.put("srvSalesOrderId", CommonUtils.nvl( params.get("hidSalesOrderId")).toString());
    		      TAXRATE = membershipConvSaleMapper.getTaxRate(params);
    		///////////////////////add by hgham     get taxRate  //////////////////


    		if(ApptypeID.equals("66") ){

    			int  salesDt =CommonUtils.intNvl(ordInfo.get("salesDt"));
    			int  salesGSTcutOffDate =CommonUtils.intNvl(CommonUtils.getNowDate());

				if(salesDt < salesGSTcutOffDate){

					  ////GST  do Not  2년 전부터 안했다고 함.
    			}
    		}


    		if(ApptypeID.equals("67")  || ApptypeID.equals("68") ||ApptypeID.equals("1412")){
    			
    			///////////////////////////////  고객 정보 및 주소 추가 /////////////////////////////////////////
    			EgovMap   custInfoMap    = new EgovMap();
    			//EgovMap   micgAddres    = new EgovMap();
    			
    			params.put("SALES_ORD_NO",params.get("hidTaxInvDSalesOrderNo")) ;
    			custInfoMap = installationResultListMapper.getCustInfo(params);
    			//custInfoMap = installationResultListMapper.getMAddressInfo(params);
    			
    			 ///////////////////////////////  고객 정보 및 주소 추가 /////////////////////////////////////////
    			
    			
    			

    			if(ApptypeID.equals("1412")){
        			if(outright35dAmount > 200){
        				   outrightSubProcessing = 0;
                           outrightSubBalance = outrightTotalPrice - outright35dAmount;
        			}else{
        				outrightSubProcessing = (200 - outright35dAmount);
                        outrightSubBalance = outrightTotalPrice - (outright35dAmount + (200 - outright35dAmount));
        			}
    			}

    			 if (outrightTotalPrice  > outright35dAmount) {

    				 		isBillAvb =true;

    				 		/////////////////////////////PAY0039D////////////////////////////////////////////
				 		    Map<String,Object> accTRXMinus = new HashMap();
				 		    accTRXMinus.put("TRXItemNo", 1);
				 		    accTRXMinus.put("TRXGLAccID", 166);
				 		    accTRXMinus.put("TRXGLDept", "0");
				 		    accTRXMinus.put("TRXProject", "");
				 		    accTRXMinus.put("TRXFinYear", 0);
				 		    accTRXMinus.put("TRXPeriod", 0);
				 		    accTRXMinus.put("TRXSourceTypeID", 389);
				 		    accTRXMinus.put("TRXDocTypeID", 409);
				 		    accTRXMinus.put("TRXNo",      CommonUtils.nvl( params.get("hidEntryId")).toString() );
				 		    accTRXMinus.put("TRXDocNo", params.get("hidTradeLedger_InstallNo"));
				 		    accTRXMinus.put("TRXCustBillID", CommonUtils.nvl( params.get("hidSalesOrderId")));
				 		    accTRXMinus.put("TRXChequeNo", "");
		                    accTRXMinus.put("TRXCRCardSlip", "");
		                    accTRXMinus.put("TRXBisNo", "");
		                    accTRXMinus.put("TRXReconDate", new Date());
		                    accTRXMinus.put("TRXRemark",CommonUtils.nvl( params.get("msgRemark")));
		                    accTRXMinus.put("TRXCurrID", "RM");
		                    accTRXMinus.put("TRXCurrRate", 1);
		                    accTRXMinus.put("TRXAmount",     -outrightBalance);
		                    accTRXMinus.put("TRXAmountRM", -outrightBalance);
		                    accTRXMinus.put("TRXIsSynch", 0);
		                    installationReversalMapper.addAccTRXes(accTRXMinus);


		                    Map<String,Object> accTRXPlus = new HashMap();
		                    accTRXPlus.put("TRXItemNo", 2);
				 		    accTRXPlus.put("TRXGLAccID", 38);
				 		    accTRXPlus.put("TRXGLDept", "0");
				 		    accTRXPlus.put("TRXProject", "");
				 		    accTRXPlus.put("TRXFinYear", 0);
				 		    accTRXPlus.put("TRXPeriod", 0);
				 		    accTRXPlus.put("TRXSourceTypeID", 389);
				 		    accTRXPlus.put("TRXDocTypeID", 409);
				 		    accTRXPlus.put("TRXNo",      CommonUtils.nvl( params.get("hidEntryId")).toString() );
				 		    accTRXPlus.put("TRXDocNo", params.get("hidTradeLedger_InstallNo"));
				 		    accTRXPlus.put("TRXCustBillID", CommonUtils.nvl( params.get("hidSalesOrderId")));
				 		    accTRXPlus.put("TRXChequeNo", "");
		                    accTRXPlus.put("TRXCRCardSlip", "");
		                    accTRXPlus.put("TRXBisNo", "");
		                    accTRXPlus.put("TRXReconDate", new Date());
		                    accTRXPlus.put("TRXRemark",CommonUtils.nvl( params.get("msgRemark")));
		                    accTRXPlus.put("TRXCurrID", "RM");
		                    accTRXPlus.put("TRXCurrRate", 1);
		                    accTRXPlus.put("TRXAmount",     outrightBalance);
		                    accTRXPlus.put("TRXAmountRM", outrightBalance);
		                    accTRXPlus.put("TRXIsSynch", 0);
		                    installationReversalMapper.addAccTRXes(accTRXPlus);
		                   /////////////////////////////PAY0039D////////////////////////////////////////////



		                    /////////////////////////////PAY0033D////////////////////////////////////////////
        				 	String TAX_INVC_ID = installationResultListMapper.getPAY0033D_SEQ(invoiceNum);

        					//Insert TaxinvoiceOutright
        					taxInvoiceOutright.put("TAX_INVC_ID",TAX_INVC_ID);
        					taxInvoiceOutright.put("TAX_INVC_REF_NO",invoiceNo);
        					taxInvoiceOutright.put("TAX_INVC_REF_DT", CommonUtils.getNowDate());
        					taxInvoiceOutright.put("TAX_INVC_CUST_NAME",CommonUtils.nvl( custInfoMap.get("customer")));
        	        		taxInvoiceOutright.put("TAX_INVC_CNTC_PERSON", CommonUtils.nvl(custInfoMap.get("contact")));
        	        		// set address
        	        		taxInvoiceOutright.put("TAX_INVC_ADDR1",CommonUtils.nvl(addrM.get("taxInvcAddr1")));
        	        		taxInvoiceOutright.put("TAX_INVC_ADDR2",CommonUtils.nvl(addrM.get("taxInvcAddr2")));
        	        		taxInvoiceOutright.put("TAX_INVC_ADDR3",0);
        	        		taxInvoiceOutright.put("TAX_INVC_ADDR4",0);
        	        		taxInvoiceOutright.put("TAX_INVC_POST_CODE",CommonUtils.nvl(addrM.get("taxInvcPostCode")));
        	        		taxInvoiceOutright.put("TAX_INVC_STATE_NAME",CommonUtils.nvl(addrM.get("taxInvcStateName")));
        	        		taxInvoiceOutright.put("TAX_INVC_CNTY",CommonUtils.nvl(addrM.get("taxInvcCnty")));
        	        		taxInvoiceOutright.put("TAX_INVC_TASK_ID",0);
        	        		taxInvoiceOutright.put("TAX_INVC_CRT_DT",CommonUtils.getNowDate());
        	        		taxInvoiceOutright.put("TAX_INVC_REM",params.get("hidTradeLedger_InstallNo"));


        	        		 if (TAXRATE > 0)  {
        	        			 taxInvoiceOutright.put("TAX_INVC_CHRG",outrightBalance * 100 / 106 );
        	                 }else {
        	             		taxInvoiceOutright.put("TAX_INVC_CHRG",outrightBalance);
        	                 }

        	        		taxInvoiceOutright.put("TAX_INVC_OVERDU",0);
        	        		taxInvoiceOutright.put("TAX_INVC_AMT_DUE",outrightBalance);
        	        		taxInvoiceOutright.put("TAX_INVC_PO_NO","");
        	        		taxInvoiceOutright.put("AREA_ID", CommonUtils.nvl(params.get("hidInstallation_AreaID")));
        	        		taxInvoiceOutright.put("ADDR_DTL",CommonUtils.nvl( params.get("hidInstallation_AddDtl")));
        	        		taxInvoiceOutright.put("STREET","");
        	        		logger.debug("Prepared TaxinvoiceOutright:{}",taxInvoiceOutright);
        	        		/////////////////////////////PAY0033D////////////////////////////////////////////



        	        		/////////////////////////////PAY0034D////////////////////////////////////////////
        	    			if(ApptypeID.equals("1412"))	{

        	            		taxInvoiceOutrightSub.put("TAX_INVC_ID",TAX_INVC_ID);
        	            		taxInvoiceOutrightSub.put("INVC_ITM_ORD_NO",CommonUtils.nvl(params.get("hidTaxInvDSalesOrderNo")));
        	            		taxInvoiceOutrightSub.put("INVC_ITM_PO_NO","");
        	            		taxInvoiceOutrightSub.put("INVC_ITM_GST_RATE",TAXRATE);


        	            		if(TAXRATE > 0){
        	            			taxInvoiceOutrightSub.put("INVC_ITM_GST_TXS", Double.toString( outrightBalance - ( outrightBalance  * 100 / 106)));
        	                		taxInvoiceOutrightSub.put("INVC_ITM_RENTAL_FEE",Double.toString(outrightBalance  * 100 / 106 ));
        	                		taxInvoiceOutrightSub.put("INVC_ITM_FEES_GST_TXS",outrightSubProcessing - ( outrightSubProcessing  * 100 / 106));
        	                		taxInvoiceOutrightSub.put("INVC_ITM_FEES_CHRG",Double.toString(outrightSubProcessing  * 100 / 106 ));
        	                	}else{
        	            			taxInvoiceOutrightSub.put("INVC_ITM_GST_TXS", "0");
        	                		taxInvoiceOutrightSub.put("INVC_ITM_RENTAL_FEE",  outrightSubBalance);
        	                		taxInvoiceOutrightSub.put("INVC_ITM_FEES_GST_TXS","0");
        	                		taxInvoiceOutrightSub.put("INVC_ITM_FEES_CHRG",outrightSubProcessing);
        	                	}

        	            		 double  a =( outrightBalance - ( outrightBalance  * 100 / 106)) ;
        	            		 double  b =(outrightBalance  * 100 / 106 );
        	            		 
        	            		taxInvoiceOutrightSub.put("INVC_ITM_AMT_DUE",Double.toString (a+b));
        	            		taxInvoiceOutrightSub.put("INVC_ITM_FEES_AMT_DUE",outrightSubProcessing);
        	            		taxInvoiceOutrightSub.put("INVC_ITM_PRODUCT_CTGRY",CommonUtils.nvl(params.get("hidCategoryId")));
        	            		taxInvoiceOutrightSub.put("INVC_ITM_PRODUCT_MODEL","");
        	            		taxInvoiceOutrightSub.put("INVC_ITM_PRODUCT_SERIAL_NO",CommonUtils.nvl((params.get("hidSerialNo"))));
        	            		// set address
        	              		taxInvoiceOutrightSub.put("INVC_ITM_ADD1",CommonUtils.nvl(addrD.get("invcItmAdd1")));
        	            		taxInvoiceOutrightSub.put("INVC_ITM_ADD2",CommonUtils.nvl(addrD.get("invcItmAdd2")));
        	            		taxInvoiceOutrightSub.put("INVC_ITM_ADD3","");
        	            		taxInvoiceOutrightSub.put("INVC_ITM_POST_CODE",CommonUtils.nvl(addrD.get("invcItmPostCode")));
        	            		taxInvoiceOutrightSub.put("INVC_ITM_STATE_NAME",CommonUtils.nvl(addrD.get("invcItmStateName")));
        	            		taxInvoiceOutrightSub.put("INVC_ITM_CNTY",CommonUtils.nvl(addrD.get("invcItmCnty")));

        	            		taxInvoiceOutrightSub.put("AREA_ID",CommonUtils.nvl( params.get("hidInstallation_AreaID")));
        	            		taxInvoiceOutrightSub.put("ADDR_DTL",CommonUtils.nvl(params.get("hidInstallation_AddDtl")));
        	            		taxInvoiceOutrightSub.put("STREET","");
        	            		logger.debug("Prepared taxInvoiceOutrightSub: ",taxInvoiceOutrightSub);



        	    			}else{

        	    				taxInvoiceOutrightSub.put("TAX_INVC_ID",TAX_INVC_ID);
        	            		taxInvoiceOutrightSub.put("INVC_ITM_ORD_NO",CommonUtils.nvl(params.get("hidTaxInvDSalesOrderNo")));
        	            		taxInvoiceOutrightSub.put("INVC_ITM_PO_NO","");
        	            		taxInvoiceOutrightSub.put("INVC_ITM_GST_RATE",TAXRATE);


        	            		if(TAXRATE > 0){
        	            			taxInvoiceOutrightSub.put("INVC_ITM_GST_TXS", Double.toString( outrightBalance - ( outrightBalance  * 100 / 106)));
        	                		taxInvoiceOutrightSub.put("INVC_ITM_RENTAL_FEE",  outrightBalance  * 100 / 106);

        	                	}else{
        	            			taxInvoiceOutrightSub.put("INVC_ITM_GST_TXS", "0");
        	                		taxInvoiceOutrightSub.put("INVC_ITM_RENTAL_FEE",  outrightSubBalance);
        	                	}

        	            		
        	            		 double  a =( outrightBalance - ( outrightBalance  * 100 / 106)) ;
        	            		 double  b =(outrightBalance  * 100 / 106 );
        	            		taxInvoiceOutrightSub.put("INVC_ITM_AMT_DUE",Double.toString (a+b));
        	            		
        	            		//taxInvoiceOutrightSub.put("INVC_ITM_AMT_DUE",outrightSubBalance);
        	            		taxInvoiceOutrightSub.put("INVC_ITM_FEES_AMT_DUE","0");
        	            		taxInvoiceOutrightSub.put("INVC_ITM_PRODUCT_CTGRY",CommonUtils.nvl(custInfoMap.get("codeDesc")));
        	            		taxInvoiceOutrightSub.put("INVC_ITM_PRODUCT_MODEL",CommonUtils.nvl(custInfoMap.get("stkDesc")));
        	            		taxInvoiceOutrightSub.put("INVC_ITM_PRODUCT_SERIAL_NO",CommonUtils.nvl((params.get("hidSerialNo"))));
        	            		// set address
        	              		taxInvoiceOutrightSub.put("INVC_ITM_ADD1",CommonUtils.nvl(addrD.get("invcItmAdd1")));
        	            		taxInvoiceOutrightSub.put("INVC_ITM_ADD2",CommonUtils.nvl(addrD.get("invcItmAdd2")));
        	            		taxInvoiceOutrightSub.put("INVC_ITM_ADD3","");
        	            		taxInvoiceOutrightSub.put("INVC_ITM_POST_CODE",CommonUtils.nvl(addrD.get("invcItmPostCode")));
        	            		taxInvoiceOutrightSub.put("INVC_ITM_STATE_NAME",CommonUtils.nvl(addrD.get("invcItmStateName")));
        	            		taxInvoiceOutrightSub.put("INVC_ITM_CNTY",CommonUtils.nvl(addrD.get("invcItmCnty")));

        	            		taxInvoiceOutrightSub.put("AREA_ID",CommonUtils.nvl( params.get("hidInstallation_AreaID")));
        	            		taxInvoiceOutrightSub.put("ADDR_DTL",CommonUtils.nvl(params.get("hidInstallation_AddDtl")));
        	            		taxInvoiceOutrightSub.put("STREET","");
        	            		logger.debug("Prepared taxInvoiceOutrightSub: ",taxInvoiceOutrightSub);
        	    			}
        	    			/////////////////////////////PAY0034D////////////////////////////////////////////


        	    			AccTradeLedger.put("TRADE_RUN_ID", 0);
        	    			AccTradeLedger.put("TRADE_ID", 0);
        	    			AccTradeLedger.put("TRADE_SO_ID", Integer.parseInt(params.get("hidSalesOrderId").toString()));
        	    			AccTradeLedger.put("TRADE_DOC_NO",invoiceNo); //params.get("hidTradeLedger_InstallNo"));
        	    			AccTradeLedger.put("TRADE_DOC_TYPE_ID", 164);
        	    			AccTradeLedger.put("TRADE_DT_TM", CommonUtils.getNowDate());
        	    			AccTradeLedger.put("TRADE_AMT", outrightBalance);
        	    			AccTradeLedger.put("TRADE_BATCH_NO", "");
        	    			AccTradeLedger.put("TRADE_INST_NO", 0);
        	    			AccTradeLedger.put("TRADE_UPD_USER_ID", sessionVO.getUserId());
        	    			AccTradeLedger.put("TRADE_UPD_DT", CommonUtils.getNowDate());
        	    			AccTradeLedger.put("TRADE_IS_SYNC", 0);
        	    			AccTradeLedger.put("R01", 0);
        	    			logger.debug("Prepared AccTradeLedger: ",AccTradeLedger);



        	    			/////////////////////////////PAY0016D////////////////////////////////////////////
        	    			AccOrderBill.put("ACC_BILL_ID", 0);
        	    			AccOrderBill.put("ACC_BILL_TASK_ID", 0);
        	    			AccOrderBill.put("ACC_BILL_REF_DT", CommonUtils.getNowDate());
        	    			AccOrderBill.put("ACC_BILL_REF_NO", "1000");
        	    			AccOrderBill.put("ACC_BILL_ORD_ID", Integer.parseInt(params.get("hidSalesOrderId").toString()));
        	    			AccOrderBill.put("ACC_BILL_ORD_NO", CommonUtils.nvl(params.get("hidTaxInvDSalesOrderNo")).toString());
        	    			AccOrderBill.put("ACC_BILL_TYPE_ID", 1159);
        	    			AccOrderBill.put("ACC_BILL_MODE_ID", 1164);
        	    			AccOrderBill.put("ACC_BILL_SCHDUL_ID", 0);
        	    			AccOrderBill.put("ACC_BILL_SCHDUL_PRIOD", 0);
        	    			AccOrderBill.put("ACC_BILL_ADJ_ID", 0);
        	    			AccOrderBill.put("ACC_BILL_SCHDUL_AMT", outrightBalance);
        	    			AccOrderBill.put("ACC_BILL_ADJ_AMT", 0);
        	    			AccOrderBill.put("ACC_BILL_NET_AMT", outrightBalance);
        	    			AccOrderBill.put("ACC_BILL_STUS", 1);

        	    			if(null  !=params.get("hidTradeLedger_InstallNo") ){
        	        			AccOrderBill.put("ACC_BILL_REM",  invoiceNo);
        	    			}else{
        	    				AccOrderBill.put("ACC_BILL_REM",  " ");
        	    			}

        	    			AccOrderBill.put("ACC_BILL_CRT_DT", CommonUtils.getNowDate());
        	    			AccOrderBill.put("ACC_BILL_CRT_USER_ID", sessionVO.getUserId());
        	    			AccOrderBill.put("ACC_BILL_GRP_ID", 0);
        	    			AccOrderBill.put("ACC_BILL_TAX_CODE_ID", TAXRATE == 0 ? 28 : 39);
        	    			AccOrderBill.put("ACC_BILL_TAX_RATE", TAXRATE);

        	    			if(TAXRATE ==6){
        	      	    		 AccOrderBill.put("ACC_BILL_TXS_AMT", Double.toString( outrightBalance -( outrightBalance  * 100 / 106)));
        	    			}else{
        	    				AccOrderBill.put("ACC_BILL_TXS_AMT", 0);
        	    			}

        	    			AccOrderBill.put("ACC_BILL_ACCT_CNVR", 0);
        	    			AccOrderBill.put("ACC_BILL_CNTRCT_ID", 0);
        	    			logger.debug("prepared AccOrderBill: ",AccOrderBill);
        	    			/////////////////////////////PAY0016D////////////////////////////////////////////


        	    		}


    			 }


    	//	//FAIL
		if( params.get("installStatus").toString().equals("21")){
			//FAIL
			callEntry.put("callEntryId", 0);
			callEntry.put("salesOrderId", Integer.parseInt(params.get("hidSalesOrderId").toString()));
			callEntry.put("typeId", Integer.parseInt(params.get("hidCallType").toString()) );
			callEntry.put("statusCodeId", 19);
			callEntry.put("resultId", 0);
			callEntry.put("docId", CommonUtils.nvl(params.get("hidDocId")));
			callEntry.put("creator", sessionVO.getUserId());
			callEntry.put("created", new Date());
			callEntry.put("callDate", nextDateCall);
			callEntry.put("isWaitForCancel", false);
			callEntry.put("happyCallerId", 0);
			callEntry.put("updated", new Date());
			callEntry.put("updator", sessionVO.getUserId());
			callEntry.put("oriCallDate", nextDateCall);

			logger.debug("callEntry1111 : {}", callEntry);
			//installationResultListMapper.insertCallEntry(callEntry);

			callResult.put("callResultId", 0);
			callResult.put("callEntryId", 0);
			callResult.put("callStatusId", 19);
			callResult.put("callCallDate", nextDateCall);
			callResult.put("callActionDate", "01/01/1900");
			callResult.put("callFeedBackId", 0);
			callResult.put("callCTID", 0);
			callResult.put("callRemark", installResult.get("remark"));
			callResult.put("callCreateBy", sessionVO.getUserId());
			callResult.put("callCreateAt", new Date());
			callResult.put("callCreateByDept",0);
			callResult.put("callHCID",0);
			callResult.put("callROSAmt",0);
			callResult.put("callSMS",false);
			callResult.put("callSMSRemark","");

			logger.debug("callResultJInmu : {}", callResult);
			//installationResultListMapper.insertCallResult(callResult);

			//callEntry.put("resultId", "위에 쿼리 시퀀스");
			//installationResultListMapper.updateCallEntry(callEntry);

			orderLog.put("LogID", 0);
			orderLog.put("salesOrderId", Integer.parseInt(params.get("hidSalesOrderId").toString()));
			orderLog.put("progressId",  Integer.parseInt(params.get("hidCallType").toString()) == 257 ? 2:3);
			orderLog.put("logDate", new Date());
			orderLog.put("refId", 0);
			orderLog.put("isLock", 0);
			orderLog.put("logCreator", sessionVO.getUserId());
			orderLog.put("logCreated", new Date());

			logger.debug("orderLog : {}", orderLog);
			//installationResultListMapper.insertOrderLog(orderLog);
		}



		if(Integer.parseInt(CommonUtils.nvl(params.get("installStatus")).toString()) == 4){
			resultValue.put("value", "Completed");

			orderLog.put("LogID", 0);
			orderLog.put("salesOrderId", Integer.parseInt(params.get("hidSalesOrderId").toString()));
			orderLog.put("progressId",  5);
			orderLog.put("logDate", new Date());
			orderLog.put("refId", 0);
			orderLog.put("isLock", 0);
			orderLog.put("logCreator", sessionVO.getUserId());
			orderLog.put("logCreated", new Date());


		}else{
			resultValue.put("value", "Fail");
		}
		resultValue.put("installEntryNo", CommonUtils.nvl(params.get("hiddeninstallEntryNo")));



		//////////////////////////// insertInstallation ////////////////////////////////
		insertInstallation(statusId
							   ,ApptypeID
							   ,installResult
							   ,callEntry
							   ,callResult
							   ,orderLog
							   ,TaxinvoiceCompany
							   ,AccTradeLedger
							   ,AccOrderBill
							   ,taxInvoiceOutright
							   ,taxInvoiceOutrightSub
							   ,salesOrderM ,isBillAvb );

        ////////////////////////////insertInstallation ////////////////////////////////







		////////////////////////물류 호출   add by hgham/////////////////////////////
        Map<String, Object>  logPram = null ;
		if(Integer.parseInt(params.get("installStatus").toString()) == 4 ){
			/////////////////////////물류 호출//////////////////////
			logPram =new HashMap<String, Object>();
            logPram.put("ORD_ID",  params.get("hiddeninstallEntryNo") );
            logPram.put("RETYPE", "COMPLET");
            logPram.put("P_TYPE", "OD01");
            logPram.put("P_PRGNM", "INSCOM");
            logPram.put("USERID", sessionVO.getUserId());

            logger.debug("install 물류 호출 PRAM ===>"+ logPram.toString());
            servicesLogisticsPFCMapper.SP_LOGISTIC_REQUEST(logPram);
        	logPram.put("P_RESULT_TYPE", "IN");
    		logPram.put("P_RESULT_MSG", logPram.get("p1"));
            logger.debug("install 물류 호출 결과 ===>" +logPram);
            /////////////////////////물류 호출 END //////////////////////

      }else if(Integer.parseInt(params.get("installStatus").toString()) == 21){

    	  /////////////////////////물류 호출//////////////////////
    		logPram =new HashMap<String, Object>();
            logPram.put("ORD_ID",    params.get("hiddeninstallEntryNo") );
            logPram.put("RETYPE", "SVO");
            logPram.put("P_TYPE", "OD02");
            logPram.put("P_PRGNM", "INSCAN");
            logPram.put("USERID", sessionVO.getUserId());

            logger.debug("install 물류  CANCEL 호출 PRAM ===>"+ logPram.toString());
            servicesLogisticsPFCMapper.SP_LOGISTIC_REQUEST(logPram);
            logPram.put("P_RESULT_TYPE", "IN");
    		logPram.put("P_RESULT_MSG", logPram.get("p1"));
            logger.debug("install 물류 CANCEL  호출 결과 ===>");
            /////////////////////////물류 호출 END //////////////////////
      }
       resultValue.put("spMap", logPram);
      ////////////////////////물류 호출   add by hgham/////////////////////////////


		return resultValue;
	}




	@Transactional
	private boolean insertInstallation(int statusId,String ApptypeID,Map<String, Object> installResult,Map<String, Object> callEntry
													,Map<String, Object> callResult,Map<String, Object> orderLog, Map<String,Object> TaxinvoiceCompany
													,Map<String,Object>AccTradeLedger,Map<String,Object>AccOrderBill,Map<String,Object>taxInvoiceOutright,
													Map<String,Object>taxInvoiceOutrightSub,Map<String,Object>salesOrderM  ,boolean isBillAvb ) throws ParseException{


		//installEntry status가 1,21 이면 그 밑에 있는걸 ㅌ야된다(컴플릿이 되어도 다시 상태값 변경 가능하게 해야된다
    		String maxId = "";  //각 테이블에 maxid 값 가져온다(다음 실행할 쿼리에 값을 넣기 위해 사용)
    		EgovMap maxIdValue = new EgovMap();
    		installationResultListMapper.insertInstallResult(installResult);
    		EgovMap entry = installationResultListMapper.selectEntry(installResult);
    		logger.debug("entry : {}", entry);
    		maxIdValue.put("value", "resultId");
    		maxId = installationResultListMapper.selectMaxId(maxIdValue);
    		logger.debug("maxId : {}", maxId);
    		EgovMap maxtaxInvoiceID = new EgovMap();
    		maxtaxInvoiceID.put("value", "taxInvoiceId");
    		String maxTaxInvoiceID = installationResultListMapper.selectMaxId(maxtaxInvoiceID);
    		//String ApptypeID = (String) TaxinvoiceCompany.get("ApptypeID");

    		//update SalesM Status
    		installationResultListMapper.updateSalesOrderMStatus(salesOrderM);


    		if("66".equals(ApptypeID)) {

    			if(installResult.get("statusCodeId").toString().equals("4")){
    				EgovMap  s46dup =new EgovMap();
    				s46dup.put("installResultId", maxId );
    				s46dup.put("stusCodeId", installResult.get("statusCodeId"));
    				s46dup.put("updated",  installResult.get("created"));
    				s46dup.put("updator",  installResult.get("creator"));
    				s46dup.put("installEntryId",  installResult.get("entryId"));

            		installationResultListMapper.updateInstallEntry(s46dup);

    			}
    		}


    		if("67".equals(ApptypeID)   || "68".equals(ApptypeID) || "1412".equals(ApptypeID)){	//api 추가

    			if(isBillAvb){
            		//insert taxinvoiceRental
            		//installationResultListMapper.insertTaxInvoiceCompany(TaxinvoiceCompany);

        			//insert taxinvoiceOutright
            		installationResultListMapper.insertTaxInvoiceOutright(taxInvoiceOutright);
            		//insert taxinvoiceOutright_Sub
            		installationResultListMapper.insertTaxInvoiceOutrightSub(taxInvoiceOutrightSub);
            		//insert tradeLedger
            		installationResultListMapper.insertAccTradeLedger(AccTradeLedger);
            		//insert Accorderbill
            		installationResultListMapper.insertAccorderBill(AccOrderBill);

    			}

        		entry.put("installResultId", maxId);
        		entry.put("stusCodeId", installResult.get("statusCodeId"));
        		entry.put("updated",  installResult.get("created"));
        		entry.put("updator",  installResult.get("creator"));
        		installationResultListMapper.updateInstallEntry(entry);
		}



    	//	Complete
        if(installResult.get("statusCodeId").toString().equals("4")){
        	installationResultListMapper.insertOrderLog(orderLog);
        }


        //Fail
        if(installResult.get("statusCodeId").toString().equals("21")){
        	if(callEntry != null){
				installationResultListMapper.insertCallEntry(callEntry);
				//callEntry에 max 값 구해서 CallResult에 저장
				maxIdValue.put("value", "callEntryId");
				maxId = installationResultListMapper.selectMaxId(maxIdValue);
				callResult.put("callEntryId", maxId);
				installationResultListMapper.insertCallResult(callResult);
				//callresult에 max값 구해서 callEntry에 업데이트
				maxIdValue.put("value", "callResultId");
				maxId = installationResultListMapper.selectMaxId(maxIdValue);
				callEntry.put("resultId", maxId);
				maxIdValue.put("value", "resultId");
				maxId = installationResultListMapper.selectMaxId(maxIdValue);
				callEntry.put("callEntryId", maxId);
				installationResultListMapper.updateCallEntry(callEntry);
				
				
				Map m = new HashMap();
				m.put("installEntryId", CommonUtils.nvl( installResult.get("entryId")));
				m.put("stusCodeId", "21");
				m.put("creator",installResult.get("creator"));
				m.put("installResultId", maxId );
        		installationResultListMapper.updateInstallEntry(m);
		
				
				
			}

        	installationResultListMapper.insertOrderLog(orderLog);
        }





    	/////////////////////////////////	happyCall////////////////////////////
		Map<String, Object> happyCall = new HashMap<String, Object>();
		//happyCall.put("HCID", 0);
		happyCall.put("HCSOID", salesOrderM.get("salesOrdId"));
		happyCall.put("HCCallEntryId", 0);
		happyCall.put("HCTypeNo", entry.get("installEntryNo"));
		happyCall.put("HCTypeId", 508);
		happyCall.put("HCStatusId", 33);
		happyCall.put("HCRemark", "");
		happyCall.put("HCCommentTypeId", 0);

		happyCall.put("HCCommentGId", 0);
		happyCall.put("HCCommentSId", 0);
		happyCall.put("HCCommentDId", 0);
		happyCall.put("creator", installResult.get("creator"));
		happyCall.put("created", new Date());
		happyCall.put("updator", installResult.get("creator"));
		happyCall.put("updated", new Date());
		happyCall.put("HCNoService", false);
		happyCall.put("HCLock", false);
		happyCall.put("HCCloseId", 0);
		logger.debug("happyCall : {}", happyCall);
		installationResultListMapper.insertHappyCall(happyCall);
		/////////////////////////////////	happyCall////////////////////////////

		return true;
	}




	@Override
	public List<EgovMap> assignCtList(Map<String, Object> params) {
		return installationResultListMapper.assignCtList(params);
	}

	@Override
	public List<EgovMap> assignCtOrderList(Map<String, Object> params) {
		return installationResultListMapper.assignCtOrderList(params);
	}


	@Override
	public Map<String, Object>  updateAssignCT(Map<String, Object> params) {
		List <EgovMap> updateItemList = (List<EgovMap>) params.get(AppConstants.AUIGRID_UPDATE);
		Map<String, Object> resultValue = new HashMap<String, Object>();
		int rtnValue  = 0;
		int successCnt = 0;
		int failCnt = 0;
		List<String> successList = new ArrayList<String>();
		List<String> failList = new ArrayList<String>();

		if (updateItemList.size() > 0) {

			for (int i = 0; i < updateItemList.size(); i++) {
				Map<String, Object> updateMap = (Map<String, Object>) updateItemList.get(i);
				logger.debug("updateMap : {}", updateMap);
				
				// Transfer 실행 여부 제어 로직 추가 (프로시저 호출)
				// 프로시저 호출하여 그 결과에 따라 updateAssignCT 실행
				// Transfer 불가능한 경우, 메시지창을 띄워 알려줌
				String procResult;
				/////////////////////////물류 호출//////////////////////
                Map<String, Object>  transProc = null ;
            	transProc =new HashMap<String, Object>();
            	transProc.put("SVONO",  updateMap.get("installEntryNo") );
            	transProc.put("F_CT", updateMap.get("ctId") );
            	transProc.put("T_CT", updateMap.get("insstallCtId") );
            	transProc.put("P_PRGNM", "TRNSFR");
            	transProc.put("P_USER", "9999999999");
            
                logger.debug("Transfer 물류 호출 PRAM ===> "+ transProc.toString());
                servicesLogisticsPFCMapper.SP_LOGISTIC_REQUEST_TRANS(transProc);
                procResult = transProc.get("p1").toString().substring(0, 3);
                logger.debug("Transfer 물류 호출 결과 ===> " +procResult);
                /////////////////////////물류 호출 END //////////////////////

                if (procResult.equals("000")) {
                	rtnValue = installationResultListMapper.updateAssignCT(updateMap) ;
                	successCnt += rtnValue;
                	successList.add(updateMap.get("installEntryNo").toString());
                } else {
                	failCnt++;
                	failList.add(updateMap.get("installEntryNo").toString());
                }
				
			}
		}
		resultValue.put("successCnt", successCnt);
		resultValue.put("successList", successList);
		resultValue.put("failCnt", failCnt);
		resultValue.put("failList", failList);
		
		logger.debug("resultValue : {}", resultValue);
		return resultValue;
	}

	//@Override
	public List<EgovMap> selectInstallationNoteListing(Map<String, Object> params) throws ParseException{

		return installationResultListMapper.selectInstallationNoteListing(params);
	}

	@Override
	public EgovMap selectInstallInfo(Map<String, Object> params) {
		return installationResultListMapper.selectInstallInfo(params);
	}

	@Override
	public int editInstallationResult(Map<String, Object> params, SessionVO sessionVO) throws ParseException {
		int resultValue =installationResultListMapper.updateInstallResultEdit(params);

		return resultValue;
	}


	@Override
	public int  isInstallAlreadyResult(Map<String, Object> params) {
		return installationResultListMapper.isInstallAlreadyResult(params);
	}

	@Override
	public EgovMap validationInstallationResult(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return installationResultListMapper.validationInstallationResult(params);
	}

	@Override
	public EgovMap getLocInfo(Map<String, Object> params) {
		return installationResultListMapper.getLocInfo(params);
	}

	@Override
	public EgovMap getInstallationResultInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return installationResultListMapper.getInstallationResultInfo(params);
	}

	@Override
	public List<EgovMap> viewInstallationResult(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return installationResultListMapper.viewInstallationResult(params);
	}
}
