package com.coway.trust.biz.services.installation.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.services.as.impl.ServicesLogisticsPFCMapper;
import com.coway.trust.biz.services.installation.InstallationReversalService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.services.installation.InstallationReversalController;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;


@Service("installationReversalService")
public class InstallationReversalServiceImpl extends EgovAbstractServiceImpl implements InstallationReversalService{
	private static final Logger logger = LoggerFactory.getLogger(InstallationReversalController.class);

	@Resource(name = "installationReversalMapper")
	private InstallationReversalMapper installationReversalMapper;

	@Resource(name = "servicesLogisticsPFCMapper")
	private ServicesLogisticsPFCMapper servicesLogisticsPFCMapper;

	public List<EgovMap> selectOrderList(Map<String, Object> params) {
		return installationReversalMapper.selectOrderList(params);
	}

	@Override
	public EgovMap  SP_LOGISTIC_REQUEST(Map<String, Object> params) {
		return (EgovMap) installationReversalMapper.SP_LOGISTIC_REQUEST(params);
	}

	@Override
	public EgovMap installationReversalSearchDetail1(Map<String, Object> params) {
		return installationReversalMapper.selectOrderListDetail1(params);
	}
	@Override
	public EgovMap installationReversalSearchDetail2(Map<String, Object> params) {
		return installationReversalMapper.selectOrderListDetail2(params);
	}
	@Override
	public EgovMap installationReversalSearchDetail3(Map<String, Object> params) {
		return installationReversalMapper.selectOrderListDetail3(params);
	}
	@Override
	public EgovMap installationReversalSearchDetail4(Map<String, Object> params) {
		return installationReversalMapper.selectOrderListDetail4(params);
	}
	@Override
	public EgovMap installationReversalSearchDetail5(Map<String, Object> params) {
		return installationReversalMapper.selectOrderListDetail5(params);
	}

	@Override
	public List<EgovMap> selectReverseReason() {
		return installationReversalMapper.selectReverseReason();
	}

	@Override
	public List<EgovMap> selectFailReason() {
		return installationReversalMapper.selectFailReason();
	}

	@Override
	public  int    saveReverseNewInstallationResult(Map<String, Object> params) {
		return installationReversalMapper.saveReverseNewInstallationResult(params);
	}

	@Override
	public  String    getMemIDBySalesOrderIDAndPacID(Map<String, Object> params) {
		return installationReversalMapper.getMemIDBySalesOrderIDAndPacID(params);
	}

	@Override
	public  String    getLatestConfigIDBySalesOrderID(Map<String, Object> params) {
		return installationReversalMapper.getLatestConfigIDBySalesOrderID(params);
	}

	@Override
	public  String    getHCIDBySalesOrderID(Map<String, Object> params) {
		return installationReversalMapper.getHCIDBySalesOrderID(params);
	}

	@Override
	public EgovMap getRequiredView(Map<String, Object> params) {
		return installationReversalMapper.getRequiredView(params);
	}

	@Override
	public  String    getDOCNumber(Map<String, Object> params) {
		return installationReversalMapper.getDOCNumber(params);
	}

	@Override
	public  void    updateDOCNumber(Map<String, Object> params) {
		installationReversalMapper.updateDOCNumber(params);
	}

	@Override
	public  void    addAccAdjTransEntry(Map<String, Object> params) {
		installationReversalMapper.addAccAdjTransEntry(params);
	}

	@Override
	public  int    selectLastadjEntryId() {
		return installationReversalMapper.selectLastadjEntryId();
	}

	@Override
	public  void    addAccAdjTransResult(Map<String, Object> params) {
		installationReversalMapper.addAccAdjTransResult(params);
	}

	@Override
	public  String    getDOCNumberOnlyNumber() {
		return installationReversalMapper.getDOCNumberOnlyNumber();
	}

	@Override
	public EgovMap getQryPreBill(Map<String, Object> params) {
		return installationReversalMapper.getQryPreBill(params);
	}

	@Override
	public  void    addAccOrderVoid_Invoice(Map<String, Object> params) {
		installationReversalMapper.addAccOrderVoid_Invoice(params);
	}

	@Override
	public  void    addAccOrderVoid_Invoice_Sub(Map<String, Object> params) {
		installationReversalMapper.addAccOrderVoid_Invoice_Sub(params);
	}

	@Override
	public  void    updateAccOrderBill(Map<String, Object> params) {
		installationReversalMapper.updateAccOrderBill(params);
	}

	@Override
	public  void    addAccTradeLedger(Map<String, Object> params) {
		installationReversalMapper.addAccTradeLedger(params);
	}

	@Override
	public  void    updateRentalScheme(Map<String, Object> params) {
		installationReversalMapper.updateRentalScheme(params);
	}

	@Override
	public EgovMap getQryPreBill_out(Map<String, Object> params) {
		return installationReversalMapper.getQryPreBill_out(params);
	}

	@Override
	public List<EgovMap> getQryOutS(Map<String, Object> params) {
		//installationReversalMapper.getQryOutS(params);

		//return (List<EgovMap>) params.get("p1");
		//return (List<EgovMap>) params;
		return installationReversalMapper.getQryOutS(params);
	}

	@Override
	public EgovMap getQryAccBill(Map<String, Object> params) {
		return installationReversalMapper.getQryAccBill(params);
	}

	@Override
	public  void    updateAccOrderBill2(Map<String, Object> params) {
		installationReversalMapper.updateAccOrderBill2(params);
	}

	@Override
	public  void    updateDOCNumber_8Digit(Map<String, Object> params) {
		installationReversalMapper.updateDOCNumber_8Digit(params);
	}

	@Override
	public  void    addAccInvAdjr(Map<String, Object> params) {
		installationReversalMapper.addAccInvAdjr(params);
	}

	@Override
	public  String    getAccBillTaxCodeID(Map<String, Object> params) {
		return installationReversalMapper.getAccBillTaxCodeID(params);
	}

	@Override
	public  void    addAccInvoiceAdjustment_Sub(Map<String, Object> params) {
		installationReversalMapper.addAccInvoiceAdjustment_Sub(params);
	}

	@Override
	public  void    addAccTaxDebitCreditNote(Map<String, Object> params) {
		installationReversalMapper.addAccTaxDebitCreditNote(params);
	}

	@Override
	public  void    addAccTaxDebitCreditNote_Sub(Map<String, Object> params) {
		installationReversalMapper.addAccTaxDebitCreditNote_Sub(params);
	}

	@Override
	public  int    getMemoAdjustID() {
		return installationReversalMapper.getMemoAdjustID();
	}

	@Override
	public  int  getNoteID() {
		return installationReversalMapper.getNoteID();
	}

	@Override
	public  int    getAccInvVoidID() {
		return installationReversalMapper.getAccInvVoidID();
	}

	@Override
	public  void    updateInstallresult(Map<String, Object> params) {
		installationReversalMapper.updateInstallresult(params);
	}

	@Override
	public EgovMap getInstallResults(Map<String, Object> params) {
		return installationReversalMapper.getInstallResults(params);
	}

	@Override
	public  void    addInstallresultReverse(Map<String, Object> params) {
		installationReversalMapper.addInstallresultReverse(params);
	}

	@Override
	public  void    updateInstallEntry(Map<String, Object> params) {
		installationReversalMapper.updateInstallEntry(params);
	}

	@Override
	public  void    updateSrvMembershipSale(Map<String, Object> params) {
		installationReversalMapper.updateSrvMembershipSale(params);
	}

	@Override
	public  void    updateSrvConfiguration(Map<String, Object> params) {
		installationReversalMapper.updateSrvConfiguration(params);
	}

	@Override
	public  void    updateSrvConfigSetting(Map<String, Object> params) {
		installationReversalMapper.updateSrvConfigSetting(params);
	}

	@Override
	public  void    updateSrvConfigPeriod(Map<String, Object> params) {
		installationReversalMapper.updateSrvConfigPeriod(params);
	}

	@Override
	public  void    updateSrvConfigFilter(Map<String, Object> params) {
		installationReversalMapper.updateSrvConfigFilter(params);
	}

	@Override
	public  void    updateHappyCallM(Map<String, Object> params) {
		installationReversalMapper.updateHappyCallM(params);
	}

	@Override
	public  void    updateSalesOrderM(Map<String, Object> params) {
		installationReversalMapper.updateSalesOrderM(params);
	}

	@Override
	public  void    updateInstallation(Map<String, Object> params) {
		installationReversalMapper.updateInstallation(params);
	}

	@Override
	public  void    addCallEntry(Map<String, Object> params) {
		installationReversalMapper.addCallEntry(params);
	}

	@Override
	public int getCallEntry(Map<String, Object> params) {
		return installationReversalMapper.getCallEntry(params);
	}

	@Override
	public  void    addCallResult(Map<String, Object> params) {
		installationReversalMapper.addCallResult(params);
	}

	@Override
	public  void    addSalesorderLog(Map<String, Object> params) {
		installationReversalMapper.addSalesorderLog(params);
	}

	@Override
	public EgovMap GetOrderExchangeTypeByInstallEntryID(Map<String, Object> params) {
		return installationReversalMapper.GetOrderExchangeTypeByInstallEntryID(params);
	}

	@Override
	public  void    updateSalesOrderExchange(Map<String, Object> params) {
		installationReversalMapper.updateSalesOrderExchange(params);
	}

	@Override
	public  void    updateSrvConfigurations(Map<String, Object> params) {
		installationReversalMapper.updateSrvConfigurations(params);
	}

	@Override
	public  void    updateSrvConfigSetting2(Map<String, Object> params) {
		installationReversalMapper.updateSrvConfigSetting2(params);
	}

	@Override
	public  void    updateSrvConfigPeriod2(Map<String, Object> params) {
		installationReversalMapper.updateSrvConfigPeriod2(params);
	}

	@Override
	public  void    updateSrvConfigFilter2(Map<String, Object> params) {
		installationReversalMapper.updateSrvConfigFilter2(params);
	}

	@Override
	public EgovMap getRequiredView2(Map<String, Object> params) {
		return installationReversalMapper.getRequiredView2(params);
	}

	public  void    updateSalesOrderM2(Map<String, Object> params) {
		installationReversalMapper.updateSalesOrderM2(params);
	}

	public  void    updateSalesOrderD2(Map<String, Object> params) {
		installationReversalMapper.updateSalesOrderD2(params);
	}

	@Override
	public  void    addAccTRXes(Map<String, Object> params) {
		installationReversalMapper.addAccTRXes(params);
	}

	@Override
	public  void    updateSrvMembershipSale2(Map<String, Object> params) {
		installationReversalMapper.updateSrvMembershipSale2(params);
	}

	@Override
	public  void    addAccRentLedger(Map<String, Object> params) {
		installationReversalMapper.addAccRentLedger(params);
	}

  @Override
  public void saveResaval2(SessionVO sessionVO, Map<String, Object> params) {

    EgovMap returnMap = new EgovMap();
    int userId = sessionVO.getUserId();
    params.put("userId", userId);

    String defaultDate = "1900-01-01";
    //Map<String, Object> formData = (Map<String, Object>)params.get(AppConstants.AUIGRID_FORM); // 폼 객체 데이터 가져오기
    //formData.put("user_id", userId);

    int callTypeId = CommonUtils.intNvl(Integer.parseInt(params.get("callTypeId").toString())); //ccr0006d.type_id
    int result = 0 ;

  /*  By KV - this is wrong - int installResultID = CommonUtils.intNvl(Integer.parseInt(params.get("einstallEntryId").toString()));*/
    int installEntryID = CommonUtils.intNvl(Integer.parseInt(params.get("einstallEntryId").toString()));
    String installEntryNo = CommonUtils.nvl(params.get("einstallEntryNo").toString());
    String installDate = CommonUtils.nvl(params.get("instalStrlDate").toString());
    String nextCallDate = CommonUtils.nvl(params.get("nextCallStrlDate").toString());

    logger.debug("-----------------------installDate-------------------------");;
    logger.debug(installDate);;

    String remark = params.get("reverseReasonText").toString();
    logger.debug(remark);;

    String failReason =params.get("failReason").toString();
    logger.debug(failReason);;

    String ctID = params.get("ectid").toString();
    logger.debug(ctID);;

    int applicationTypeID = Integer.parseInt(params.get("applicationTypeID").toString());
    System.out.println(applicationTypeID);;

    int salesOrderID = Integer.parseInt(params.get("esalesOrdId").toString());
    System.out.println(salesOrderID);;

    String salesDt = params.get("esalesDt").toString();
    logger.debug(salesDt);;

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
    String memid = null;
    memid= getMemIDBySalesOrderIDAndPacID(params);
    if(memid !=null)
    memID = Integer.parseInt(memid);
    params.put("memID",memID);

    int configID = -1;
    String configid = null;
    configid = getLatestConfigIDBySalesOrderID(params);
    if(configid!=null)
    configID = Integer.parseInt(configid);
    params.put("configID",configID);

    int hcID = 0;
    String hcid = null;
    hcid = getHCIDBySalesOrderID(params);
    if(hcid!=null)
    hcID = Integer.parseInt(hcid);
    params.put("hcID",hcID);

    int inChargeCTWHID = 0;
    if(params.get("inChargeCTWHID") !=null)
    inChargeCTWHID = Integer.parseInt(params.get("inChargeCTWHID").toString());

    int retWarehouseID;
    String warehouseGrade;

    int productID = 0;
    if(params.get("eProductID") !=null)
    productID = Integer.parseInt(params.get("eProductID").toString());


    String customerName = "";
    if(params.get("eCustomerName")!=null)
    customerName = params.get("eCustomerName").toString();

    String installNo = "";
    if(params.get("einstallEntryNo")!=null)
    installNo = params.get("einstallEntryNo").toString();

    EgovMap  installresults = getInstallResults(params);
    //logger.debug("installresults {} :" ,installresults);
    Map<String, Object> InstallresultReverse = new HashMap();
    InstallresultReverse.put("InstallResultID", installresults.get("resultId"));
//    InstallresultReverse.put("InstallEntryID", installresults.get("entryId"));
    InstallresultReverse.put("InstallEntryID", installEntryID);
//    InstallresultReverse.put("InstallStatusID", installresults.get("stusCodeId"));
    InstallresultReverse.put("InstallStatusID", "21");
//    InstallresultReverse.put("InstallCTID", installresults.get("ctId"));
    InstallresultReverse.put("InstallCTID",ctID );
//    InstallresultReverse.put("InstallDate", installresults.get("installDt"));
    InstallresultReverse.put("InstallDate", installDate);
//    InstallresultReverse.put("InstallRemark", installresults.get("rem"));
    InstallresultReverse.put("InstallRemark", remark);
//    InstallresultReverse.put("GLPost", installresults.get("glPost"));
    InstallresultReverse.put("GLPost", 0);
//    InstallresultReverse.put("InstallCreateBy", installresults.get("crtUserId"));
    InstallresultReverse.put("InstallCreateBy", 0);
//    InstallresultReverse.put("InstallCreateAt", installresults.get("crtDt"));
//    InstallresultReverse.put("InstallSirimNo", installresults.get("sirimNo"));
    InstallresultReverse.put("InstallSirimNo", "");
//    InstallresultReverse.put("InstallSerialNo", installresults.get("serialNo"));
    InstallresultReverse.put("InstallSerialNo", "");
//    InstallresultReverse.put("InstallFailID", installresults.get("fail_id"));
    InstallresultReverse.put("InstallFailID", failReason);
//    InstallresultReverse.put("InstallNextCallDate", installresults.get("nextCallDt"));   //nextCallDate
    InstallresultReverse.put("InstallNextCallDate", nextCallDate);
//    InstallresultReverse.put("InstallAllowComm", installresults.get("allowComm"));
    InstallresultReverse.put("InstallAllowComm", 1);
//    InstallresultReverse.put("InstallIsTradeIn", installresults.get("isTradeIn"));
    InstallresultReverse.put("InstallIsTradeIn", 1);
//    InstallresultReverse.put("InstallRequireSMS", installresults.get("requireSms"));
    InstallresultReverse.put("InstallRequireSMS", 1);
//    InstallresultReverse.put("InstallDocRefNo1", installresults.get("docRefNo1"));
    InstallresultReverse.put("InstallDocRefNo1", "");
//    InstallresultReverse.put("InstallDocRefNo2", installresults.get("docRefNo2"));
    InstallresultReverse.put("InstallDocRefNo2", "");
    InstallresultReverse.put("InstallUpdateAt", installresults.get("updDt"));
//    InstallresultReverse.put("InstallUpdateBy", installresults.get("updUserId"));
    InstallresultReverse.put("InstallUpdateBy", userId);
//    InstallresultReverse.put("InstallAdjAmount", installresults.get("adjAmt"));
    InstallresultReverse.put("InstallAdjAmount", 0);
    InstallresultReverse.put("einstallEntryId", params.get("einstallEntryId"));

    /*BY KV - add resultId */
    params.put("InstallResultID", installresults.get("resultId"));

    if(callTypeId == 257){ //ccr0006d.type_id = 257
      //result = installationReversalService.saveReverseNewInstallationResult(params);


        updateInstallresult(params);
        addInstallresultReverse(InstallresultReverse);
        updateInstallEntry(params);

        Map<String, Object> srvMembershipSale = new HashMap();
        srvMembershipSale.put("SrvMemID", memID);
        srvMembershipSale.put("SrvStatusCodeID", '8');
        srvMembershipSale.put("userId", userId);

        updateSrvMembershipSale(srvMembershipSale);


//        Map<String, Object> srvConfiguration = new HashMap();
//        srvConfiguration.put("SrvConfigID", configID);
//        srvConfiguration.put("SrvStatusID", 8);
//        srvConfiguration.put("SrvRemark", "INSTALLATION RESULT REVERSAL");
//        srvConfiguration.put("userId", userId);
//
//        updateSrvConfiguration(srvConfiguration);
//
//
//        Map<String,Object> srvConfigSetting = new HashMap();
//        srvConfigSetting.put("SrvConfigID", configID);
//        srvConfigSetting.put("SrvSettStatusID", 8);
//        srvConfigSetting.put("SrvSettRemark", "INSTALLATION RESULT REVERSAL");
//
//        updateSrvConfigSetting(srvConfigSetting);
//
//
//        Map<String,Object> srvConfigPeriod = new HashMap();
//        srvConfigPeriod.put("SrvConfigID", configID);
//        srvConfigPeriod.put("SrvPrdStatusID", 8);
//        srvConfigPeriod.put("SrvPrdRemark", "INSTALLATION RESULT REVERSAL");
//        srvConfigPeriod.put("userId", userId);
//
//        updateSrvConfigPeriod(srvConfigPeriod);
//
//        Map<String,Object> srvConfigFilter = new HashMap();
//        srvConfigFilter.put("SrvConfigID",configID);
//        srvConfigFilter.put("SrvFilterStatusID",8);
//        srvConfigFilter.put("SrvFilterRemark","INSTALLATION RESULT REVERSAL");
//        srvConfigFilter.put("userId",userId);
//
//        updateSrvConfigFilter(srvConfigFilter);


        Map<String,Object> happyCallM = new HashMap();
        happyCallM.put("HCID", hcID);
        happyCallM.put("HCStatusID", 8);
        happyCallM.put("HCRemark", "INSTALLATION RESULT REVERSAL");
        happyCallM.put("userId", userId);

        updateHappyCallM(happyCallM);


        Map<String,Object> salesOrderM = new HashMap();
        salesOrderM.put("SalesOrderID", salesOrderID);
        salesOrderM.put("StatusCodeID", 1);
        salesOrderM.put("SyncCheck", 1);
        salesOrderM.put("userId", userId);
        salesOrderM.put("PVMonth", 0);
        salesOrderM.put("PVYear", 0);
        salesOrderM.put("AppTypeID", applicationTypeID);
        salesOrderM.put("SalesDate", salesDt);

        updateSalesOrderM(salesOrderM);


        Map<String,Object> installation = new HashMap();
        installation.put("SalesOrderID", salesOrderID);
        installation.put("IsTradeIn", 1);
        installation.put("userId", userId);

        updateInstallation(installation);

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

        addCallEntry(callEntry);

        int  CallEntryId = getCallEntry(params);

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

        addCallResult(callResult);


        Map<String,Object> salesorderLog = new HashMap();
        salesorderLog.put("SalesOrderID", salesOrderID);
        salesorderLog.put("ProgressID", 2);
        salesorderLog.put("RefID", 0);
        salesorderLog.put("IsLock", 0); //true
        salesorderLog.put("userId", userId);
        salesorderLog.put("CallEntryId", CallEntryId);

        addSalesorderLog(salesorderLog);


         // Logistics Reversal Process Begin -- Added By Adrian, 17/01/2019
          Map<String, Object>  logPram = null ;

            logPram =new HashMap<String, Object>();
              logPram.put("ORD_ID", installEntryNo);
              logPram.put("RETYPE", "SVO");
              logPram.put("P_TYPE", "OD02");
              logPram.put("P_PRGNM", "INSCAN");
              logPram.put("USERID", sessionVO.getUserId());


              SP_LOGISTIC_REQUEST(logPram);
             // Logistics Reversal Process End




        String rentDateTime = "2017-02-01";
            params.put("rentDateTime", rentDateTime);

            EgovMap  rv = getRequiredView(params);

            params.put("TotalAmt", rv.get("totAmt"));

        int adjTypeSetID = 0;
            int adjDrAccID = 0;
            int adjCrAccID = 0;

            if(Integer.parseInt(params.get("applicationTypeID").toString())==66 || Integer.parseInt(params.get("applicationTypeID").toString())==67 || Integer.parseInt(params.get("applicationTypeID").toString())==68){

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
                SimpleDateFormat format2 = new SimpleDateFormat("YY/MM/DD");

                String esalesDt = params.get("esalesDt").toString();

                Date salesdate = null;
                Date mthapril = null;

                try {
                  mthapril =  format.parse("2015-APR-01");
                } catch (ParseException e) {
                  // TODO Auto-generated catch block
                  e.printStackTrace();
                }
                try {
                  salesdate = format2.parse(esalesDt);
                } catch (ParseException e) {
                  // TODO Auto-generated catch block
                  e.printStackTrace();
                }
                System.out.println(salesdate);

                if (salesdate.compareTo(mthapril)<0){
                  String adJEntryReportNo = null;
                  params.put("docno",18);
                  adJEntryReportNo =  getDOCNumber(params);
                  params.put("adJEntryReportNo", adJEntryReportNo);
                  String adjEntryNoteNo = null;
                  params.put("docno",15);
                  adjEntryNoteNo =  getDOCNumber(params);
                  params.put("adjEntryNoteNo", adjEntryNoteNo);

                  params.put("docNoId",18);
                   updateDOCNumber(params);
                  params.put("docNoId",15);
                   updateDOCNumber(params);


                 //   installationReversalService.addAccAdjTransEntry(params);
                    int adjEntryId =  selectLastadjEntryId();

                    params.put("adjEntryId",adjEntryId);
                    //installationReversalService.addAccAdjTransResult(params);
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
                      EgovMap  qryPreBill =  getQryPreBill(params);
//                      params.put("TaxInvoiceRefNo",qryPreBill.get("taxInvcRefNo"));
//                      params.put("TaxInvoiceAmountDue",qryPreBill.get("taxInvcAmtDue"));;
//                      params.put("Updator",qryPreBill.get("uptUserId"));;
//                      params.put("AccBillID",qryPreBill.get("accBillId"));;

                      if(qryPreBill !=null){
                        params.put("TaxInvoiceRefNo",qryPreBill.get("taxInvcRefNo"));
                          params.put("TaxInvoiceAmountDue",qryPreBill.get("taxInvcAmtDue"));;
                          params.put("Updator",qryPreBill.get("uptUserId"));;
                          params.put("AccBillID",qryPreBill.get("accBillId"));;

                        String VoidNo = null;
                        params.put("docno",112);
                        VoidNo =  getDOCNumber(params);
                        params.put("VoidNo", VoidNo);
                        params.put("docNoId",112);
                           updateDOCNumber(params);

                         // installationReversalService.addAccOrderVoid_Invoice(params);

                         // installationReversalService.addAccOrderVoid_Invoice_Sub(params);

                          //installationReversalService.updateAccOrderBill(params);
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
                 // installationReversalService.addAccRentLedger(params);

                   updateRentalScheme(params);

                   updateRentalScheme(params);


                    }else{
                      EgovMap  qryPreBill =  getQryPreBill_out(params);
//                      params.put("TaxInvoiceRefNo",qryPreBill.get("taxInvcRefNo"));
//                      params.put("TaxInvoiceAmountDue",qryPreBill.get("taxInvcAmtDue"));;
//                      params.put("Updator",qryPreBill.get("uptUserId"));;
//                      params.put("AccBillID",qryPreBill.get("accBillId"));;

                      if(qryPreBill !=null){
                        params.put("TaxInvoiceRefNo",qryPreBill.get("taxInvcRefNo"));
                          params.put("TaxInvoiceAmountDue",qryPreBill.get("taxInvcAmtDue"));;
                          params.put("Updator",qryPreBill.get("uptUserId"));;
                          params.put("AccBillID",qryPreBill.get("accBillId"));;

                        String VoidNo = null;
                        params.put("docno",112);
                        VoidNo =  getDOCNumber(params);
                        params.put("VoidNo", VoidNo);
                        params.put("docNoId",112);
                           updateDOCNumber(params);

                          //installationReversalService.addAccOrderVoid_Invoice(params);

                          int AccInvVoidID =  getAccInvVoidID();
                          params.put("AccInvVoidID",AccInvVoidID);

                          //installationReversalService.addAccOrderVoid_Invoice_Sub(params);

                          //installationReversalService.updateAccOrderBill(params);
                      }

                     // installationReversalService.addAccTradeLedger(params);

                    }
                }else{
                  if(Integer.parseInt(params.get("applicationTypeID").toString())==67 || Integer.parseInt(params.get("applicationTypeID").toString())==68){

                    List<EgovMap> QryOutSList =  getQryOutS(params);
                    if(QryOutSList.size()>0){

                      for(int i = 0 ; i<QryOutSList.size() ; i++){
                        params.put("TaxInvoiceID",QryOutSList.get(i).get("taxInvcId"));
                        params.put("InvoiceItemGSTTaxes",QryOutSList.get(i).get("invcItmGstTxs"));
                        params.put("InvoiceItemAmountDue",QryOutSList.get(i).get("invcItmAmtDue"));
                        params.put("InvocieItemID",QryOutSList.get(i).get("invcItmId"));
                        params.put("InvoiceItemGSTRate",QryOutSList.get(i).get("invcItmGstRate"));
                        params.put("InvoiceItemRentalFee",QryOutSList.get(i).get("invcItmRentalFee"));
                        params.put("InvoiceItemOrderNo",QryOutSList.get(i).get("invcItmOrdNo"));
                        params.put("InvoiceItemProductModel",QryOutSList.get(i).get("invcItmProductModel"));
                        params.put("InvoiceItemProductSerialNo",QryOutSList.get(i).get("invcItmProductSerialNo"));

                        //,d.INVC_ITM_PRODUCT_MODEL,INVC_ITM_PRODUCT_SERIAL_NO


                        EgovMap  qryAccBill =  getQryAccBill(params);
                        params.put("AccBillID",qryAccBill.get("accBillId"));
                        params.put("TaxInvoiceRefNo",qryAccBill.get("taxInvcRefNo"));
                        params.put("TaxInvoiceRefDate",qryAccBill.get("taxInvcRefDt"));
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

                        // updateAccOrderBill2(params); pay

                        String cnno = null;
                        params.put("docno",134);
                        cnno =  getDOCNumber(params);
                        params.put("cnno", cnno);
                        params.put("adjEntryNoteNo", cnno);
                        params.put("docNoId",134);
                         updateDOCNumber_8Digit(params);

                        String adJEntryReportNo = null;
                        params.put("docno",18);
                        adJEntryReportNo =  getDOCNumber(params);
                        params.put("adJEntryReportNo", adJEntryReportNo);
                        params.put("docNoId",18);
                         updateDOCNumber(params);

                      //   addAccInvAdjr(params);

                        int MemoAdjustID =  getMemoAdjustID();
                        params.put("MemoAdjustID", MemoAdjustID);

                        String AccBillTaxCodeID = null;
                        AccBillTaxCodeID =  getAccBillTaxCodeID(params);
                        params.put("AccBillTaxCodeID", AccBillTaxCodeID);

                        int crid = 0;
                                int drid = 0;
                                int conv = Integer.parseInt(qryAccBill.get("accBillAcctCnvr").toString());
                                    //ACC_BILL_ACCT_CNVR;

                                if (conv == 0)
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

                               //  addAccInvoiceAdjustment_Sub(params);

                              //   addAccTaxDebitCreditNote(params);

                                int NoteID =  getNoteID();
                                params.put("NoteID",NoteID);

                              //   addAccTaxDebitCreditNote_Sub(params);

                                String  VoidNo = null;
                                params.put("docno",112);
                                VoidNo =  getDOCNumber(params);
                                params.put("VoidNo", VoidNo);
                                params.put("docNoId",112);
                               updateDOCNumber(params);


                              params.put("Updator",userId);
                              // addAccOrderVoid_Invoice(params);
                              params.put("adjEntryId",MemoAdjustID);
                              params.put("TotalAmt",qryAccBill.get("taxInvcAmtDue"));

                              //installationReversalService.addAccOrderVoid_Invoice_Sub(params);

                              //installationReversalService.addAccTradeLedger(params);

                      }
                    }
                  }
                }
            }
    }else{
      EgovMap  orderExchangeTypeByInstallEntryID =  GetOrderExchangeTypeByInstallEntryID(params);
      String hidPEAfterInstall = null;
      returnMap.put("spanInstallationType",orderExchangeTypeByInstallEntryID.get("soCurStusId"));
      params.put("docId",orderExchangeTypeByInstallEntryID.get("docId"));

      if(Integer.parseInt(orderExchangeTypeByInstallEntryID.get("soCurStusId").toString())==25 || Integer.parseInt(orderExchangeTypeByInstallEntryID.get("soCurStusId").toString())==26){

        hidPEAfterInstall = "1";

         updateInstallresult(params);
         addInstallresultReverse(InstallresultReverse);
         updateSalesOrderExchange(params);
         updateInstallEntry(params);

        Map<String, Object> srvConfiguration = new HashMap();
          srvConfiguration.put("SrvConfigID", configID);
          srvConfiguration.put("SrvStatusID", 8);
          srvConfiguration.put("SrvRemark", "INSTALLATION RESULT REVERSAL");
          srvConfiguration.put("userId", userId);

           updateSrvConfiguration(srvConfiguration);


          Map<String,Object> srvConfigSetting = new HashMap();
          srvConfigSetting.put("SrvConfigID", configID);
          srvConfigSetting.put("SrvSettStatusID", 8);
          srvConfigSetting.put("SrvSettRemark", "INSTALLATION RESULT REVERSAL");

           updateSrvConfigSetting(srvConfigSetting);


          Map<String,Object> srvConfigPeriod = new HashMap();
          srvConfigPeriod.put("SrvConfigID", configID);
          srvConfigPeriod.put("SrvPrdStatusID", 8);
          srvConfigPeriod.put("SrvPrdRemark", "INSTALLATION RESULT REVERSAL");
          srvConfigPeriod.put("userId", userId);

           updateSrvConfigPeriod(srvConfigPeriod);


          Map<String,Object> srvConfigFilter = new HashMap();
          srvConfigFilter.put("SrvConfigID",configID);
          srvConfigFilter.put("SrvFilterStatusID",8);
          srvConfigFilter.put("SrvFilterRemark","INSTALLATION RESULT REVERSAL");
          srvConfigFilter.put("userId",userId);

           updateSrvConfigFilter(srvConfigFilter);

           updateSrvConfigurations(params);

           updateSrvConfigSetting2(params);

           updateSrvConfigPeriod2(params);

           updateSrvConfigFilter2(params);


          Map<String,Object> happyCallM = new HashMap();
          happyCallM.put("HCID", hcID);
          happyCallM.put("HCStatusID", 8);
          happyCallM.put("HCRemark", "INSTALLATION RESULT REVERSAL");
          happyCallM.put("userId", userId);

           updateHappyCallM(happyCallM);

          EgovMap  rv =  getRequiredView2(params);

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

           updateSalesOrderM2(salesOrderM);


          Map<String,Object> salesOrderD = new HashMap();
          salesOrderD.put("ItemStkID", rv.get("soExchgOldStkId"));
          salesOrderD.put("ItemPriceID", rv.get("soExchgOldPrcId"));
          salesOrderD.put("ItemPrice", rv.get("soExchgOldPrc"));
          salesOrderD.put("ItemPV", rv.get("soExchgOldPv"));
          salesOrderD.put("userId", userId);

           updateSalesOrderD2(salesOrderD);

           updateInstallation(params);

          Map<String,Object> callEntry = new HashMap();
          callEntry.put("SalesOrderID", salesOrderID);
          callEntry.put("TypeID", 258);
          callEntry.put("StatusCodeID", 1);
          callEntry.put("ResultID", 0);
          //callEntry.put("DocID", salesOrderID);
          callEntry.put("DocID", orderExchangeTypeByInstallEntryID.get("docId")); // Hui Ding - change to use DOC_ID as this is the linkage to SAL0004D, 2021-07-29
          callEntry.put("userId", userId);
          callEntry.put("CallDate", nextCallDate);
          callEntry.put("IsWaitForCancel", 1);
          callEntry.put("OriCallDate", nextCallDate);

           addCallEntry(callEntry);

          int  CallEntryId =  getCallEntry(params);

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

           addCallResult(callResult);


          Map<String,Object> salesorderLog = new HashMap();
          salesorderLog.put("SalesOrderID", salesOrderID);
          salesorderLog.put("ProgressID", 2);
          salesorderLog.put("RefID", 0);
          salesorderLog.put("IsLock", 0); //true
          salesorderLog.put("userId", userId);
          salesorderLog.put("CallEntryId", CallEntryId);

           addSalesorderLog(salesorderLog);


          if(Integer.parseInt(params.get("applicationTypeID").toString())==66 || Integer.parseInt(params.get("applicationTypeID").toString())==67 || Integer.parseInt(params.get("applicationTypeID").toString())==68){

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

                  try {
                    mthapril =  format.parse("2015-APR-01");
                  } catch (ParseException e1) {
                    // TODO Auto-generated catch block
                    e1.printStackTrace();
                  }
                  try {
                    salesdate = format.parse(esalesDt);
                  } catch (ParseException e) {
                    // TODO Auto-generated catch block
                    e.printStackTrace();
                  }
                  System.out.println(salesdate);

                  if (salesdate.compareTo(mthapril)<0){
                    String adJEntryReportNo = null;
                    params.put("docno",18);
                    adJEntryReportNo =  getDOCNumber(params);
                    params.put("adJEntryReportNo", adJEntryReportNo);
                    String adjEntryNoteNo = null;
                    params.put("docno",15);
                    adjEntryNoteNo =  getDOCNumber(params);
                    params.put("adjEntryNoteNo", adjEntryNoteNo);

                    params.put("docNoId",18);
                     updateDOCNumber(params);
                    params.put("docNoId",15);
                     updateDOCNumber(params);

                    //EgovMap  rv2 =  getRequiredView(params);

                      //params.put("TotalAmt", rv2.get("totAmt"));


                    //   addAccAdjTransEntry(params);
                      int adjEntryId =  selectLastadjEntryId();

                      params.put("adjEntryId",adjEntryId);
                     //  addAccAdjTransResult(params);

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

                      int trxNo = Integer.parseInt( getDOCNumberOnlyNumber().toString());
                      accTRXPlus.put("TRXNo", trxNo);
                      accTRXPlus.put("TRXDocNo", adjEntryNoteNo);

                      // addAccTRXes(accTRXPlus);


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

                    //   addAccTRXes(accTRXMinus);


                      if(Integer.parseInt(params.get("applicationTypeID").toString())==66){
                        EgovMap  qryPreBill =  getQryPreBill(params);
//                        params.put("TaxInvoiceRefNo",qryPreBill.get("taxInvcRefNo"));
//                        params.put("TaxInvoiceAmountDue",qryPreBill.get("taxInvcAmtDue"));;
//                        params.put("Updator",qryPreBill.get("uptUserId"));;
//                        params.put("AccBillID",qryPreBill.get("accBillId"));;

                        if(qryPreBill !=null){
                          params.put("TaxInvoiceRefNo",qryPreBill.get("taxInvcRefNo"));
                          params.put("TaxInvoiceAmountDue",qryPreBill.get("taxInvcAmtDue"));;
                          params.put("Updator",qryPreBill.get("uptUserId"));;
                          params.put("AccBillID",qryPreBill.get("accBillId"));;

                          String VoidNo = null;
                          params.put("docno",112);
                          VoidNo =  getDOCNumber(params);
                          params.put("VoidNo", VoidNo);
                          params.put("docNoId",112);
                             updateDOCNumber(params);

                           // installationReversalService.addAccOrderVoid_Invoice(params);

                            int AccInvVoidID =  getAccInvVoidID();
                            params.put("AccInvVoidID",AccInvVoidID);

                          //  installationReversalService.addAccOrderVoid_Invoice_Sub(params);

                           // installationReversalService.updateAccOrderBill(params);
                        }

                        Map<String,Object> accRentLedger = new HashMap();
                          accRentLedger.put("RentSOID", salesOrderID);
                          accRentLedger.put("RentDocTypeID", 155);
                          accRentLedger.put("RentAmount", Integer.parseInt(rv.get("soExchgNwPrc").toString())*-1);
                         //  addAccRentLedger(params);

                        // addAccTradeLedger(params);

                        // updateRentalScheme(params);

                      }else{
                        EgovMap  qryPreBill =  getQryPreBill_out(params);
//                        params.put("TaxInvoiceRefNo",qryPreBill.get("taxInvcRefNo"));
//                        params.put("TaxInvoiceAmountDue",qryPreBill.get("taxInvcAmtDue"));;
//                        params.put("Updator",qryPreBill.get("uptUserId"));;
//                        params.put("AccBillID",qryPreBill.get("accBillId"));;

                        if(qryPreBill !=null){
                          params.put("TaxInvoiceRefNo",qryPreBill.get("taxInvcRefNo"));
                          params.put("TaxInvoiceAmountDue",qryPreBill.get("taxInvcAmtDue"));;
                          params.put("Updator",qryPreBill.get("uptUserId"));;
                          params.put("AccBillID",qryPreBill.get("accBillId"));;

                          String VoidNo = null;
                          params.put("docno",112);
                          VoidNo =  getDOCNumber(params);
                          params.put("VoidNo", VoidNo);
                          params.put("docNoId",112);
                             updateDOCNumber(params);

                           //  addAccOrderVoid_Invoice(params);

                            int AccInvVoidID =  getAccInvVoidID();
                            params.put("AccInvVoidID",AccInvVoidID);

                           //  addAccOrderVoid_Invoice_Sub(params);

                         //    updateAccOrderBill(params);
                        }
                          /*
                          Map<String,Object> accRentLedger = new HashMap();
                          accRentLedger.put("RentSOID", salesOrderID);
                          accRentLedger.put("RentDocTypeID", 155);
                          accRentLedger.put("RentAmount", Integer.parseInt(rv.get("soExchgNwPrc").toString())*-1);
                           addAccRentLedger(params);
                          */
                         //  addAccTradeLedger(params);
                          // updateRentalScheme(params);
                      }
                  }else{
                    if(Integer.parseInt(params.get("applicationTypeID").toString())==66){
                    }else if(Integer.parseInt(params.get("applicationTypeID").toString())==67 || Integer.parseInt(params.get("applicationTypeID").toString())==67){

                      List<EgovMap> QryOutSList =  getQryOutS(params);
                      if(QryOutSList.size()>0){

                        EgovMap  qryAccBill =  getQryAccBill(params);
                        params.put("AccBillID",qryAccBill.get("accBillId"));
                        params.put("TaxInvoiceRefNo",qryAccBill.get("taxInvcRefNo"));
                        params.put("TaxInvoiceRefDate",qryAccBill.get("taxInvcRefDt"));
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

                      //   updateAccOrderBill2(params);

                        String cnno = null;
                        params.put("docno",134);
                        cnno =  getDOCNumber(params);
                        params.put("cnno", cnno);
                        params.put("adjEntryNoteNo", cnno);
                        params.put("docNoId",134);
                         updateDOCNumber_8Digit(params);

                        String adJEntryReportNo = null;
                        params.put("docno",18);
                        adJEntryReportNo =  getDOCNumber(params);
                        params.put("adJEntryReportNo", adJEntryReportNo);
                        params.put("docNoId",18);
                         updateDOCNumber(params);

                        // addAccInvAdjr(params);

                        int MemoAdjustID =  getMemoAdjustID();
                        params.put("MemoAdjustID", MemoAdjustID);

                        String AccBillTaxCodeID = null;
                        AccBillTaxCodeID =  getAccBillTaxCodeID(params);
                        params.put("AccBillTaxCodeID", AccBillTaxCodeID);

                        int crid = 0;
                                int drid = 0;
                                int conv = Integer.parseInt(qryAccBill.get("accBillAcctCnvr").toString());
                                    //ACC_BILL_ACCT_CNVR;

                                if (conv == 0)
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

                            //     addAccInvoiceAdjustment_Sub(params);

                               //  addAccTaxDebitCreditNote(params);

                                int NoteID =  getNoteID();
                                params.put("NoteID",NoteID);

                              //   addAccTaxDebitCreditNote_Sub(params);

                                String  VoidNo = null;
                                params.put("docno",112);
                                VoidNo =  getDOCNumber(params);
                                params.put("VoidNo", VoidNo);
                                params.put("docNoId",112);
                               updateDOCNumber(params);

                            //   addAccOrderVoid_Invoice(params);
                              params.put("adjEntryId",MemoAdjustID);
                              params.put("TotalAmt",qryAccBill.get("taxInvcAmtDue"));

                            //   addAccOrderVoid_Invoice_Sub(params);
                            //   addAccTradeLedger(params);

                              // updateAccOrderBill(params);
                      }
                    }
                  }
          }
      }else{
        hidPEAfterInstall = "0";

         updateInstallresult(params);
         addInstallresultReverse(InstallresultReverse);
         updateSalesOrderExchange(params);
         updateInstallEntry(params);

        Map<String, Object> srvMembershipSale = new HashMap();
          srvMembershipSale.put("SrvMemID", memID);
          srvMembershipSale.put("SrvStatusCodeID", '8');
          srvMembershipSale.put("userId", userId);

           updateSrvMembershipSale2(srvMembershipSale);


          Map<String, Object> srvConfiguration = new HashMap();
          srvConfiguration.put("SrvConfigID", configID);
          srvConfiguration.put("SrvStatusID", 8);
          srvConfiguration.put("SrvRemark", "INSTALLATION RESULT REVERSAL");
          srvConfiguration.put("userId", userId);

           updateSrvConfiguration(srvConfiguration);


          Map<String,Object> srvConfigSetting = new HashMap();
          srvConfigSetting.put("SrvConfigID", configID);
          srvConfigSetting.put("SrvSettStatusID", 8);
          srvConfigSetting.put("SrvSettRemark", "INSTALLATION RESULT REVERSAL");

           updateSrvConfigSetting(srvConfigSetting);


          Map<String,Object> srvConfigPeriod = new HashMap();
          srvConfigPeriod.put("SrvConfigID", configID);
          srvConfigPeriod.put("SrvPrdStatusID", 8);
          srvConfigPeriod.put("SrvPrdRemark", "INSTALLATION RESULT REVERSAL");
          srvConfigPeriod.put("userId", userId);

           updateSrvConfigPeriod(srvConfigPeriod);


          Map<String,Object> srvConfigFilter = new HashMap();
          srvConfigFilter.put("SrvConfigID",configID);
          srvConfigFilter.put("SrvFilterStatusID",8);
          srvConfigFilter.put("SrvFilterRemark","INSTALLATION RESULT REVERSAL");
          srvConfigFilter.put("userId",userId);

           updateSrvConfigFilter(srvConfigFilter);
          Map<String,Object> happyCallM = new HashMap();
          happyCallM.put("HCID", hcID);
          happyCallM.put("HCStatusID", 8);
          happyCallM.put("HCRemark", "INSTALLATION RESULT REVERSAL");
          happyCallM.put("userId", userId);
           updateHappyCallM(happyCallM);
          EgovMap  rv =  getRequiredView2(params);
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

           updateSalesOrderM2(salesOrderM);

          Map<String,Object> salesOrderD = new HashMap();
          salesOrderD.put("ItemStkID", rv.get("soExchgOldStkId"));
          salesOrderD.put("ItemPriceID", rv.get("soExchgOldPrcId"));
          salesOrderD.put("ItemPrice", rv.get("soExchgOldPrc"));
          salesOrderD.put("ItemPV", rv.get("soExchgOldPv"));
          salesOrderD.put("userId", userId);

           updateSalesOrderD2(salesOrderD);
           updateInstallation(params);

          Map<String,Object> callEntry = new HashMap();
          callEntry.put("SalesOrderID", salesOrderID);
          callEntry.put("TypeID", 258);
          callEntry.put("StatusCodeID", 1);
          callEntry.put("ResultID", 0);
          callEntry.put("DocID", params.get("docId"));
          callEntry.put("userId", userId);
          callEntry.put("CallDate", nextCallDate);
          callEntry.put("IsWaitForCancel", 1);
          callEntry.put("OriCallDate", nextCallDate);

           addCallEntry(callEntry);

          int  CallEntryId =  getCallEntry(params);

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

           addCallResult(callResult);

          Map<String,Object> salesorderLog = new HashMap();
          salesorderLog.put("SalesOrderID", salesOrderID);
          salesorderLog.put("ProgressID", 3);
          salesorderLog.put("RefID", 0);
          salesorderLog.put("IsLock", 0); //true
          salesorderLog.put("userId", userId);
          salesorderLog.put("CallEntryId", CallEntryId);

           addSalesorderLog(salesorderLog);


          if(Integer.parseInt(params.get("applicationTypeID").toString())==66 || Integer.parseInt(params.get("applicationTypeID").toString())==67 || Integer.parseInt(params.get("applicationTypeID").toString())==68){

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
                  SimpleDateFormat format = new SimpleDateFormat("yyyy/MM/dd");
                  String esalesDt = params.get("esalesDt").toString();
                  Date salesdate = null;
                  Date mthapril = null;
                  try {
                    mthapril =  format.parse("2015/04/01");
                  } catch (ParseException e) {
                    // TODO Auto-generated catch block
                    e.printStackTrace();
                  }
                  try {
                    salesdate = format.parse(esalesDt);
                  } catch (ParseException e) {
                    // TODO Auto-generated catch block
                    e.printStackTrace();
                  }

                  if (salesdate.compareTo(mthapril)<0){
                    String adJEntryReportNo = null;
                    params.put("docno",18);
                    adJEntryReportNo =  getDOCNumber(params);
                    params.put("adJEntryReportNo", adJEntryReportNo);
                    String adjEntryNoteNo = null;
                    params.put("docno",15);
                    adjEntryNoteNo =  getDOCNumber(params);
                    params.put("adjEntryNoteNo", adjEntryNoteNo);

                    params.put("docNoId",18);
                     updateDOCNumber(params);
                    params.put("docNoId",15);
                     updateDOCNumber(params);

                    // addAccAdjTransEntry(params);
                      int adjEntryId =  selectLastadjEntryId();

                      params.put("adjEntryId",adjEntryId);
                      // addAccAdjTransResult(params);

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

                      int trxNo = Integer.parseInt( getDOCNumberOnlyNumber().toString());
                      accTRXPlus.put("TRXNo", trxNo);
                      accTRXPlus.put("TRXDocNo", adjEntryNoteNo);

                     //  addAccTRXes(accTRXPlus);


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

                  //     addAccTRXes(accTRXMinus);

                      if(Integer.parseInt(params.get("applicationTypeID").toString())==66){

                        EgovMap  qryPreBill =  getQryPreBill(params);
//                        params.put("TaxInvoiceRefNo",qryPreBill.get("taxInvcRefNo"));
//                        params.put("TaxInvoiceAmountDue",qryPreBill.get("taxInvcAmtDue"));;
//                        params.put("Updator",qryPreBill.get("uptUserId"));;
//                        params.put("AccBillID",qryPreBill.get("accBillId"));;

                        if(qryPreBill !=null){
                          params.put("TaxInvoiceRefNo",qryPreBill.get("taxInvcRefNo"));
                          params.put("TaxInvoiceAmountDue",qryPreBill.get("taxInvcAmtDue"));;
                          params.put("Updator",qryPreBill.get("uptUserId"));;
                          params.put("AccBillID",qryPreBill.get("accBillId"));;

                          String VoidNo = null;
                          params.put("docno",112);
                          VoidNo =  getDOCNumber(params);
                          params.put("VoidNo", VoidNo);
                          params.put("docNoId",112);
                             updateDOCNumber(params);

                            // addAccOrderVoid_Invoice(params);

                            int AccInvVoidID =  getAccInvVoidID();
                            params.put("AccInvVoidID",AccInvVoidID);

                            // addAccOrderVoid_Invoice_Sub(params);

                            // updateAccOrderBill(params);
                        }

                        Map<String,Object> accRentLedger = new HashMap();
                          accRentLedger.put("RentSOID", salesOrderID);
                          accRentLedger.put("RentDocTypeID", 155);
                          accRentLedger.put("RentAmount", Integer.parseInt(rv.get("soExchgNwPrc").toString())*-1);
                          // addAccRentLedger(params);

                           updateRentalScheme(params);
                      }else{
                        EgovMap  qryPreBill =  getQryPreBill_out(params);
//                        params.put("TaxInvoiceRefNo",qryPreBill.get("taxInvcRefNo"));
//                        params.put("TaxInvoiceAmountDue",qryPreBill.get("taxInvcAmtDue"));;
//                        params.put("Updator",qryPreBill.get("uptUserId"));;
//                        params.put("AccBillID",qryPreBill.get("accBillId"));;

                        if(qryPreBill !=null){
                          params.put("TaxInvoiceRefNo",qryPreBill.get("taxInvcRefNo"));
                          params.put("TaxInvoiceAmountDue",qryPreBill.get("taxInvcAmtDue"));;
                          params.put("Updator",qryPreBill.get("uptUserId"));;
                          params.put("AccBillID",qryPreBill.get("accBillId"));;

                          String VoidNo = null;
                          params.put("docno",112);
                          VoidNo =  getDOCNumber(params);
                          params.put("VoidNo", VoidNo);
                          params.put("docNoId",112);
                             updateDOCNumber(params);

                           //  addAccOrderVoid_Invoice(params);

                            int AccInvVoidID =  getAccInvVoidID();
                            params.put("AccInvVoidID",AccInvVoidID);

                           //  addAccOrderVoid_Invoice_Sub(params);

                           //  updateAccOrderBill(params);
                        }
                        Map<String,Object> accRentLedger = new HashMap();
                          accRentLedger.put("RentSOID", salesOrderID);
                          accRentLedger.put("RentDocTypeID", 155);
                          accRentLedger.put("RentAmount", Integer.parseInt(rv.get("soExchgNwPrc").toString())*-1);
                          // addAccRentLedger(params);
                      }
                  }else{
                    if(Integer.parseInt(params.get("applicationTypeID").toString())==66){
                    }else if(Integer.parseInt(params.get("applicationTypeID").toString())==67 || Integer.parseInt(params.get("applicationTypeID").toString())==67){

                      List<EgovMap> QryOutSList =  getQryOutS(params);
                      if(QryOutSList.size()>0){
                        EgovMap  qryAccBill =  getQryAccBill(params);
                        params.put("AccBillID",qryAccBill.get("accBillId"));
                        params.put("TaxInvoiceRefNo",qryAccBill.get("taxInvcRefNo"));
                        params.put("TaxInvoiceRefDate",qryAccBill.get("taxInvcRefDt"));
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

                        // updateAccOrderBill2(params);

                        String cnno = null;
                        params.put("docno",134);
                        cnno =  getDOCNumber(params);
                        params.put("cnno", cnno);
                        params.put("adjEntryNoteNo", cnno);
                        params.put("docNoId",134);
                         updateDOCNumber_8Digit(params);

                        String adJEntryReportNo = null;
                        params.put("docno",18);
                        adJEntryReportNo =  getDOCNumber(params);
                        params.put("adJEntryReportNo", adJEntryReportNo);
                        params.put("docNoId",18);
                         updateDOCNumber(params);

                        // addAccInvAdjr(params);

                        int MemoAdjustID =  getMemoAdjustID();
                        params.put("MemoAdjustID", MemoAdjustID);

                        String AccBillTaxCodeID = null;
                        AccBillTaxCodeID =  getAccBillTaxCodeID(params);
                        params.put("AccBillTaxCodeID", AccBillTaxCodeID);

                        int crid = 0;
                                int drid = 0;
                                int conv = Integer.parseInt(qryAccBill.get("accBillAcctCnvr").toString());
                                    //ACC_BILL_ACCT_CNVR;

                                if (conv == 0)
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

                                // addAccInvoiceAdjustment_Sub(params);

                               //  addAccTaxDebitCreditNote(params);

                                int NoteID =  getNoteID();
                                params.put("NoteID",NoteID);

                               //  addAccTaxDebitCreditNote_Sub(params);

                                String  VoidNo = null;
                                params.put("docno",112);
                                VoidNo =  getDOCNumber(params);
                                params.put("VoidNo", VoidNo);
                                params.put("docNoId",112);
                               updateDOCNumber(params);

                              // addAccOrderVoid_Invoice(params);
                              params.put("adjEntryId",MemoAdjustID);
                              params.put("TotalAmt",qryAccBill.get("taxInvcAmtDue"));

                            //   addAccOrderVoid_Invoice_Sub(params);

                              // addAccTradeLedger(params);

                      }
                    }
                  }
          }
      }


    }
	}

	public void saveResavalSerial(Map<String, Object> params) throws ParseException {
	  logger.debug("---------save Resaval Serial Implementation-------------------");
		EgovMap returnMap = new EgovMap();

		String defaultDate = "1900-01-01";

		int callTypeId = CommonUtils.intNvl(Integer.parseInt(params.get("callTypeId").toString()));	//ccr0006d.type_id
		int result = 0 ;

		/*	By KV - this is wrong - int installResultID = CommonUtils.intNvl(Integer.parseInt(params.get("einstallEntryId").toString()));*/
		int installEntryID = CommonUtils.intNvl(Integer.parseInt(params.get("einstallEntryId").toString()));
		String installEntryNo = CommonUtils.nvl(params.get("einstallEntryNo").toString());
		String installDate = CommonUtils.nvl(params.get("instalStrlDate").toString());
		String nextCallDate = CommonUtils.nvl(params.get("nextCallStrlDate").toString());

		logger.debug("-----------------------installDate-------------------------");;
		logger.debug(installDate);;

		String remark = params.get("reverseReasonText").toString();
		logger.debug(remark);;

		String failReason =params.get("failReason").toString();
		logger.debug(failReason);;

		String ctID = params.get("ectid").toString();
		logger.debug(ctID);;

		int applicationTypeID = Integer.parseInt(params.get("applicationTypeID").toString());
		System.out.println(applicationTypeID);;

		int salesOrderID = Integer.parseInt(params.get("esalesOrdId").toString());
		System.out.println(salesOrderID);;

		String salesDt = params.get("esalesDt").toString();
		logger.debug(salesDt);;

		int defaultPacID=0;
		if(Integer.parseInt(params.get("applicationTypeID").toString())==66){
			defaultPacID=4;
		}else if(Integer.parseInt(params.get("applicationTypeID").toString())==67 || Integer.parseInt(params.get("applicationTypeID").toString())==68 || Integer.parseInt(params.get("applicationTypeID").toString())==142){
			defaultPacID=3;
		}else if(Integer.parseInt(params.get("applicationTypeID").toString())==144){
			defaultPacID=10;
		}else if(Integer.parseInt(params.get("applicationTypeID").toString())==7759){
			defaultPacID=35;
		}else{
			defaultPacID=2;
		}
		params.put("defaultPacID",defaultPacID);

		int memID = 0;
		String memid = null;
		memid= getMemIDBySalesOrderIDAndPacID(params);
		if(memid !=null)
		memID = Integer.parseInt(memid);
		params.put("memID",memID);

		int configID = -1;
		String configid = null;
		configid = getLatestConfigIDBySalesOrderID(params);
		if(configid!=null)
		configID = Integer.parseInt(configid);
		params.put("configID",configID);

		int hcID = 0;
		String hcid = null;
		hcid = getHCIDBySalesOrderID(params);
		if(hcid!=null)
		hcID = Integer.parseInt(hcid);
		params.put("hcID",hcID);

		int inChargeCTWHID = 0;
		if(params.get("inChargeCTWHID") !=null)
		inChargeCTWHID = Integer.parseInt(params.get("inChargeCTWHID").toString());

		int retWarehouseID;
		String warehouseGrade;

		int productID = 0;
		if(params.get("eProductID") !=null)
		productID = Integer.parseInt(params.get("eProductID").toString());


		String customerName = "";
		if(params.get("eCustomerName")!=null)
		customerName = params.get("eCustomerName").toString();

		String installNo = "";
		if(params.get("einstallEntryNo")!=null)
		installNo = params.get("einstallEntryNo").toString();

		EgovMap  installresults = getInstallResults(params);
		//logger.debug("installresults {} :" ,installresults);
		Map<String, Object> InstallresultReverse = new HashMap();
		InstallresultReverse.put("InstallResultID", installresults.get("resultId"));
//		InstallresultReverse.put("InstallEntryID", installresults.get("entryId"));
		InstallresultReverse.put("InstallEntryID", installEntryID);
//		InstallresultReverse.put("InstallStatusID", installresults.get("stusCodeId"));
		InstallresultReverse.put("InstallStatusID", "21");
//		InstallresultReverse.put("InstallCTID", installresults.get("ctId"));
		InstallresultReverse.put("InstallCTID",ctID );
//		InstallresultReverse.put("InstallDate", installresults.get("installDt"));
		InstallresultReverse.put("InstallDate", installDate);
//		InstallresultReverse.put("InstallRemark", installresults.get("rem"));
		InstallresultReverse.put("InstallRemark", remark);
//		InstallresultReverse.put("GLPost", installresults.get("glPost"));
		InstallresultReverse.put("GLPost", 0);
//		InstallresultReverse.put("InstallCreateBy", installresults.get("crtUserId"));
		InstallresultReverse.put("InstallCreateBy", 0);
//		InstallresultReverse.put("InstallCreateAt", installresults.get("crtDt"));
//		InstallresultReverse.put("InstallSirimNo", installresults.get("sirimNo"));
		InstallresultReverse.put("InstallSirimNo", "");
//		InstallresultReverse.put("InstallSerialNo", installresults.get("serialNo"));
		InstallresultReverse.put("InstallSerialNo", "");
//		InstallresultReverse.put("InstallFailID", installresults.get("fail_id"));
		InstallresultReverse.put("InstallFailID", failReason);
//		InstallresultReverse.put("InstallNextCallDate", installresults.get("nextCallDt"));   //nextCallDate
		InstallresultReverse.put("InstallNextCallDate", nextCallDate);
//		InstallresultReverse.put("InstallAllowComm", installresults.get("allowComm"));
		InstallresultReverse.put("InstallAllowComm", 1);
//		InstallresultReverse.put("InstallIsTradeIn", installresults.get("isTradeIn"));
		InstallresultReverse.put("InstallIsTradeIn", 1);
//		InstallresultReverse.put("InstallRequireSMS", installresults.get("requireSms"));
		InstallresultReverse.put("InstallRequireSMS", 1);
//		InstallresultReverse.put("InstallDocRefNo1", installresults.get("docRefNo1"));
		InstallresultReverse.put("InstallDocRefNo1", "");
//		InstallresultReverse.put("InstallDocRefNo2", installresults.get("docRefNo2"));
		InstallresultReverse.put("InstallDocRefNo2", "");
		InstallresultReverse.put("InstallUpdateAt", installresults.get("updDt"));
//		InstallresultReverse.put("InstallUpdateBy", installresults.get("updUserId"));
		InstallresultReverse.put("InstallUpdateBy", params.get("userId"));
//		InstallresultReverse.put("InstallAdjAmount", installresults.get("adjAmt"));
		InstallresultReverse.put("InstallAdjAmount", 0);
		InstallresultReverse.put("einstallEntryId", params.get("einstallEntryId"));

		/*BY KV - add resultId */
		params.put("InstallResultID", installresults.get("resultId"));

		if(callTypeId == 257){ //ccr0006d.type_id = 257
			logger.debug("-------------2---------------");
			//result = saveReverseNewInstallationResult(params);


    		updateInstallresult(params);
    		addInstallresultReverse(InstallresultReverse);
    		updateInstallEntry(params);

    		Map<String, Object> srvMembershipSale = new HashMap();
    		srvMembershipSale.put("SrvMemID", memID);
    		srvMembershipSale.put("SrvStatusCodeID", '8');
    		srvMembershipSale.put("userId", params.get("userId"));

    		updateSrvMembershipSale(srvMembershipSale);


//    		Map<String, Object> srvConfiguration = new HashMap();
//    		srvConfiguration.put("SrvConfigID", configID);
//    		srvConfiguration.put("SrvStatusID", 8);
//    		srvConfiguration.put("SrvRemark", "INSTALLATION RESULT REVERSAL");
//    		srvConfiguration.put("userId", params.get("userId"));
//
//    		updateSrvConfiguration(srvConfiguration);
//
//
//    		Map<String,Object> srvConfigSetting = new HashMap();
//    		srvConfigSetting.put("SrvConfigID", configID);
//    		srvConfigSetting.put("SrvSettStatusID", 8);
//    		srvConfigSetting.put("SrvSettRemark", "INSTALLATION RESULT REVERSAL");
//
//    		updateSrvConfigSetting(srvConfigSetting);
//
//
//    		Map<String,Object> srvConfigPeriod = new HashMap();
//    		srvConfigPeriod.put("SrvConfigID", configID);
//    		srvConfigPeriod.put("SrvPrdStatusID", 8);
//    		srvConfigPeriod.put("SrvPrdRemark", "INSTALLATION RESULT REVERSAL");
//    		srvConfigPeriod.put("userId", params.get("userId"));
//
//    		updateSrvConfigPeriod(srvConfigPeriod);
//
//    		Map<String,Object> srvConfigFilter = new HashMap();
//    		srvConfigFilter.put("SrvConfigID",configID);
//    		srvConfigFilter.put("SrvFilterStatusID",8);
//    		srvConfigFilter.put("SrvFilterRemark","INSTALLATION RESULT REVERSAL");
//    		srvConfigFilter.put("userId",params.get("userId"));
//
//    		updateSrvConfigFilter(srvConfigFilter);


    		Map<String,Object> happyCallM = new HashMap();
    		happyCallM.put("HCID", hcID);
    		happyCallM.put("HCStatusID", 8);
    		happyCallM.put("HCRemark", "INSTALLATION RESULT REVERSAL");
    		happyCallM.put("userId", params.get("userId"));

    		updateHappyCallM(happyCallM);


    		Map<String,Object> salesOrderM = new HashMap();
    		salesOrderM.put("SalesOrderID", salesOrderID);
    		salesOrderM.put("StatusCodeID", 1);
    		salesOrderM.put("SyncCheck", 1);
    		salesOrderM.put("userId", params.get("userId"));
    		salesOrderM.put("PVMonth", 0);
    		salesOrderM.put("PVYear", 0);
    		salesOrderM.put("AppTypeID", applicationTypeID);
    		salesOrderM.put("SalesDate", salesDt);

    		updateSalesOrderM(salesOrderM);


    		Map<String,Object> installation = new HashMap();
    		installation.put("SalesOrderID", salesOrderID);
    		installation.put("IsTradeIn", 1);
    		installation.put("userId", params.get("userId"));

    		updateInstallation(installation);

    		Map<String,Object> callEntry = new HashMap();
    		callEntry.put("SalesOrderID", salesOrderID);
    		callEntry.put("TypeID", 257);
    		callEntry.put("StatusCodeID", 1);
    		callEntry.put("ResultID", 0);
    		callEntry.put("DocID", salesOrderID);
    		callEntry.put("userId", params.get("userId"));
    		callEntry.put("CallDate", nextCallDate);
    		callEntry.put("IsWaitForCancel", 1);
    		callEntry.put("OriCallDate", nextCallDate);

    		addCallEntry(callEntry);

    		int  CallEntryId = getCallEntry(params);

    		Map<String,Object> callResult = new HashMap();
    		//callResult.put("CallResultID", 0);
    		callResult.put("CallEntryID", CallEntryId);
    		callResult.put("CallStatusID", 1);
    		callResult.put("CallCallDate", defaultDate);
    		callResult.put("CallActionDate", defaultDate);
    		callResult.put("CallFeedBackID", 0);
    		callResult.put("CallCTID", 0);
    		callResult.put("CallRemark", remark);
    		callResult.put("userId", params.get("userId"));
    		callResult.put("CallCreateByDept", 0);
    		callResult.put("CallHCID", 0);
    		callResult.put("CallROSAmt", 0);
    		callResult.put("CallSMS", 0);
    		callResult.put("CallSMSRemark", "");

    		addCallResult(callResult);


    		Map<String,Object> salesorderLog = new HashMap();
    		salesorderLog.put("SalesOrderID", salesOrderID);
    		salesorderLog.put("ProgressID", 2);
    		salesorderLog.put("RefID", 0);
    		salesorderLog.put("IsLock", 0);	//true
    		salesorderLog.put("userId", params.get("userId"));
    		salesorderLog.put("CallEntryId", CallEntryId);

    		addSalesorderLog(salesorderLog);


    		// Logistics Reversal Process Begin -- Added By Adrian, 17/01/2019
    		Map<String, Object>  logPram = null ;

      		logPram =new HashMap<String, Object>();
            logPram.put("ORD_ID", installEntryNo);
            logPram.put("RETYPE", "SVO");
            logPram.put("P_TYPE", "OD02");
            logPram.put("P_PRGNM", "INSCAN");
            logPram.put("USERID", params.get("userId"));

            Map<String, Object> resultValue = new HashMap<String, Object>();

            resultValue = servicesLogisticsPFCMapper.SP_LOGISTIC_REQUEST_SERIAL(logPram);
            // Logistics Reversal Process End
            if (!"000".equals(CommonUtils.nvl(logPram.get("p1")))){
            	throw new ApplicationException(AppConstants.FAIL, "[ERROR]" + logPram.get("p1")+ ":" + "INSTALLATION Reversal Result Error");
            }

    		String rentDateTime = "2017-02-01";
            params.put("rentDateTime", rentDateTime);

            EgovMap  rv = getRequiredView(params);

            params.put("TotalAmt", rv.get("totAmt"));

    		int adjTypeSetID = 0;
            int adjDrAccID = 0;
            int adjCrAccID = 0;

            if(Integer.parseInt(params.get("applicationTypeID").toString())==66 || Integer.parseInt(params.get("applicationTypeID").toString())==7759  || Integer.parseInt(params.get("applicationTypeID").toString())==67 || Integer.parseInt(params.get("applicationTypeID").toString())==68){
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
                SimpleDateFormat format2 = new SimpleDateFormat("YY/MM/DD");

                String esalesDt = params.get("esalesDt").toString();

                Date salesdate = null;
                Date mthapril = null;

                mthapril =  format.parse("2015-APR-01");
                salesdate = format2.parse(esalesDt);
                System.out.println(salesdate);

                if (salesdate.compareTo(mthapril)<0){
                	logger.debug("-------------4---------------");
                	String adJEntryReportNo = null;
                	params.put("docno",18);
                	adJEntryReportNo = getDOCNumber(params);
                	params.put("adJEntryReportNo", adJEntryReportNo);
                	String adjEntryNoteNo = null;
                	params.put("docno",15);
                	adjEntryNoteNo = getDOCNumber(params);
                	params.put("adjEntryNoteNo", adjEntryNoteNo);

                	params.put("docNoId",18);
                	updateDOCNumber(params);
                	params.put("docNoId",15);
                	updateDOCNumber(params);


                 //   addAccAdjTransEntry(params);
                    int adjEntryId = selectLastadjEntryId();

                    params.put("adjEntryId",adjEntryId);
                    //addAccAdjTransResult(params);
                    /*
                    String trxNo = getDOCNumberOnlyNumber();
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

                    int trxNo = Integer.parseInt(getDOCNumberOnlyNumber().toString());
                    accTRXPlus.put("TRXNo", trxNo);
                    accTRXPlus.put("TRXDocNo", adjEntryNoteNo);

                    addAccTRXes(accTRXPlus);


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

                    addAccTRXes(accTRXMinus);

                    */
                    if(Integer.parseInt(params.get("applicationTypeID").toString())==66 || Integer.parseInt(params.get("applicationTypeID").toString())==7759 ){
                    	logger.debug("-------------5---------------");
                    	EgovMap  qryPreBill = getQryPreBill(params);
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
                    		VoidNo = getDOCNumber(params);
                    		params.put("VoidNo", VoidNo);
                    		params.put("docNoId",112);
                         	updateDOCNumber(params);

                         //	addAccOrderVoid_Invoice(params);

                         //	addAccOrderVoid_Invoice_Sub(params);

                         	//updateAccOrderBill(params);
                    	}
                    /*
                 	Map<String,Object> accTradeLedger = new HashMap();
                 	accTradeLedger.put("TradeSOID", salesOrderID);
                 	accTradeLedger.put("TradeDocTypeID", salesOrderID);
                 	accTradeLedger.put("TradeAmount", Integer.parseInt(rv.get("totAmt").toString())*-1);
                 	accTradeLedger.put("TradeInstNo", 0);
                 	accTradeLedger.put("TradeBatchNo", "0");
                 	accTradeLedger.put("TradeIsSync", 1);
                 	accTradeLedger.put("userId", params.get("userId"));

                 	addAccTradeLedger(accTradeLedger);
                 	*/

                	Map<String,Object> accRentLedger = new HashMap();
                 	accRentLedger.put("RentSOID", salesOrderID);
                 	accRentLedger.put("RentDocTypeID", 155);
                 	accRentLedger.put("RentAmount", Integer.parseInt(rv.get("totAmt").toString())*-1);
                 //	addAccRentLedger(params);

                 	updateRentalScheme(params);

                 	updateRentalScheme(params);


                    }else{
                    	logger.debug("-------------7---------------");
                    	EgovMap  qryPreBill = getQryPreBill_out(params);
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
                    		VoidNo = getDOCNumber(params);
                    		params.put("VoidNo", VoidNo);
                    		params.put("docNoId",112);
                         	updateDOCNumber(params);

                         	//addAccOrderVoid_Invoice(params);

                         	int AccInvVoidID = getAccInvVoidID();
                         	params.put("AccInvVoidID",AccInvVoidID);

                         	//addAccOrderVoid_Invoice_Sub(params);

                         	//updateAccOrderBill(params);
                    	}

                     //	addAccTradeLedger(params);

                    }
                }else{
                	logger.debug("-------------9---------------");
                	if(Integer.parseInt(params.get("applicationTypeID").toString())==67 || Integer.parseInt(params.get("applicationTypeID").toString())==68){
                		logger.debug("-------------10---------------");
                		List<EgovMap> QryOutSList = getQryOutS(params);
                		if(QryOutSList.size()>0){
                			logger.debug("-------------11---------------");
                			for(int i = 0 ; i<QryOutSList.size() ; i++){
                				params.put("TaxInvoiceID",QryOutSList.get(i).get("taxInvcId"));
                				params.put("InvoiceItemGSTTaxes",QryOutSList.get(i).get("invcItmGstTxs"));
                				params.put("InvoiceItemAmountDue",QryOutSList.get(i).get("invcItmAmtDue"));
                				params.put("InvocieItemID",QryOutSList.get(i).get("invcItmId"));
                				params.put("InvoiceItemGSTRate",QryOutSList.get(i).get("invcItmGstRate"));
                				params.put("InvoiceItemRentalFee",QryOutSList.get(i).get("invcItmRentalFee"));
                				params.put("InvoiceItemOrderNo",QryOutSList.get(i).get("invcItmOrdNo"));
                				params.put("InvoiceItemProductModel",QryOutSList.get(i).get("invcItmProductModel"));
                				params.put("InvoiceItemProductSerialNo",QryOutSList.get(i).get("invcItmProductSerialNo"));

                				//,d.INVC_ITM_PRODUCT_MODEL,INVC_ITM_PRODUCT_SERIAL_NO


                				EgovMap  qryAccBill = getQryAccBill(params);
                				params.put("AccBillID",qryAccBill.get("accBillId"));
                				params.put("TaxInvoiceRefNo",qryAccBill.get("taxInvcRefNo"));
                				params.put("TaxInvoiceRefDate",qryAccBill.get("taxInvcRefDt"));
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

                				//updateAccOrderBill2(params); pay

                				String cnno = null;
                				params.put("docno",134);
                				cnno = getDOCNumber(params);
                				params.put("cnno", cnno);
                				params.put("adjEntryNoteNo", cnno);
                				params.put("docNoId",134);
                				updateDOCNumber_8Digit(params);

                				String adJEntryReportNo = null;
                				params.put("docno",18);
                				adJEntryReportNo = getDOCNumber(params);
                				params.put("adJEntryReportNo", adJEntryReportNo);
                				params.put("docNoId",18);
                				updateDOCNumber(params);

                			//	addAccInvAdjr(params);

                				int MemoAdjustID = getMemoAdjustID();
                				params.put("MemoAdjustID", MemoAdjustID);

                				String AccBillTaxCodeID = null;
                				AccBillTaxCodeID = getAccBillTaxCodeID(params);
                				params.put("AccBillTaxCodeID", AccBillTaxCodeID);

                				int crid = 0;
                                int drid = 0;
                                int conv = Integer.parseInt(qryAccBill.get("accBillAcctCnvr").toString());
                                		//ACC_BILL_ACCT_CNVR;

                                if (conv == 0)
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

                               // addAccInvoiceAdjustment_Sub(params);

                              //  addAccTaxDebitCreditNote(params);

                                int NoteID = getNoteID();
                                params.put("NoteID",NoteID);

                              //  addAccTaxDebitCreditNote_Sub(params);

                                String  VoidNo = null;
                                params.put("docno",112);
                                VoidNo = getDOCNumber(params);
                                params.put("VoidNo", VoidNo);
                                params.put("docNoId",112);
                            	updateDOCNumber(params);


                            	params.put("Updator",params.get("userId"));
                            	//addAccOrderVoid_Invoice(params);
                            	params.put("adjEntryId",MemoAdjustID);
                            	params.put("TotalAmt",qryAccBill.get("taxInvcAmtDue"));

                            	//addAccOrderVoid_Invoice_Sub(params);

                            	//addAccTradeLedger(params);

                			}
                		}
                	}
                }
            }
		}else{
			logger.debug("-------------12---------------");
			EgovMap  orderExchangeTypeByInstallEntryID = GetOrderExchangeTypeByInstallEntryID(params);
			String hidPEAfterInstall = null;
			returnMap.put("spanInstallationType",orderExchangeTypeByInstallEntryID.get("soCurStusId"));
	    params.put("docId",orderExchangeTypeByInstallEntryID.get("docId"));
			if(Integer.parseInt(orderExchangeTypeByInstallEntryID.get("soCurStusId").toString())==25 || Integer.parseInt(orderExchangeTypeByInstallEntryID.get("soCurStusId").toString())==26){
				logger.debug("-------------13---------------");
				hidPEAfterInstall = "1";

				updateInstallresult(params);
				addInstallresultReverse(InstallresultReverse);
				updateSalesOrderExchange(params);
				updateInstallEntry(params);

				Map<String, Object> srvConfiguration = new HashMap();
	    		srvConfiguration.put("SrvConfigID", configID);
	    		srvConfiguration.put("SrvStatusID", 8);
	    		srvConfiguration.put("SrvRemark", "INSTALLATION RESULT REVERSAL");
	    		srvConfiguration.put("userId", params.get("userId"));

	    		updateSrvConfiguration(srvConfiguration);


	    		Map<String,Object> srvConfigSetting = new HashMap();
	    		srvConfigSetting.put("SrvConfigID", configID);
	    		srvConfigSetting.put("SrvSettStatusID", 8);
	    		srvConfigSetting.put("SrvSettRemark", "INSTALLATION RESULT REVERSAL");

	    		updateSrvConfigSetting(srvConfigSetting);


	    		Map<String,Object> srvConfigPeriod = new HashMap();
	    		srvConfigPeriod.put("SrvConfigID", configID);
	    		srvConfigPeriod.put("SrvPrdStatusID", 8);
	    		srvConfigPeriod.put("SrvPrdRemark", "INSTALLATION RESULT REVERSAL");
	    		srvConfigPeriod.put("userId", params.get("userId"));

	    		updateSrvConfigPeriod(srvConfigPeriod);


	    		Map<String,Object> srvConfigFilter = new HashMap();
	    		srvConfigFilter.put("SrvConfigID",configID);
	    		srvConfigFilter.put("SrvFilterStatusID",8);
	    		srvConfigFilter.put("SrvFilterRemark","INSTALLATION RESULT REVERSAL");
	    		srvConfigFilter.put("userId",params.get("userId"));

	    		updateSrvConfigFilter(srvConfigFilter);

	    		updateSrvConfigurations(params);

	    		updateSrvConfigSetting2(params);

	    		updateSrvConfigPeriod2(params);

	    		updateSrvConfigFilter2(params);


	    		Map<String,Object> happyCallM = new HashMap();
	    		happyCallM.put("HCID", hcID);
	    		happyCallM.put("HCStatusID", 8);
	    		happyCallM.put("HCRemark", "INSTALLATION RESULT REVERSAL");
	    		happyCallM.put("userId", params.get("userId"));

	    		updateHappyCallM(happyCallM);

	    		EgovMap  rv = getRequiredView2(params);

	    		Map<String,Object> salesOrderM = new HashMap();
	    		salesOrderM.put("SalesOrderID", salesOrderID);
	    		//salesOrderM.put("StatusCodeID", 1);
	    		salesOrderM.put("SyncCheck", 1);
	    		salesOrderM.put("userId", params.get("userId"));
	    		salesOrderM.put("PVMonth", 0);
	    		salesOrderM.put("PVYear", 0);
	    		salesOrderM.put("TotalAmt", rv.get("soExchgOldPrc"));
	    		salesOrderM.put("PromoID", rv.get("soExchgOldPromoId"));
	    		salesOrderM.put("TotalPV", rv.get("soExchgOldPv"));
	    		salesOrderM.put("MthRentAmt", rv.get("soExchgOldRentAmt"));
	    		salesOrderM.put("DefRentAmt", rv.get("soExchgOldRentAmt"));
	    		salesOrderM.put("AppTypeID", applicationTypeID);
	    		salesOrderM.put("SalesDate", salesDt);

	    		updateSalesOrderM2(salesOrderM);


	    		Map<String,Object> salesOrderD = new HashMap();
	    		salesOrderD.put("ItemStkID", rv.get("soExchgOldStkId"));
	    		salesOrderD.put("ItemPriceID", rv.get("soExchgOldPrcId"));
	    		salesOrderD.put("ItemPrice", rv.get("soExchgOldPrc"));
	    		salesOrderD.put("ItemPV", rv.get("soExchgOldPv"));
	    		salesOrderD.put("userId", params.get("userId"));

	    		updateSalesOrderD2(salesOrderD);

	    		updateInstallation(params);

	    		Map<String,Object> callEntry = new HashMap();
	    		callEntry.put("SalesOrderID", salesOrderID);
	    		callEntry.put("TypeID", 258);
	    		callEntry.put("StatusCodeID", 1);
	    		callEntry.put("ResultID", 0);
	    		//callEntry.put("DocID", salesOrderID);
	    		callEntry.put("DocID",  params.get("docId"));
	    		callEntry.put("userId", params.get("userId"));
	    		callEntry.put("CallDate", nextCallDate);
	    		callEntry.put("IsWaitForCancel", 1);
	    		callEntry.put("OriCallDate", nextCallDate);

	    		addCallEntry(callEntry);

	    		int  CallEntryId = getCallEntry(params);

	    		Map<String,Object> callResult = new HashMap();
	    		//callResult.put("CallResultID", 0);
	    		callResult.put("CallEntryID", CallEntryId);
	    		callResult.put("CallStatusID", 1);
	    		callResult.put("CallCallDate", defaultDate);
	    		callResult.put("CallActionDate", defaultDate);
	    		callResult.put("CallFeedBackID", 0);
	    		callResult.put("CallCTID", 0);
	    		callResult.put("CallRemark", remark);
	    		callResult.put("userId", params.get("userId"));
	    		callResult.put("CallCreateByDept", 0);
	    		callResult.put("CallHCID", 0);
	    		callResult.put("CallROSAmt", 0);
	    		callResult.put("CallSMS", 0);
	    		callResult.put("CallSMSRemark", "");

	    		addCallResult(callResult);


	    		Map<String,Object> salesorderLog = new HashMap();
	    		salesorderLog.put("SalesOrderID", salesOrderID);
	    		salesorderLog.put("ProgressID", 2);
	    		salesorderLog.put("RefID", 0);
	    		salesorderLog.put("IsLock", 0);	//true
	    		salesorderLog.put("userId", params.get("userId"));
	    		salesorderLog.put("CallEntryId", CallEntryId);

	    		addSalesorderLog(salesorderLog);





	    		if(Integer.parseInt(params.get("applicationTypeID").toString())==66 || Integer.parseInt(params.get("applicationTypeID").toString())==7759 || Integer.parseInt(params.get("applicationTypeID").toString())==67 || Integer.parseInt(params.get("applicationTypeID").toString())==68){
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
	                	adJEntryReportNo = getDOCNumber(params);
	                	params.put("adJEntryReportNo", adJEntryReportNo);
	                	String adjEntryNoteNo = null;
	                	params.put("docno",15);
	                	adjEntryNoteNo = getDOCNumber(params);
	                	params.put("adjEntryNoteNo", adjEntryNoteNo);

	                	params.put("docNoId",18);
	                	updateDOCNumber(params);
	                	params.put("docNoId",15);
	                	updateDOCNumber(params);

	                	//EgovMap  rv2 = getRequiredView(params);

	                    //params.put("TotalAmt", rv2.get("totAmt"));


	                  //  addAccAdjTransEntry(params);
	                    int adjEntryId = selectLastadjEntryId();

	                    params.put("adjEntryId",adjEntryId);
	                   // addAccAdjTransResult(params);

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

	                    int trxNo = Integer.parseInt(getDOCNumberOnlyNumber().toString());
	                    accTRXPlus.put("TRXNo", trxNo);
	                    accTRXPlus.put("TRXDocNo", adjEntryNoteNo);

	                    //addAccTRXes(accTRXPlus);


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

	                  //  addAccTRXes(accTRXMinus);


	                    if(Integer.parseInt(params.get("applicationTypeID").toString())==66 || Integer.parseInt(params.get("applicationTypeID").toString())==7759){
	                    	logger.debug("-------------17---------------");
	                    	EgovMap  qryPreBill = getQryPreBill(params);
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
	                    		VoidNo = getDOCNumber(params);
	                    		params.put("VoidNo", VoidNo);
	                    		params.put("docNoId",112);
	                         	updateDOCNumber(params);

	                         //	addAccOrderVoid_Invoice(params);

	                         	int AccInvVoidID = getAccInvVoidID();
	                         	params.put("AccInvVoidID",AccInvVoidID);

	                        // 	addAccOrderVoid_Invoice_Sub(params);

	                         //	updateAccOrderBill(params);
	                    	}

	                    	Map<String,Object> accRentLedger = new HashMap();
                         	accRentLedger.put("RentSOID", salesOrderID);
                         	accRentLedger.put("RentDocTypeID", 155);
                         	accRentLedger.put("RentAmount", Integer.parseInt(rv.get("soExchgNwPrc").toString())*-1);
                         //	addAccRentLedger(params);

	                    	//addAccTradeLedger(params);

	                    	//updateRentalScheme(params);

	                    }else{
	                    	logger.debug("-------------19---------------");
	                    	EgovMap  qryPreBill = getQryPreBill_out(params);
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
	                    		VoidNo = getDOCNumber(params);
	                    		params.put("VoidNo", VoidNo);
	                    		params.put("docNoId",112);
	                         	updateDOCNumber(params);

	                         //	addAccOrderVoid_Invoice(params);

	                         	int AccInvVoidID = getAccInvVoidID();
	                         	params.put("AccInvVoidID",AccInvVoidID);

	                         //	addAccOrderVoid_Invoice_Sub(params);

	                       //  	updateAccOrderBill(params);
	                    	}
                         	/*
                         	Map<String,Object> accRentLedger = new HashMap();
                         	accRentLedger.put("RentSOID", salesOrderID);
                         	accRentLedger.put("RentDocTypeID", 155);
                         	accRentLedger.put("RentAmount", Integer.parseInt(rv.get("soExchgNwPrc").toString())*-1);
                         	addAccRentLedger(params);
                         	*/
                         //	addAccTradeLedger(params);
                         	//updateRentalScheme(params);
	                    }
	                }else{
	                	logger.debug("-------------21---------------");
	                	if(Integer.parseInt(params.get("applicationTypeID").toString())==66 || Integer.parseInt(params.get("applicationTypeID").toString())==7759){
	                		logger.debug("-------------22---------------");
	                	}else if(Integer.parseInt(params.get("applicationTypeID").toString())==67 || Integer.parseInt(params.get("applicationTypeID").toString())==67){
	                		logger.debug("-------------23---------------");
	                		List<EgovMap> QryOutSList = getQryOutS(params);
	                		if(QryOutSList.size()>0){
	                			logger.debug("-------------24---------------");
	                			EgovMap  qryAccBill = getQryAccBill(params);
                				params.put("AccBillID",qryAccBill.get("accBillId"));
                				params.put("TaxInvoiceRefNo",qryAccBill.get("taxInvcRefNo"));
                				params.put("TaxInvoiceRefDate",qryAccBill.get("taxInvcRefDt"));
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

                			//	updateAccOrderBill2(params);

                				String cnno = null;
                				params.put("docno",134);
                				cnno = getDOCNumber(params);
                				params.put("cnno", cnno);
                				params.put("adjEntryNoteNo", cnno);
                				params.put("docNoId",134);
                				updateDOCNumber_8Digit(params);

                				String adJEntryReportNo = null;
                				params.put("docno",18);
                				adJEntryReportNo = getDOCNumber(params);
                				params.put("adJEntryReportNo", adJEntryReportNo);
                				params.put("docNoId",18);
                				updateDOCNumber(params);

                				//addAccInvAdjr(params);

                				int MemoAdjustID = getMemoAdjustID();
                				params.put("MemoAdjustID", MemoAdjustID);

                				String AccBillTaxCodeID = null;
                				AccBillTaxCodeID = getAccBillTaxCodeID(params);
                				params.put("AccBillTaxCodeID", AccBillTaxCodeID);

                				int crid = 0;
                                int drid = 0;
                                int conv = Integer.parseInt(qryAccBill.get("accBillAcctCnvr").toString());
                                		//ACC_BILL_ACCT_CNVR;

                                if (conv == 0)
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

                            //    addAccInvoiceAdjustment_Sub(params);

                               // addAccTaxDebitCreditNote(params);

                                int NoteID = getNoteID();
                                params.put("NoteID",NoteID);

                              //  addAccTaxDebitCreditNote_Sub(params);

                                String  VoidNo = null;
                                params.put("docno",112);
                                VoidNo = getDOCNumber(params);
                                params.put("VoidNo", VoidNo);
                                params.put("docNoId",112);
                            	updateDOCNumber(params);

                            //	addAccOrderVoid_Invoice(params);
                            	params.put("adjEntryId",MemoAdjustID);
                            	params.put("TotalAmt",qryAccBill.get("taxInvcAmtDue"));

                            //	addAccOrderVoid_Invoice_Sub(params);
                            //	addAccTradeLedger(params);

                            	//updateAccOrderBill(params);
	                		}
	                	}
	                }
	    		}
			}else{
				logger.debug("-------------25---------------");
				hidPEAfterInstall = "0";

				updateInstallresult(params);
				addInstallresultReverse(InstallresultReverse);
				updateSalesOrderExchange(params);
				updateInstallEntry(params);

				Map<String, Object> srvMembershipSale = new HashMap();
	    		srvMembershipSale.put("SrvMemID", memID);
	    		srvMembershipSale.put("SrvStatusCodeID", '8');
	    		srvMembershipSale.put("userId", params.get("userId"));

	    		updateSrvMembershipSale2(srvMembershipSale);


	    		Map<String, Object> srvConfiguration = new HashMap();
	    		srvConfiguration.put("SrvConfigID", configID);
	    		srvConfiguration.put("SrvStatusID", 8);
	    		srvConfiguration.put("SrvRemark", "INSTALLATION RESULT REVERSAL");
	    		srvConfiguration.put("userId", params.get("userId"));

	    		updateSrvConfiguration(srvConfiguration);


	    		Map<String,Object> srvConfigSetting = new HashMap();
	    		srvConfigSetting.put("SrvConfigID", configID);
	    		srvConfigSetting.put("SrvSettStatusID", 8);
	    		srvConfigSetting.put("SrvSettRemark", "INSTALLATION RESULT REVERSAL");

	    		updateSrvConfigSetting(srvConfigSetting);


	    		Map<String,Object> srvConfigPeriod = new HashMap();
	    		srvConfigPeriod.put("SrvConfigID", configID);
	    		srvConfigPeriod.put("SrvPrdStatusID", 8);
	    		srvConfigPeriod.put("SrvPrdRemark", "INSTALLATION RESULT REVERSAL");
	    		srvConfigPeriod.put("userId", params.get("userId"));

	    		updateSrvConfigPeriod(srvConfigPeriod);


	    		Map<String,Object> srvConfigFilter = new HashMap();
	    		srvConfigFilter.put("SrvConfigID",configID);
	    		srvConfigFilter.put("SrvFilterStatusID",8);
	    		srvConfigFilter.put("SrvFilterRemark","INSTALLATION RESULT REVERSAL");
	    		srvConfigFilter.put("userId",params.get("userId"));

	    		updateSrvConfigFilter(srvConfigFilter);


	    		Map<String,Object> happyCallM = new HashMap();
	    		happyCallM.put("HCID", hcID);
	    		happyCallM.put("HCStatusID", 8);
	    		happyCallM.put("HCRemark", "INSTALLATION RESULT REVERSAL");
	    		happyCallM.put("userId", params.get("userId"));

	    		updateHappyCallM(happyCallM);


	    		EgovMap  rv = getRequiredView2(params);

	    		Map<String,Object> salesOrderM = new HashMap();
	    		salesOrderM.put("SalesOrderID", salesOrderID);
	    		//salesOrderM.put("StatusCodeID", 1);
	    		salesOrderM.put("SyncCheck", 1);
	    		salesOrderM.put("userId", params.get("userId"));
	    		salesOrderM.put("PVMonth", 0);
	    		salesOrderM.put("PVYear", 0);
	    		salesOrderM.put("TotalAmt", rv.get("soExchgOldPrc"));
	    		salesOrderM.put("PromoID", rv.get("soExchgOldPromoId"));
	    		salesOrderM.put("TotalPV", rv.get("soExchgOldPv"));
	    		salesOrderM.put("MthRentAmt", rv.get("soExchgOldRentAmt"));
	    		salesOrderM.put("DefRentAmt", rv.get("soExchgOldRentAmt"));
	    		salesOrderM.put("AppTypeID", applicationTypeID);
	    		salesOrderM.put("SalesDate", salesDt);

	    		updateSalesOrderM2(salesOrderM);


	    		Map<String,Object> salesOrderD = new HashMap();
	    		salesOrderD.put("ItemStkID", rv.get("soExchgOldStkId"));
	    		salesOrderD.put("ItemPriceID", rv.get("soExchgOldPrcId"));
	    		salesOrderD.put("ItemPrice", rv.get("soExchgOldPrc"));
	    		salesOrderD.put("ItemPV", rv.get("soExchgOldPv"));
	    		salesOrderD.put("userId", params.get("userId"));

	    		updateSalesOrderD2(salesOrderD);

	    		updateInstallation(params);

	    		Map<String,Object> callEntry = new HashMap();
	    		callEntry.put("SalesOrderID", salesOrderID);
	    		callEntry.put("TypeID", 258);
	    		callEntry.put("StatusCodeID", 1);
	    		callEntry.put("ResultID", 0);
	    		//callEntry.put("DocID", salesOrderID);
	    		callEntry.put("DocID", orderExchangeTypeByInstallEntryID.get("docId")); // Hui Ding - change to use DOC_ID as this is the linkage to SAL0004D, 2021-07-29
	    		callEntry.put("userId", params.get("userId"));
	    		callEntry.put("CallDate", nextCallDate);
	    		callEntry.put("IsWaitForCancel", 1);
	    		callEntry.put("OriCallDate", nextCallDate);

	    		addCallEntry(callEntry);


	    		int  CallEntryId = getCallEntry(params);

	    		Map<String,Object> callResult = new HashMap();
	    		//callResult.put("CallResultID", 0);
	    		callResult.put("CallEntryID", CallEntryId);
	    		callResult.put("CallStatusID", 1);
	    		callResult.put("CallCallDate", defaultDate);
	    		callResult.put("CallActionDate", defaultDate);
	    		callResult.put("CallFeedBackID", 0);
	    		callResult.put("CallCTID", 0);
	    		callResult.put("CallRemark", remark);
	    		callResult.put("userId", params.get("userId"));
	    		callResult.put("CallCreateByDept", 0);
	    		callResult.put("CallHCID", 0);
	    		callResult.put("CallROSAmt", 0);
	    		callResult.put("CallSMS", 0);
	    		callResult.put("CallSMSRemark", "");

	    		addCallResult(callResult);


	    		Map<String,Object> salesorderLog = new HashMap();
	    		salesorderLog.put("SalesOrderID", salesOrderID);
	    		salesorderLog.put("ProgressID", 3);
	    		salesorderLog.put("RefID", 0);
	    		salesorderLog.put("IsLock", 0);	//true
	    		salesorderLog.put("userId", params.get("userId"));
	    		salesorderLog.put("CallEntryId", CallEntryId);

	    		addSalesorderLog(salesorderLog);


	    		if(Integer.parseInt(params.get("applicationTypeID").toString())==66 || Integer.parseInt(params.get("applicationTypeID").toString())==7759 || Integer.parseInt(params.get("applicationTypeID").toString())==67 || Integer.parseInt(params.get("applicationTypeID").toString())==68){
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

	                SimpleDateFormat format = new SimpleDateFormat("yyyy/MM/dd");

	                String esalesDt = params.get("esalesDt").toString();

	                Date salesdate = null;
	                Date mthapril = null;

	                mthapril =  format.parse("2015/04/01");
	                salesdate = format.parse(esalesDt);

	                if (salesdate.compareTo(mthapril)<0){
	                	logger.debug("-------------27---------------");
	                	String adJEntryReportNo = null;
	                	params.put("docno",18);
	                	adJEntryReportNo = getDOCNumber(params);
	                	params.put("adJEntryReportNo", adJEntryReportNo);
	                	String adjEntryNoteNo = null;
	                	params.put("docno",15);
	                	adjEntryNoteNo = getDOCNumber(params);
	                	params.put("adjEntryNoteNo", adjEntryNoteNo);

	                	params.put("docNoId",18);
	                	updateDOCNumber(params);
	                	params.put("docNoId",15);
	                	updateDOCNumber(params);

	                	//addAccAdjTransEntry(params);
	                    int adjEntryId = selectLastadjEntryId();

	                    params.put("adjEntryId",adjEntryId);
	                    //addAccAdjTransResult(params);

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

	                    int trxNo = Integer.parseInt(getDOCNumberOnlyNumber().toString());
	                    accTRXPlus.put("TRXNo", trxNo);
	                    accTRXPlus.put("TRXDocNo", adjEntryNoteNo);

	                   // addAccTRXes(accTRXPlus);


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

	                //    addAccTRXes(accTRXMinus);

	                    if(Integer.parseInt(params.get("applicationTypeID").toString())==66 || Integer.parseInt(params.get("applicationTypeID").toString())==7759){
	                    	logger.debug("-------------28---------------");
	                    	EgovMap  qryPreBill = getQryPreBill(params);
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
	                    		VoidNo = getDOCNumber(params);
	                    		params.put("VoidNo", VoidNo);
	                    		params.put("docNoId",112);
	                         	updateDOCNumber(params);

	                         	//addAccOrderVoid_Invoice(params);

	                         	int AccInvVoidID = getAccInvVoidID();
	                         	params.put("AccInvVoidID",AccInvVoidID);

	                         	//addAccOrderVoid_Invoice_Sub(params);

	                         	//updateAccOrderBill(params);
	                    	}

	                    	Map<String,Object> accRentLedger = new HashMap();
                         	accRentLedger.put("RentSOID", salesOrderID);
                         	accRentLedger.put("RentDocTypeID", 155);
                         	accRentLedger.put("RentAmount", Integer.parseInt(rv.get("soExchgNwPrc").toString())*-1);
                         	//addAccRentLedger(params);

                         	updateRentalScheme(params);
	                    }else{
	                    	logger.debug("-------------30---------------");
	                    	EgovMap  qryPreBill = getQryPreBill_out(params);
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
	                    		VoidNo = getDOCNumber(params);
	                    		params.put("VoidNo", VoidNo);
	                    		params.put("docNoId",112);
	                         	updateDOCNumber(params);

	                         //	addAccOrderVoid_Invoice(params);

	                         	int AccInvVoidID = getAccInvVoidID();
	                         	params.put("AccInvVoidID",AccInvVoidID);

	                         //	addAccOrderVoid_Invoice_Sub(params);

	                         //	updateAccOrderBill(params);
	                    	}
	                    	Map<String,Object> accRentLedger = new HashMap();
                         	accRentLedger.put("RentSOID", salesOrderID);
                         	accRentLedger.put("RentDocTypeID", 155);
                         	accRentLedger.put("RentAmount", Integer.parseInt(rv.get("soExchgNwPrc").toString())*-1);
                         	//addAccRentLedger(params);
	                    }
	                }else{
	                	logger.debug("-------------32---------------");
	                	if(Integer.parseInt(params.get("applicationTypeID").toString())==66 || Integer.parseInt(params.get("applicationTypeID").toString())==7759){
	                		logger.debug("-------------33---------------");
	                	}else if(Integer.parseInt(params.get("applicationTypeID").toString())==67 || Integer.parseInt(params.get("applicationTypeID").toString())==67){
	                		logger.debug("-------------34---------------");
	                		List<EgovMap> QryOutSList = getQryOutS(params);
	                		if(QryOutSList.size()>0){
	                			logger.debug("-------------35---------------");
	                			EgovMap  qryAccBill = getQryAccBill(params);
                				params.put("AccBillID",qryAccBill.get("accBillId"));
                				params.put("TaxInvoiceRefNo",qryAccBill.get("taxInvcRefNo"));
                				params.put("TaxInvoiceRefDate",qryAccBill.get("taxInvcRefDt"));
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

                				//updateAccOrderBill2(params);

                				String cnno = null;
                				params.put("docno",134);
                				cnno = getDOCNumber(params);
                				params.put("cnno", cnno);
                				params.put("adjEntryNoteNo", cnno);
                				params.put("docNoId",134);
                				updateDOCNumber_8Digit(params);

                				String adJEntryReportNo = null;
                				params.put("docno",18);
                				adJEntryReportNo = getDOCNumber(params);
                				params.put("adJEntryReportNo", adJEntryReportNo);
                				params.put("docNoId",18);
                				updateDOCNumber(params);

                				//addAccInvAdjr(params);

                				int MemoAdjustID = getMemoAdjustID();
                				params.put("MemoAdjustID", MemoAdjustID);

                				String AccBillTaxCodeID = null;
                				AccBillTaxCodeID = getAccBillTaxCodeID(params);
                				params.put("AccBillTaxCodeID", AccBillTaxCodeID);

                				int crid = 0;
                                int drid = 0;
                                int conv = Integer.parseInt(qryAccBill.get("accBillAcctCnvr").toString());
                                		//ACC_BILL_ACCT_CNVR;

                                if (conv == 0)
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

                                //addAccInvoiceAdjustment_Sub(params);

                               // addAccTaxDebitCreditNote(params);

                                int NoteID = getNoteID();
                                params.put("NoteID",NoteID);

                               // addAccTaxDebitCreditNote_Sub(params);

                                String  VoidNo = null;
                                params.put("docno",112);
                                VoidNo = getDOCNumber(params);
                                params.put("VoidNo", VoidNo);
                                params.put("docNoId",112);
                            	updateDOCNumber(params);

                            	//addAccOrderVoid_Invoice(params);
                            	params.put("adjEntryId",MemoAdjustID);
                            	params.put("TotalAmt",qryAccBill.get("taxInvcAmtDue"));

                            //	addAccOrderVoid_Invoice_Sub(params);

                            	//addAccTradeLedger(params);

	                		}
	                	}
	                }
	    		}
			}
		}

		// KR-OHK Barcode Save Start
		if("Y".equals(params.get("hidSerialRequireChkYn"))) {
    		Map<String, Object> setmap = new HashMap();
            setmap.put("serialNo", params.get("hidSerialNo"));
            setmap.put("salesOrdId", params.get("hidSalesOrderId"));
            setmap.put("reqstNo", params.get("hidInstallEntryNo"));
            setmap.put("callGbn", "INSTALL_REVERSE");
            setmap.put("mobileYn", "N");
            setmap.put("userId", params.get("userId"));

            servicesLogisticsPFCMapper.SP_SVC_BARCODE_SAVE(setmap);

            String errCode = (String)setmap.get("pErrcode");
        	String errMsg = (String)setmap.get("pErrmsg");

         	logger.debug(">>>>>>>>>>>SP_SVC_BARCODE_SAVE ERROR CODE : " + errCode);
        	logger.debug(">>>>>>>>>>>SP_SVC_BARCODE_SAVE ERROR MSG: " + errMsg);

        	// pErrcode : 000  = Success, others = Fail
        	if(!"000".equals(errCode)){
        		throw new ApplicationException(AppConstants.FAIL, "[ERROR]" + errCode + ":" + errMsg);
        	}
		}
		// KR-OHK Barcode Save Start
	}


}
