package com.coway.trust.web.services.installation;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.sales.order.OrderDetailService;
import com.coway.trust.biz.sample.SampleDefaultVO;
import com.coway.trust.biz.services.installation.InstallationReversalService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/services")
public class InstallationReversalController {
	private static final Logger logger = LoggerFactory.getLogger(InstallationReversalController.class);
	
	@Resource(name = "installationReversalService")
	private InstallationReversalService installationReversalService;
	@Resource(name = "commonService")
	private CommonService commonService;
	@Resource(name = "orderDetailService")
	private OrderDetailService orderDetailService;
	
	/**
	 * organization transfer page  
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/installationReversal.do")
	public String installationResultList(@RequestParam Map<String, Object> params, ModelMap model) {
		
		List<EgovMap> selectReverseReason = installationReversalService.selectReverseReason();
		List<EgovMap> selectFailReason = installationReversalService.selectFailReason();
		
		
		
		model.addAttribute("selectReverseReason", selectReverseReason);
		model.addAttribute("selectFailReason", selectFailReason);
		
		return "services/installation/installationReversal";
	}
	
	/**
	 * Search installation reversal orderNo
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/installationReversalSearch", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> installationReversalListSearch(@ModelAttribute("searchVO") SampleDefaultVO searchVO, @RequestParam Map<String, Object> params, ModelMap model) {

//		logger.debug("orderNo : {}", params.get("orderNo"));

		List<EgovMap> orderList = installationReversalService.selectOrderList(params);
//		logger.debug("list : {}", orderList);
		return ResponseEntity.ok(orderList);
	}
	
	@RequestMapping(value = "/installationReversalSearchDetail" ,method = RequestMethod.POST)
	public ResponseEntity<Map>  installationReversalSearchDetail(@RequestBody Map<String, Object> params, Model model)	throws Exception {
		
//		logger.debug("in  installation reversal detail ");
//		logger.debug("			pram set  log");  
//		logger.debug("					" + params.toString());
//		logger.debug("			pram set end  ");
//		
		
		EgovMap  list1 = installationReversalService.installationReversalSearchDetail1(params);
		EgovMap  list2 = installationReversalService.installationReversalSearchDetail2(params);
		EgovMap  list3 = installationReversalService.installationReversalSearchDetail3(params);
		EgovMap  list4 = installationReversalService.installationReversalSearchDetail4(params);
		EgovMap  list5 = installationReversalService.installationReversalSearchDetail5(params);
		
//		logger.debug("list : {}", list1);
		
		
		Map<String, Object> map = new HashMap();
		map.put("list1", list1);
		map.put("list2", list2);
		map.put("list3", list3);
		map.put("list4", list4);
		map.put("list5", list5);
		
		return ResponseEntity.ok(map);
	}
	
	@RequestMapping(value = "/saveResaval", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveResaval(@RequestBody Map<String, Object> params, Model model,SessionVO sessionVO) throws Exception {
		logger.debug("-------------1---------------");
		EgovMap returnMap = new EgovMap();
		int userId = sessionVO.getUserId();
		params.put("userId", userId);
		
		String defaultDate = "1900-01-01";
		//Map<String, Object> formData = (Map<String, Object>)params.get(AppConstants.AUIGRID_FORM); // 폼 객체 데이터 가져오기
		//formData.put("user_id", userId);
		
		
		int callTypeId = Integer.parseInt(params.get("callTypeId").toString());	//ccr0006d.type_id
		int result = 0 ;
		
		int installResultID = Integer.parseInt(params.get("einstallEntryId").toString());
		int installEntryID = Integer.parseInt(params.get("einstallEntryId").toString());
		String installDate = params.get("instalStrlDate").toString();
		String nextCallDate = params.get("nextCallStrlDate").toString();
		String remark = params.get("reverseReasonText").toString();
		String failReason =params.get("failReason").toString();
		String ctID = params.get("ectid").toString(); 
		int applicationTypeID = Integer.parseInt(params.get("applicationTypeID").toString());
		int salesOrderID = Integer.parseInt(params.get("esalesOrdId").toString());
		String salesDt = params.get("esalesDt").toString();
		
		int defaultPacID=0;
		
		if(Integer.parseInt(params.get("applicationTypeID").toString())==66){
			defaultPacID=4;
		}else if(Integer.parseInt(params.get("applicationTypeID").toString())==67 || Integer.parseInt(params.get("applicationTypeID").toString())==68 || Integer.parseInt(params.get("applicationTypeID").toString())==142){
			defaultPacID=3;
		}else if(Integer.parseInt(params.get("applicationTypeID").toString())==144){
			defaultPacID=10;
		}else{
			defaultPacID=2;
		}
		params.put("defaultPacID",defaultPacID);
		
		int memID = 0;
		memID = installationReversalService.getMemIDBySalesOrderIDAndPacID(params);
		params.put("memID",memID);
		
		int configID = 0;
		configID = installationReversalService.getLatestConfigIDBySalesOrderID(params);
		params.put("configID",configID);
		
		int hcID = 0;
		hcID = installationReversalService.getHCIDBySalesOrderID(params);
		params.put("hcID",hcID);
		
		int inChargeCTWHID;
		int retWarehouseID;
		String warehouseGrade;
		int productID;
		
		String customerName = params.get("eCustomerName").toString();  
		String installNo = params.get("einstallEntryNo").toString();
		
		EgovMap  installresults = installationReversalService.getInstallResults(params);
		
		Map<String, Object> InstallresultReverse = new HashMap();
		InstallresultReverse.put("InstallResultID", installresults.get("resultId"));
		InstallresultReverse.put("InstallEntryID", installresults.get("entryId"));
		InstallresultReverse.put("InstallStatusID", installresults.get("stusCodeId"));
		InstallresultReverse.put("InstallCTID", installresults.get("ctId"));
		InstallresultReverse.put("InstallDate", installresults.get("installDt"));
		InstallresultReverse.put("InstallRemark", installresults.get("rem"));
		InstallresultReverse.put("GLPost", installresults.get("glPost"));
		InstallresultReverse.put("InstallCreateBy", installresults.get("crtUserId"));
		InstallresultReverse.put("InstallCreateAt", installresults.get("crtDt"));
		InstallresultReverse.put("InstallSirimNo", installresults.get("sirimNo"));
		InstallresultReverse.put("InstallSerialNo", installresults.get("serialNo"));
		InstallresultReverse.put("InstallFailID", installresults.get("fail_id"));
		InstallresultReverse.put("InstallNextCallDate", installresults.get("nextCallDt"));
		InstallresultReverse.put("InstallAllowComm", installresults.get("allowComm"));
		InstallresultReverse.put("InstallIsTradeIn", installresults.get("isTradeIn"));
		InstallresultReverse.put("InstallRequireSMS", installresults.get("requireSms"));
		InstallresultReverse.put("InstallDocRefNo1", installresults.get("docRefNo1"));
		InstallresultReverse.put("InstallDocRefNo2", installresults.get("docRefNo2"));
		InstallresultReverse.put("InstallUpdateAt", installresults.get("updDt"));
		InstallresultReverse.put("InstallUpdateBy", installresults.get("updUserId"));
		InstallresultReverse.put("InstallAdjAmount", installresults.get("adjAmt"));
		InstallresultReverse.put("einstallEntryId", params.get("einstallEntryId"));
		
		if(callTypeId == 257){ //ccr0006d.type_id = 257
			logger.debug("-------------2---------------");
			//result = installationReversalService.saveReverseNewInstallationResult(params);
		
    		
    		installationReversalService.updateInstallresult(params);
    		installationReversalService.addInstallresultReverse(InstallresultReverse);
    		installationReversalService.updateInstallEntry(params);
    		
    		Map<String, Object> srvMembershipSale = new HashMap();
    		srvMembershipSale.put("SrvMemID", memID);
    		srvMembershipSale.put("SrvStatusCodeID", '8');
    		srvMembershipSale.put("userId", userId);
    		
    		installationReversalService.updateSrvMembershipSale(srvMembershipSale);
    		
    		
    		Map<String, Object> srvConfiguration = new HashMap();
    		srvConfiguration.put("SrvConfigID", configID);
    		srvConfiguration.put("SrvStatusID", 8);
    		srvConfiguration.put("SrvRemark", "INSTALLATION RESULT REVERSAL");
    		srvConfiguration.put("userId", userId);
    		
    		installationReversalService.updateSrvConfiguration(srvConfiguration);
    		
    		
    		Map<String,Object> srvConfigSetting = new HashMap();
    		srvConfigSetting.put("SrvConfigID", configID);
    		srvConfigSetting.put("SrvSettStatusID", 8);
    		srvConfigSetting.put("SrvSettRemark", "INSTALLATION RESULT REVERSAL");
    		
    		installationReversalService.updateSrvConfigSetting(srvConfigSetting);
    		
    		
    		Map<String,Object> srvConfigPeriod = new HashMap();
    		srvConfigPeriod.put("SrvConfigID", configID);
    		srvConfigPeriod.put("SrvPrdStatusID", 8);
    		srvConfigPeriod.put("SrvPrdRemark", "INSTALLATION RESULT REVERSAL");
    		srvConfigPeriod.put("userId", userId);
    		
    		installationReversalService.updateSrvConfigPeriod(srvConfigPeriod);
    		
    		Map<String,Object> srvConfigFilter = new HashMap();
    		srvConfigFilter.put("SrvConfigID",configID);
    		srvConfigFilter.put("SrvFilterStatusID",8);
    		srvConfigFilter.put("SrvFilterRemark","INSTALLATION RESULT REVERSAL");
    		srvConfigFilter.put("userId",userId);
    		
    		installationReversalService.updateSrvConfigFilter(srvConfigFilter);
    		
    		
    		Map<String,Object> happyCallM = new HashMap();
    		happyCallM.put("HCID", hcID);
    		happyCallM.put("HCStatusID", 8);
    		happyCallM.put("HCRemark", "INSTALLATION RESULT REVERSAL");
    		happyCallM.put("userId", userId);
    		
    		installationReversalService.updateHappyCallM(happyCallM);
    		
    		
    		Map<String,Object> salesOrderM = new HashMap();
    		salesOrderM.put("SalesOrderID", salesOrderID);
    		salesOrderM.put("StatusCodeID", 1);
    		salesOrderM.put("SyncCheck", 1);
    		salesOrderM.put("userId", userId);
    		salesOrderM.put("PVMonth", 0);
    		salesOrderM.put("PVYear", 0);
    		salesOrderM.put("AppTypeID", applicationTypeID);
    		salesOrderM.put("SalesDate", salesDt);
    		
    		installationReversalService.updateSalesOrderM(salesOrderM);
    		
    		
    		Map<String,Object> installation = new HashMap();
    		installation.put("SalesOrderID", salesOrderID);
    		installation.put("IsTradeIn", 1);
    		installation.put("userId", userId);
    		
    		installationReversalService.updateInstallation(installation);
    		
    		Map<String,Object> callEntry = new HashMap();
    		callEntry.put("SalesOrderID", salesOrderID);
    		callEntry.put("TypeID", 257);
    		callEntry.put("StatusCodeID", 1);
    		callEntry.put("ResultID", 0);
    		callEntry.put("DocID", salesOrderID);
    		callEntry.put("userId", userId);
    		callEntry.put("CallDate", nextCallDate);
    		callEntry.put("IsWaitForCancel", 1);
    		callEntry.put("OriCallDate", nextCallDate);
    		
    		installationReversalService.addCallEntry(callEntry);
    		
    		int  CallEntryId = installationReversalService.getCallEntry(params);
    		
    		Map<String,Object> callResult = new HashMap();
    		//callResult.put("CallResultID", 0);
    		callResult.put("CallEntryID", CallEntryId);
    		callResult.put("CallStatusID", 1);
    		callResult.put("CallCallDate", defaultDate);
    		callResult.put("CallActionDate", defaultDate);
    		callResult.put("CallFeedBackID", 0);
    		callResult.put("CallCTID", 0);
    		callResult.put("CallRemark", remark);
    		callResult.put("userId", userId);
    		callResult.put("CallCreateByDept", 0);
    		callResult.put("CallHCID", 0);
    		callResult.put("CallROSAmt", 0);
    		callResult.put("CallSMS", 0);
    		callResult.put("CallSMSRemark", "");
    		
    		installationReversalService.addCallResult(callResult);
    		
    		
    		Map<String,Object> salesorderLog = new HashMap();
    		salesorderLog.put("SalesOrderID", salesOrderID);
    		salesorderLog.put("ProgressID", 2);
    		salesorderLog.put("RefID", 0);
    		salesorderLog.put("IsLock", 0);	//true
    		salesorderLog.put("userId", userId);
    		salesorderLog.put("CallEntryId", CallEntryId);
    		
    		installationReversalService.addSalesorderLog(salesorderLog);
    		
    		String rentDateTime = "2017-02-01";
            params.put("rentDateTime", rentDateTime);
            
            EgovMap  rv = installationReversalService.getRequiredView(params);
            
            params.put("TotalAmt", rv.get("totAmt"));
    		
    		int adjTypeSetID = 0;
            int adjDrAccID = 0;
            int adjCrAccID = 0;
            
            if(Integer.parseInt(params.get("applicationTypeID").toString())==66 || Integer.parseInt(params.get("applicationTypeID").toString())==67 || Integer.parseInt(params.get("applicationTypeID").toString())==68){
            	logger.debug("-------------3---------------");
            	if(Integer.parseInt(params.get("applicationTypeID").toString())==66){
            		adjTypeSetID = 7;
                    adjDrAccID = 171;
                    adjCrAccID = 43;
                    
                    
            	}else if (Integer.parseInt(params.get("applicationTypeID").toString()) == 67)
                {
                    adjTypeSetID = 8;
                    adjDrAccID = 166;
                    adjCrAccID = 38;
                }else
                {
                    adjTypeSetID = 9;
                    adjDrAccID = 166;
                    adjCrAccID = 38;
                } 
            	
            	params.put("adjTypeSetID", adjTypeSetID);
                params.put("adjDrAccID", adjDrAccID);
                params.put("adjCrAccID", adjCrAccID);
                
                SimpleDateFormat format = new SimpleDateFormat("YYYY-MMM-DD");
                
                String esalesDt = params.get("esalesDt").toString();
                
                Date salesdate = null;
                Date mthapril = null;
                
                mthapril =  format.parse("2015-APR-01");
                salesdate = format.parse(esalesDt);
                System.out.println(salesdate);
                
                if (salesdate.compareTo(mthapril)<0){
                	logger.debug("-------------4---------------");
                	String adJEntryReportNo = null;
                	params.put("docno",18);
                	adJEntryReportNo = installationReversalService.getDOCNumber(params);
                	params.put("adJEntryReportNo", adJEntryReportNo);
                	String adjEntryNoteNo = null;
                	params.put("docno",15);
                	adjEntryNoteNo = installationReversalService.getDOCNumber(params);
                	params.put("adjEntryNoteNo", adjEntryNoteNo);
                	
                	params.put("docNoId",18);
                	installationReversalService.updateDOCNumber(params);
                	params.put("docNoId",15);
                	installationReversalService.updateDOCNumber(params);
                
                
                    installationReversalService.addAccAdjTransEntry(params);
                    int adjEntryId = installationReversalService.selectLastadjEntryId();
                    
                    params.put("adjEntryId",adjEntryId);
                    installationReversalService.addAccAdjTransResult(params);
                    /*
                    String trxNo = installationReversalService.getDOCNumberOnlyNumber();
                    params.put("trxNo", trxNo);
                    */
                    
                    /*
                    Map<String,Object> accTRXPlus = new HashMap();
                    accTRXPlus.put("TRXItemNo", 1);
                    accTRXPlus.put("TRXGLAccID", adjDrAccID);
                    accTRXPlus.put("TRXGLDept", "");
                    accTRXPlus.put("TRXProject", "");
                    accTRXPlus.put("TRXFinYear", 0);
                    accTRXPlus.put("TRXPeriod", 0);
                    accTRXPlus.put("TRXSourceTypeID", 391);
                    accTRXPlus.put("TRXDocTypeID", 155);
                    accTRXPlus.put("TRXCustBillID", 0);
                    accTRXPlus.put("TRXChequeNo", "");
                    accTRXPlus.put("TRXCRCardSlip", "");
                    accTRXPlus.put("TRXBisNo", "");
                    accTRXPlus.put("TRXReconDate", defaultDate);
                    accTRXPlus.put("TRXRemark", params.get("eCustomerName"));
                    accTRXPlus.put("TRXCurrID", "RM");
                    accTRXPlus.put("TRXCurrRate", 1);
                    accTRXPlus.put("TRXAmount", Integer.parseInt(rv.get("totAmt").toString()));
                    accTRXPlus.put("TRXAmountRM", Integer.parseInt(rv.get("totAmt").toString()));
                    accTRXPlus.put("TRXIsSynch", 1);
                    
                    int trxNo = Integer.parseInt(installationReversalService.getDOCNumberOnlyNumber().toString());
                    accTRXPlus.put("TRXNo", trxNo);
                    accTRXPlus.put("TRXDocNo", adjEntryNoteNo);
                    
                    installationReversalService.addAccTRXes(accTRXPlus);
                    
                    
                    Map<String,Object> accTRXMinus = new HashMap();
                    accTRXMinus.put("TRXItemNo", 2);
                    accTRXMinus.put("TRXGLAccID", adjDrAccID);
                    accTRXMinus.put("TRXGLDept", "");
                    accTRXMinus.put("TRXProject", "");
                    accTRXMinus.put("TRXFinYear", 0);
                    accTRXMinus.put("TRXPeriod", 0);
                    accTRXMinus.put("TRXSourceTypeID", 391);
                    accTRXMinus.put("TRXDocTypeID", 155);
                    accTRXMinus.put("TRXCustBillID", 0);
                    accTRXMinus.put("TRXChequeNo", "");
                    accTRXMinus.put("TRXCRCardSlip", "");
                    accTRXMinus.put("TRXBisNo", "");
                    accTRXMinus.put("TRXReconDate", defaultDate);
                    accTRXMinus.put("TRXRemark", params.get("eCustomerName"));
                    accTRXMinus.put("TRXCurrID", "RM");
                    accTRXMinus.put("TRXCurrRate", 1);
                    accTRXMinus.put("TRXAmount", Integer.parseInt(rv.get("totAmt").toString())*-1);
                    accTRXMinus.put("TRXAmountRM", Integer.parseInt(rv.get("totAmt").toString())*-1);
                    accTRXMinus.put("TRXIsSynch", 1);
                    
                    installationReversalService.addAccTRXes(accTRXMinus);
                    
                    */
                    if(Integer.parseInt(params.get("applicationTypeID").toString())==66){
                    	logger.debug("-------------5---------------");
                    	EgovMap  qryPreBill = installationReversalService.getQryPreBill(params);
//                    	params.put("TaxInvoiceRefNo",qryPreBill.get("taxInvcRefNo"));
//                    	params.put("TaxInvoiceAmountDue",qryPreBill.get("taxInvcAmtDue"));;
//                    	params.put("Updator",qryPreBill.get("uptUserId"));;
//                    	params.put("AccBillID",qryPreBill.get("accBillId"));;
                    	
                    	if(qryPreBill !=null){
                    		logger.debug("-------------6---------------");
                    		params.put("TaxInvoiceRefNo",qryPreBill.get("taxInvcRefNo"));
                        	params.put("TaxInvoiceAmountDue",qryPreBill.get("taxInvcAmtDue"));;
                        	params.put("Updator",qryPreBill.get("uptUserId"));;
                        	params.put("AccBillID",qryPreBill.get("accBillId"));;
                        	
                    		String VoidNo = null;
                    		params.put("docno",112);
                    		VoidNo = installationReversalService.getDOCNumber(params);
                    		params.put("VoidNo", VoidNo);
                    		params.put("docNoId",112);
                         	installationReversalService.updateDOCNumber(params);
                         	 
                         	installationReversalService.addAccOrderVoid_Invoice(params);
                         	
                         	installationReversalService.addAccOrderVoid_Invoice_Sub(params);
                         	
                         	installationReversalService.updateAccOrderBill(params);
                    	}
                    /*     	
                 	Map<String,Object> accTradeLedger = new HashMap();
                 	accTradeLedger.put("TradeSOID", salesOrderID);
                 	accTradeLedger.put("TradeDocTypeID", salesOrderID);
                 	accTradeLedger.put("TradeAmount", Integer.parseInt(rv.get("totAmt").toString())*-1);
                 	accTradeLedger.put("TradeInstNo", 0);
                 	accTradeLedger.put("TradeBatchNo", "0");
                 	accTradeLedger.put("TradeIsSync", 1);
                 	accTradeLedger.put("userId", userId);
                 	
                 	installationReversalService.addAccTradeLedger(accTradeLedger);
                 	*/
                    	
                	Map<String,Object> accRentLedger = new HashMap();
                 	accRentLedger.put("RentSOID", salesOrderID);
                 	accRentLedger.put("RentDocTypeID", 155);
                 	accRentLedger.put("RentAmount", Integer.parseInt(rv.get("totAmt").toString())*-1);
                 	installationReversalService.addAccRentLedger(params);
                 	
                 	installationReversalService.updateRentalScheme(params);
                 	
                 	installationReversalService.updateRentalScheme(params);
                         	
                    	
                    }else{
                    	logger.debug("-------------7---------------");
                    	EgovMap  qryPreBill = installationReversalService.getQryPreBill_out(params);
//                    	params.put("TaxInvoiceRefNo",qryPreBill.get("taxInvcRefNo"));
//                    	params.put("TaxInvoiceAmountDue",qryPreBill.get("taxInvcAmtDue"));;
//                    	params.put("Updator",qryPreBill.get("uptUserId"));;
//                    	params.put("AccBillID",qryPreBill.get("accBillId"));;
                    	
                    	if(qryPreBill !=null){
                    		logger.debug("-------------8---------------");
                    		params.put("TaxInvoiceRefNo",qryPreBill.get("taxInvcRefNo"));
                        	params.put("TaxInvoiceAmountDue",qryPreBill.get("taxInvcAmtDue"));;
                        	params.put("Updator",qryPreBill.get("uptUserId"));;
                        	params.put("AccBillID",qryPreBill.get("accBillId"));;
                        	
                    		String VoidNo = null;
                    		params.put("docno",112);
                    		VoidNo = installationReversalService.getDOCNumber(params);
                    		params.put("VoidNo", VoidNo);
                    		params.put("docNoId",112);
                         	installationReversalService.updateDOCNumber(params);
                         	 
                         	installationReversalService.addAccOrderVoid_Invoice(params);
                         	
                         	int AccInvVoidID = installationReversalService.getAccInvVoidID();
                         	params.put("AccInvVoidID",AccInvVoidID);
                         	
                         	installationReversalService.addAccOrderVoid_Invoice_Sub(params);
                         	
                         	installationReversalService.updateAccOrderBill(params);
                    	}
                         	
                     	installationReversalService.addAccTradeLedger(params);               	
                    	
                    }
                }else{
                	logger.debug("-------------9---------------");
                	if(Integer.parseInt(params.get("applicationTypeID").toString())==67 || Integer.parseInt(params.get("applicationTypeID").toString())==68){
                		logger.debug("-------------10---------------");
                		List<EgovMap> QryOutSList = installationReversalService.getQryOutS(params);
                		if(QryOutSList.size()>0){
                			logger.debug("-------------11---------------");
                			for(int i = 0 ; i<QryOutSList.size() ; i++){
                				params.put("TaxInvoiceID",QryOutSList.get(0).get("taxInvcId"));
                				params.put("InvoiceItemGSTTaxes",QryOutSList.get(0).get("invcItmGstTxs"));
                				params.put("InvoiceItemAmountDue",QryOutSList.get(0).get("invcItmAmtDue"));
                				params.put("InvocieItemID",QryOutSList.get(0).get("invcItmId"));
                				params.put("InvoiceItemGSTRate",QryOutSList.get(0).get("invcItmGstRate"));
                				params.put("InvoiceItemRentalFee",QryOutSList.get(0).get("invcItmRentalFee"));
                				params.put("InvoiceItemOrderNo",QryOutSList.get(0).get("invcItmOrdNo"));
                				params.put("InvoiceItemProductModel",QryOutSList.get(0).get("invcItmProductModel"));
                				params.put("InvoiceItemProductSerialNo",QryOutSList.get(0).get("invcItmProductSerialNo"));
                				
                				//,d.INVC_ITM_PRODUCT_MODEL,INVC_ITM_PRODUCT_SERIAL_NO
                				
                				
                				EgovMap  qryAccBill = installationReversalService.getQryAccBill(params);
                				params.put("AccBillID",qryAccBill.get("accBillId"));
                				params.put("TaxInvoiceRefNo",qryAccBill.get("taxInvcRefNo"));
                				params.put("TaxInvoiceRefDate",qryAccBill.get("taxInvcRefNo"));
                				params.put("TaxInvoiceCustName",qryAccBill.get("taxInvcCustName"));
                				params.put("TaxInvoiceContactPerson",qryAccBill.get("taxInvcCntcPerson"));
                				
                				params.put("TaxInvoiceAddress1",qryAccBill.get("taxInvcAddr1"));
                				params.put("TaxInvoiceAddress2",qryAccBill.get("taxInvcAddr2"));
                				params.put("TaxInvoiceAddress3",qryAccBill.get("taxInvcAddr3"));
                				params.put("TaxInvoiceAddress4",qryAccBill.get("taxInvcAddr4"));
                				params.put("TaxInvoicePostCode",qryAccBill.get("taxInvcPostCode"));
                				params.put("TaxInvoiceStateName",qryAccBill.get("taxInvcStateName"));
                				params.put("TaxInvoiceCountry",qryAccBill.get("taxInvcCnty"));
                				
                				params.put("TaxInvoiceAmountDue",qryAccBill.get("taxInvcAmtDue"));
                				
                				//TaxInvoiceCountry
                				//TAX_INVC_CNTY
    
                				installationReversalService.updateAccOrderBill2(params);
                				
                				String cnno = null;
                				params.put("docno",134);
                				cnno = installationReversalService.getDOCNumber(params);
                				params.put("cnno", cnno);
                				params.put("adjEntryNoteNo", cnno);
                				params.put("docNoId",134);
                				installationReversalService.updateDOCNumber_8Digit(params);
                				
                				String adJEntryReportNo = null;
                				params.put("docno",18);
                				adJEntryReportNo = installationReversalService.getDOCNumber(params);
                				params.put("adJEntryReportNo", adJEntryReportNo);
                				params.put("docNoId",18);
                				installationReversalService.updateDOCNumber(params);
                				
                				installationReversalService.addAccInvAdjr(params);
                				
                				int MemoAdjustID = installationReversalService.getMemoAdjustID();
                				params.put("MemoAdjustID", MemoAdjustID);
                				
                				String AccBillTaxCodeID = null;
                				AccBillTaxCodeID = installationReversalService.getAccBillTaxCodeID(params);
                				params.put("AccBillTaxCodeID", AccBillTaxCodeID);
                				
                				int crid = 0;
                                int drid = 0;
                                boolean conv = (boolean)qryAccBill.get("accBillAcctCnvr");
                                		//ACC_BILL_ACCT_CNVR; 
    
                                if (conv == false)
                                {
                                    crid = 38;
                                    drid = 535;
                                }
                                else
                                {
                                    crid = 38;
                                    drid = 166;
                                }
                                
                                params.put("crid",crid);
                                params.put("drid",drid);
                                
                                installationReversalService.addAccInvoiceAdjustment_Sub(params);
                                
                                installationReversalService.addAccTaxDebitCreditNote(params);
                                
                                int NoteID = installationReversalService.getNoteID();
                                params.put("NoteID",NoteID);
                                
                                installationReversalService.addAccTaxDebitCreditNote_Sub(params);
                                
                                String  VoidNo = null;
                                params.put("docno",112);
                                VoidNo = installationReversalService.getDOCNumber(params);
                                params.put("VoidNo", VoidNo);
                                params.put("docNoId",112);
                            	installationReversalService.updateDOCNumber(params);
                                
                            	installationReversalService.addAccOrderVoid_Invoice(params);
                            	params.put("adjEntryId",MemoAdjustID);
                            	params.put("TotalAmt",qryAccBill.get("taxInvcAmtDue"));
                            	
                            	installationReversalService.addAccOrderVoid_Invoice_Sub(params);
                            	
                            	installationReversalService.addAccTradeLedger(params);
                				
                			}
                		}
                	}
                }
            }
		}else{
			logger.debug("-------------12---------------");
			EgovMap  orderExchangeTypeByInstallEntryID = installationReversalService.GetOrderExchangeTypeByInstallEntryID(params);
			String hidPEAfterInstall = null;
			returnMap.put("spanInstallationType",orderExchangeTypeByInstallEntryID.get("soCurStusId"));
			if(Integer.parseInt(orderExchangeTypeByInstallEntryID.get("soCurStusId").toString())==25 || Integer.parseInt(orderExchangeTypeByInstallEntryID.get("soCurStusId").toString())==26){
				logger.debug("-------------13---------------");
				hidPEAfterInstall = "1";
				
				installationReversalService.updateInstallresult(params);
				installationReversalService.addInstallresultReverse(InstallresultReverse);
				installationReversalService.updateSalesOrderExchange(params);
				installationReversalService.updateInstallEntry(params);
				
				Map<String, Object> srvConfiguration = new HashMap();
	    		srvConfiguration.put("SrvConfigID", configID);
	    		srvConfiguration.put("SrvStatusID", 8);
	    		srvConfiguration.put("SrvRemark", "INSTALLATION RESULT REVERSAL");
	    		srvConfiguration.put("userId", userId);
	    		
	    		installationReversalService.updateSrvConfiguration(srvConfiguration);
	    		
	    		
	    		Map<String,Object> srvConfigSetting = new HashMap();
	    		srvConfigSetting.put("SrvConfigID", configID);
	    		srvConfigSetting.put("SrvSettStatusID", 8);
	    		srvConfigSetting.put("SrvSettRemark", "INSTALLATION RESULT REVERSAL");
	    		
	    		installationReversalService.updateSrvConfigSetting(srvConfigSetting);
	    		
	    		
	    		Map<String,Object> srvConfigPeriod = new HashMap();
	    		srvConfigPeriod.put("SrvConfigID", configID);
	    		srvConfigPeriod.put("SrvPrdStatusID", 8);
	    		srvConfigPeriod.put("SrvPrdRemark", "INSTALLATION RESULT REVERSAL");
	    		srvConfigPeriod.put("userId", userId);
	    		
	    		installationReversalService.updateSrvConfigPeriod(srvConfigPeriod);
	    		
	    		
	    		Map<String,Object> srvConfigFilter = new HashMap();
	    		srvConfigFilter.put("SrvConfigID",configID);
	    		srvConfigFilter.put("SrvFilterStatusID",8);
	    		srvConfigFilter.put("SrvFilterRemark","INSTALLATION RESULT REVERSAL");
	    		srvConfigFilter.put("userId",userId);
	    		
	    		installationReversalService.updateSrvConfigFilter(srvConfigFilter);
	    		
	    		installationReversalService.updateSrvConfigurations(params);
	    		
	    		installationReversalService.updateSrvConfigSetting2(params);
	    		
	    		installationReversalService.updateSrvConfigPeriod2(params);
	    		
	    		installationReversalService.updateSrvConfigFilter2(params);
	    		
	    		
	    		Map<String,Object> happyCallM = new HashMap();
	    		happyCallM.put("HCID", hcID);
	    		happyCallM.put("HCStatusID", 8);
	    		happyCallM.put("HCRemark", "INSTALLATION RESULT REVERSAL");
	    		happyCallM.put("userId", userId);
	    		
	    		installationReversalService.updateHappyCallM(happyCallM);
	    		
	    		EgovMap  rv = installationReversalService.getRequiredView2(params);
	    		
	    		Map<String,Object> salesOrderM = new HashMap();
	    		salesOrderM.put("SalesOrderID", salesOrderID);
	    		//salesOrderM.put("StatusCodeID", 1);
	    		salesOrderM.put("SyncCheck", 1);
	    		salesOrderM.put("userId", userId);
	    		salesOrderM.put("PVMonth", 0);
	    		salesOrderM.put("PVYear", 0);
	    		salesOrderM.put("TotalAmt", rv.get("soExchgOldPrc"));
	    		salesOrderM.put("PromoID", rv.get("soExchgOldPromoId"));
	    		salesOrderM.put("TotalPV", rv.get("soExchgOldPv"));
	    		salesOrderM.put("MthRentAmt", rv.get("soExchgOldRentAmt"));
	    		salesOrderM.put("DefRentAmt", rv.get("soExchgOldRentAmt"));
	    		salesOrderM.put("AppTypeID", applicationTypeID);
	    		salesOrderM.put("SalesDate", salesDt);
	    		
	    		installationReversalService.updateSalesOrderM2(salesOrderM);
	    		
	    		
	    		Map<String,Object> salesOrderD = new HashMap();
	    		salesOrderD.put("ItemStkID", rv.get("soExchgOldStkId"));
	    		salesOrderD.put("ItemPriceID", rv.get("soExchgOldPrcId"));
	    		salesOrderD.put("ItemPrice", rv.get("soExchgOldPrc"));
	    		salesOrderD.put("ItemPV", rv.get("soExchgOldPv"));
	    		salesOrderD.put("userId", userId);
	    		
	    		installationReversalService.updateSalesOrderD2(salesOrderD);
	    		
	    		installationReversalService.updateInstallation(params);
	    		
	    		Map<String,Object> callEntry = new HashMap();
	    		callEntry.put("SalesOrderID", salesOrderID);
	    		callEntry.put("TypeID", 258);
	    		callEntry.put("StatusCodeID", 1);
	    		callEntry.put("ResultID", 0);
	    		callEntry.put("DocID", salesOrderID);
	    		callEntry.put("userId", userId);
	    		callEntry.put("CallDate", nextCallDate);
	    		callEntry.put("IsWaitForCancel", 1);
	    		callEntry.put("OriCallDate", nextCallDate);
	    		
	    		installationReversalService.addCallEntry(callEntry);
	    		
	    		int  CallEntryId = installationReversalService.getCallEntry(params);
	    		
	    		Map<String,Object> callResult = new HashMap();
	    		//callResult.put("CallResultID", 0);
	    		callResult.put("CallEntryID", CallEntryId);
	    		callResult.put("CallStatusID", 1);
	    		callResult.put("CallCallDate", defaultDate);
	    		callResult.put("CallActionDate", defaultDate);
	    		callResult.put("CallFeedBackID", 0);
	    		callResult.put("CallCTID", 0);
	    		callResult.put("CallRemark", remark);
	    		callResult.put("userId", userId);
	    		callResult.put("CallCreateByDept", 0);
	    		callResult.put("CallHCID", 0);
	    		callResult.put("CallROSAmt", 0);
	    		callResult.put("CallSMS", 0);
	    		callResult.put("CallSMSRemark", "");
	    		
	    		installationReversalService.addCallResult(callResult);
	    		
	    		
	    		Map<String,Object> salesorderLog = new HashMap();
	    		salesorderLog.put("SalesOrderID", salesOrderID);
	    		salesorderLog.put("ProgressID", 2);
	    		salesorderLog.put("RefID", 0);
	    		salesorderLog.put("IsLock", 0);	//true
	    		salesorderLog.put("userId", userId);
	    		salesorderLog.put("CallEntryId", CallEntryId);
	    		
	    		installationReversalService.addSalesorderLog(salesorderLog);
	    		
	    		
	    		if(Integer.parseInt(params.get("applicationTypeID").toString())==66 || Integer.parseInt(params.get("applicationTypeID").toString())==67 || Integer.parseInt(params.get("applicationTypeID").toString())==68){
	    			logger.debug("-------------14---------------");
	    			int adjTypeSetID = 0;
	                int adjDrAccID = 0;
	                int adjCrAccID = 0;
	                
	                
	                
	                params.put("TotalAmt", rv.get("totAmt"));
	                
	    			if(Integer.parseInt(params.get("applicationTypeID").toString())==66){
	    				logger.debug("-------------15---------------");
	            		adjTypeSetID = 7;
	                    adjDrAccID = 171;
	                    adjCrAccID = 43;
	                    
	                    
	            	}else if (Integer.parseInt(params.get("applicationTypeID").toString()) == 67)
	                {
	                    adjTypeSetID = 8;
	                    adjDrAccID = 166;
	                    adjCrAccID = 38;
	                }else
	                {
	                    adjTypeSetID = 9;
	                    adjDrAccID = 166;
	                    adjCrAccID = 38;
	                } 
	            	
	            	params.put("adjTypeSetID", adjTypeSetID);
	                params.put("adjDrAccID", adjDrAccID);
	                params.put("adjCrAccID", adjCrAccID);
	                
	                SimpleDateFormat format = new SimpleDateFormat("YYYY-MMM-DD");
	                
	                String esalesDt = params.get("esalesDt").toString();
	                
	                Date salesdate = null;
	                Date mthapril = null;
	                
	                mthapril =  format.parse("2015-APR-01");
	                salesdate = format.parse(esalesDt);
	                System.out.println(salesdate);
	                
	                if (salesdate.compareTo(mthapril)<0){
	                	logger.debug("-------------16---------------");
	                	String adJEntryReportNo = null;
	                	params.put("docno",18);
	                	adJEntryReportNo = installationReversalService.getDOCNumber(params);
	                	params.put("adJEntryReportNo", adJEntryReportNo);
	                	String adjEntryNoteNo = null;
	                	params.put("docno",15);
	                	adjEntryNoteNo = installationReversalService.getDOCNumber(params);
	                	params.put("adjEntryNoteNo", adjEntryNoteNo);
	                	
	                	params.put("docNoId",18);
	                	installationReversalService.updateDOCNumber(params);
	                	params.put("docNoId",15);
	                	installationReversalService.updateDOCNumber(params);
	                
	                	//EgovMap  rv2 = installationReversalService.getRequiredView(params);
	                    
	                    //params.put("TotalAmt", rv2.get("totAmt"));
	                    
	                    
	                    installationReversalService.addAccAdjTransEntry(params);
	                    int adjEntryId = installationReversalService.selectLastadjEntryId();
	                    
	                    params.put("adjEntryId",adjEntryId);
	                    installationReversalService.addAccAdjTransResult(params);
	                    
	                    Map<String,Object> accTRXPlus = new HashMap();
	                    accTRXPlus.put("TRXItemNo", 1);
	                    accTRXPlus.put("TRXGLAccID", adjDrAccID);
	                    accTRXPlus.put("TRXGLDept", "");
	                    accTRXPlus.put("TRXProject", "");
	                    accTRXPlus.put("TRXFinYear", 0);
	                    accTRXPlus.put("TRXPeriod", 0);
	                    accTRXPlus.put("TRXSourceTypeID", 391);
	                    accTRXPlus.put("TRXDocTypeID", 155);
	                    accTRXPlus.put("TRXCustBillID", 0);
	                    accTRXPlus.put("TRXChequeNo", "");
	                    accTRXPlus.put("TRXCRCardSlip", "");
	                    accTRXPlus.put("TRXBisNo", "");
	                    accTRXPlus.put("TRXReconDate", defaultDate);
	                    accTRXPlus.put("TRXRemark", params.get("eCustomerName"));
	                    accTRXPlus.put("TRXCurrID", "RM");
	                    accTRXPlus.put("TRXCurrRate", 1);
	                    accTRXPlus.put("TRXAmount", Integer.parseInt(rv.get("soExchgNwPrc").toString()));
	                    accTRXPlus.put("TRXAmountRM", Integer.parseInt(rv.get("soExchgNwPrc").toString()));
	                    accTRXPlus.put("TRXIsSynch", 1);
	                    
	                    int trxNo = Integer.parseInt(installationReversalService.getDOCNumberOnlyNumber().toString());
	                    accTRXPlus.put("TRXNo", trxNo);
	                    accTRXPlus.put("TRXDocNo", adjEntryNoteNo);
	                    
	                    installationReversalService.addAccTRXes(accTRXPlus);
	                    
	                    
	                    Map<String,Object> accTRXMinus = new HashMap();
	                    accTRXMinus.put("TRXItemNo", 2);
	                    accTRXMinus.put("TRXGLAccID", adjDrAccID);
	                    accTRXMinus.put("TRXGLDept", "");
	                    accTRXMinus.put("TRXProject", "");
	                    accTRXMinus.put("TRXFinYear", 0);
	                    accTRXMinus.put("TRXPeriod", 0);
	                    accTRXMinus.put("TRXSourceTypeID", 391);
	                    accTRXMinus.put("TRXDocTypeID", 155);
	                    accTRXMinus.put("TRXCustBillID", 0);
	                    accTRXMinus.put("TRXChequeNo", "");
	                    accTRXMinus.put("TRXCRCardSlip", "");
	                    accTRXMinus.put("TRXBisNo", "");
	                    accTRXMinus.put("TRXReconDate", defaultDate);
	                    accTRXMinus.put("TRXRemark", params.get("eCustomerName"));
	                    accTRXMinus.put("TRXCurrID", "RM");
	                    accTRXMinus.put("TRXCurrRate", 1);
	                    accTRXMinus.put("TRXAmount", Integer.parseInt(rv.get("soExchgNwPrc").toString())*-1);
	                    accTRXMinus.put("TRXAmountRM", Integer.parseInt(rv.get("soExchgNwPrc").toString())*-1);
	                    accTRXMinus.put("TRXIsSynch", 1);
	                    
	                    installationReversalService.addAccTRXes(accTRXMinus);
	                    
	                    
	                    if(Integer.parseInt(params.get("applicationTypeID").toString())==66){
	                    	logger.debug("-------------17---------------");
	                    	EgovMap  qryPreBill = installationReversalService.getQryPreBill(params);
//	                    	params.put("TaxInvoiceRefNo",qryPreBill.get("taxInvcRefNo"));
//	                    	params.put("TaxInvoiceAmountDue",qryPreBill.get("taxInvcAmtDue"));;
//	                    	params.put("Updator",qryPreBill.get("uptUserId"));;
//	                    	params.put("AccBillID",qryPreBill.get("accBillId"));;
	                    	
	                    	if(qryPreBill !=null){
	                    		logger.debug("-------------18---------------");	
	                    		params.put("TaxInvoiceRefNo",qryPreBill.get("taxInvcRefNo"));
		                    	params.put("TaxInvoiceAmountDue",qryPreBill.get("taxInvcAmtDue"));;
		                    	params.put("Updator",qryPreBill.get("uptUserId"));;
		                    	params.put("AccBillID",qryPreBill.get("accBillId"));;
		                    	
	                    		String VoidNo = null;
	                    		params.put("docno",112);
	                    		VoidNo = installationReversalService.getDOCNumber(params);
	                    		params.put("VoidNo", VoidNo);
	                    		params.put("docNoId",112);
	                         	installationReversalService.updateDOCNumber(params);
	                         	 
	                         	installationReversalService.addAccOrderVoid_Invoice(params);
	                         	
	                         	int AccInvVoidID = installationReversalService.getAccInvVoidID();
	                         	params.put("AccInvVoidID",AccInvVoidID);
	                         	
	                         	installationReversalService.addAccOrderVoid_Invoice_Sub(params);
	                         	
	                         	installationReversalService.updateAccOrderBill(params);
	                    	}
	                    	
	                    	Map<String,Object> accRentLedger = new HashMap();
                         	accRentLedger.put("RentSOID", salesOrderID);
                         	accRentLedger.put("RentDocTypeID", 155);
                         	accRentLedger.put("RentAmount", Integer.parseInt(rv.get("soExchgNwPrc").toString())*-1);
                         	installationReversalService.addAccRentLedger(params);
                         	
	                    	//installationReversalService.addAccTradeLedger(params);
                     	
	                    	//installationReversalService.updateRentalScheme(params);
	                    	
	                    }else{
	                    	logger.debug("-------------19---------------");
	                    	EgovMap  qryPreBill = installationReversalService.getQryPreBill_out(params);
//	                    	params.put("TaxInvoiceRefNo",qryPreBill.get("taxInvcRefNo"));
//	                    	params.put("TaxInvoiceAmountDue",qryPreBill.get("taxInvcAmtDue"));;
//	                    	params.put("Updator",qryPreBill.get("uptUserId"));;
//	                    	params.put("AccBillID",qryPreBill.get("accBillId"));;
	                    	
	                    	if(qryPreBill !=null){
	                    		logger.debug("-------------20---------------");	
	                    		params.put("TaxInvoiceRefNo",qryPreBill.get("taxInvcRefNo"));
		                    	params.put("TaxInvoiceAmountDue",qryPreBill.get("taxInvcAmtDue"));;
		                    	params.put("Updator",qryPreBill.get("uptUserId"));;
		                    	params.put("AccBillID",qryPreBill.get("accBillId"));;
		                    	
	                    		String VoidNo = null;
	                    		params.put("docno",112);
	                    		VoidNo = installationReversalService.getDOCNumber(params);
	                    		params.put("VoidNo", VoidNo);
	                    		params.put("docNoId",112);
	                         	installationReversalService.updateDOCNumber(params);
	                         	 
	                         	installationReversalService.addAccOrderVoid_Invoice(params);
	                         	
	                         	int AccInvVoidID = installationReversalService.getAccInvVoidID();
	                         	params.put("AccInvVoidID",AccInvVoidID);
	                         	
	                         	installationReversalService.addAccOrderVoid_Invoice_Sub(params);
	                         	
	                         	installationReversalService.updateAccOrderBill(params);
	                    	}
                         	/*
                         	Map<String,Object> accRentLedger = new HashMap();
                         	accRentLedger.put("RentSOID", salesOrderID);
                         	accRentLedger.put("RentDocTypeID", 155);
                         	accRentLedger.put("RentAmount", Integer.parseInt(rv.get("soExchgNwPrc").toString())*-1);
                         	installationReversalService.addAccRentLedger(params);
                         	*/
                         	installationReversalService.addAccTradeLedger(params);
                         	//installationReversalService.updateRentalScheme(params);
	                    }
	                }else{
	                	logger.debug("-------------21---------------");
	                	if(Integer.parseInt(params.get("applicationTypeID").toString())==66){
	                		logger.debug("-------------22---------------");
	                	}else if(Integer.parseInt(params.get("applicationTypeID").toString())==67 || Integer.parseInt(params.get("applicationTypeID").toString())==67){
	                		logger.debug("-------------23---------------");
	                		List<EgovMap> QryOutSList = installationReversalService.getQryOutS(params);
	                		if(QryOutSList.size()>0){
	                			logger.debug("-------------24---------------");
	                			EgovMap  qryAccBill = installationReversalService.getQryAccBill(params);
                				params.put("AccBillID",qryAccBill.get("accBillId"));
                				params.put("TaxInvoiceRefNo",qryAccBill.get("taxInvcRefNo"));
                				params.put("TaxInvoiceRefDate",qryAccBill.get("taxInvcRefNo"));
                				params.put("TaxInvoiceCustName",qryAccBill.get("taxInvcCustName"));
                				params.put("TaxInvoiceContactPerson",qryAccBill.get("taxInvcCntcPerson"));
                				
                				params.put("TaxInvoiceAddress1",qryAccBill.get("taxInvcAddr1"));
                				params.put("TaxInvoiceAddress2",qryAccBill.get("taxInvcAddr2"));
                				params.put("TaxInvoiceAddress3",qryAccBill.get("taxInvcAddr3"));
                				params.put("TaxInvoiceAddress4",qryAccBill.get("taxInvcAddr4"));
                				params.put("TaxInvoicePostCode",qryAccBill.get("taxInvcPostCode"));
                				params.put("TaxInvoiceStateName",qryAccBill.get("taxInvcStateName"));
                				params.put("TaxInvoiceCountry",qryAccBill.get("taxInvcCnty"));
                				
                				params.put("TaxInvoiceAmountDue",qryAccBill.get("taxInvcAmtDue"));
                				
                				installationReversalService.updateAccOrderBill2(params);
                				
                				String cnno = null;
                				params.put("docno",134);
                				cnno = installationReversalService.getDOCNumber(params);
                				params.put("cnno", cnno);
                				params.put("adjEntryNoteNo", cnno);
                				params.put("docNoId",134);
                				installationReversalService.updateDOCNumber_8Digit(params);
                				
                				String adJEntryReportNo = null;
                				params.put("docno",18);
                				adJEntryReportNo = installationReversalService.getDOCNumber(params);
                				params.put("adJEntryReportNo", adJEntryReportNo);
                				params.put("docNoId",18);
                				installationReversalService.updateDOCNumber(params);
                				
                				installationReversalService.addAccInvAdjr(params);
                				
                				int MemoAdjustID = installationReversalService.getMemoAdjustID();
                				params.put("MemoAdjustID", MemoAdjustID);
                				
                				String AccBillTaxCodeID = null;
                				AccBillTaxCodeID = installationReversalService.getAccBillTaxCodeID(params);
                				params.put("AccBillTaxCodeID", AccBillTaxCodeID);
                				
                				int crid = 0;
                                int drid = 0;
                                boolean conv = (boolean)qryAccBill.get("accBillAcctCnvr");
                                		//ACC_BILL_ACCT_CNVR; 
    
                                if (conv == false)
                                {
                                    crid = 38;
                                    drid = 535;
                                }
                                else
                                {
                                    crid = 38;
                                    drid = 166;
                                }
                                
                                params.put("crid",crid);
                                params.put("drid",drid);
                                
                                installationReversalService.addAccInvoiceAdjustment_Sub(params);
                                
                                installationReversalService.addAccTaxDebitCreditNote(params);
                                
                                int NoteID = installationReversalService.getNoteID();
                                params.put("NoteID",NoteID);
                                
                                installationReversalService.addAccTaxDebitCreditNote_Sub(params);
                                
                                String  VoidNo = null;
                                params.put("docno",112);
                                VoidNo = installationReversalService.getDOCNumber(params);
                                params.put("VoidNo", VoidNo);
                                params.put("docNoId",112);
                            	installationReversalService.updateDOCNumber(params);
                                
                            	installationReversalService.addAccOrderVoid_Invoice(params);
                            	params.put("adjEntryId",MemoAdjustID);
                            	params.put("TotalAmt",qryAccBill.get("taxInvcAmtDue"));
                            	
                            	installationReversalService.addAccOrderVoid_Invoice_Sub(params);
                            	installationReversalService.addAccTradeLedger(params);
                            	
                            	//installationReversalService.updateAccOrderBill(params);
	                		}    	
	                	}
	                }
	    		}
			}else{
				logger.debug("-------------25---------------");
				hidPEAfterInstall = "0";
				
				installationReversalService.updateInstallresult(params);
				installationReversalService.addInstallresultReverse(InstallresultReverse);
				installationReversalService.updateSalesOrderExchange(params);
				installationReversalService.updateInstallEntry(params);
				
				Map<String, Object> srvMembershipSale = new HashMap();
	    		srvMembershipSale.put("SrvMemID", memID);
	    		srvMembershipSale.put("SrvStatusCodeID", '8');
	    		srvMembershipSale.put("userId", userId);
	    		
	    		installationReversalService.updateSrvMembershipSale2(srvMembershipSale);
	    		
	    		
	    		Map<String, Object> srvConfiguration = new HashMap();
	    		srvConfiguration.put("SrvConfigID", configID);
	    		srvConfiguration.put("SrvStatusID", 8);
	    		srvConfiguration.put("SrvRemark", "INSTALLATION RESULT REVERSAL");
	    		srvConfiguration.put("userId", userId);
	    		
	    		installationReversalService.updateSrvConfiguration(srvConfiguration);
	    		
	    		
	    		Map<String,Object> srvConfigSetting = new HashMap();
	    		srvConfigSetting.put("SrvConfigID", configID);
	    		srvConfigSetting.put("SrvSettStatusID", 8);
	    		srvConfigSetting.put("SrvSettRemark", "INSTALLATION RESULT REVERSAL");
	    		
	    		installationReversalService.updateSrvConfigSetting(srvConfigSetting);
	    		
	    		
	    		Map<String,Object> srvConfigPeriod = new HashMap();
	    		srvConfigPeriod.put("SrvConfigID", configID);
	    		srvConfigPeriod.put("SrvPrdStatusID", 8);
	    		srvConfigPeriod.put("SrvPrdRemark", "INSTALLATION RESULT REVERSAL");
	    		srvConfigPeriod.put("userId", userId);
	    		
	    		installationReversalService.updateSrvConfigPeriod(srvConfigPeriod);
	    		
	    		
	    		Map<String,Object> srvConfigFilter = new HashMap();
	    		srvConfigFilter.put("SrvConfigID",configID);
	    		srvConfigFilter.put("SrvFilterStatusID",8);
	    		srvConfigFilter.put("SrvFilterRemark","INSTALLATION RESULT REVERSAL");
	    		srvConfigFilter.put("userId",userId);
	    		
	    		installationReversalService.updateSrvConfigFilter(srvConfigFilter);
	    		
	    		
	    		Map<String,Object> happyCallM = new HashMap();
	    		happyCallM.put("HCID", hcID);
	    		happyCallM.put("HCStatusID", 8);
	    		happyCallM.put("HCRemark", "INSTALLATION RESULT REVERSAL");
	    		happyCallM.put("userId", userId);
	    		
	    		installationReversalService.updateHappyCallM(happyCallM);
	    		
	    		
	    		EgovMap  rv = installationReversalService.getRequiredView2(params);
	    		
	    		Map<String,Object> salesOrderM = new HashMap();
	    		salesOrderM.put("SalesOrderID", salesOrderID);
	    		//salesOrderM.put("StatusCodeID", 1);
	    		salesOrderM.put("SyncCheck", 1);
	    		salesOrderM.put("userId", userId);
	    		salesOrderM.put("PVMonth", 0);
	    		salesOrderM.put("PVYear", 0);
	    		salesOrderM.put("TotalAmt", rv.get("soExchgOldPrc"));
	    		salesOrderM.put("PromoID", rv.get("soExchgOldPromoId"));
	    		salesOrderM.put("TotalPV", rv.get("soExchgOldPv"));
	    		salesOrderM.put("MthRentAmt", rv.get("soExchgOldRentAmt"));
	    		salesOrderM.put("DefRentAmt", rv.get("soExchgOldRentAmt"));
	    		salesOrderM.put("AppTypeID", applicationTypeID);
	    		salesOrderM.put("SalesDate", salesDt);
	    		
	    		installationReversalService.updateSalesOrderM2(salesOrderM);
	    		
	    		
	    		Map<String,Object> salesOrderD = new HashMap();
	    		salesOrderD.put("ItemStkID", rv.get("soExchgOldStkId"));
	    		salesOrderD.put("ItemPriceID", rv.get("soExchgOldPrcId"));
	    		salesOrderD.put("ItemPrice", rv.get("soExchgOldPrc"));
	    		salesOrderD.put("ItemPV", rv.get("soExchgOldPv"));
	    		salesOrderD.put("userId", userId);
	    		
	    		installationReversalService.updateSalesOrderD2(salesOrderD);
	    		
	    		installationReversalService.updateInstallation(params);
	    		
	    		Map<String,Object> callEntry = new HashMap();
	    		callEntry.put("SalesOrderID", salesOrderID);
	    		callEntry.put("TypeID", 258);
	    		callEntry.put("StatusCodeID", 1);
	    		callEntry.put("ResultID", 0);
	    		callEntry.put("DocID", salesOrderID);
	    		callEntry.put("userId", userId);
	    		callEntry.put("CallDate", nextCallDate);
	    		callEntry.put("IsWaitForCancel", 1);
	    		callEntry.put("OriCallDate", nextCallDate);
	    		
	    		installationReversalService.addCallEntry(callEntry);
	    		
	    		
	    		int  CallEntryId = installationReversalService.getCallEntry(params);
	    		
	    		Map<String,Object> callResult = new HashMap();
	    		//callResult.put("CallResultID", 0);
	    		callResult.put("CallEntryID", CallEntryId);
	    		callResult.put("CallStatusID", 1);
	    		callResult.put("CallCallDate", defaultDate);
	    		callResult.put("CallActionDate", defaultDate);
	    		callResult.put("CallFeedBackID", 0);
	    		callResult.put("CallCTID", 0);
	    		callResult.put("CallRemark", remark);
	    		callResult.put("userId", userId);
	    		callResult.put("CallCreateByDept", 0);
	    		callResult.put("CallHCID", 0);
	    		callResult.put("CallROSAmt", 0);
	    		callResult.put("CallSMS", 0);
	    		callResult.put("CallSMSRemark", "");
	    		
	    		installationReversalService.addCallResult(callResult);
	    		
	    		
	    		Map<String,Object> salesorderLog = new HashMap();
	    		salesorderLog.put("SalesOrderID", salesOrderID);
	    		salesorderLog.put("ProgressID", 3);
	    		salesorderLog.put("RefID", 0);
	    		salesorderLog.put("IsLock", 0);	//true
	    		salesorderLog.put("userId", userId);
	    		salesorderLog.put("CallEntryId", CallEntryId);
	    		
	    		installationReversalService.addSalesorderLog(salesorderLog);
	    		
	    		
	    		if(Integer.parseInt(params.get("applicationTypeID").toString())==66 || Integer.parseInt(params.get("applicationTypeID").toString())==67 || Integer.parseInt(params.get("applicationTypeID").toString())==68){
	    			logger.debug("-------------26---------------");
	    			int adjTypeSetID = 0;
	                int adjDrAccID = 0;
	                int adjCrAccID = 0;
	                
	                
	                
	                params.put("TotalAmt", rv.get("totAmt"));
	                
	    			if(Integer.parseInt(params.get("applicationTypeID").toString())==66){
	            		adjTypeSetID = 7;
	                    adjDrAccID = 171;
	                    adjCrAccID = 43;
	                    
	                    
	            	}else if (Integer.parseInt(params.get("applicationTypeID").toString()) == 67)
	                {
	                    adjTypeSetID = 8;
	                    adjDrAccID = 166;
	                    adjCrAccID = 38;
	                }else
	                {
	                    adjTypeSetID = 9;
	                    adjDrAccID = 166;
	                    adjCrAccID = 38;
	                } 
	            	
	            	params.put("adjTypeSetID", adjTypeSetID);
	                params.put("adjDrAccID", adjDrAccID);
	                params.put("adjCrAccID", adjCrAccID);
	                
	                SimpleDateFormat format = new SimpleDateFormat("YYYY-MMM-DD");
	                
	                String esalesDt = params.get("esalesDt").toString();
	                
	                Date salesdate = null;
	                Date mthapril = null;
	                
	                mthapril =  format.parse("2015-APR-01");
	                salesdate = format.parse(esalesDt);
	                
	                if (salesdate.compareTo(mthapril)<0){
	                	logger.debug("-------------27---------------");	                	
	                	String adJEntryReportNo = null;
	                	params.put("docno",18);
	                	adJEntryReportNo = installationReversalService.getDOCNumber(params);
	                	params.put("adJEntryReportNo", adJEntryReportNo);
	                	String adjEntryNoteNo = null;
	                	params.put("docno",15);
	                	adjEntryNoteNo = installationReversalService.getDOCNumber(params);
	                	params.put("adjEntryNoteNo", adjEntryNoteNo);
	                	
	                	params.put("docNoId",18);
	                	installationReversalService.updateDOCNumber(params);
	                	params.put("docNoId",15);
	                	installationReversalService.updateDOCNumber(params);
	                	
	                	installationReversalService.addAccAdjTransEntry(params);
	                    int adjEntryId = installationReversalService.selectLastadjEntryId();
	                    
	                    params.put("adjEntryId",adjEntryId);
	                    installationReversalService.addAccAdjTransResult(params);
	                    
	                    Map<String,Object> accTRXPlus = new HashMap();
	                    accTRXPlus.put("TRXItemNo", 1);
	                    accTRXPlus.put("TRXGLAccID", adjDrAccID);
	                    accTRXPlus.put("TRXGLDept", "");
	                    accTRXPlus.put("TRXProject", "");
	                    accTRXPlus.put("TRXFinYear", 0);
	                    accTRXPlus.put("TRXPeriod", 0);
	                    accTRXPlus.put("TRXSourceTypeID", 391);
	                    accTRXPlus.put("TRXDocTypeID", 155);
	                    accTRXPlus.put("TRXCustBillID", 0);
	                    accTRXPlus.put("TRXChequeNo", "");
	                    accTRXPlus.put("TRXCRCardSlip", "");
	                    accTRXPlus.put("TRXBisNo", "");
	                    accTRXPlus.put("TRXReconDate", defaultDate);
	                    accTRXPlus.put("TRXRemark", params.get("eCustomerName"));
	                    accTRXPlus.put("TRXCurrID", "RM");
	                    accTRXPlus.put("TRXCurrRate", 1);
	                    accTRXPlus.put("TRXAmount", Integer.parseInt(rv.get("soExchgNwPrc").toString()));
	                    accTRXPlus.put("TRXAmountRM", Integer.parseInt(rv.get("soExchgNwPrc").toString()));
	                    accTRXPlus.put("TRXIsSynch", 1);
	                    
	                    int trxNo = Integer.parseInt(installationReversalService.getDOCNumberOnlyNumber().toString());
	                    accTRXPlus.put("TRXNo", trxNo);
	                    accTRXPlus.put("TRXDocNo", adjEntryNoteNo);
	                    
	                    installationReversalService.addAccTRXes(accTRXPlus);
	                    
	                    
	                    Map<String,Object> accTRXMinus = new HashMap();
	                    accTRXMinus.put("TRXItemNo", 2);
	                    accTRXMinus.put("TRXGLAccID", adjDrAccID);
	                    accTRXMinus.put("TRXGLDept", "");
	                    accTRXMinus.put("TRXProject", "");
	                    accTRXMinus.put("TRXFinYear", 0);
	                    accTRXMinus.put("TRXPeriod", 0);
	                    accTRXMinus.put("TRXSourceTypeID", 391);
	                    accTRXMinus.put("TRXDocTypeID", 155);
	                    accTRXMinus.put("TRXCustBillID", 0);
	                    accTRXMinus.put("TRXChequeNo", "");
	                    accTRXMinus.put("TRXCRCardSlip", "");
	                    accTRXMinus.put("TRXBisNo", "");
	                    accTRXMinus.put("TRXReconDate", defaultDate);
	                    accTRXMinus.put("TRXRemark", params.get("eCustomerName"));
	                    accTRXMinus.put("TRXCurrID", "RM");
	                    accTRXMinus.put("TRXCurrRate", 1);
	                    accTRXMinus.put("TRXAmount", Integer.parseInt(rv.get("soExchgNwPrc").toString())*-1);
	                    accTRXMinus.put("TRXAmountRM", Integer.parseInt(rv.get("soExchgNwPrc").toString())*-1);
	                    accTRXMinus.put("TRXIsSynch", 1);
	                    
	                    installationReversalService.addAccTRXes(accTRXMinus);
	                    
	                    if(Integer.parseInt(params.get("applicationTypeID").toString())==66){
	                    	logger.debug("-------------28---------------");
	                    	EgovMap  qryPreBill = installationReversalService.getQryPreBill(params);
//	                    	params.put("TaxInvoiceRefNo",qryPreBill.get("taxInvcRefNo"));
//	                    	params.put("TaxInvoiceAmountDue",qryPreBill.get("taxInvcAmtDue"));;
//	                    	params.put("Updator",qryPreBill.get("uptUserId"));;
//	                    	params.put("AccBillID",qryPreBill.get("accBillId"));;
	                    	
	                    	if(qryPreBill !=null){
	                    		logger.debug("-------------29---------------");
	                    		params.put("TaxInvoiceRefNo",qryPreBill.get("taxInvcRefNo"));
		                    	params.put("TaxInvoiceAmountDue",qryPreBill.get("taxInvcAmtDue"));;
		                    	params.put("Updator",qryPreBill.get("uptUserId"));;
		                    	params.put("AccBillID",qryPreBill.get("accBillId"));;
		                    	
	                    		String VoidNo = null;
	                    		params.put("docno",112);
	                    		VoidNo = installationReversalService.getDOCNumber(params);
	                    		params.put("VoidNo", VoidNo);
	                    		params.put("docNoId",112);
	                         	installationReversalService.updateDOCNumber(params);
	                         	 
	                         	installationReversalService.addAccOrderVoid_Invoice(params);
	                         	
	                         	int AccInvVoidID = installationReversalService.getAccInvVoidID();
	                         	params.put("AccInvVoidID",AccInvVoidID);
	                         	
	                         	installationReversalService.addAccOrderVoid_Invoice_Sub(params);
	                         	
	                         	installationReversalService.updateAccOrderBill(params);
	                    	}
	                    	
	                    	Map<String,Object> accRentLedger = new HashMap();
                         	accRentLedger.put("RentSOID", salesOrderID);
                         	accRentLedger.put("RentDocTypeID", 155);
                         	accRentLedger.put("RentAmount", Integer.parseInt(rv.get("soExchgNwPrc").toString())*-1);
                         	installationReversalService.addAccRentLedger(params);
                         	
                         	installationReversalService.updateRentalScheme(params);
	                    }else{
	                    	logger.debug("-------------30---------------");
	                    	EgovMap  qryPreBill = installationReversalService.getQryPreBill_out(params);
//	                    	params.put("TaxInvoiceRefNo",qryPreBill.get("taxInvcRefNo"));
//	                    	params.put("TaxInvoiceAmountDue",qryPreBill.get("taxInvcAmtDue"));;
//	                    	params.put("Updator",qryPreBill.get("uptUserId"));;
//	                    	params.put("AccBillID",qryPreBill.get("accBillId"));;
	                    	
	                    	if(qryPreBill !=null){
	                    		logger.debug("-------------31---------------");	
	                    		params.put("TaxInvoiceRefNo",qryPreBill.get("taxInvcRefNo"));
		                    	params.put("TaxInvoiceAmountDue",qryPreBill.get("taxInvcAmtDue"));;
		                    	params.put("Updator",qryPreBill.get("uptUserId"));;
		                    	params.put("AccBillID",qryPreBill.get("accBillId"));;
		                    	
	                    		String VoidNo = null;
	                    		params.put("docno",112);
	                    		VoidNo = installationReversalService.getDOCNumber(params);
	                    		params.put("VoidNo", VoidNo);
	                    		params.put("docNoId",112);
	                         	installationReversalService.updateDOCNumber(params);
	                         	 
	                         	installationReversalService.addAccOrderVoid_Invoice(params);
	                         	
	                         	int AccInvVoidID = installationReversalService.getAccInvVoidID();
	                         	params.put("AccInvVoidID",AccInvVoidID);
	                         	
	                         	installationReversalService.addAccOrderVoid_Invoice_Sub(params);
	                         	
	                         	installationReversalService.updateAccOrderBill(params);
	                    	}
	                    	Map<String,Object> accRentLedger = new HashMap();
                         	accRentLedger.put("RentSOID", salesOrderID);
                         	accRentLedger.put("RentDocTypeID", 155);
                         	accRentLedger.put("RentAmount", Integer.parseInt(rv.get("soExchgNwPrc").toString())*-1);
                         	installationReversalService.addAccRentLedger(params);
	                    }
	                }else{
	                	logger.debug("-------------32---------------");
	                	if(Integer.parseInt(params.get("applicationTypeID").toString())==66){
	                		logger.debug("-------------33---------------");
	                	}else if(Integer.parseInt(params.get("applicationTypeID").toString())==67 || Integer.parseInt(params.get("applicationTypeID").toString())==67){
	                		logger.debug("-------------34---------------");
	                		List<EgovMap> QryOutSList = installationReversalService.getQryOutS(params);
	                		if(QryOutSList.size()>0){
	                			logger.debug("-------------35---------------");
	                			EgovMap  qryAccBill = installationReversalService.getQryAccBill(params);
                				params.put("AccBillID",qryAccBill.get("accBillId"));
                				params.put("TaxInvoiceRefNo",qryAccBill.get("taxInvcRefNo"));
                				params.put("TaxInvoiceRefDate",qryAccBill.get("taxInvcRefNo"));
                				params.put("TaxInvoiceCustName",qryAccBill.get("taxInvcCustName"));
                				params.put("TaxInvoiceContactPerson",qryAccBill.get("taxInvcCntcPerson"));
                				
                				params.put("TaxInvoiceAddress1",qryAccBill.get("taxInvcAddr1"));
                				params.put("TaxInvoiceAddress2",qryAccBill.get("taxInvcAddr2"));
                				params.put("TaxInvoiceAddress3",qryAccBill.get("taxInvcAddr3"));
                				params.put("TaxInvoiceAddress4",qryAccBill.get("taxInvcAddr4"));
                				params.put("TaxInvoicePostCode",qryAccBill.get("taxInvcPostCode"));
                				params.put("TaxInvoiceStateName",qryAccBill.get("taxInvcStateName"));
                				params.put("TaxInvoiceCountry",qryAccBill.get("taxInvcCnty"));
                				
                				params.put("TaxInvoiceAmountDue",qryAccBill.get("taxInvcAmtDue"));
                				
                				installationReversalService.updateAccOrderBill2(params);
                				
                				String cnno = null;
                				params.put("docno",134);
                				cnno = installationReversalService.getDOCNumber(params);
                				params.put("cnno", cnno);
                				params.put("adjEntryNoteNo", cnno);
                				params.put("docNoId",134);
                				installationReversalService.updateDOCNumber_8Digit(params);
                				
                				String adJEntryReportNo = null;
                				params.put("docno",18);
                				adJEntryReportNo = installationReversalService.getDOCNumber(params);
                				params.put("adJEntryReportNo", adJEntryReportNo);
                				params.put("docNoId",18);
                				installationReversalService.updateDOCNumber(params);
                				
                				installationReversalService.addAccInvAdjr(params);
                				
                				int MemoAdjustID = installationReversalService.getMemoAdjustID();
                				params.put("MemoAdjustID", MemoAdjustID);
                				
                				String AccBillTaxCodeID = null;
                				AccBillTaxCodeID = installationReversalService.getAccBillTaxCodeID(params);
                				params.put("AccBillTaxCodeID", AccBillTaxCodeID);
                				
                				int crid = 0;
                                int drid = 0;
                                boolean conv = (boolean)qryAccBill.get("accBillAcctCnvr");
                                		//ACC_BILL_ACCT_CNVR; 
    
                                if (conv == false)
                                {
                                    crid = 38;
                                    drid = 535;
                                }
                                else
                                {
                                    crid = 38;
                                    drid = 166;
                                }
                                
                                params.put("crid",crid);
                                params.put("drid",drid);
                                
                                installationReversalService.addAccInvoiceAdjustment_Sub(params);
                                
                                installationReversalService.addAccTaxDebitCreditNote(params);
                                
                                int NoteID = installationReversalService.getNoteID();
                                params.put("NoteID",NoteID);
                                
                                installationReversalService.addAccTaxDebitCreditNote_Sub(params);
                                
                                String  VoidNo = null;
                                params.put("docno",112);
                                VoidNo = installationReversalService.getDOCNumber(params);
                                params.put("VoidNo", VoidNo);
                                params.put("docNoId",112);
                            	installationReversalService.updateDOCNumber(params);
                                
                            	installationReversalService.addAccOrderVoid_Invoice(params);
                            	params.put("adjEntryId",MemoAdjustID);
                            	params.put("TotalAmt",qryAccBill.get("taxInvcAmtDue"));
                            	
                            	installationReversalService.addAccOrderVoid_Invoice_Sub(params);
                            	
                            	installationReversalService.addAccTradeLedger(params);
                				
	                		}
	                	}
	                }
	    		}
			}
			
			
		}
			
		
		
		
		ReturnMessage message = new ReturnMessage();
		message.setMessage("controllend");
		return ResponseEntity.ok(message);
	}
	
	
}
