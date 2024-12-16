package com.coway.trust.biz.services.bs.impl;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.impl.CommonMapper;
import com.coway.trust.biz.logistics.returnusedparts.ReturnUsedPartsService;
import com.coway.trust.biz.payment.invoice.service.impl.InvoiceAdjMapper;
import com.coway.trust.biz.sales.order.impl.OrderRegisterMapper;
import com.coway.trust.biz.services.as.impl.ServicesLogisticsPFCMapper;
import com.coway.trust.biz.services.bs.HsManualService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.organization.organization.MemberEventListController;
import com.coway.trust.web.sales.SalesConstants;
import com.ibm.icu.util.StringTokenizer;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

@Service("hsManualService")
public class HsManualServiceImpl extends EgovAbstractServiceImpl implements HsManualService {

  private static final Logger logger = LoggerFactory.getLogger(MemberEventListController.class);

  @Value("${app.name}")
  private String appName;

  @Resource(name = "commonMapper")
  private CommonMapper commonMapper;

  @Resource(name = "hsManualMapper")
  private HsManualMapper hsManualMapper;

  @Resource(name = "returnUsedPartsService")
  private ReturnUsedPartsService returnUsedPartsService;

  @Resource(name = "servicesLogisticsPFCMapper")
  private ServicesLogisticsPFCMapper servicesLogisticsPFCMapper;

  @Resource(name = "invoiceAdjMapper")
  private InvoiceAdjMapper invoiceMapper;

  @Resource(name = "orderRegisterMapper")
  private OrderRegisterMapper orderRegisterMapper;

  @Autowired
  private MessageSourceAccessor messageSourceAccessor;

  @Override
  public List<EgovMap> selectHsConfigList(Map<String, Object> params) {
    // TODO Auto-generated method stub

    if (params.get("ManuaMyBSMonth") != null) {
      StringTokenizer str1 = new StringTokenizer(params.get("ManuaMyBSMonth").toString());

      for (int i = 0; i <= 1; i++) {
        str1.hasMoreElements();
        String result = str1.nextToken("/"); // 특정문자로 자를시 사용

        logger.debug("iiiii: {}", i);

        if (i == 0) {
          params.put("myBSMonth", result);
          logger.debug("myBSMonth : {}", params.get("myBSMonth"));
        } else {
          params.put("myBSYear", result);
          logger.debug("myBSYear : {}", params.get("myBSYear"));
        }
      }

    }

    logger.debug("myBSMonth : {}", params.get("myBSMonth"));
    logger.debug("saleOrdListSp : {}", params.get("saleOrdListSp"));
    logger.debug("ManualCustId : {}", params.get("ManualCustId"));

    return hsManualMapper.selectHsConfigList(params);
  }

  @Override
  public List<EgovMap> selectHsManualList(Map<String, Object> params) {
    // TODO Auto-generated method stub
    if (params.get("ManuaMyBSMonth") != null) {
      if (!params.get("ManuaMyBSMonth").toString().equals("")) {
        StringTokenizer str1 = new StringTokenizer(params.get("ManuaMyBSMonth").toString());
        for (int i = 0; i <= 1; i++) {
          str1.hasMoreElements();
          String result = str1.nextToken("/");
          if (i == 0) {
            params.put("myBSMonth", result);
            logger.debug("myBSMonth : {}", params.get("myBSMonth"));
          } else {
            params.put("myBSYear", result);
            logger.debug("myBSYear : {}", params.get("myBSYear"));
          }
        }
      }
    }

    logger.debug("myBSMonth : {}", params.get("myBSMonth"));
    logger.debug("saleOrdListSp : {}", params.get("saleOrdListSp"));
    logger.debug("ManualCustId : {}", params.get("ManualCustId"));

    return hsManualMapper.selectHsManualList(params);
  }

  @Override
  public List<EgovMap> selectHsAssiinlList(Map<String, Object> params) {
    // TODO Auto-generated method stub
    logger.debug("myBSMonth : {}", params.get("myBSMonth"));
    StringTokenizer str1 = new StringTokenizer(params.get("myBSMonth").toString());
    logger.debug("myBSMonth : {}", params.get("myBSMonth"));

    return hsManualMapper.selectHsAssiinlList(params);
  }

  @Override
  public List<EgovMap> selectBranchList(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return hsManualMapper.selectBranchList(params);
  }

  @Override
  public List<EgovMap> selectCtList(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return hsManualMapper.selectCtList(params);
  }

  @Override
  public List<EgovMap> getCdUpMemList(Map<String, Object> params) {
    // TODO Auto-generated method stub
    params.put("memLvl", 3);
    return hsManualMapper.getCdUpMemList(params);
  }

  @Override
  public List<EgovMap> getCdDeptList(Map<String, Object> params) {
    // TODO Auto-generated method stub
    params.put("memLvl", 3);
    return hsManualMapper.getCdDeptList(params);
  }

  /*
   * BY KV - Change to textBox - txtcodyCode and below code no more used.
   *
   * @Override public List<EgovMap> getCdList(Map<String, Object> params) { //
   * TODO Auto-generated method stub params.put("memLvl", 4); return
   * hsManualMapper.getCdUpMemList(params); }
   */

  @Override
  public List<EgovMap> getCdList_1(Map<String, Object> params) {
    // TODO Auto-generated method stub
    params.put("memLvl", 3);
    return hsManualMapper.getCdList_1(params);
  }

  @Override
  public List<EgovMap> selectHsManualListPop(Map<String, Object> params) {
    // TODO Auto-generated method stub

    if (params.get("ManuaMyBSMonth") != null) {
      StringTokenizer str1 = new StringTokenizer(params.get("ManuaMyBSMonth").toString());

      for (int i = 0; i <= 1; i++) {
        str1.hasMoreElements();
        String result = str1.nextToken("/"); // 특정문자로 자를시 사용

        logger.debug("iiiii: {}", i);

        if (i == 0) {
          params.put("myBSMonth", result);
          logger.debug("myBSMonth : {}", params.get("myBSMonth"));
        } else {
          params.put("myBSYear", result);
          logger.debug("myBSYear : {}", params.get("myBSYear"));
        }
      }

    }

    logger.debug("myBSMonth : {}", params.get("myBSMonth"));
    logger.debug("saleOrdListSp : {}", params.get("saleOrdListSp"));
    logger.debug("ManualCustId : {}", params.get("ManualCustId"));

    return hsManualMapper.selectHsManualListPop(params);
  }

  public Map<String, Object> insertHsResult(Map<String, Object> params, List<Object> docType, SessionVO sessionVO) {

    Boolean success = false;

    String appId = "";
    String saveDocNo = "";
    Map<String, Object> codeMap1 = new HashMap<String, Object>();
    Map<String, Object> MemApp = new HashMap<String, Object>();
    Map<String, Object> resultValue = new HashMap<String, Object>();

    for (int i = 0; i < docType.size(); i++) {
      // for(Object obj : docType){

      Map<String, Object> docSub = (Map<String, Object>) docType.get(i);

      int fomSalesOrdNo = Integer.parseInt((String) docSub.get("salesOrdNo"));
      // int nextSchId = (int) docSub.get("salesOrdNo");
      int nextSchId = hsManualMapper.getNextSchdulId();
      String docNo = commonMapper.selectDocNo("10");

      if (docSub.get("year") != null) {
        StringTokenizer str1 = new StringTokenizer(docSub.get("year").toString());

        for (int k = 0; k <= 1; k++) {
          str1.hasMoreElements();
          String result = str1.nextToken("/"); // 특정문자로 자를시 사용

          logger.debug("iiiii: {}", i);

          if (k == 0) {
            docSub.put("myBSMonth", result);
            logger.debug("myBSMonth : {}", params.get("myBSMonth"));
          } else {
            docSub.put("myBSYear", result);
            logger.debug("myBSYear : {}", params.get("myBSYear"));
          }
        }

      }
      logger.debug("docSub : " + docSub);
      docSub.put("no", docNo);
      docSub.put("schdulId", nextSchId);
      docSub.put("salesOrdId", docSub.get("salesOrdId"));
      docSub.put("resultID", 0);
      // hsResult.put("custId", (params.get("custId").toString()));
      docSub.put("salesOrdNo", String.format("%08d", fomSalesOrdNo));
      docSub.put("month", docSub.get("myBSMonth"));
      docSub.put("year", docSub.get("myBSYear"));
      docSub.put("typeId", "438");
      docSub.put("stus", docSub.get("stus"));
      docSub.put("lok", "4");
      docSub.put("lastSvc", "0");
      docSub.put("codyId", docSub.get("codyId"));
      docSub.put("creator", sessionVO.getUserId());
      docSub.put("created", new Date());

      hsManualMapper.insertHsResult(docSub);
      // hsManualMapper.insertHsResult((Map<String, Object>)obj);

      saveDocNo += docNo;

      if (docType.size() > 1 && docType.size() > i) {
        saveDocNo += ",";
      }

      resultValue.put("docNo", saveDocNo);
    }

    success = true;
    // hsManualMapper.insertHsResult(MemApp);

    return resultValue;
  }

  private boolean Save(boolean isfreepromo, Map<String, Object> params, SessionVO sessionVO) throws ParseException {

    String appId = "";
    Map<String, Object> codeMap1 = new HashMap<String, Object>();
    Map<String, Object> MemApp = new HashMap<String, Object>();

    hsManualMapper.insertHsResult(MemApp);

    insertHs(MemApp);

    return true;
  }

  @Transactional
  private boolean insertHs(Map<String, Object> hsResult) throws ParseException {

    String appId = "";
    Map<String, Object> codeMap1 = new HashMap<String, Object>();
    Map<String, Object> MemApp = new HashMap<String, Object>();

    hsManualMapper.insertHsResult(MemApp);
    return true;
  }

  @Override
  public EgovMap selectHsInitDetailPop(Map<String, Object> params) {
    // TODO Auto-generated method stub

    return hsManualMapper.selectHsInitDetailPop(params);
  }

  @Override
  @Transactional
  public Map<String, Object> addIHsResult(Map<String, Object> params, List<Object> docType, SessionVO sessionVO)
      throws Exception {

    Map<String, Object> resultValue = new HashMap<String, Object>();

    resultValue = SaveResult(true, params, docType, sessionVO);

    // logs(물류) call
    ///////////////////////// 물류 호출//////////////////////
    // String str = params.get("serviceNo").toString();
    // returnUsedPartsService.returnPartsInsert(str);
    ///////////////////////// 물류 호출 end /////////////////

    return resultValue;
  }

  public String getNextDocNo(String prefixNo, String docNo) {
    String nextDocNo = "";
    int docNoLength = 0;
    System.out.println("!!!" + prefixNo);
    if (prefixNo != null && prefixNo != "") {
      docNoLength = docNo.replace(prefixNo, "").length();
      docNo = docNo.replace(prefixNo, "");
    } else {
      docNoLength = docNo.length();
    }

    int nextNo = Integer.parseInt(docNo) + 1;
    nextDocNo = String.format("%0" + docNoLength + "d", nextNo);
    logger.debug("nextDocNo : {}", nextDocNo);
    return nextDocNo;
  }

  private Map<String, Object> SaveResult(boolean isfreepromo, Map<String, Object> params, List<Object> docType,
      SessionVO sessionVO) {

    logger.debug("=========================SaveResult - START - ===============================");

    logger.debug("*****PARAMSSSSS:***** "+ params.toString()) ;

    int schdulId = Integer.parseInt(params.get("hidschdulId").toString());
    String docNo = commonMapper.selectDocNo("11");
    int masterCnt = hsManualMapper.selectHSResultMCnt(params);
    int nextSeq = hsManualMapper.getNextSvc006dSeq();

    // EgovMap selectDetailList = hsManualMapper.selectDetailList(params);
    // EgovMap selectHSResultMList = hsManualMapper.selectHSResultMList(params);
    // EgovMap selectHSDocNoList = hsManualMapper.selectHSDocNoList(params);
    // String resultNo =
    // selectHSDocNoList.get("c2").toString()+selectHSDocNoList.get("c1").toString();

    EgovMap insertHsResultfinal = new EgovMap();
    String LOG_SVC0008D_NO = "";
    LOG_SVC0008D_NO = (String) hsManualMapper.getSVC008D_NO(params);

    if (masterCnt > 0) {
      params.put("resultId", nextSeq);
      hsManualMapper.insertHsResultCopy(params);
    } else {
      params.put("resultId", nextSeq);

      // String nextDocNo =
      // getNextDocNo(selectHSDocNoList.get("c2").toString(),selectHSDocNoList.get("c1").toString());
      // logger.debug("nextDocNo : {}",nextDocNo);
      // EgovMap docNoM = new EgovMap();
      // docNoM.put("nextDocNo", nextDocNo);
      // hsManualMapper.updateDocNo(docNoM);

      logger.debug("= Next Sequence : {}", nextSeq);
      logger.debug("= Param : {}", params);

      int status = 0;
      status = Integer.parseInt(params.get("cmbStatusType").toString());

      insertHsResultfinal.put("resultId", nextSeq);
      insertHsResultfinal.put("docNo", docNo);
      insertHsResultfinal.put("typeId", 306);
      insertHsResultfinal.put("schdulId", schdulId);
      insertHsResultfinal.put("salesOrdId", params.get("hidSalesOrdId"));
      insertHsResultfinal.put("codyId", params.get("hidCodyId"));
      // insertHsResultfinal.put("setlDt", params.get("settleDate"));

      // SET DEFAULT AS 01/01/1900 IF SETTLE DATE ARE EMPTY
      if (params.get("settleDate") != null || params.get("settleDate") != "") {
        insertHsResultfinal.put("setlDt", String.valueOf(params.get("settleDate")));
      } else {
        insertHsResultfinal.put("setlDt", "01/01/1900");
      }

      insertHsResultfinal.put("resultStusCodeId", params.get("cmbStatusType"));
      insertHsResultfinal.put("failResnId", params.get("failReason"));
      insertHsResultfinal.put("renColctId", params.get("cmbCollectType"));

      /*
       * if (status == 4) { // COMPLETED insertHsResultfinal.put("failResnId",
       * 0); } else if (status == 21 || status == 10) { // FAIL & CANCELLED
       * insertHsResultfinal.put("failResnId", params.get("failReason")); }
       */

//      if (status == 4) { // COMPLETE
//        insertHsResultfinal.put("renColctId", params.get("cmbCollectType"));
//      } else if (status == 21 || status == 10) { // FAIL & CANCELLED
//        insertHsResultfinal.put("renColctId", params.get("cmbCollectType"));
//      }

      LocalDate currentDate = LocalDate.now();
      LocalDate defaultNextAppntDt = currentDate;
      if(status == SalesConstants.STATUS_FAILED){
        defaultNextAppntDt = currentDate.withDayOfMonth(5).plusMonths(1);
      }else if(status == SalesConstants.STATUS_CANCELLED) {
        defaultNextAppntDt = currentDate.withDayOfMonth(5).plusMonths(2);
      }else{
         // DO NOTHING
      }

      DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyyMMdd");

      insertHsResultfinal.put("whId", params.get("wareHouse"));
      insertHsResultfinal.put("resultRem", params.get("remark"));
      insertHsResultfinal.put("resultCrtUserId", sessionVO.getUserId());
      insertHsResultfinal.put("resultUpdUserId", sessionVO.getUserId());
      // insertHsResultfinal.put("resultCrtDt", SYSDATE);
      // insertHsResultfinal.put("resultUpdDt", SYSDATE);

      insertHsResultfinal.put("resultIsSync", '0');
      insertHsResultfinal.put("resultIsEdit", '0');
      insertHsResultfinal.put("resultStockUse", '1');
      insertHsResultfinal.put("resultIsCurr", '1');
      insertHsResultfinal.put("resultMtchId", '0');
      insertHsResultfinal.put("resultIsAdj", '0');

      // FOR MOBILE APPS DATA
      insertHsResultfinal.put("temperateSetng", params.get("temperateSetng"));
      insertHsResultfinal.put("nextAppntDt", status == SalesConstants.STATUS_COMPLETED ? params.get("nextAppntDt") : dateFormatter.format(defaultNextAppntDt));
      insertHsResultfinal.put("nextAppointmentTime", status == SalesConstants.STATUS_COMPLETED ? params.get("nextAppointmentTime") : "0900");
      insertHsResultfinal.put("ownerCode", params.get("ownerCode"));
      insertHsResultfinal.put("resultCustName", params.get("resultCustName"));
      insertHsResultfinal.put("resultMobileNo", params.get("resultMobileNo"));
      insertHsResultfinal.put("resultRptEmailNo", params.get("resultRptEmailNo"));
      insertHsResultfinal.put("resultAceptName", params.get("resultAceptName"));
      insertHsResultfinal.put("sgnDt", params.get("sgnDt"));

      insertHsResultfinal.put("instChklstCheckBox", params.get("instChklstCheckBox"));
      insertHsResultfinal.put("codeFailRemark", params.get("codeFailRemark"));
      insertHsResultfinal.put("voucherRedemption", params.get("voucherRedemption"));
      insertHsResultfinal.put("switchChkLst", params.get("switchChkLst"));

      logger.debug("= INSERT SVC0006D START : {}", insertHsResultfinal);
      hsManualMapper.insertHsResultfinal(insertHsResultfinal); // INSERT  SVC0006D

      List<EgovMap> qryUsedFilter = hsManualMapper.selectQryUsedFilter2(insertHsResultfinal);

      logger.debug("= LOOP ITEM : {}", docType.size());

      for (int i = 0; i < docType.size(); i++) {
        Map<String, Object> docSub = (Map<String, Object>) docType.get(i);

        	// logger.info("#### addList: " + docSub.get("stkDesc").toString());

            docSub.put("bsResultId", nextSeq);
            docSub.put("bsResultPartId", docSub.get("stkId"));
            docSub.put("bsResultPartDesc", docSub.get("stkDesc"));
            docSub.put("bsResultPartQty", docSub.get("name"));
            docSub.put("bsResultRem", "");
            docSub.put("bsResultCrtUserId", sessionVO.getUserId());
            docSub.put("bsResultFilterClm", docSub.get("name"));
            //docSub.put("serialNo", docSub.get("filterBarcdSerialNo"));
            String srcform = params.get("srcform") == null ? "" : params.get("srcform").toString();
            if(srcform.equals("WEB")){
            	docSub.put("filterBarcdNewSerialNo",docSub.get("serialNo"));
            }else{
            	docSub.put("oldSerialNo", docSub.get("filterBarcdSerialNoOld"));
            	docSub.put("serialNo", docSub.get("filterBarcdNewSerialNo"));
            	docSub.put("filterSerialUnmatchReason", docSub.get("filterSerialUnmatchReason"));
            }
            // docSub.put("bsResultCrtDt");
            // Map<String, Object> docSub2 = (Map<String, Object>)
            // insertHsResultfinal.get(i);

            EgovMap docSub2 = new EgovMap();
            Map<String, Object> docSub3 = (Map<String, Object>) docType.get(i);
            int custId = hsManualMapper.selectCustomer(params);
            int codyId = hsManualMapper.selectCody(params);
            params.put("bsResultId", nextSeq);

            // String serialNo = hsManualMapper.selectSerialNo(params);

            docSub2.put("hsNo", LOG_SVC0008D_NO);
            docSub2.put("custId", custId);
            docSub2.put("bsResultPartId", docSub3.get("stkId"));
            docSub2.put("bsResultPartQty", docSub3.get("name"));
            docSub2.put("serialNo", docSub3.get("serialNo"));
            docSub2.put("bsCodyId", codyId);
            docSub2.put("bsResultId", nextSeq);
            docSub2.put("oldSerialNo", docSub3.get("filterBarcdSerialNoOld"));

            // docSub2.put("bsResultCrtDt");

            String vstkId = String.valueOf(docSub.get("stkId"));
            String filterBarcdSerialNoOld = String.valueOf(docSub.get("filterBarcdSerialNoOld"));
            String filterBarcdNewSerialNo = String.valueOf(docSub.get("filterBarcdNewSerialNo"));
            String filterBarcdNewSerialNoWeb = String.valueOf(docSub.get("serialNo"));
            logger.debug("= STOCK ID : {}", vstkId);
            logger.debug("= filterBarcdSerialNoOld : {}", filterBarcdSerialNoOld);
            logger.debug("= filterBarcdNewSerialNo : {}", filterBarcdNewSerialNo);

            /*
             * String filterLastserial = hsManualMapper.select0087DFilter(docSub);
             *
             * if("".equals(filterLastserial)){ docSub.put("prvSerialNo",
             * filterLastserial); }else { docSub.put("lastSerialNo",
             * docSub.get("SerialNo")); }
             *
             * docSub.put("settleDate", params.get("settleDate"));
             * docSub.put("hidCodyId", params.get("hidCodyId"));
             * params.put("srvConfigId", docSub.get("srvConfigId"));
             *
             * hsManualMapper.updateHsFilterSiriNo(docSub);
             */

            if (!"".equals(vstkId) && !("null").equals(vstkId) && vstkId != null) {
              logger.debug("= INSERT SVC0007D VIA docSub: {}", docSub);
              hsManualMapper.insertHsResultD(docSub); // INSERT SVC0007D
              logger.debug("= INSERT LOG0082M VIA docSub2: {}", docSub2);
              hsManualMapper.insertUsedFilter(docSub2); // INSERT LOG0082M

              docSub.put("hidOrdId", params.get("hidSalesOrdId"));

              String filterLastserial = "";

              if (!CommonUtils.nvl(docSub.get("srvFilterId")).equals("")) {
                filterLastserial = hsManualMapper.select0087DFilter(docSub);
              } else {
                filterLastserial = hsManualMapper.select0087DFilter2(docSub);
              }

              /*
               * if ("".equals(filterLastserial)) { docSub.put("prvSerialNo",
               * filterLastserial); } else { docSub.put("lastSerialNo",
               * docSub.get("serialNo")); }
               */

              docSub.put("prvSerialNo", CommonUtils.nvl(filterLastserial));
              docSub.put("lastSerialNo", CommonUtils.nvl(docSub.get("serialNo")));
              docSub.put("settleDate", params.get("settleDate"));
              docSub.put("hidCodyId", params.get("hidCodyId"));
              params.put("srvConfigId", docSub.get("srvConfigId"));

              if (!CommonUtils.nvl(docSub.get("srvFilterId")).equals("")) {
                hsManualMapper.updateHsFilterSiriNo(docSub); // UPDATE SAL0087D
              } else {
                hsManualMapper.updateHsFilterSiriNo2(docSub); // UPDATE SAL0087D
              }

              //April 2022 start - HLTANG - filter barcode scanner - update log0100m after serial has been used
              if (!"".equals(filterBarcdNewSerialNo) && !("null").equals(filterBarcdNewSerialNo) && filterBarcdNewSerialNo != null) {
            	  Map<String, Object> filter = new HashMap<String, Object>();
            	  filter.put("serialNo", filterBarcdNewSerialNo);
            	  filter.put("salesOrdId", params.get("hidSalesOrdId"));
            	  if(srcform.equals("WEB")){
            		  filter.put("serviceNo", params.get("hidSalesOrdCd"));
            	  }else{
            		  filter.put("serviceNo", params.get("serviceNo"));
            	  }
            	  int LocationID_Rev = 0;
                  if (Integer.parseInt(params.get("hidCodyId").toString()) != 0) {
                	  filter.put("codyId", params.get("hidCodyId"));
                	  LocationID_Rev = hsManualMapper.getMobileWarehouseByMemID(filter);
                  }

                  filter.put("lastLocId", LocationID_Rev);
                  int filterCnt = hsManualMapper.selectFilterSerial(filter);
            	  if (filterCnt == 0) {
          	        throw new ApplicationException(AppConstants.FAIL, "[ERROR]" + "HS Result Error : Cody did not have this serial on hand "+ filter.get("serialNo").toString());
          	      }

            	  hsManualMapper.updateHsFilterSerial(filter);
              }
              //April 2022 end - HLTANG
            }
          }

      hsManualMapper.updateHs009d(params); // UPDATE SAL0090D
    }

   /* if (params.get("instruction") != null && params.get("instruction") != ""){
    	Map<String, Object> instructionParams = new HashMap<String, Object>();
    	instructionParams.put("instruction", params.get("instruction").toString().trim());
    	instructionParams.put("hidSalesOrdId", params.get("hidSalesOrdId"));
    	//hsManualMapper.updateHs009d(instructionParams); // UPDATE SAL0090D to set latest instruction.
    	hsManualMapper.updateHsIns(instructionParams); // UPDATE SAL0090D to set latest instruction.
    }*/

    EgovMap getHsResultMList = hsManualMapper.selectHSResultMList(params); // GET
                                                                           // SVC0006D
    int scheduleCnt = hsManualMapper.selectHSScheduleMCnt(params);

    if (scheduleCnt > 0) {
      EgovMap insertHsScheduleM = new EgovMap();

      insertHsScheduleM.put("hidschdulId", params.get("hidschdulId"));
      insertHsScheduleM.put("resultStusCodeId", params.get("cmbStatusType"));
      insertHsScheduleM.put("actnMemId", getHsResultMList.get("codyId"));

      hsManualMapper.updateHsScheduleM(insertHsScheduleM); // UPDATE SVC0008D
    }

    EgovMap srvConfiguration = hsManualMapper.selectSrvConfiguration(params);

    if (srvConfiguration.size() > 0) {
      if (getHsResultMList.get("resultStusCodeId").toString().equals("4")) {
        // COMPLETE
        // qryConfig.SrvRemark = bsInstruction;
        // qryConfig.SrvPreviousDate = bsResultMas.SettleDate;
        // qryConfig.SrvBSWeek = bsPreferWeek;
        // entity.SaveChanges();

        EgovMap insertHsSrvConfigM = new EgovMap();
        insertHsSrvConfigM.put("salesOrdId", getHsResultMList.get("salesOrdId"));
        insertHsSrvConfigM.put("srvRem", params.get("instruction"));
        insertHsSrvConfigM.put("srvPrevDt", params.get("settleDate"));
        insertHsSrvConfigM.put("srvBsWeek", params.get("srvBsWeek"));

        logger.debug("*** Service No: **** " + params.get("serviceNo"));
        logger.debug("***  hidSalesOrdCd: **** " + params.get("hidSalesOrdCd"));

        EgovMap callMas = new EgovMap();
        callMas.put("hcsoid", getHsResultMList.get("salesOrdId"));
        callMas.put("hcTypeNo", params.get("hidSalesOrdCd") !=null ? params.get("hidSalesOrdCd") : params.get("serviceNo")); // Edited by Hui Ding for solving Happy Call Survey issue. 08/08/2024
        callMas.put("crtUserId", sessionVO.getUserId());
        callMas.put("updUserId", sessionVO.getUserId());
        // callMas.put("hcTypeNo", params.get("serviceNo") );

        hsManualMapper.insertCcr0001d(callMas);

        // hsManualMapper.updateHsSrvConfigM(insertHsSrvConfigM);
        // HappyCallM callMas = new HappyCallM();
        // callMas.HCID = 0;
        // callMas.HCSOID = bsResultMas.SalesOrderId;
        // callMas.HCCallEntryID = 0;
        // callMas.HCTypeNo = qrySchedule.No;
        // callMas.HCTypeID = 509;
        // callMas.HCStatusID = 33;
        // callMas.HCRemark = "";
        // callMas.HCCommentDID = 0;
        // callMas.HCCommentGID = 0;
        // callMas.HCCommentSID = 0;
        // callMas.HCCommentDID = 0;
        // callMas.Creator = bsResultMas.ResultCreator;
        // callMas.Created = DateTime.Now;
        // callMas.Updator = bsResultMas.ResultCreator;
        // callMas.Updated = DateTime.Now;
        // callMas.HCNoService = false;
        // callMas.HCLock = false;
        // callMas.HCCloseID = 0;
        // entity.HappyCallMs.Add(callMas);
      } else {
        // OTHER STATUS
        // qryConfig.SrvRemark = bsInstruction;
        // qryConfig.SrvBSWeek = bsPreferWeek;
        // entity.SaveChanges();
      }
    }

    // LOGISTICS CALL
    Map<String, Object> logPram = null;
    if (Integer.parseInt(params.get("cmbStatusType").toString()) == 4) { // COMPLETED
      logPram = new HashMap<String, Object>();
      logPram.put("ORD_ID", LOG_SVC0008D_NO);
      logPram.put("RETYPE", "COMPLET");
      logPram.put("P_TYPE", "OD05");
      logPram.put("P_PRGNM", "HSCOM");
      logPram.put("USERID", sessionVO.getUserId());

      logger.debug("= HSCOM LOGISTICS CALL PARAM ===>" + logPram.toString());

      logger.debug("= HSCOM params ===>" +params);

      // KR-OHK Serial check add start
      if ("Y".equals(params.get("hidSerialRequireChkYn"))) {
        servicesLogisticsPFCMapper.SP_LOGISTIC_REQUEST_SERIAL(logPram);
      } else {
        servicesLogisticsPFCMapper.SP_LOGISTIC_REQUEST(logPram);
      }
      logger.debug("= HSCOMCALL LOGISTICS CALL RESULT ===> {}", logPram);

      if (!"000".equals(logPram.get("p1"))) {
        throw new ApplicationException(AppConstants.FAIL, "[ERROR]" + logPram.get("p1") + ":" + "HS Result Error");
      }
      // KR-OHK Serial check add end

      logPram.put("P_RESULT_TYPE", "HS");
      logPram.put("P_RESULT_MSG", logPram.get("p1"));
    }

    /*
     * else if(Integer.parseInt(params.get("cmbStatusType").toString()) == 21){
     * // Failed
     *
     * /////////////////////////물류 호출////////////////////// logPram =new
     * HashMap<String, Object>(); logPram.put("ORD_ID", LOG_SVC0008D_NO );
     * logPram.put("RETYPE", "SVO"); logPram.put("P_TYPE", "OD06");
     * logPram.put("P_PRGNM", "HSCAN"); logPram.put("USERID",
     * sessionVO.getUserId());
     *
     * logger.debug("HSCOMCALL 물류 호출 PRAM ===>"+ logPram.toString());
     * servicesLogisticsPFCMapper.SP_LOGISTIC_REQUEST(logPram);
     * logPram.put("P_RESULT_TYPE", "HS"); logPram.put("P_RESULT_MSG",
     * logPram.get("p1")); logger.debug("HSCOMCALL 물류 호출 결과 ===>");
     * /////////////////////////물류 호출 END ////////////////////// }
     */

    Map<String, Object> resultValue = new HashMap<String, Object>();
    resultValue.put("resultId", params.get("hidSalesOrdCd"));
    resultValue.put("spMap", logPram);
    resultValue.put("hsrNo", insertHsResultfinal.get("docNo")); // KR-OHK Serial
                                                                // Check add


    if ("API".equals(CommonUtils.nvl(params.get("stage")).toString())) { // MOBILE
    	// INSERT EDITTED CONTACT INFO FOR APPROVAL
        // CELESTE: Added for edit customer contact on 25/08/2022 [s]

        if((params.get("newHandphoneTel") != null && params.get("newHandphoneTel") != "") || (params.get("newHomeTel") != null && params.get("newHomeTel") != "") || (params.get("newOfficeTel") != null && params.get("newOfficeTel") != "") || (params.get("newEmail") != null && params.get("newEmail") != ""))
        {
      	  logger.debug("==================== editContactInfo [start] ========================");
            logger.debug("params: " + params);
            EgovMap insertHSNewContact = new EgovMap();
            params.put("orderId", params.get("hidSalesOrdId").toString());
            params.put("hsNo", params.get("serviceNo").toString());
            EgovMap brnchDt = hsManualMapper.selectBrchDt(params);
            EgovMap oldContDt = hsManualMapper.selectOldContactDt(params);

            logger.debug("==================== brnchDt========================");
            logger.debug(" brnchDt: " + brnchDt);
            logger.debug("==================== oldContDt========================");
            logger.debug(" oldContDt: " + oldContDt);

            insertHSNewContact.put("hsrNo", docNo);
            insertHSNewContact.put("hsNo", params.get("serviceNo").toString());
            insertHSNewContact.put("userId", params.get("userId").toString());
            insertHSNewContact.put("salesOrderNo", params.get("salesOrderNo").toString());
            insertHSNewContact.put("salesOrderId", params.get("hidSalesOrdId").toString());
            logger.debug("==================== line 1========================");
            insertHSNewContact.put("oldHpNo", params.get("resultIcMobileNo") == null ? null : params.get("resultIcMobileNo").toString());
            insertHSNewContact.put("oldHomeNo", params.get("resultIcHomeNo") == null ? null : params.get("resultIcHomeNo").toString());
            insertHSNewContact.put("oldOfficeNo", params.get("resultIcOfficeNo") == null ? null : params.get("resultIcOfficeNo").toString());
            insertHSNewContact.put("oldEmail", params.get("resultReportEmailNo") == null ? null : params.get("resultReportEmailNo").toString());
            insertHSNewContact.put("oldHpNo", oldContDt.get("oldHpNo") == null ? null : oldContDt.get("oldHpNo").toString());
            insertHSNewContact.put("oldHomeNo", oldContDt.get("oldHomeNo") == null ? null : oldContDt.get("oldHomeNo").toString());
            insertHSNewContact.put("oldOfficeNo", oldContDt.get("oldOfficeNo") == null ? null : oldContDt.get("oldOfficeNo").toString());
            insertHSNewContact.put("oldEmail", oldContDt.get("oldEmail") == null ? null : oldContDt.get("oldEmail").toString());
            logger.debug("==================== line 2========================");
            insertHSNewContact.put("newHpNo", params.get("newHandphoneTel") == null ? null : params.get("newHandphoneTel").toString());
            insertHSNewContact.put("newHomeNo", params.get("newHomeTel") == null ? null : params.get("newHomeTel").toString());
            insertHSNewContact.put("newOfficeNo", params.get("newOfficeTel") == null ? null : params.get("newOfficeTel").toString());
            insertHSNewContact.put("newEmail", params.get("newEmail") == null ? null : params.get("newEmail").toString());
            logger.debug("==================== line 3========================");
            insertHSNewContact.put("brnchId",brnchDt.get("brnchId").toString());
            insertHSNewContact.put("deptCode",brnchDt.get("deptCode").toString());
            insertHSNewContact.put("grpCode",brnchDt.get("grpCode").toString());
            insertHSNewContact.put("orgCode",brnchDt.get("orgCode").toString());
            logger.debug("==================== line 4========================");
            insertHSNewContact.put("status","P");
            insertHSNewContact.put("cntcId", oldContDt.get("custCntcId"));
            insertHSNewContact.put("custName", oldContDt.get("custName"));
            insertHSNewContact.put("custId", oldContDt.get("custId"));

            logger.debug("==================== insertHSNewContact ========================");
            logger.debug(" insertHSNewContact: " + insertHSNewContact);

            hsManualMapper.insertSAL0329D(insertHSNewContact);

            logger.debug("==================== editContactInfo [end] ========================");
        }

        // CELESTE: Added for edit customer contact on 25/08/2022 [e]

    	//start - this must put to the last of the HS sync
      params.put("selSchdulId", CommonUtils.nvl(params.get("hidschdulId")).toString());
      EgovMap useFilterList = hsManualMapper.getBSFilterInfo(params);

      // INSERT AS ENTRY FOR OMBAK -- TPY
      if (useFilterList != null) {
        String stkId = useFilterList.get("stkId").toString();
        if (stkId.equals("1428")) { // 1428 - MINERAL FILTER
          logger.debug("==================== saveASEntryResult [Start] ========================");

          params.put("userId", params.get("hidCodyId").toString());
          params.put("salesOrdId", params.get("hidSalesOrdId").toString());
          params.put("codyId", params.get("hidCodyId").toString());
          params.put("settleDate", params.get("settleDate").toString());
          params.put("stkId", useFilterList.get("stkId").toString());
          params.put("stkCode", useFilterList.get("stkCode").toString());
          params.put("stkDesc", useFilterList.get("stkDesc").toString());
          params.put("stkQty", useFilterList.get("bsResultPartQty").toString());
          params.put("amt", useFilterList.get("amt").toString());
          params.put("totalAmt", useFilterList.get("totalAmt").toString());
          params.put("no", useFilterList.get("no").toString());
          logger.debug("saveASEntryResult params :" + params.toString());

          Map<String, Object> sm = new HashMap<String, Object>();
          sm = this.saveASEntryResult(params);
          params.put("asNo", sm.get("asNo").toString());
          params.put("asId", sm.get("asId").toString());
          params.put("asResultNo", sm.get("asResultNo").toString());

          logger.debug("==================== saveASEntryResult [End] ========================");

          // INSERT TAX INVOICE FOR OMBAK -- TPY
          logger.debug("==================== saveASTaxInvoice [Start] ========================");
          logger.debug("saveASTaxInvoice params :" + params.toString());
          Map<String, Object> pb = new HashMap<String, Object>();
          pb = this.saveASTaxInvoice(params);

          logger.debug("==================== saveASTaxInvoice [End] ========================");
        }
      }

    //end - this must put to the last of the HS sync


    }
    return resultValue;
  }

  @Transactional
  private boolean insertHsResultfinal(int statusId, Map<String, Object> installResult, Map<String, Object> callEntry,
      Map<String, Object> callResult, Map<String, Object> orderLog) throws ParseException {
    // installEntry status가 1,21 이면 그 밑에 있는걸 ㅌ야된다(컴플릿이 되어도 다시 상태값 변경 가능하게 해야된다
    // String maxId = ""; //각 테이블에 maxid 값 가져온다(다음 실행할 쿼리에 값을 넣기 위해 사용)
    // EgovMap maxIdValue = new EgovMap();
    hsManualMapper.insertHsResultfinal(installResult);
    // EgovMap entry = installationResultListMapper.selectEntry(installResult);
    // logger.debug("entry : {}", entry);
    // maxIdValue.put("value", "resultId");
    // maxId = installationResultListMapper.selectMaxId(maxIdValue);
    // logger.debug("maxId : {}", maxId);
    // entry.put("installResultId", maxId);
    // entry.put("stusCodeId", installResult.get("statusCodeId"));
    // entry.put("updated", installResult.get("created"));
    // entry.put("updator", installResult.get("creator"));
    // installationResultListMapper.updateInstallEntry(entry);
    // if(installResult.get("statusCodeId").toString().equals("21")){
    // if(callEntry != null){
    // installationResultListMapper.insertCallEntry(callEntry);
    // //callEntry에 max 값 구해서 CallResult에 저장
    // maxIdValue.put("value", "callEntryId");
    // maxId = installationResultListMapper.selectMaxId(maxIdValue);
    // callResult.put("callEntryId", maxId);
    //
    // installationResultListMapper.insertCallResult(callResult);
    // //callresult에 max값 구해서 callEntry에 업데이트
    // maxIdValue.put("value", "callResultId");
    // maxId = installationResultListMapper.selectMaxId(maxIdValue);
    // callEntry.put("resultId", maxId);
    // maxIdValue.put("value", "resultId");
    // maxId = installationResultListMapper.selectMaxId(maxIdValue);
    // callEntry.put("callEntryId", maxId);
    // installationResultListMapper.updateCallEntry(callEntry);
    // }
    //
    // hsManualMapper.insertOrderLog(orderLog);
    // }
    return true;
  }

  @Override
  public List<EgovMap> cmbCollectTypeComboList(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return hsManualMapper.cmbCollectTypeComboList();
  }

  @Override
  public List<EgovMap> cmbCollectTypeComboList2(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return hsManualMapper.cmbCollectTypeComboList2();
  }

  @Override
  public List<EgovMap> cmbServiceMemList(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return hsManualMapper.cmbServiceMemList();
  }

  @Override
  public List<EgovMap> selectHsFilterList(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return hsManualMapper.selectHsFilterList(params);
  }

  @Override
  public EgovMap selectHsViewBasicInfo(Map<String, Object> params) {

    return hsManualMapper.selectHsViewBasicInfo(params);
  }

  @Override
  public List<EgovMap> failReasonList(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return hsManualMapper.failReasonList(params);
  }

  @Override
  public List<EgovMap> serMemList(Map<String, Object> params) {
    return hsManualMapper.serMemList(params);
  }

  @Override
  public List<EgovMap> selectHsViewfilterInfo(Map<String, Object> params) {
    // TODO Auto-generated method stub
    params.put("selSchdulId2", params.get("selSchdulId"));
    logger.debug("jinmu{}", params);
    return hsManualMapper.selectHsViewfilterInfo(params);
  }

  @Override
  public EgovMap selectSettleInfo(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return hsManualMapper.selectSettleInfo(params);
  }

  @Override
  @Transactional
  public Map<String, Object> UpdateHsResult(Map<String, Object> params, List<Object> docType, SessionVO sessionVO) {

    Map<String, Object> resultValue = new HashMap<String, Object>();

    EgovMap UpdateHsResult = new EgovMap();

    // BSResultD
    for (int i = 0; i < docType.size(); i++) {
      Map<String, Object> docSub = (Map<String, Object>) docType.get(i);
      docSub.put("bsResultId", params.get("hidschdulId"));
      docSub.put("bsResultPartId", docSub.get("stkId"));
      docSub.put("bsResultPartDesc", docSub.get("stkDesc"));
      docSub.put("bsResultPartQty", docSub.get("name"));
      // docSub.put("bsResultCrtDt");
      docSub.put("bsResultCrtUserId", sessionVO.getUserId());
      docSub.put("bsResultFilterClm", docSub.get("name"));

      hsManualMapper.updateHsResultD(docSub);
    }

    // BSResultM
    EgovMap HsResultUdateEdit = new EgovMap();
    HsResultUdateEdit.put("hidschdulId", params.get("hidschdulId"));
    HsResultUdateEdit.put("srvRem", params.get("instruction"));
    HsResultUdateEdit.put("codyId", params.get("cmbServiceMem"));
    HsResultUdateEdit.put("failReason", params.get("failReason"));
    HsResultUdateEdit.put("renColctId", params.get("cmbCollectType"));
    HsResultUdateEdit.put("srvBsWeek", params.get("srvBsWeek"));

    hsManualMapper.updateHsResultM(HsResultUdateEdit); // m

    // BSScheduleM
    int scheduleCnt = hsManualMapper.selectHSScheduleMCnt(params);

    if (scheduleCnt > 0) {
      EgovMap insertHsScheduleM = new EgovMap();
      insertHsScheduleM.put("hidschdulId", params.get("hidschdulId"));
      insertHsScheduleM.put("resultStusCodeId", params.get("cmbStatusType2"));
      insertHsScheduleM.put("actnMemId", params.get("cmbServiceMem"));

      hsManualMapper.updateHsScheduleM(insertHsScheduleM);
    }

    EgovMap updateHsSrvConfigM = new EgovMap();

    updateHsSrvConfigM.put("salesOrdId", params.get("hidschdulId"));
    updateHsSrvConfigM.put("srvBsWeek", params.get("srvBsWeek"));

    // hsManualMapper.updateHsSrvConfigM(updateHsSrvConfigM);

    return resultValue;
  }

  @Override
  public List<EgovMap> selectFilterTransaction(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return hsManualMapper.selectFilterTransaction(params);
  }

  @Override
  public List<EgovMap> selectHistoryHSResult(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return hsManualMapper.selectHistoryHSResult(params);
  }

  @Override
  public EgovMap selectConfigBasicInfo(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return hsManualMapper.selectConfigBasicInfo(params);
  }

  @Override
  public int updateHsConfigBasic(Map<String, Object> params, SessionVO sessionVO) {
    // TODO Auto-generated method stub
    logger.debug("[HsManualServiceImpl - updateHsConfigBasic] - hsResultM params ===> {}" + params);

    int cnt = 0;

    LinkedHashMap hsBasicmap = (LinkedHashMap) params.get("hsResultM");
    EgovMap selectConfigBasicInfoYn = hsManualMapper.selectConfigBasicInfoYn(hsBasicmap);

    if (selectConfigBasicInfoYn.size() > 0) {
      Map<String, Object> sal0090 = new HashMap<String, Object>();
      sal0090.put("salesOrderId", hsBasicmap.get("salesOrderId"));
      sal0090.put("availability", hsBasicmap.get("availability"));
      sal0090.put("srvConfigId", selectConfigBasicInfoYn.get("srvConfigId"));
      sal0090.put("cmbServiceMem", hsBasicmap.get("cmbServiceMem"));
      sal0090.put("lstHSDate", hsBasicmap.get("lstHSDate"));
      sal0090.put("remark", hsBasicmap.get("remark"));
      sal0090.put("srvBsWeek", hsBasicmap.get("srvBsWeek"));
      sal0090.put("srvUpdateAt", sessionVO.getUserId());
      sal0090.put("hscodyId", hsBasicmap.get("hscodyId"));
      sal0090.put("faucetExch", hsBasicmap.get("faucetExch"));

      /* Self Service (DIY) Project - Service Type add by Fannie - 14/08/2024 */
      String originalSrvType = hsBasicmap.get("oldSrvType").toString();
      String serviceType = hsBasicmap.get("serviceType").toString();
   
      // Self Service (DIY) Project - Service Type add by Fannie - 14/08/2024
      // calculate the PV for SS Rebate
      int promoItmPv = Integer.parseInt(hsBasicmap.get("promoItmPv").toString());
      int promoItmPvSs = Integer.parseInt(hsBasicmap.get("promoItmPvSs").toString());
      int pvRebatePerInstallment = promoItmPv - promoItmPvSs;

      hsBasicmap.put("srvUpdateAt", sessionVO.getUserId());

      // Self Service (DIY) Project - Service Type add by Fannie - 14/08/2024
        if(hsBasicmap.get("isChgSrvType").toString().equals("true")) {

        	  // [Project ID 7139026265] Self Service (DIY) Project - count the SAL0090H records add by Fannie - 05/12/2024
        	  Map<String, Object> cntSrvTypeHistory = new HashMap<String, Object>();
        	  cntSrvTypeHistory.put("salesOrdId", hsBasicmap.get("salesOrderId"));

        	  if(getSrvTypeChgTm(cntSrvTypeHistory) > 0){
        		  //Update the previous record SAL0090H Status to 4
        		  hsManualMapper.updateHsConfigBasicHistoryStatus(hsBasicmap);
        	  }

               // Insert SAL0090H
               hsManualMapper.insertHsConfigBasicHistory(hsBasicmap);

                // Self Service Rebate - PAY0286D
               params.put("srvCntrctPacId", hsBasicmap.get("ordSrvPacId"));
               EgovMap srvPackageResult = orderRegisterMapper.selectServiceContractPackage(params);

               //check the new or existing have SS GST Rebate - PAY0286D
               EgovMap getSSGstRebateInfo = hsManualMapper.getSSGstRebate(hsBasicmap);

               // Get SS PV Rebate info - PAY0367D
               EgovMap getPvSSRebateInfo = hsManualMapper.getPvSSRebate(hsBasicmap);

               if(!srvPackageResult.isEmpty() && Integer.parseInt(hsBasicmap.get("appTypeId").toString()) == SalesConstants.APP_TYPE_CODE_ID_RENTAL){
                       // if found existing have self service rebate, then update stusid = 8 in PAY0286D
                       if(getSSGstRebateInfo != null && getSSGstRebateInfo.size() > 0){
                            Map<String,Object> oriPay0286 = new HashMap();
                            oriPay0286.put("stusId", 8);
                            oriPay0286.put("ordId", getSSGstRebateInfo.get("ordId"));
                            oriPay0286.put("gstRebateId", getSSGstRebateInfo.get("gstRebateId"));
                            oriPay0286.put("updUserId", sessionVO.getUserId());
                            hsManualMapper.updateSSRebateStatus(oriPay0286);
                       }

                       if(getPvSSRebateInfo != null && getPvSSRebateInfo.size() > 0){
                             Map<String,Object> oriPay0367 = new HashMap();
                             oriPay0367.put("stusId", 8);
                             oriPay0367.put("ordId", getPvSSRebateInfo.get("ordId"));
                             oriPay0367.put("pvRebateId", getPvSSRebateInfo.get("pvRebateId"));
                             oriPay0367.put("updUserId", sessionVO.getUserId());
                             hsManualMapper.updatePvSSRebateStatus(oriPay0367);
                      }

                       if(hsBasicmap.get("serviceType").equals("SS")){
                           // Insert the SS GST Rebate - PAY0286D
                           Map<String,Object> newPay0286 = new HashMap();
                           newPay0286.put("ordId", hsBasicmap.get("salesOrderId"));
                           newPay0286.put("rebateType", 0);
                           newPay0286.put("rebateStartInstallment", 1);
                           newPay0286.put("rebateEndInstallment", srvPackageResult.get("srvCntrctPacDur"));
                           newPay0286.put("rem", hsBasicmap.get("ordMthRentAmt"));
                           newPay0286.put("crtUserId", sessionVO.getUserId());
                           newPay0286.put("updUserId", sessionVO.getUserId());
                           newPay0286.put("stusId", 1);
                           newPay0286.put("cntrctId", 0);
                           newPay0286.put("rebateAmtPerInstallment", 5); // RM5 for Self Service Discount Rebate
                           orderRegisterMapper.insertSSRebate(newPay0286);

                           //Insert the SS PV Rebate - PAY0367D
                           Map<String,Object> pay0367 = new HashMap();
                           pay0367.put("ordId", hsBasicmap.get("salesOrderId"));
                           pay0367.put("pvRebateType", 0);
                           pay0367.put("pvRebateStartInstallment", 1);
                           pay0367.put("pvRebateEndInstallment", srvPackageResult.get("srvCntrctPacDur"));
                           pay0367.put("rem", hsBasicmap.get("ordMthRentAmt"));
                           pay0367.put("crtUserId", sessionVO.getUserId());
                           pay0367.put("updUserId", sessionVO.getUserId());
                           pay0367.put("stusId", 1);
                           pay0367.put("cntrctId", 0);
                           pay0367.put("pvRebatePerInstallment", pvRebatePerInstallment); // PV for Self Service Rebate
                           hsManualMapper.insertPvSSRebate(pay0367);
                    }
               }
           }

      // sal0090.put("SrvUpdateAt", SYSDATE);
      // hsManualMapper.updateHsSVC0006D(sal0090);
      cnt = hsManualMapper.updateHsConfigBasic(sal0090);

      // SrvConfigSetting --> Installation : 281
      List<EgovMap> configSettingMap = hsManualMapper.selectConfigSettingYn(hsBasicmap);

      if (configSettingMap.size() > 0) {
        for (int i = 0; i < configSettingMap.size(); i++) {
          Map<String, Object> sal0089 = configSettingMap.get(i);

          if (configSettingMap.get(i).get("srvSettTypeId").toString().equals("281")) {
              if ("1".equals(hsBasicmap.get("settIns").toString())) {
                sal0089.put("srvSettStusId", 1);
              } else {
                sal0089.put("srvSettStusId", 8);
              }
          } else if (configSettingMap.get(i).get("srvSettTypeId").toString().equals("280")) {
              if ("1".equals(hsBasicmap.get("settHs").toString())) {
                sal0089.put("srvSettStusId", 1);
              } else {
                sal0089.put("srvSettStusId", 8);
              }
          } else if (configSettingMap.get(i).get("srvSettTypeId").toString().equals("279")) {
              if ("1".equals(hsBasicmap.get("settAs").toString())) {
                sal0089.put("srvSettStusId", 1);
              } else {
                sal0089.put("srvSettStusId", 8);
              }
          }

          sal0089.put("salesOrderId", hsBasicmap.get("salesOrderId"));
          sal0089.put("configId", hsBasicmap.get("configId"));
          sal0089.put("srvSettRem", "");
          sal0089.put("srvSettCrtUserId", sessionVO.getUserId());

          hsManualMapper.updateHsconfigSetting(sal0089);
        }
      }
    }

    return cnt;
  }

  @Override
  public EgovMap selectHSOrderView(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return hsManualMapper.selectHSOrderView(params);
  }

  @Override
  public List<EgovMap> selectOrderInactiveFilter(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return hsManualMapper.selectOrderInactiveFilter(params);
  }

  @Override
  public List<EgovMap> selectOrderActiveFilter(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return hsManualMapper.selectOrderActiveFilter(params);
  }

  @Override
  public String updateAssignCody(Map<String, Object> params) {
    List<EgovMap> updateItemList = (List<EgovMap>) params.get(AppConstants.AUIGRID_UPDATE);
    String rtnValue = "";
    String line = System.getProperty("line.separator");

    if (updateItemList.size() > 0) {

      for (int i = 0; i < updateItemList.size(); i++) {
        Map<String, Object> updateMap = (Map<String, Object>) updateItemList.get(i);
        logger.debug("updateMap : {}" + updateMap);
        hsManualMapper.updateAssignCody(updateMap);
        hsManualMapper.updateAssignCody90D(updateMap);

        if (i != 0) {
          rtnValue += "<br>";
        }

        rtnValue += "* Cody Transfer for HS Order ‘" + updateMap.get("no") + "'" + "<br>from " + "'"
            + updateMap.get("oldCodyCd") + "'" + " to " + "'" + updateMap.get("codyCd") + "'" + "\r\n";
        rtnValue = rtnValue.replace("\n", line);
      }
    }
    return rtnValue;
  }

  @Override
  public List<EgovMap> selectBranch_id(Map<String, Object> params) {
    return hsManualMapper.selectBranch_id(params);
  }

  @Override
  public List<EgovMap> selectCTMByDSC_id(Map<String, Object> params) {
    return hsManualMapper.selectCTMByDSC_id(params);
  }

  @Override
  public EgovMap selectCheckMemCode(Map<String, Object> params) {

    return hsManualMapper.selectCheckMemCode(params);
  }

  @Override
  public EgovMap serMember(Map<String, Object> params) {

    return hsManualMapper.selectSerMember(params);
  }

  @Override
  public List<EgovMap> selectHSCodyList(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return hsManualMapper.selectHSCodyList(params);
  }

  @Override
  public String getSrvCodyIdbyMemcode(Map<String, Object> params) {

    return hsManualMapper.selectMemberId(params);
  }

  @Override
  public int updateSrvCodyId(Map<String, Object> params) {
    int cnt = 0;
    hsManualMapper.updateSrvCodyId(params);
    return cnt;
  }

  @Override
  public List<EgovMap> selectHSAddFilterSetInfo(Map<String, Object> params) {
    return hsManualMapper.selectHSAddFilterSetInfo(params);
  }

  @Override
  public List<EgovMap> addSrvFilterIdCnt(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return hsManualMapper.addSrvFilterIdCnt(params);
  }

  @Override
  public int updateFilterInfo(Map<String, Object> params, SessionVO sessionVO) {
    // TODO Auto-generated method stub
    return hsManualMapper.updateFilterInfo(params);
  }

  @Override
  public String getSrvConfigId_SAL009(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return hsManualMapper.getSrvConfigId_SAL009(params);
  }

  @Override
  public String getbomPartPriod_LOG0001M(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return hsManualMapper.getbomPartPriod_LOG0001M(params);
  }

  @Override
  public String getSalesDtSAL_0001D(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return hsManualMapper.getSalesDtSAL_0001D(params);
  }

  @Override
  public EgovMap getSrvConfigFilter_SAL0087D(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return hsManualMapper.getSrvConfigFilter_SAL0087D(params);
  }

  @Override
  public int saveHsFilterInfoAdd(Map<String, Object> params) {
    // TODO Auto-generated method stub
    int result = -1;

    String configID = hsManualMapper.getSrvConfigId_SAL009(params);
    String filterPeriod = hsManualMapper.getbomPartPriod_LOG0001M(params);
    String orderdate = hsManualMapper.getSalesDtSAL_0001D(params);

    // DateTime CutOffDate = DateTime.ParseExact("04/27/2016", "MM/dd/yyyy",
    // CultureInfo.InvariantCulture);
    String productID = String.valueOf(params.get("productID"));
    String filterCode = String.valueOf(params.get("filterCode"));

    // if (ProductID == 892 || orderdate < CutOffDate)
    /*
     * if(productID == "892"){ if(filterCode == "303" || filterCode == "901"){
     * filterPeriod = "6"; } }
     */

    Map<String, Object> send_sal0087D = new HashMap();

    if (configID != null && !"0".equals(configID)) {
      EgovMap sal0087D = hsManualMapper.getSrvConfigFilter_SAL0087D(params);

      if (sal0087D != null) {
        /*
         * send_sal0087D.put("SRV_FILTER_PRIOD", filterPeriod);
         * send_sal0087D.put("SRV_FILTER_PRV_CHG_DT",
         * params.get("lastChangeDate"));
         * send_sal0087D.put("SRV_FILTER_STUS_ID", 1);
         * send_sal0087D.put("SRV_FILTER_UPD_USER_ID" , params.get("updator"));
         * send_sal0087D.put("SRV_FILTER_REM", params.get("remark"));
         *
         * hsManualMapper.saveChanges(send_sal0087D);
         */

        // 이미 존재
        result = -100;

      } else {
        /*
         * send_sal0087D.put("SRV_FILTER_ID" ,0);
         * send_sal0087D.put("SRV_CONFIG_ID" ,configID);
         * send_sal0087D.put("SRV_FILTER_STK_ID" ,filterCode);
         * send_sal0087D.put("SRV_FILTER_PRIOD" ,filterPeriod);
         * send_sal0087D.put("SRV_FILTER_PRV_CHG_DT"
         * ,params.get("lastChangeDate"));
         * send_sal0087D.put("SRV_FILTER_STUS_ID" ,1);
         * send_sal0087D.put("SRV_FILTER_REM" ,params.get("remark")); //
         * send_sal0087D.put("SRV_FILTER_CRT_DT" ,); sysdate
         * send_sal0087D.put("SRV_FILTER_CRT_USER_ID" , params.get("updator"));
         * // send_sal0087D.put("SRV_FILTER_UPD_DT" ,);sysdate
         * send_sal0087D.put("SRV_FILTER_UPD_USER_ID" ,params.get("updator"));
         *
         * hsManualMapper.saveChanges(send_sal0087D);
         */

        // Insert SAL0087D
        hsManualMapper.saveHsFilterInfoAdd(params);
        result = 1;

      }
    }

    return result;
  }

  @Override
  public int saveDeactivateFilter(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return hsManualMapper.saveDeactivateFilter(params);
  }

  @Override
  public int saveFilterUpdate(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return hsManualMapper.saveFilterUpdate(params);
  }

  @Override
  public List<EgovMap> selecthSFilterUseHistorycall(Map<String, Object> params) {
    return hsManualMapper.selecthSFilterUseHistorycall(params);
  }

  @Override
  @Transactional
  public String UpdateIsReturn(Map<String, Object> params, List<Object> docType, SessionVO sessionVO)
      throws ParseException {
    logger.debug("============================UpdateIsReturn - START =================================");
    for (int i = 0; i < docType.size(); i++) {
      Map<String, Object> docSub = (Map<String, Object>) docType.get(i);
      logger.debug("= DOC SUB{} : " + docSub);

      if ("1428".equals(CommonUtils.nvl(docSub.get("stkId")))) {
        logger.debug("= PROCESS : " + CommonUtils.nvl(docSub.get("stkId")));

        Map<String, Object> bsResultMas = new HashMap<String, Object>();
        bsResultMas.put("SalesOrderId", String.valueOf(params.get("hidSalesOrdId")));

        Map<String, Object> qryConfig = new HashMap<String, Object>();
        qryConfig = hsManualMapper.selectQryConfig(bsResultMas);

        Map<String, Object> value = new HashMap<String, Object>();
        value.put("srvConfigId", CommonUtils.nvl(qryConfig.get("srvConfigId")));
        value.put("isReturn", CommonUtils.nvl(docSub.get("isReturn")));
        value.put("stkId", CommonUtils.nvl(docSub.get("stkId")));

        hsManualMapper.updateIsReturn(value);
      } else {
        logger.debug("= SKIP : " + CommonUtils.nvl(docSub.get("stkId")));
      }
    }
    logger.debug("============================UpdateIsReturn - END =================================");
    return "";
  }

  @Override
  @Transactional
  public Map<String, Object> UpdateHsResult2(Map<String, Object> params, List<Object> docType, SessionVO sessionVO)
      throws ParseException {

    Map<String, Object> resultValue = new HashMap<String, Object>();

    EgovMap UpdateHsResult = new EgovMap();

    List<Map<String, Object>> bsResultDet = new ArrayList<Map<String, Object>>();

    for (int i = 0; i < docType.size(); i++) {
      Map<String, Object> bsd = new HashMap<String, Object>();
      Map<String, Object> docSub = (Map<String, Object>) docType.get(i);
      logger.debug("docSub{} : " + docSub);

      // bsd.put("BSResultItemID",0 );
      bsd.put("BSResultID", String.valueOf(params.get("hidschdulId")));
      bsd.put("BSResultPartID", String.valueOf(docSub.get("stkId")));
      bsd.put("BSResultPartDesc", String.valueOf(docSub.get("stkDesc")));
      bsd.put("BSResultPartQty", String.valueOf(docSub.get("name")));
      bsd.put("BSResultPartIsRtrn", String.valueOf(docSub.get("isReturn")));
      bsd.put("BSResultRemark", "");
      // bsd.put("BSResultCreateAt",0 );
      bsd.put("BSResultCreateBy", String.valueOf(sessionVO.getUserId()));
      bsd.put("BSResultFilterClaim", String.valueOf(1));
      bsd.put("SerialNo", docSub.get("serialNo") != null ? String.valueOf(docSub.get("serialNo")) : "");

      bsResultDet.add(bsd);
    }

    Map<String, Object> bsResultMas = new HashMap<String, Object>();
    // bsResultMas.put("ResultID", 0);
    bsResultMas.put("No", "");
    bsResultMas.put("TypeID", String.valueOf(306));
    bsResultMas.put("ScheduleID", String.valueOf(params.get("hidschdulId")));
    bsResultMas.put("SalesOrderId", String.valueOf(params.get("hidSalesOrdId")));

    if (params.get("cmbServiceMem") == null || params.get("cmbServiceMem") == "") {
      bsResultMas.put("CodyID", String.valueOf(sessionVO.getUserId()));
    } else {
      bsResultMas.put("CodyID", String.valueOf(params.get("cmbServiceMem")));
    }

    // bsResultMas.put("SettleDate", params.get("setlDt"));
    logger.debug(">>>>>>settleDt isEmpty : " + StringUtils.isEmpty(String.valueOf(params.get("settleDt")).trim()));
    if (params.get("settleDt") != null || params.get("settleDt") != "") {
      bsResultMas.put("SettleDate", String.valueOf(params.get("settleDt")));
    } else {
      bsResultMas.put("SettleDate", "01/01/1900");
    }

    if (params.get("cmbStatusType2") == null || params.get("cmbStatusType2") == "") {
      bsResultMas.put("ResultStatusCodeID", String.valueOf("0"));
    } else {
      bsResultMas.put("ResultStatusCodeID", String.valueOf(params.get("cmbStatusType2")));
    }

    if (params.get("failReason") == null || params.get("failReason") == "") {
      bsResultMas.put("FailReasonID", String.valueOf("0"));
    } else {
      bsResultMas.put("FailReasonID", String.valueOf(params.get("failReason")));
    }

    if (params.get("cmbCollectType") == null || params.get("cmbCollectType") == "") {
      bsResultMas.put("RenCollectionID", String.valueOf("0"));
    } else {
      bsResultMas.put("RenCollectionID", String.valueOf(params.get("cmbCollectType")));
    }
    // bsResultMas.put("RenCollectionID",
    // String.valueOf(params.get("cmbCollectType")));

    if (params.get("wareHouse") == null || params.get("wareHouse") == "") {
      bsResultMas.put("WarehouseID", String.valueOf("0"));
    } else {
      bsResultMas.put("WarehouseID", String.valueOf(params.get("wareHouse")));
    }

    // logger.debug("txtRemark isEmpty : " +
    // StringUtils.isEmpty(String.valueOf(params.get(""txtRemark"")).trim()));
    bsResultMas.put("ResultRemark", String.valueOf(params.get("txtRemark")));
    // [19-09-2018] ADD HS INSTRUCTION REMARK FOR MAPPER USE
    bsResultMas.put("ResultInstRemark", String.valueOf(params.get("txtInstruction")));

    LocalDate currentDate = LocalDate.now();
    int stusCodeId = CommonUtils.intNvl(params.get("cmbStatusType2"));

    LocalDate defaultNextAppntDt = currentDate;
    if(stusCodeId == SalesConstants.STATUS_FAILED){
      defaultNextAppntDt = currentDate.withDayOfMonth(5).plusMonths(1);
    }else if(stusCodeId == SalesConstants.STATUS_CANCELLED) {
      defaultNextAppntDt = currentDate.withDayOfMonth(5).plusMonths(2);
    }else{
      // DO NOTHING
    }

    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    bsResultMas.put("nextAppntDt", stusCodeId == SalesConstants.STATUS_COMPLETED ? String.valueOf(params.get("nextAppntDt")) : dateFormatter.format(defaultNextAppntDt));
    bsResultMas.put("nextAppntTime", stusCodeId == SalesConstants.STATUS_COMPLETED ? String.valueOf(params.get("nextAppointmentTime")) : "0900");

    /*
     * logger.debug("configBsRem isEmpty : " +
     * StringUtils.isEmpty(String.valueOf(params.get("configBsRem")).trim()));
     * if(StringUtils.isEmpty(String.valueOf(params.get("configBsRem")).trim()))
     * { bsResultMas.put("ResultRemark", String.valueOf(0)); }else{
     * bsResultMas.put("ResultRemark",
     * String.valueOf(params.get("configBsRem"))); }
     */

    // bsResultMas.put("ResultCreated", sysdate);
    bsResultMas.put("ResultCreator", String.valueOf(sessionVO.getUserId()));
    // bsResultMas.put("ResultUpdated", sysdate);
    bsResultMas.put("ResultIsSync", String.valueOf(1));
    bsResultMas.put("ResultIsEdit", String.valueOf(1));

    if (bsResultDet.size() > 0) {
      bsResultMas.put("ResultStockUse", String.valueOf(1));
    } else {
      bsResultMas.put("ResultStockUse", String.valueOf(0));
    }
    bsResultMas.put("ResultIsCurrent", String.valueOf(1));
    bsResultMas.put("ResultMatchID", String.valueOf(0));
    bsResultMas.put("ResultIsAdjust", String.valueOf(1));
    bsResultMas.put("bsPreferWeek", String.valueOf(params.get("srvBsWeek")));
    bsResultMas.put("instChklstCheckBox", params.get("instChklstCheckBox"));

    Map<String, Object> bsResultMas_Rev = new HashMap<String, Object>();


    String ResultNo_Rev = "";
    int BS_RESULT = 11;
    String docNo = null;

    bsResultMas_Rev.put("DOCNO", BS_RESULT);
    EgovMap eMap = hsManualMapper.getHsResultDocNo(bsResultMas_Rev);
    docNo = String.valueOf(eMap.get("hsrno")).trim();
    bsResultMas_Rev.put("docNo", docNo);
    logger.info("###HSRNO: " + docNo);

   /* String ResultNo_Rev = "";
    int BS_RESULT = 11;
    bsResultMas_Rev.put("doctype", BS_RESULT);

    String docNo = null;
    docNo = hsManualMapper.GetDocNo(bsResultMas_Rev);
    bsResultMas_Rev.put("docNo", docNo);

    String BS_RESULT_BSR = "HSR";

    String nextNo = getNextDocNo(BS_RESULT_BSR, docNo);

     * String DocNoFormat = ""; for (int i = 1; i <= BS_RESULT_BSR.length();
     * i++) { DocNoFormat += "0"; } DocNoFormat = "{0:" + DocNoFormat + "}";
     *
     * int docNo_int = Integer.parseInt(docNo.replace(BS_RESULT_BSR,
     * "").toString()); int nextNo = docNo_int +1;

    bsResultMas_Rev.put("ID_New", BS_RESULT);
    bsResultMas_Rev.put("nextDocNo_New", nextNo);
    hsManualMapper.updateQry_New(bsResultMas_Rev);*/
    // int docNo1 = hsManualMapper.GetDocNo1(bsResultMas_Rev);

    EgovMap qryBS_Rev = null;
    qryBS_Rev = hsManualMapper.selectQryBS_Rev(bsResultMas);
    logger.debug("qryBS_Rev : {}" + qryBS_Rev);

    if (qryBS_Rev != null) {
      int BSResultM_resultID = hsManualMapper.getBSResultM_resultID();
      bsResultMas_Rev.put("ResultID", BSResultM_resultID); // sequence
      bsResultMas_Rev.put("No", String.valueOf(docNo));
      bsResultMas_Rev.put("TypeID", String.valueOf("307"));
      bsResultMas_Rev.put("ScheduleID", String.valueOf(qryBS_Rev.get("schdulId")));
      bsResultMas_Rev.put("SalesOrderId", String.valueOf(qryBS_Rev.get("salesOrdId")));
      bsResultMas_Rev.put("CodyID", String.valueOf(qryBS_Rev.get("codyId")));
      bsResultMas_Rev.put("SettleDate", String.valueOf(qryBS_Rev.get("setlDt")));
      bsResultMas_Rev.put("ResultStatusCodeID", String.valueOf(qryBS_Rev.get("resultStusCodeId")));// RESULT_STUS_CODE_ID
      bsResultMas_Rev.put("FailReasonID", String.valueOf(qryBS_Rev.get("failResnId")));// FAIL_RESN_ID
      bsResultMas_Rev.put("RenCollectionID", String.valueOf(qryBS_Rev.get("renColctId")));// REN_COLCT_ID
      bsResultMas_Rev.put("WarehouseID", String.valueOf(qryBS_Rev.get("whId")));// WH_ID
      bsResultMas_Rev.put("ResultRemark", String.valueOf(qryBS_Rev.get("resultRem")));// RESULT_REM
      // bsResultMas_Rev.put("ResultCreated", "sysdate");
      bsResultMas_Rev.put("ResultCreator", String.valueOf(sessionVO.getUserId()));
      bsResultMas_Rev.put("ResultIsSync", String.valueOf(1));
      bsResultMas_Rev.put("ResultIsEdit", String.valueOf(0));
      bsResultMas_Rev.put("ResultStockUse", String.valueOf(qryBS_Rev.get("resultStockUse")));// RESULT_STOCK_USE
      bsResultMas_Rev.put("ResultIsCurrent", String.valueOf(1));
      bsResultMas_Rev.put("ResultMatchID", String.valueOf(qryBS_Rev.get("resultId")));// RESULT_ID
      bsResultMas_Rev.put("ResultIsAdjust", String.valueOf(1));

      if(qryBS_Rev.get("instChklstCheckBox") != null) {
         bsResultMas_Rev.put("instChklstCheckBox", qryBS_Rev.get("instChklstCheckBox"));
      } else {
    	 bsResultMas_Rev.put("instChklstCheckBox", params.get("instChklstCheckBox"));
      }

      int count = hsManualMapper.selectTotalFilter(bsResultMas_Rev);
      logger.debug("selectQryResultDet : {}" + bsResultMas_Rev);
      List<EgovMap> qryResultDet = hsManualMapper.selectQryResultDet(bsResultMas_Rev);
      List<EgovMap> qryUsedFilter;
      if (count == 0) {
        qryUsedFilter = hsManualMapper.selectQryUsedFilterNew(bsResultMas_Rev);

      } else {
        qryUsedFilter = hsManualMapper.selectQryUsedFilter(bsResultMas_Rev);

      }
      logger.debug("qryResultDet : {}" + qryResultDet);
      logger.debug("qryResultDet.size() : {}" + qryResultDet.size());

      int checkInt = 0;

      // bsResultDet
      Map<String, Object> bsResultDet_Rev = null;
      Map<String, Object> usedFilter_Rev = null;
      for (int i = 0; i < qryResultDet.size(); i++) {

        bsResultDet_Rev = new HashMap<String, Object>();
        usedFilter_Rev = new HashMap<String, Object>();
        // bsResultDet_Rev.put("BSResultItemID", 0);
        bsResultDet_Rev.put("BSResultID", BSResultM_resultID);
        bsResultDet_Rev.put("BSResultPartID", String.valueOf(qryResultDet.get(i).get("bsResultPartId")));// BS_RESULT_PART_ID
        bsResultDet_Rev.put("BSResultPartDesc", CommonUtils.nvl(qryResultDet.get(i).get("bsResultPartDesc")));// BS_RESULT_PART_DESC
        if (String.valueOf(qryBS_Rev.get("resultId")) != null && String.valueOf(qryBS_Rev.get("resultId")) != "") {
          bsResultDet_Rev.put("BSResultPartQty", CommonUtils.intNvl(qryResultDet.get(i).get("bsResultPartQty")) * -1);// BS_RESULT_PART_QTY
          logger.debug("jinmu {}" + String.valueOf(qryBS_Rev.get("resultId")));
        } else {
          bsResultDet_Rev.put("BSResultPartQty", CommonUtils.intNvl(qryResultDet.get(i).get("bsResultPartQty")));
          logger.debug("jinmu111 {}" + String.valueOf(qryBS_Rev.get("resultId")));
        }
        bsResultDet_Rev.put("BSResultRemark", CommonUtils.nvl(qryResultDet.get(i).get("bsResultRem")));// BS_RESULT_REM
        bsResultDet_Rev.put("BSResultCreateAt", "sysdate");// BS_RESULT_REM
        bsResultDet_Rev.put("BSResultCreateBy", String.valueOf(sessionVO.getUserId()));
        bsResultDet_Rev.put("BSResultFilterClaim", CommonUtils.intNvl(qryResultDet.get(i).get("bsResultFilterClm")));// BS_RESULT_FILTER_CLM

        usedFilter_Rev.put("HSNo", String.valueOf(qryUsedFilter.get(i).get("no")));
        usedFilter_Rev.put("CustId", CommonUtils.intNvl(qryUsedFilter.get(i).get("custId")));
        usedFilter_Rev.put("CreatedDt", String.valueOf(qryUsedFilter.get(i).get("resultCrtDt")));
        usedFilter_Rev.put("PartId", CommonUtils.intNvl(qryUsedFilter.get(i).get("bsResultPartId")));
        if (String.valueOf(qryBS_Rev.get("resultId")) != null && String.valueOf(qryBS_Rev.get("resultId")) != "") {
          usedFilter_Rev.put("PartQty", CommonUtils.intNvl(qryUsedFilter.get(i).get("bsResultPartQty")) * -1);// BS_RESULT_PART_QTY
          // logger.debug("jinmu {}" +
          // String.valueOf(qryBS_Rev.get("resultId")));
        } else {
          usedFilter_Rev.put("PartQty", CommonUtils.intNvl(qryUsedFilter.get(i).get("bsResultPartQty")));
          // logger.debug("jinmu111 {}" +
          // String.valueOf(qryBS_Rev.get("resultId")));
        }
        usedFilter_Rev.put("SerialNo", String.valueOf(qryUsedFilter.get(i).get("serialNo")));
        usedFilter_Rev.put("CodyId", CommonUtils.intNvl(qryUsedFilter.get(i).get("codyId")));
        usedFilter_Rev.put("ResultId", CommonUtils.intNvl(qryUsedFilter.get(i).get("resultId")));
        if (CommonUtils.intNvl(qryResultDet.get(i).get("bsResultPartQty")) > 0) {
          hsManualMapper.addbsResultDet_Rev(bsResultDet_Rev); // insert svc
                                                              // 0007d c
          hsManualMapper.addusedFilter_Rev(usedFilter_Rev); // insert log0082m

          checkInt++;
          if (i == (qryResultDet.size() - 1)) { // 마지막일때 넘기기

          }
        }
      }

      if (checkInt > 0) {
        hsManualMapper.addbsResultMas_Rev(bsResultMas_Rev); // svc 0006d B
                                                            // insert
        logger.debug("reverse JM" + String.valueOf(bsResultDet_Rev.get("BSResultID")));
        // 물류 프로시져 호출
        Map<String, Object> logPram = null;
        logPram = new HashMap<String, Object>();
        logPram.put("ORD_ID", String.valueOf(bsResultDet_Rev.get("BSResultID")));
        logPram.put("RETYPE", "RETYPE");
        logPram.put("P_TYPE", "OD06");
        logPram.put("P_PRGNM", "HSCEN");
        logPram.put("USERID", String.valueOf(sessionVO.getUserId()));

        Map SRMap = new HashMap();
        logger.debug("ASManagementListServiceImpl.asResult_update in  CENCAL  물류 차감  PRAM ===>" + logPram.toString());
        servicesLogisticsPFCMapper.SP_LOGISTIC_REQUEST_REVERSE(logPram);
        logger.debug("ASManagementListServiceImpl.asResult_update  in  CENCAL 물류 차감 결과   ===>" + logPram.toString());
      }

      EgovMap qry_stkReqM = null;
      qry_stkReqM = hsManualMapper.selectQry_stkReqM(bsResultMas_Rev);

      if (qry_stkReqM != null) {
        String PDONo = null;
        int PDO_REQUEST = 26;
        bsResultMas_Rev.put("docType", PDO_REQUEST);
        PDONo = hsManualMapper.GetDocNo(bsResultMas_Rev);
        bsResultMas_Rev.put("PDONo", PDONo);

        String PDO_REQUEST_PDO = "PDO";

        String nextDocNo_PDO = getNextDocNo(PDO_REQUEST_PDO, PDONo);

        bsResultMas_Rev.put("ID_New", PDO_REQUEST);
        bsResultMas_Rev.put("nextDocNo_New", nextDocNo_PDO);
        hsManualMapper.updateQry_New(bsResultMas_Rev);
        /*
         * String DocNoFormat_pod = ""; for (int i = 1; i <=
         * PDO_REQUEST_PDO.length(); i++) { DocNoFormat_pod += "0"; }
         * DocNoFormat_pod = "{0:" + DocNoFormat_pod + "}";
         *
         * docNo_int = Integer.parseInt(PDONo.replace(PDO_REQUEST_PDO,
         * "").toString()); int nextDocNo_PDO = docNo_int +1;
         * bsResultMas_Rev.put("nextNo", nextDocNo_PDO);
         *
         * int qry_PDO = hsManualMapper.GetDocNo1(bsResultMas_Rev);
         */
        Map<String, Object> stkReqM_Rev = new HashMap<String, Object>();
        // stkReqM_Rev.put("StkReqID", 0);
        stkReqM_Rev.put("StkReqNo", String.valueOf(PDONo));
        stkReqM_Rev.put("StkReqLocFromID", String.valueOf(qry_stkReqM.get("stkReqLocFromId")));// STK_REQ_LOC_FROM_ID
        stkReqM_Rev.put("StkReqLocToID", String.valueOf(qry_stkReqM.get("stkReqLocToId")));// STK_REQ_LOC_TO_ID
        stkReqM_Rev.put("StkReqRemark", String.valueOf(qry_stkReqM.get("stkReqRem")));// STK_REQ_REM
        stkReqM_Rev.put("StkReqCreateAt", "sysdate");// STK_REQ_REM
        stkReqM_Rev.put("StkReqCreateBy", String.valueOf(sessionVO.getUserId()));// STK_REQ_REM

        hsManualMapper.addstkReqM_Rev(stkReqM_Rev);

        int LocationID_Rev = 0;
        if (Integer.parseInt(qryBS_Rev.get("codyId").toString()) != 0) {
          LocationID_Rev = hsManualMapper.getMobileWarehouseByMemID(qryBS_Rev);
        }

        int stkReqM_StkReqID = hsManualMapper.getStkReqM_StkReqID();

        EgovMap qryBS = null;
        qryBS = hsManualMapper.selectQryBS(bsResultMas);
        // bsResultMas_Rev.put("ResultMatchID
        EgovMap qry_stkReqD_Rev = null;
        qry_stkReqD_Rev = hsManualMapper.qry_stkReqD_Rev(bsResultMas_Rev);
        int stkCrdCounter_Rev = 1;
        for (int i = 0; i < qry_stkReqD_Rev.size(); i++) {
          Map<String, Object> stkReqD_Rev = new HashMap<String, Object>();
          // stkReqD_Rev.put("ReqItemID", 0);//sequence
          stkReqD_Rev.put("ReqID", String.valueOf(stkReqM_StkReqID));//
          stkReqD_Rev.put("ReqItemTypeID", String.valueOf("464"));//
          stkReqD_Rev.put("ReqItemRefID", String.valueOf(BSResultM_resultID));// BSResultM_resultID
          stkReqD_Rev.put("ReqItemStkID", String.valueOf(qryBS.get("bsResultPartId")));// BS_RESULT_PART_ID
          stkReqD_Rev.put("ReqItemStkDesc", String.valueOf(qryBS.get("bsResultPartDesc")));//
          stkReqD_Rev.put("ReqItemQty", Integer.parseInt(qryBS.get("bsResultPartQty").toString()) * -1);//
          stkReqD_Rev.put("ReqItemStatusID", String.valueOf(1));//
          stkReqD_Rev.put("ReqItemRemark", "");// BS_RESULT_REM

          hsManualMapper.addStkReqD_Rev(stkReqD_Rev);

          Map<String, Object> stkCrd_Rev = new HashMap<String, Object>();
          stkCrd_Rev.put("LocationID", LocationID_Rev);
          stkCrd_Rev.put("StockID", qry_stkReqD_Rev.get("bsResultPartId"));// BS_RESULT_PART_ID
          stkCrd_Rev.put("EntryDate", "sysdate");//
          stkCrd_Rev.put("TypeID", String.valueOf("464"));//
          stkCrd_Rev.put("RefNo", qryBS.get("no"));
          stkCrd_Rev.put("SalesOrderId", qryBS.get("salesOrdId"));// SALES_ORD_ID
          stkCrd_Rev.put("SourceID", String.valueOf(477));
          stkCrd_Rev.put("ProjectID", String.valueOf(0));
          stkCrd_Rev.put("BatchNo", String.valueOf(0));
          stkCrd_Rev.put("Qty", String.valueOf(qry_stkReqD_Rev.get("bsResultPartQty")));// BS_RESULT_PART_QTY
          stkCrd_Rev.put("CurrID", String.valueOf(479));
          stkCrd_Rev.put("CurrRate", String.valueOf(1));
          stkCrd_Rev.put("Cost", String.valueOf(0));
          stkCrd_Rev.put("Price", String.valueOf(0));
          stkCrd_Rev.put("Remark", "");
          stkCrd_Rev.put("SerialNo", "");
          stkCrd_Rev.put("InstallNo", qryBS_Rev.get("no"));
          stkCrd_Rev.put("CostDate", "sysdate");
          stkCrd_Rev.put("AppTypeID", String.valueOf("0"));
          stkCrd_Rev.put("StkGrade", "A");
          stkCrd_Rev.put("InstallFail", String.valueOf(1));
          stkCrd_Rev.put("IsSynch", String.valueOf(1));
          stkCrd_Rev.put("EntryMethodID", String.valueOf(764));
          stkCrd_Rev.put("Origin", "1");
          stkCrd_Rev.put("ItemNo", stkCrdCounter_Rev);

          hsManualMapper.addStkCrd_Rev(stkCrd_Rev);

          stkCrdCounter_Rev = stkCrdCounter_Rev + 1;
        }
      }

      Map<String, Object> qry_CurBS = new HashMap<String, Object>();
      qry_CurBS.put("ScheduleID", String.valueOf(bsResultMas.get("ScheduleID")));
      qry_CurBS.put("SalesOrderId", String.valueOf(bsResultMas.get("SalesOrderId")));
      qry_CurBS.put("userId", sessionVO.getUserId());

      hsManualMapper.updateQry_CurBS(qry_CurBS); // 업데이트 svc0006d

      String ResultNo_New = null;
      BS_RESULT = 11;
      bsResultMas_Rev.put("DOCNO", String.valueOf(BS_RESULT));

      eMap = hsManualMapper.getHsResultDocNo(bsResultMas_Rev);
      ResultNo_New = String.valueOf(eMap.get("hsrno")).trim();
      logger.info("###ResultNo_New: " + ResultNo_New);


      /*
      ResultNo_New = hsManualMapper.GetDocNo(bsResultMas_Rev);

      int ID_New = 11;
      String nextDocNo_New = getNextDocNo(BS_RESULT_BSR, ResultNo_New);

      Map<String, Object> qry_New = new HashMap<String, Object>();
      qry_New.put("ID_New", String.valueOf(BS_RESULT));
      qry_New.put("nextDocNo_New", String.valueOf(nextDocNo_New));
      hsManualMapper.updateQry_New(qry_New);*/

      int BSResultM_resultID2 = hsManualMapper.getBSResultM_resultID();
      bsResultMas.put("No", ResultNo_New);
      bsResultMas.put("ResultId", BSResultM_resultID2);
      bsResultMas.put("CodyId", String.valueOf(bsResultMas_Rev.get("codyId")));

      // 확인용
      int cnt = 0;
      for (int i = 0; i < bsResultDet.size(); i++) {
        Map<String, Object> row = bsResultDet.get(i);

        row.put("BSResultID", BSResultM_resultID2);

        Map<String, Object> usedFilter = bsResultDet.get(i);
        usedFilter.put("HSNo", String.valueOf(qryUsedFilter.get(0).get("no")));
        usedFilter.put("CustId", String.valueOf(qryUsedFilter.get(0).get("custId")));
        // usedFilter.put("CreatedDt",
        // String.valueOf(qryUsedFilter_2.get(i).get("resultCrtDt")));
        // usedFilter.put("PartId",
        // String.valueOf(bsResultDet.get(i).get("bsResultPartId")));
        // usedFilter.put("PartQty",
        // CommonUtils.intNvl(bsResultDet.get(i).get("bsResultPartQty")));
        // usedFilter.put("SerialNo",
        // String.valueOf(bsResultDet.get(i).get("serialNo")));
        usedFilter.put("CodyId", String.valueOf(qryUsedFilter.get(0).get("codyId")));
        usedFilter.put("ResultId", BSResultM_resultID2);

        if (row.get("BSResultPartQty") != null && !row.get("BSResultPartQty").toString().equals("0")) {
          hsManualMapper.addbsResultDet_Rev(row); // 인서트 svc 0007d
          hsManualMapper.addusedFilter(usedFilter);
          cnt++;
          if (i == (bsResultDet.size() - 1)) {
            logger.debug("request JM" + i + String.valueOf(row.get("BSResultID")));

          }

        }
      }

      if (cnt != 0) { // 0이 아닐 경우 인서트
        hsManualMapper.addbsResultMas(bsResultMas); // insert 1건 svc0006d
      } else if (cnt == 0) { // 0일 경우 업데이트
        if (bsResultMas.get("SettleDate") != null || bsResultMas.get("SettleDate") != "") {
          bsResultMas.put("SettleDate", String.valueOf(bsResultMas.get("SettleDate")));
        } else {
          bsResultMas.put("SettleDate", "01/01/1900");
        }
        logger.debug(">>>>>>>>>>bsResultMas : {}", bsResultMas);
        hsManualMapper.updatebsResultMas(bsResultMas); // UPDATE 1건 svc0006d
      }

      hsManualMapper.updateQry_CurBSZero(qry_CurBS);// 최신거 업데이트

      hsManualMapper.updateQrySchedule(bsResultMas);// 업데이트 00008d

      Map<String, Object> qrySchedule = new HashMap<String, Object>();
      qrySchedule = hsManualMapper.selectQrySchedule(bsResultMas);

      ////////////////////// 물류호출/////////////////////
      Map<String, Object> logPram2 = new HashMap<String, Object>();
      logPram2.put("ORD_ID", String.valueOf(qrySchedule.get("no")));
      logPram2.put("RETYPE", "COMPLET");
      logPram2.put("P_TYPE", "OD05");
      logPram2.put("P_PRGNM", "HSCOM");
      logPram2.put("USERID", sessionVO.getUserId());

      logger.debug("HSCOM 물류 호출 PRAM ===>" + logPram2.toString());
      servicesLogisticsPFCMapper.SP_LOGISTIC_REQUEST(logPram2);
      logger.debug("HSCOMCALL 물류 호출 결과 ===> {}", logPram2);

      hsManualMapper.updateQryConfig(bsResultMas);
      Map<String, Object> qryConfig = new HashMap<String, Object>();
      qryConfig = hsManualMapper.selectQryConfig(bsResultMas);

      if (Integer.parseInt(bsResultMas.get("ResultStatusCodeID").toString()) == 4) {
        hsManualMapper.updateQryConfig4(bsResultMas);
      } else {
        hsManualMapper.updateQryConfig(bsResultMas);
      }

      if (bsResultDet.size() > 0) {
        int ItemNo = 1;

        for (int i = 0; i < bsResultDet.size(); i++) {
          bsResultDet.get(i).put("BSResultID", BSResultM_resultID);

          int LocationID = 0;

          LocationID = hsManualMapper.selectLocationID(bsResultMas);

          if (LocationID != 0) {
            Map<String, Object> stkCrd_new = new HashMap<String, Object>();
            // stkCrd_new.put("SRCardID", 0); sequence
            stkCrd_new.put("LocationID", String.valueOf(LocationID));
            stkCrd_new.put("StockID", String.valueOf(bsResultDet.get(i).get("BSResultPartID")));
            stkCrd_new.put("EntryDate", "sysdate");
            stkCrd_new.put("TypeID", String.valueOf(462));
            stkCrd_new.put("RefNo", qrySchedule.get("no"));
            stkCrd_new.put("SalesOrderId", String.valueOf(bsResultMas.get("SalesOrderId")));
            stkCrd_new.put("ItemNo", String.valueOf(ItemNo));
            stkCrd_new.put("SourceID", String.valueOf(477));
            stkCrd_new.put("ProjectID", String.valueOf(0));
            stkCrd_new.put("BatchNo", String.valueOf(0));
            stkCrd_new.put("Qty", Integer.parseInt(bsResultDet.get(i).get("BSResultPartQty").toString()) * -1);
            stkCrd_new.put("CurrID", String.valueOf(479));
            stkCrd_new.put("CurrRate", String.valueOf(1));
            stkCrd_new.put("Cost", String.valueOf(0));
            stkCrd_new.put("Price", String.valueOf(0));
            stkCrd_new.put("Remark", "");
            stkCrd_new.put("SerialNo", "");
            stkCrd_new.put("InstallNo", bsResultMas.get("No"));
            stkCrd_new.put("CostDate", "1900-01-01");
            stkCrd_new.put("AppTypeID", String.valueOf(0));
            stkCrd_new.put("StkGrade", "A");
            stkCrd_new.put("InstallFail", String.valueOf(1));
            stkCrd_new.put("IsSynch", String.valueOf(1));
            stkCrd_new.put("EntryMethodID", String.valueOf(764));
            stkCrd_new.put("Origin", "1");

            hsManualMapper.addStkCrd_new(stkCrd_new);
          }
          Map<String, Object> qryFilter_param = new HashMap<String, Object>();
          // qryFilter_param.put("SrvConfigID",
          // String.valueOf(qryConfig.get("SrvConfigID")));
          qryFilter_param.put("SrvConfigID", String.valueOf(qryConfig.get("srvConfigId"))); // edit
                                                                                            // hgham
                                                                                            // 25-12
                                                                                            // -2017
          qryFilter_param.put("BSResultPartID", String.valueOf(bsResultDet.get(i).get("BSResultPartID")));
          qryFilter_param.put("BSResultPartIsRtrn", bsResultDet.get(i).get("BSResultPartIsRtrn"));
          qryFilter_param.put("SettleDate", String.valueOf(bsResultMas.get("SettleDate")));
          qryFilter_param.put("ResultCreator", String.valueOf(sessionVO.getUserId()));
          hsManualMapper.updateQryFilter(qryFilter_param);

          ItemNo = ItemNo + 1;
        }
      } else {
        /*
         * Map<String, Object> bsResultDet_NoFilter = new HashMap<String,
         * Object>(); bsResultDet_NoFilter.put("BSResultItemID",
         * String.valueOf(0)); bsResultDet_NoFilter.put("BSResultID",
         * BSResultM_resultID); bsResultDet_NoFilter.put("BSResultPartID",
         * String.valueOf(0)); bsResultDet_NoFilter.put("BSResultPartDesc", "");
         * bsResultDet_NoFilter.put("BSResultPartQty", String.valueOf(0));
         * bsResultDet_NoFilter.put("BSResultRemark", "0");
         * bsResultDet_NoFilter.put("BSResultCreateAt", "sysdate");
         * bsResultDet_NoFilter.put("BSResultCreateBy",
         * String.valueOf(sessionVO.getUserId()));
         * bsResultDet_NoFilter.put("BSResultFilterClaim", 1);
         *
         * hsManualMapper.addBsResultDet_NoFilter(bsResultDet_NoFilter); 이거때문에
         */
      }

    }
    return resultValue;
  }

  /**
   * TO-DO HS Edit Save-Serial version = UpdateHsResult2 + UpdateIsReturn
   *
   * @Author KR-MIN
   * @Date 2019. 12. 31.
   * @param params
   * @param docType
   * @param sessionVO
   * @return
   * @throws ParseException
   * @see com.coway.trust.biz.services.bs.HsManualService#UpdateHsResult2Serial(java.util.Map,
   *      java.util.List, com.coway.trust.cmmn.model.SessionVO)
   */
  @Override
  @Transactional
  public Map<String, Object> UpdateHsResult2Serial(Map<String, Object> params, List<Object> docType,
      SessionVO sessionVO, List<Object> updList) throws ParseException {

    Map<String, Object> resultValue = new HashMap<String, Object>();

    EgovMap UpdateHsResult = new EgovMap();

    List<Map<String, Object>> bsResultDet = new ArrayList<Map<String, Object>>();

    for (int i = 0; i < docType.size(); i++) {
      Map<String, Object> bsd = new HashMap<String, Object>();
      Map<String, Object> docSub = (Map<String, Object>) docType.get(i);
      logger.debug("docSub{} : " + docSub);

      // bsd.put("BSResultItemID",0 );
      bsd.put("BSResultID", String.valueOf(params.get("hidschdulId")));
      bsd.put("BSResultPartID", String.valueOf(docSub.get("stkId")));
      bsd.put("BSResultPartDesc", String.valueOf(docSub.get("stkDesc")));
      bsd.put("BSResultPartQty", String.valueOf(docSub.get("name")));
      bsd.put("BSResultPartIsRtrn", String.valueOf(docSub.get("isReturn")));
      bsd.put("BSResultRemark", "");
      // bsd.put("BSResultCreateAt",0 );
      bsd.put("BSResultCreateBy", String.valueOf(sessionVO.getUserId()));
      bsd.put("BSResultFilterClaim", String.valueOf(1));
      bsd.put("SerialNo", docSub.get("serialNo") != null ? String.valueOf(docSub.get("serialNo")) : "");
      bsd.put("filterSerialUnmatchReason", docSub.get("filterSerialUnmatchReason") != null ? String.valueOf(docSub.get("filterSerialUnmatchReason")) : "");
      bsd.put("sSerialNo", docSub.get("sSerialNo") != null ? String.valueOf(docSub.get("sSerialNo")) : "");
      bsd.put("oldSerialNo", docSub.get("oldSerialNo") != null ? String.valueOf(docSub.get("oldSerialNo")) : "");

      bsResultDet.add(bsd);
    }

    Map<String, Object> bsResultMas = new HashMap<String, Object>();
    // bsResultMas.put("ResultID", 0);
    bsResultMas.put("No", "");
    bsResultMas.put("TypeID", String.valueOf(306));
    bsResultMas.put("ScheduleID", String.valueOf(params.get("hidschdulId")));
    bsResultMas.put("SalesOrderId", String.valueOf(params.get("hidSalesOrdId")));

    if (params.get("cmbServiceMem") == null || params.get("cmbServiceMem") == "") {
      bsResultMas.put("CodyID", String.valueOf(sessionVO.getUserId()));
    } else {
      bsResultMas.put("CodyID", String.valueOf(params.get("cmbServiceMem")));
    }

    // bsResultMas.put("SettleDate", params.get("setlDt"));
    logger.debug(">>>>>>settleDt isEmpty : " + StringUtils.isEmpty(String.valueOf(params.get("settleDt")).trim()));
    if (params.get("settleDt") != null || params.get("settleDt") != "") {
      bsResultMas.put("SettleDate", String.valueOf(params.get("settleDt")));
    } else {
      bsResultMas.put("SettleDate", "01/01/1900");
    }

    if (params.get("cmbStatusType2") == null || params.get("cmbStatusType2") == "") {
      bsResultMas.put("ResultStatusCodeID", String.valueOf("0"));
    } else {
      bsResultMas.put("ResultStatusCodeID", String.valueOf(params.get("cmbStatusType2")));
    }

    if (params.get("failReason") == null || params.get("failReason") == "") {
      bsResultMas.put("FailReasonID", String.valueOf("0"));
    } else {
      bsResultMas.put("FailReasonID", String.valueOf(params.get("failReason")));
    }

    if (params.get("cmbCollectType") == null || params.get("cmbCollectType") == "") {
      bsResultMas.put("RenCollectionID", String.valueOf("0"));
    } else {
      bsResultMas.put("RenCollectionID", String.valueOf(params.get("cmbCollectType")));
    }
    // bsResultMas.put("RenCollectionID",
    // String.valueOf(params.get("cmbCollectType")));

    if (params.get("wareHouse") == null || params.get("wareHouse") == "") {
      bsResultMas.put("WarehouseID", String.valueOf("0"));
    } else {
      bsResultMas.put("WarehouseID", String.valueOf(params.get("wareHouse")));
    }

    // logger.debug("txtRemark isEmpty : " +
    // StringUtils.isEmpty(String.valueOf(params.get(""txtRemark"")).trim()));
    bsResultMas.put("ResultRemark", String.valueOf(params.get("txtRemark")));
    // [19-09-2018] ADD HS INSTRUCTION REMARK FOR MAPPER USE
    bsResultMas.put("ResultInstRemark", String.valueOf(params.get("txtInstruction")));

    /*
     * logger.debug("configBsRem isEmpty : " +
     * StringUtils.isEmpty(String.valueOf(params.get("configBsRem")).trim()));
     * if(StringUtils.isEmpty(String.valueOf(params.get("configBsRem")).trim()))
     * { bsResultMas.put("ResultRemark", String.valueOf(0)); }else{
     * bsResultMas.put("ResultRemark",
     * String.valueOf(params.get("configBsRem"))); }
     */

    // bsResultMas.put("ResultCreated", sysdate);
    bsResultMas.put("ResultCreator", String.valueOf(sessionVO.getUserId()));
    // bsResultMas.put("ResultUpdated", sysdate);
    bsResultMas.put("ResultIsSync", String.valueOf(1));
    bsResultMas.put("ResultIsEdit", String.valueOf(1));

    if (bsResultDet.size() > 0) {
      bsResultMas.put("ResultStockUse", String.valueOf(1));
    } else {
      bsResultMas.put("ResultStockUse", String.valueOf(0));
    }
    bsResultMas.put("ResultIsCurrent", String.valueOf(1));
    bsResultMas.put("ResultMatchID", String.valueOf(0));
    bsResultMas.put("ResultIsAdjust", String.valueOf(1));
    bsResultMas.put("bsPreferWeek", String.valueOf(params.get("srvBsWeek")));

    LocalDate currentDate = LocalDate.now();
    int stusCodeId = CommonUtils.intNvl(params.get("cmbStatusType2"));

    LocalDate defaultNextAppntDt = currentDate;
    if(stusCodeId == SalesConstants.STATUS_FAILED){
      defaultNextAppntDt = currentDate.withDayOfMonth(5).plusMonths(1);
    }else if(stusCodeId == SalesConstants.STATUS_CANCELLED) {
      defaultNextAppntDt = currentDate.withDayOfMonth(5).plusMonths(2);
    }else{
      // DO NOTHING
    }

    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    bsResultMas.put("nextAppntDt", stusCodeId == SalesConstants.STATUS_COMPLETED ? String.valueOf(params.get("nextAppntDt")) : dateFormatter.format(defaultNextAppntDt));
    bsResultMas.put("nextAppntTime", stusCodeId == SalesConstants.STATUS_COMPLETED ? String.valueOf(params.get("nextAppointmentTime")) : "0900");


    Map<String, Object> bsResultMas_Rev = new HashMap<String, Object>();

    String ResultNo_Rev = "";
    int BS_RESULT = 11;
    bsResultMas_Rev.put("DOCNO", BS_RESULT);

    String docNo = null;

    EgovMap eMap = hsManualMapper.getHsResultDocNo(bsResultMas_Rev);
    docNo = String.valueOf(eMap.get("hsrno")).trim();
    logger.info("###docNo: " + docNo);

    /*
    docNo = hsManualMapper.GetDocNo(bsResultMas_Rev);
    bsResultMas_Rev.put("docNo", docNo);

    String BS_RESULT_BSR = "HSR";

    String nextNo = getNextDocNo(BS_RESULT_BSR, docNo);
    *
     * String DocNoFormat = ""; for (int i = 1; i <= BS_RESULT_BSR.length();
     * i++) { DocNoFormat += "0"; } DocNoFormat = "{0:" + DocNoFormat + "}";
     *
     * int docNo_int = Integer.parseInt(docNo.replace(BS_RESULT_BSR,
     * "").toString()); int nextNo = docNo_int +1;
     *
    bsResultMas_Rev.put("ID_New", BS_RESULT);
    bsResultMas_Rev.put("nextDocNo_New", nextNo);
    hsManualMapper.updateQry_New(bsResultMas_Rev);*/
    // int docNo1 = hsManualMapper.GetDocNo1(bsResultMas_Rev);

    EgovMap qryBS_Rev = null;
    qryBS_Rev = hsManualMapper.selectQryBS_Rev(bsResultMas);
    logger.debug("qryBS_Rev : {}" + qryBS_Rev);

    if (qryBS_Rev != null) {
      // KR-OHK Barcode Save Rerverse Start
      Map<String, Object> setmap = new HashMap();
      setmap.put("serialNo", qryBS_Rev.get("lastSerialNo"));
      setmap.put("salesOrdId", qryBS_Rev.get("salesOrdId"));
      setmap.put("reqstNo", qryBS_Rev.get("no"));
      setmap.put("callGbn", "HS_REVERSE");
      setmap.put("mobileYn", "N");
      setmap.put("userId", sessionVO.getUserId());

      servicesLogisticsPFCMapper.SP_SVC_BARCODE_SAVE(setmap);

      String errCode = (String) setmap.get("pErrcode");
      String errMsg = (String) setmap.get("pErrmsg");

      logger.debug(">>>>>>>>>>>SP_SVC_BARCODE_SAVE HS_REVERSE ERROR CODE : " + errCode);
      logger.debug(">>>>>>>>>>>SP_SVC_BARCODE_SAVE HS_REVERSE ERROR MSG: " + errMsg);

      // pErrcode : 000 = Success, others = Fail
      if (!"000".equals(errCode)) {
        throw new ApplicationException(AppConstants.FAIL, "[ERROR]" + errCode + ":" + errMsg);
      }
      // KR-OHK Barcode Save Rerverse End

      int BSResultM_resultID = hsManualMapper.getBSResultM_resultID();
      bsResultMas_Rev.put("ResultID", BSResultM_resultID); // sequence
      bsResultMas_Rev.put("No", String.valueOf(docNo));
      bsResultMas_Rev.put("TypeID", String.valueOf("307"));
      bsResultMas_Rev.put("ScheduleID", String.valueOf(qryBS_Rev.get("schdulId")));
      bsResultMas_Rev.put("SalesOrderId", String.valueOf(qryBS_Rev.get("salesOrdId")));
      bsResultMas_Rev.put("CodyID", String.valueOf(qryBS_Rev.get("codyId")));
      bsResultMas_Rev.put("SettleDate", String.valueOf(qryBS_Rev.get("setlDt")));
      bsResultMas_Rev.put("ResultStatusCodeID", String.valueOf(qryBS_Rev.get("resultStusCodeId")));// RESULT_STUS_CODE_ID
      bsResultMas_Rev.put("FailReasonID", String.valueOf(qryBS_Rev.get("failResnId")));// FAIL_RESN_ID
      bsResultMas_Rev.put("RenCollectionID", String.valueOf(qryBS_Rev.get("renColctId")));// REN_COLCT_ID
      bsResultMas_Rev.put("WarehouseID", String.valueOf(qryBS_Rev.get("whId")));// WH_ID
      bsResultMas_Rev.put("ResultRemark", String.valueOf(qryBS_Rev.get("resultRem")));// RESULT_REM
      // bsResultMas_Rev.put("ResultCreated", "sysdate");
      bsResultMas_Rev.put("ResultCreator", String.valueOf(sessionVO.getUserId()));
      bsResultMas_Rev.put("ResultIsSync", String.valueOf(1));
      bsResultMas_Rev.put("ResultIsEdit", String.valueOf(0));
      bsResultMas_Rev.put("ResultStockUse", String.valueOf(qryBS_Rev.get("resultStockUse")));// RESULT_STOCK_USE
      bsResultMas_Rev.put("ResultIsCurrent", String.valueOf(1));
      bsResultMas_Rev.put("ResultMatchID", String.valueOf(qryBS_Rev.get("resultId")));// RESULT_ID
      bsResultMas_Rev.put("ResultIsAdjust", String.valueOf(1));

      int count = hsManualMapper.selectTotalFilter(bsResultMas_Rev);
      logger.debug("selectQryResultDet : {}" + bsResultMas_Rev);
      List<EgovMap> qryResultDet = hsManualMapper.selectQryResultDet(bsResultMas_Rev);
      List<EgovMap> qryUsedFilter;
      if (count == 0) {
        qryUsedFilter = hsManualMapper.selectQryUsedFilterNew(bsResultMas_Rev);

      } else {
        qryUsedFilter = hsManualMapper.selectQryUsedFilter(bsResultMas_Rev);

      }
      logger.debug("qryResultDet : {}" + qryResultDet);
      logger.debug("qryResultDet.size() : {}" + qryResultDet.size());

      int checkInt = 0;

      // bsResultDet
      Map<String, Object> bsResultDet_Rev = null;
      Map<String, Object> usedFilter_Rev = null;
      for (int i = 0; i < qryResultDet.size(); i++) {

        bsResultDet_Rev = new HashMap<String, Object>();
        usedFilter_Rev = new HashMap<String, Object>();
        // bsResultDet_Rev.put("BSResultItemID", 0);
        bsResultDet_Rev.put("BSResultID", BSResultM_resultID);
        bsResultDet_Rev.put("BSResultPartID", String.valueOf(qryResultDet.get(i).get("bsResultPartId")));// BS_RESULT_PART_ID
        bsResultDet_Rev.put("BSResultPartDesc", CommonUtils.nvl(qryResultDet.get(i).get("bsResultPartDesc")));// BS_RESULT_PART_DESC
        if (String.valueOf(qryBS_Rev.get("resultId")) != null && String.valueOf(qryBS_Rev.get("resultId")) != "") {
          bsResultDet_Rev.put("BSResultPartQty", CommonUtils.intNvl(qryResultDet.get(i).get("bsResultPartQty")) * -1);// BS_RESULT_PART_QTY
          logger.debug("jinmu {}" + String.valueOf(qryBS_Rev.get("resultId")));
        } else {
          bsResultDet_Rev.put("BSResultPartQty", CommonUtils.intNvl(qryResultDet.get(i).get("bsResultPartQty")));
          logger.debug("jinmu111 {}" + String.valueOf(qryBS_Rev.get("resultId")));
        }
        bsResultDet_Rev.put("BSResultRemark", CommonUtils.nvl(qryResultDet.get(i).get("bsResultRem")));// BS_RESULT_REM
        bsResultDet_Rev.put("BSResultCreateAt", "sysdate");// BS_RESULT_REM
        bsResultDet_Rev.put("BSResultCreateBy", String.valueOf(sessionVO.getUserId()));
        bsResultDet_Rev.put("BSResultFilterClaim", CommonUtils.intNvl(qryResultDet.get(i).get("bsResultFilterClm")));// BS_RESULT_FILTER_CLM

        usedFilter_Rev.put("HSNo", String.valueOf(qryUsedFilter.get(i).get("no")));
        usedFilter_Rev.put("CustId", CommonUtils.intNvl(qryUsedFilter.get(i).get("custId")));
        usedFilter_Rev.put("CreatedDt", String.valueOf(qryUsedFilter.get(i).get("resultCrtDt")));
        usedFilter_Rev.put("PartId", CommonUtils.intNvl(qryUsedFilter.get(i).get("bsResultPartId")));
        if (String.valueOf(qryBS_Rev.get("resultId")) != null && String.valueOf(qryBS_Rev.get("resultId")) != "") {
          usedFilter_Rev.put("PartQty", CommonUtils.intNvl(qryUsedFilter.get(i).get("bsResultPartQty")) * -1);// BS_RESULT_PART_QTY
          // logger.debug("jinmu {}" +
          // String.valueOf(qryBS_Rev.get("resultId")));
        } else {
          usedFilter_Rev.put("PartQty", CommonUtils.intNvl(qryUsedFilter.get(i).get("bsResultPartQty")));
          // logger.debug("jinmu111 {}" +
          // String.valueOf(qryBS_Rev.get("resultId")));
        }
        usedFilter_Rev.put("SerialNo", String.valueOf(qryUsedFilter.get(i).get("serialNo")));
        usedFilter_Rev.put("OldSerialNo", String.valueOf(qryUsedFilter.get(i).get("oldSerialNo")));
        usedFilter_Rev.put("CodyId", CommonUtils.intNvl(qryUsedFilter.get(i).get("codyId")));
        usedFilter_Rev.put("ResultId", CommonUtils.intNvl(qryUsedFilter.get(i).get("resultId")));
        if (CommonUtils.intNvl(qryResultDet.get(i).get("bsResultPartQty")) > 0) {
          hsManualMapper.addbsResultDet_Rev(bsResultDet_Rev); // insert svc
                                                              // 0007d c
          hsManualMapper.addusedFilter_Rev(usedFilter_Rev); // insert log0082m

          checkInt++;
          if (i == (qryResultDet.size() - 1)) { // 마지막일때 넘기기

          }
        }
      }

      if (checkInt > 0) {
        hsManualMapper.addbsResultMas_Rev(bsResultMas_Rev); // svc 0006d B
                                                            // insert
        logger.debug("reverse JM" + String.valueOf(bsResultDet_Rev.get("BSResultID")));
        // 물류 프로시져 호출
        Map<String, Object> logPram = null;
        logPram = new HashMap<String, Object>();
        logPram.put("ORD_ID", String.valueOf(bsResultDet_Rev.get("BSResultID")));
        logPram.put("RETYPE", "RETYPE");
        logPram.put("P_TYPE", "OD06");
        logPram.put("P_PRGNM", "HSCEN");
        logPram.put("USERID", String.valueOf(sessionVO.getUserId()));

        Map SRMap = new HashMap();
        logger.debug("ASManagementListServiceImpl.asResult_update in  CENCAL  물류 차감  PRAM ===>" + logPram.toString());
        // SP_LOGISTIC_REQUEST_REVERSE -> SP_LOGISTIC_REQUEST_REV_SERIAL
        servicesLogisticsPFCMapper.SP_LOGISTIC_REQUEST_REVERSE_SERIAL(logPram);
        logger.debug("ASManagementListServiceImpl.asResult_update  in  CENCAL 물류 차감 결과   ===>" + logPram.toString());

        if (!"000".equals(logPram.get("p1"))) {
          throw new ApplicationException(AppConstants.FAIL,
              "[ERROR]" + logPram.get("p1") + ":" + "AS EDIT Result Error");
        }
      }

      EgovMap qry_stkReqM = null;
      qry_stkReqM = hsManualMapper.selectQry_stkReqM(bsResultMas_Rev);

      if (qry_stkReqM != null) {
        String PDONo = null;
        int PDO_REQUEST = 26;
        bsResultMas_Rev.put("docType", PDO_REQUEST);
        PDONo = hsManualMapper.GetDocNo(bsResultMas_Rev);
        bsResultMas_Rev.put("PDONo", PDONo);

        String PDO_REQUEST_PDO = "PDO";

        String nextDocNo_PDO = getNextDocNo(PDO_REQUEST_PDO, PDONo);

        bsResultMas_Rev.put("ID_New", PDO_REQUEST);
        bsResultMas_Rev.put("nextDocNo_New", nextDocNo_PDO);
        hsManualMapper.updateQry_New(bsResultMas_Rev);
        /*
         * String DocNoFormat_pod = ""; for (int i = 1; i <=
         * PDO_REQUEST_PDO.length(); i++) { DocNoFormat_pod += "0"; }
         * DocNoFormat_pod = "{0:" + DocNoFormat_pod + "}";
         *
         * docNo_int = Integer.parseInt(PDONo.replace(PDO_REQUEST_PDO,
         * "").toString()); int nextDocNo_PDO = docNo_int +1;
         * bsResultMas_Rev.put("nextNo", nextDocNo_PDO);
         *
         * int qry_PDO = hsManualMapper.GetDocNo1(bsResultMas_Rev);
         */
        Map<String, Object> stkReqM_Rev = new HashMap<String, Object>();
        // stkReqM_Rev.put("StkReqID", 0);
        stkReqM_Rev.put("StkReqNo", String.valueOf(PDONo));
        stkReqM_Rev.put("StkReqLocFromID", String.valueOf(qry_stkReqM.get("stkReqLocFromId")));// STK_REQ_LOC_FROM_ID
        stkReqM_Rev.put("StkReqLocToID", String.valueOf(qry_stkReqM.get("stkReqLocToId")));// STK_REQ_LOC_TO_ID
        stkReqM_Rev.put("StkReqRemark", String.valueOf(qry_stkReqM.get("stkReqRem")));// STK_REQ_REM
        stkReqM_Rev.put("StkReqCreateAt", "sysdate");// STK_REQ_REM
        stkReqM_Rev.put("StkReqCreateBy", String.valueOf(sessionVO.getUserId()));// STK_REQ_REM

        hsManualMapper.addstkReqM_Rev(stkReqM_Rev);

        int LocationID_Rev = 0;
        if (Integer.parseInt(qryBS_Rev.get("codyId").toString()) != 0) {
          LocationID_Rev = hsManualMapper.getMobileWarehouseByMemID(qryBS_Rev);
        }

        int stkReqM_StkReqID = hsManualMapper.getStkReqM_StkReqID();

        EgovMap qryBS = null;
        qryBS = hsManualMapper.selectQryBS(bsResultMas);
        // bsResultMas_Rev.put("ResultMatchID
        EgovMap qry_stkReqD_Rev = null;
        qry_stkReqD_Rev = hsManualMapper.qry_stkReqD_Rev(bsResultMas_Rev);
        int stkCrdCounter_Rev = 1;
        for (int i = 0; i < qry_stkReqD_Rev.size(); i++) {
          Map<String, Object> stkReqD_Rev = new HashMap<String, Object>();
          // stkReqD_Rev.put("ReqItemID", 0);//sequence
          stkReqD_Rev.put("ReqID", String.valueOf(stkReqM_StkReqID));//
          stkReqD_Rev.put("ReqItemTypeID", String.valueOf("464"));//
          stkReqD_Rev.put("ReqItemRefID", String.valueOf(BSResultM_resultID));// BSResultM_resultID
          stkReqD_Rev.put("ReqItemStkID", String.valueOf(qryBS.get("bsResultPartId")));// BS_RESULT_PART_ID
          stkReqD_Rev.put("ReqItemStkDesc", String.valueOf(qryBS.get("bsResultPartDesc")));//
          stkReqD_Rev.put("ReqItemQty", Integer.parseInt(qryBS.get("bsResultPartQty").toString()) * -1);//
          stkReqD_Rev.put("ReqItemStatusID", String.valueOf(1));//
          stkReqD_Rev.put("ReqItemRemark", "");// BS_RESULT_REM

          hsManualMapper.addStkReqD_Rev(stkReqD_Rev);

          Map<String, Object> stkCrd_Rev = new HashMap<String, Object>();
          stkCrd_Rev.put("LocationID", LocationID_Rev);
          stkCrd_Rev.put("StockID", qry_stkReqD_Rev.get("bsResultPartId"));// BS_RESULT_PART_ID
          stkCrd_Rev.put("EntryDate", "sysdate");//
          stkCrd_Rev.put("TypeID", String.valueOf("464"));//
          stkCrd_Rev.put("RefNo", qryBS.get("no"));
          stkCrd_Rev.put("SalesOrderId", qryBS.get("salesOrdId"));// SALES_ORD_ID
          stkCrd_Rev.put("SourceID", String.valueOf(477));
          stkCrd_Rev.put("ProjectID", String.valueOf(0));
          stkCrd_Rev.put("BatchNo", String.valueOf(0));
          stkCrd_Rev.put("Qty", String.valueOf(qry_stkReqD_Rev.get("bsResultPartQty")));// BS_RESULT_PART_QTY
          stkCrd_Rev.put("CurrID", String.valueOf(479));
          stkCrd_Rev.put("CurrRate", String.valueOf(1));
          stkCrd_Rev.put("Cost", String.valueOf(0));
          stkCrd_Rev.put("Price", String.valueOf(0));
          stkCrd_Rev.put("Remark", "");
          stkCrd_Rev.put("SerialNo", "");
          stkCrd_Rev.put("InstallNo", qryBS_Rev.get("no"));
          stkCrd_Rev.put("CostDate", "sysdate");
          stkCrd_Rev.put("AppTypeID", String.valueOf("0"));
          stkCrd_Rev.put("StkGrade", "A");
          stkCrd_Rev.put("InstallFail", String.valueOf(1));
          stkCrd_Rev.put("IsSynch", String.valueOf(1));
          stkCrd_Rev.put("EntryMethodID", String.valueOf(764));
          stkCrd_Rev.put("Origin", "1");
          stkCrd_Rev.put("ItemNo", stkCrdCounter_Rev);

          hsManualMapper.addStkCrd_Rev(stkCrd_Rev);

          stkCrdCounter_Rev = stkCrdCounter_Rev + 1;
        }
      }

      Map<String, Object> qry_CurBS = new HashMap<String, Object>();
      qry_CurBS.put("ScheduleID", String.valueOf(bsResultMas.get("ScheduleID")));
      qry_CurBS.put("SalesOrderId", String.valueOf(bsResultMas.get("SalesOrderId")));
      qry_CurBS.put("userId", sessionVO.getUserId());

      hsManualMapper.updateQry_CurBS(qry_CurBS); // 업데이트 svc0006d

      String ResultNo_New = null;
      BS_RESULT = 11;
      bsResultMas_Rev.put("DOCNO", String.valueOf(BS_RESULT));

      eMap = hsManualMapper.getHsResultDocNo(bsResultMas_Rev);
      ResultNo_New = String.valueOf(eMap.get("hsrno")).trim();
      logger.info("###ResultNo_New: " + ResultNo_New);

      /*ResultNo_New = hsManualMapper.GetDocNo(bsResultMas_Rev);

      int ID_New = 11;
      String nextDocNo_New = getNextDocNo(BS_RESULT_BSR, ResultNo_New);

      Map<String, Object> qry_New = new HashMap<String, Object>();
      qry_New.put("ID_New", String.valueOf(BS_RESULT));
      qry_New.put("nextDocNo_New", String.valueOf(nextDocNo_New));
      hsManualMapper.updateQry_New(qry_New);*/

      int BSResultM_resultID2 = hsManualMapper.getBSResultM_resultID();
      bsResultMas.put("No", ResultNo_New);
      bsResultMas.put("ResultId", BSResultM_resultID2);
      bsResultMas.put("CodyId", String.valueOf(bsResultMas_Rev.get("codyId")));

      // 확인용
      int cnt = 0;
      for (int i = 0; i < bsResultDet.size(); i++) {
        Map<String, Object> row = bsResultDet.get(i);

        row.put("BSResultID", BSResultM_resultID2);

        Map<String, Object> usedFilter = bsResultDet.get(i);
        usedFilter.put("HSNo", String.valueOf(qryUsedFilter.get(0).get("no")));
        usedFilter.put("CustId", String.valueOf(qryUsedFilter.get(0).get("custId")));
        // usedFilter.put("CreatedDt",
        // String.valueOf(qryUsedFilter_2.get(i).get("resultCrtDt")));
        // usedFilter.put("PartId",
        // String.valueOf(bsResultDet.get(i).get("bsResultPartId")));
        // usedFilter.put("PartQty",
        // CommonUtils.intNvl(bsResultDet.get(i).get("bsResultPartQty")));
        // usedFilter.put("SerialNo",
        // String.valueOf(bsResultDet.get(i).get("serialNo")));
        usedFilter.put("CodyId", String.valueOf(qryUsedFilter.get(0).get("codyId")));
        usedFilter.put("ResultId", BSResultM_resultID2);

        if (row.get("BSResultPartQty") != null && !row.get("BSResultPartQty").toString().equals("0")) {
          hsManualMapper.addbsResultDet_Rev(row); // 인서트 svc 0007d
          hsManualMapper.addusedFilter(usedFilter);
          cnt++;
          if (i == (bsResultDet.size() - 1)) {
            logger.debug("request JM" + i + String.valueOf(row.get("BSResultID")));

          }

        }


      //September 2022 start - HLTANG - filter barcode scanner - update log0100m after serial has been used
        //check current key in serial no with last time key in serial no whether match
        /*if(row.get("serialNo").toString() != ""){
        	//previous have key in serial no, but key in diff with this time
        	if(row.get("sSerialNo").toString() != ""
        			&& (row.get("sSerialNo").toString() != row.get("sSerialNo").toString() )){


        	}
        	//previous didnt key in serial, but this time have
        	else if(row.get("sSerialNo").toString() == ""){
        		String filterBarcdNewSerialNo = row.get("serialNo").toString();
              	Map<String, Object> filter = new HashMap<String, Object>();
              	filter.put("serialNo", filterBarcdNewSerialNo);
              	filter.put("salesOrdId",  String.valueOf(bsResultMas.get("SalesOrderId")));
              	filter.put("serviceNo", String.valueOf(qryUsedFilter.get(0).get("no")));
              	int LocationID_Rev = 0;
                  if (Integer.parseInt(usedFilter.get("CodyId").toString()) != 0) {
                  	filter.put("codyId", usedFilter.get("CodyId"));
                  	LocationID_Rev = hsManualMapper.getMobileWarehouseByMemID(filter);
                  }
                  filter.put("lastLocId", LocationID_Rev);
                  int filterCnt = hsManualMapper.selectFilterSerial(filter);
              	if (filterCnt == 0) {
            	   throw new ApplicationException(AppConstants.FAIL, "[ERROR]" + "HS Result Error : Cody did not have this serial on hand "+ filter.get("serialNo").toString());
        	    }
              	hsManualMapper.updateHsFilterSerial(filter);
        	}
        }*/
      //September 2022 end - HLTANG
      }

      if (cnt != 0) { // 0이 아닐 경우 인서트
        hsManualMapper.addbsResultMas(bsResultMas); // insert 1건 svc0006d
      } else if (cnt == 0) { // 0일 경우 업데이트
        if (bsResultMas.get("SettleDate") != null || bsResultMas.get("SettleDate") != "") {
          bsResultMas.put("SettleDate", String.valueOf(bsResultMas.get("SettleDate")));
        } else {
          bsResultMas.put("SettleDate", "01/01/1900");
        }
        logger.debug(">>>>>>>>>>bsResultMas : {}", bsResultMas);
        hsManualMapper.updatebsResultMas(bsResultMas); // UPDATE 1건 svc0006d
      }

      hsManualMapper.updateQry_CurBSZero(qry_CurBS);// 최신거 업데이트

      hsManualMapper.updateQrySchedule(bsResultMas);// 업데이트 00008d

      Map<String, Object> qrySchedule = new HashMap<String, Object>();
      qrySchedule = hsManualMapper.selectQrySchedule(bsResultMas);

      ////////////////////// 물류호출/////////////////////
      Map<String, Object> logPram2 = new HashMap<String, Object>();
      logPram2.put("ORD_ID", String.valueOf(qrySchedule.get("no")));
      logPram2.put("RETYPE", "COMPLET");
      logPram2.put("P_TYPE", "OD05");
      logPram2.put("P_PRGNM", "HSCOM");
      logPram2.put("USERID", sessionVO.getUserId());

      logger.debug("HSCOM 물류 호출 PRAM ===>" + logPram2.toString());
      // SP_LOGISTIC_REQUEST -> SP_LOGISTIC_REQUEST_SERIAL
      servicesLogisticsPFCMapper.SP_LOGISTIC_REQUEST_SERIAL(logPram2);

      logger.debug("HSCOMCALL 물류 호출 결과 ===> {}", logPram2);

      if (!"000".equals(logPram2.get("p1"))) {
        throw new ApplicationException(AppConstants.FAIL,
            "[ERROR]" + logPram2.get("p1") + ":" + "HS Edit Result Error");
      }

      hsManualMapper.updateQryConfig(bsResultMas);
      Map<String, Object> qryConfig = new HashMap<String, Object>();
      qryConfig = hsManualMapper.selectQryConfig(bsResultMas);

      if (Integer.parseInt(bsResultMas.get("ResultStatusCodeID").toString()) == 4) {
        hsManualMapper.updateQryConfig4(bsResultMas);
      } else {
        hsManualMapper.updateQryConfig(bsResultMas);
      }

      for (int i = 0; i < qryResultDet.size(); i++) {
    	  Map<String, Object> qryFilter_param = new HashMap<String, Object>();
          // qryFilter_param.put("SrvConfigID",
          // String.valueOf(qryConfig.get("SrvConfigID")));
          qryFilter_param.put("SrvConfigID", String.valueOf(qryConfig.get("srvConfigId")));
          qryFilter_param.put("BSResultPartID", String.valueOf(qryResultDet.get(i).get("bsResultPartId")));
          qryFilter_param.put("SettleDate", String.valueOf(bsResultMas.get("SettleDate")));
          qryFilter_param.put("ResultCreator", String.valueOf(sessionVO.getUserId()));
          //qryFilter_param.put("oldSerialNo", old_qryFilter_param.get("oldSerialNo"));

          hsManualMapper.updateQryFilter_rev(qryFilter_param);
      }

      if (bsResultDet.size() > 0) {
        int ItemNo = 1;

        for (int i = 0; i < bsResultDet.size(); i++) {
          bsResultDet.get(i).put("BSResultID", BSResultM_resultID);

          int LocationID = 0;

          LocationID = hsManualMapper.selectLocationID(bsResultMas);

          if (LocationID != 0) {
            Map<String, Object> stkCrd_new = new HashMap<String, Object>();
            // stkCrd_new.put("SRCardID", 0); sequence
            stkCrd_new.put("LocationID", String.valueOf(LocationID));
            stkCrd_new.put("StockID", String.valueOf(bsResultDet.get(i).get("BSResultPartID")));
            stkCrd_new.put("EntryDate", "sysdate");
            stkCrd_new.put("TypeID", String.valueOf(462));
            stkCrd_new.put("RefNo", qrySchedule.get("no"));
            stkCrd_new.put("SalesOrderId", String.valueOf(bsResultMas.get("SalesOrderId")));
            stkCrd_new.put("ItemNo", String.valueOf(ItemNo));
            stkCrd_new.put("SourceID", String.valueOf(477));
            stkCrd_new.put("ProjectID", String.valueOf(0));
            stkCrd_new.put("BatchNo", String.valueOf(0));
            stkCrd_new.put("Qty", Integer.parseInt(bsResultDet.get(i).get("BSResultPartQty").toString()) * -1);
            stkCrd_new.put("CurrID", String.valueOf(479));
            stkCrd_new.put("CurrRate", String.valueOf(1));
            stkCrd_new.put("Cost", String.valueOf(0));
            stkCrd_new.put("Price", String.valueOf(0));
            stkCrd_new.put("Remark", "");
            stkCrd_new.put("SerialNo", "");
            stkCrd_new.put("InstallNo", bsResultMas.get("No"));
            stkCrd_new.put("CostDate", "1900-01-01");
            stkCrd_new.put("AppTypeID", String.valueOf(0));
            stkCrd_new.put("StkGrade", "A");
            stkCrd_new.put("InstallFail", String.valueOf(1));
            stkCrd_new.put("IsSynch", String.valueOf(1));
            stkCrd_new.put("EntryMethodID", String.valueOf(764));
            stkCrd_new.put("Origin", "1");

            hsManualMapper.addStkCrd_new(stkCrd_new);
          }
          Map<String, Object> qryFilter_param = new HashMap<String, Object>();
          // qryFilter_param.put("SrvConfigID",
          // String.valueOf(qryConfig.get("SrvConfigID")));
          qryFilter_param.put("SrvConfigID", String.valueOf(qryConfig.get("srvConfigId"))); // edit
                                                                                            // hgham
                                                                                            // 25-12
                                                                                            // -2017
          qryFilter_param.put("BSResultPartID", String.valueOf(bsResultDet.get(i).get("BSResultPartID")));
          qryFilter_param.put("BSResultPartIsRtrn", bsResultDet.get(i).get("BSResultPartIsRtrn"));
          qryFilter_param.put("SettleDate", String.valueOf(bsResultMas.get("SettleDate")));
          qryFilter_param.put("ResultCreator", String.valueOf(sessionVO.getUserId()));
          qryFilter_param.put("lastSerialNo", bsResultDet.get(i).get("SerialNo"));
          qryFilter_param.put("oldSerialNo", String.valueOf(bsResultDet.get(i).get("oldSerialNo")));
          hsManualMapper.updateQryFilter(qryFilter_param);

          ItemNo = ItemNo + 1;
        }
      } else {
        /*
         * Map<String, Object> bsResultDet_NoFilter = new HashMap<String,
         * Object>(); bsResultDet_NoFilter.put("BSResultItemID",
         * String.valueOf(0)); bsResultDet_NoFilter.put("BSResultID",
         * BSResultM_resultID); bsResultDet_NoFilter.put("BSResultPartID",
         * String.valueOf(0)); bsResultDet_NoFilter.put("BSResultPartDesc", "");
         * bsResultDet_NoFilter.put("BSResultPartQty", String.valueOf(0));
         * bsResultDet_NoFilter.put("BSResultRemark", "0");
         * bsResultDet_NoFilter.put("BSResultCreateAt", "sysdate");
         * bsResultDet_NoFilter.put("BSResultCreateBy",
         * String.valueOf(sessionVO.getUserId()));
         * bsResultDet_NoFilter.put("BSResultFilterClaim", 1);
         *
         * hsManualMapper.addBsResultDet_NoFilter(bsResultDet_NoFilter); 이거때문에
         */

      }

    }

    if (updList != null) {
      UpdateIsReturn(params, updList, sessionVO);
    }

    // KR-OHK Barcode Save Start
    Map<String, Object> setmapEdit = new HashMap();
    setmapEdit.put("serialNo", params.get("stockSerialNo"));
    setmapEdit.put("salesOrdId", params.get("hidSalesOrdId"));
    setmapEdit.put("reqstNo", bsResultMas.get("No"));
    setmapEdit.put("callGbn", "HS_EDIT");
    setmapEdit.put("mobileYn", "N");
    setmapEdit.put("userId", sessionVO.getUserId());

    servicesLogisticsPFCMapper.SP_SVC_BARCODE_SAVE(setmapEdit);

    String errCodeEdit = (String) setmapEdit.get("pErrcode");
    String errMsgEdit = (String) setmapEdit.get("pErrmsg");

    logger.debug(">>>>>>>>>>>SP_SVC_BARCODE_SAVE HS ERROR CODE : " + errCodeEdit);
    logger.debug(">>>>>>>>>>>SP_SVC_BARCODE_SAVE HS ERROR MSG: " + errMsgEdit);

    // pErrcode : 000 = Success, others = Fail
    if (!"000".equals(errCodeEdit)) {
      throw new ApplicationException(AppConstants.FAIL, "[ERROR]" + errCodeEdit + ":" + errMsgEdit);
    }
    // KR-OHK Barcode Save Start

    return resultValue;
  }

  @Override
  public int isHsAlreadyResult(Map<String, Object> params) {
    return hsManualMapper.isHsAlreadyResult(params);
  }

  @Override
  public int saveValidation(Map<String, Object> params) {
    return hsManualMapper.saveValidation(params);
  }

  @Override
  public EgovMap selectHsOrderInMonth(Map<String, Object> params) {
    if (params.get("ManuaMyBSMonth") != null) {
      StringTokenizer str1 = new StringTokenizer(params.get("ManuaMyBSMonth").toString());

      for (int i = 0; i <= 1; i++) {
        str1.hasMoreElements();
        String result = str1.nextToken("/"); // 특정문자로 자를시 사용

        logger.debug("iiiii: {}", i);

        if (i == 0) {
          params.put("myBSMonth", result);
          logger.debug("myBSMonth : {}", params.get("myBSMonth"));
        } else {
          params.put("myBSYear", result);
          logger.debug("myBSYear : {}", params.get("myBSYear"));
        }
      }
    }
    return hsManualMapper.selectHsOrderInMonth(params);
  }

  @Override
  public List<EgovMap> hSMgtResultViewResultFilter(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return hsManualMapper.hSMgtResultViewResultFilter(params);
  }

  @Override
  public EgovMap hSMgtResultViewResult(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return hsManualMapper.hSMgtResultViewResult(params);
  }

  @Override
  public List<EgovMap> assignDeptMemUp(Map<String, Object> params) {
    return hsManualMapper.assignDeptMemUp(params);
  }

  @Override
  public List<EgovMap> selectCMList(Map<String, Object> params) {
    return hsManualMapper.selectCMList(params);
  }

  @Override
  public int hsResultSync(Map<String, Object> params) {
    return hsManualMapper.hsResultSync(params);
  }

  @Override
  public EgovMap getBSFilterInfo(Map<String, Object> params) {
    return hsManualMapper.getBSFilterInfo(params);
  }

  // OMBAK - AS ENTRY RESULT & INVOICE BILLING -- TPY
  public Map<String, Object> saveASEntryResult(Map<String, Object> params) {

    params.put("DOCNO", "17");
    EgovMap eMap = hsManualMapper.getASEntryDocNo(params);

    EgovMap seqMap = hsManualMapper.getASEntryId(params);

    // AS ENTRY -- SVC0001D
    params.put("AS_ID", String.valueOf(seqMap.get("seq")).trim());
    params.put("AS_NO", String.valueOf(eMap.get("asno")).trim());
    params.put("AS_SO_ID", params.get("salesOrdId").toString());
    params.put("AS_MEM_ID", "0");
    params.put("AS_REQST_DT", params.get("settleDate").toString());
    params.put("AS_APPNT_DT", params.get("settleDate").toString());
    params.put("AS_BRNCH_ID", "0");
    params.put("AS_MALFUNC_ID", "9001700");// GENERAL REQUEST
    params.put("AS_MALFUNC_RESN_ID", "5");// AS DURING INSTALLATION
    // params.put("AS_REM_REQSTER", "716");
    params.put("AS_STUS_ID", "4");
    params.put("AS_SMS", "0");
    params.put("AS_CRT_USER_ID", params.get("userId").toString());
    params.put("AS_UPD_USER_ID", params.get("userId").toString());
    params.put("AS_TYPE_ID", "3154"); // ADD ON AS
    // params.put("AS_REQSTER_TYPE_ID", "95164777");
    params.put("AS_ALLOW_COMM", "1");
    // params.put("AS_CALLLOG_ID", String.valueOf(
    // ccrSeqMap.get("seq")).trim());
    params.put("NO", params.get("no").toString());

    // AS RESULT -- SVC0004D
    Map<String, Object> params2 = null;
    params2 = new HashMap<String, Object>();

    params2.put("DOCNO", "21");
    EgovMap seqMap2 = hsManualMapper.getResultASEntryId(params2);
    EgovMap eMap2 = hsManualMapper.getASEntryDocNo(params2);

    String AS_RESULT_ID = String.valueOf(seqMap2.get("seq"));
    String AS_RESULT_NO = String.valueOf(eMap2.get("asno"));

    params2.put("AS_RESULT_ID", AS_RESULT_ID);
    params2.put("AS_RESULT_NO", AS_RESULT_NO);
    params2.put("AS_ENTRY_ID", String.valueOf(seqMap.get("seq")).trim());
    params2.put("AS_SO_ID", params.get("salesOrdId").toString());
    params2.put("AS_CT_ID", "0");
    params2.put("AS_SETL_DT", params.get("settleDate").toString());
    params2.put("AS_SETL_TM", "0");
    params2.put("AS_RESULT_STUS_ID", "4");
    params2.put("AS_BRNCH_ID", "0");
    if ("API".equals(CommonUtils.nvl(params.get("stage")).toString())) {
      params2.put("AS_RESULT_REM", "SYSTEM AUTO INSERT VIA MOBILE ENTRY.");
    } else {
      params2.put("AS_RESULT_REM", "");
    }
    // params2.put("AS_RESULT_CRT_DT", "");
    params2.put("updator", params.get("userId").toString());
    params2.put("AS_MALFUNC_ID", "9001700"); // GENERAL REQUEST
    params2.put("AS_MALFUNC_RESN_ID", "5"); // AS DURING INSTALLATION
    params2.put("AS_FILTER_AMT", params.get("amt").toString());
    params2.put("AS_TOT_AMT", params.get("totalAmt").toString());
    params2.put("AS_RESULT_TYPE_ID", "457"); // AFTER SERVICE
    params2.put("AS_RESULT_UPD_DT", "");
    params2.put("AS_RESULT_UPD_USER_ID", "");
    params2.put("AS_DEFECT_TYPE_ID", "1103"); // DT5 - SERVICE MAINTANENCE
    params2.put("AS_DEFECT_ID", "662"); // I5 - OPERATING NORMALLY
    params2.put("AS_DEFECT_PART_ID", "1253"); // AI17 - LEAD ADAPTOR
    params2.put("AS_DEFECT_DTL_RESN_ID", "514"); // 11 - NO FILTER / PART CHANGE
    params2.put("AS_SLUTN_RESN_ID", "439"); // A2 - UPGRADE : UF , BOOSTER PUMP
                                            // , OPTIONAL
    params2.put("AS_RESULT_IS_CURR", "1");
    params2.put("AS_RESULT_MTCH_ID", "0");
    params2.put("AS_RESULT_NO_ERR", "");
    params2.put("AS_RESULT_MOBILE_ID", "");
    params2.put("APPNT_DT", "");
    params2.put("APPNT_TM", "");
    params2.put("IN_HUSE_REPAIR_REM", "");
    params2.put("IN_HUSE_REPAIR_REPLACE_YN", "");
    params2.put("IN_HUSE_REPAIR_PROMIS_DT", "");
    params2.put("IN_HUSE_REPAIR_GRP_CODE", "");
    params2.put("IN_HUSE_REPAIR_PRODUCT_CODE", "");
    params2.put("IN_HUSE_REPAIR_SERIAL_NO", "");
    params2.put("RESULT_CUST_NAME", "");
    params2.put("RESULT_MOBILE_NO", "");
    params2.put("RESULT_REP_EMAIL_NO", "");
    params2.put("RESULT_ACEPT_NAME", "");
    params2.put("SGN_DT", "");
    params2.put("TRNSC_ID", "");
    params2.put("NO", params.get("no").toString());

    // AS FILTER USE -- SVC0005D
    Map<String, Object> params3 = null;
    params3 = new HashMap<String, Object>();
    params3.put("AS_RESULT_ID", AS_RESULT_ID);
    params3.put("ASR_ITM_PART_ID", params.get("stkId").toString());
    params3.put("ASR_ITM_PART_DESC", params.get("stkDesc").toString());
    params3.put("ASR_ITM_PART_QTY", params.get("stkQty").toString());
    params3.put("ASR_ITM_PART_PRC", params.get("amt").toString());
    params3.put("ASR_ITM_CHRG_AMT", params.get("amt").toString());
    params3.put("ASR_ITM_REM", "");
    params3.put("ASR_ITM_CRT_USER_ID", params.get("userId").toString());
    // params3.put("ASR_ITM_CRT_DT", "");
    params3.put("ASR_ITM_EXCHG_ID", "0");
    params3.put("ASR_ITM_CHRG_FOC", "0");
    params3.put("ASR_ITM_CLM", "0");
    params3.put("ASR_ITM_TAX_CODE_ID", "0");
    params3.put("ASR_ITM_TXS_AMT", "0");
    // params3.put("SERIAL_NO", "");
    // params3.put("EXCHG_ID", "");
    // params3.put("FILTER_BARCD_SERIAL_NO", "");

    hsManualMapper.insertSVC0001D(params);
    hsManualMapper.insertSVC0004D(params2);
    hsManualMapper.insertSVC0005D(params3);

    EgovMap em = new EgovMap();

    em.put("AS_NO", String.valueOf(params.get("AS_NO")));
    em.put("AS_ID", String.valueOf(seqMap.get("seq")).trim());
    em.put("AS_RESULT_NO", AS_RESULT_NO);

    logger.debug("===================================");
    logger.debug(em.toString());
    logger.debug("===================================");
    return em;

  }

  public Map<String, Object> saveASTaxInvoice(Map<String, Object> params) {

    // TAX INVOICE
    // PAY0031D
    params.put("AS_SO_ID", params.get("salesOrdId").toString());
    params.put("DOCNO", "128");
    EgovMap invoiceDocNo = hsManualMapper.getASEntryDocNo(params);
    int taxInvcId = hsManualMapper.getSeqPay0031D();
    EgovMap taxPersonInfo = hsManualMapper.selectTaxInvoice(params);
    params.put("DOCNO", "22");
    EgovMap asBillDocNo = hsManualMapper.getASEntryDocNo(params);

    Map<String, Object> param = new HashMap();

    param.put("AS_SO_ID", params.get("salesOrdId").toString());
    param.put("taxInvcId", taxInvcId);
    param.put("taxInvcRefNo", String.valueOf(invoiceDocNo.get("asno")));
    param.put("taxInvcRefDt", "");
    param.put("taxInvcSvcNo", params.get("asResultNo").toString());
    param.put("taxInvcType", "118"); // AS INVOICE

    try {
      param.put("taxInvcCustName", taxPersonInfo.get("taxInvoiceCustName"));
      param.put("taxInvcCntcPerson", taxPersonInfo.get("taxInvoiceContPers"));
    } catch (Exception e) {

      param.put("taxInvcCustName", "");
      param.put("taxInvcCntcPerson", "");

    }

    param.put("taxInvcAddr1", "");
    param.put("taxInvcAddr2", "");
    param.put("taxInvcAddr3", "");
    param.put("taxInvcAddr4", "");
    param.put("taxInvcPostCode", "");
    param.put("taxInvcStateName", "");
    param.put("taxInvcCnty", "");
    param.put("taxInvcTaskId", "");
    param.put("taxInvcRem", "");
    param.put("taxInvcChrg", params.get("totalAmt").toString());
    param.put("taxInvcTxs", "0");
    param.put("taxInvcAmtDue", params.get("totalAmt").toString());
    param.put("taxInvcCrtDt", new Date());
    param.put("taxInvcCrtUserId", params.get("userId").toString());

    // PAY0032D
    Map<String, Object> param2 = new HashMap();

    param2.put("taxInvcId", taxInvcId);
    param2.put("invcItmType", "459"); // AS CHANGE FILTER
    param2.put("invcItmOrdNo", params.get("salesOrdId").toString());
    param2.put("invcItmPoNo", "");
    param2.put("invcItmCode", params.get("stkCode").toString());
    param2.put("invcItmDesc1", params.get("stkDesc").toString());
    param2.put("invcItmDesc2", "");
    param2.put("invcItmSerialNo", "");
    param2.put("invcItmQty", params.get("stkQty").toString());
    param2.put("invcItmUnitPrc", "");
    param2.put("invcItmGstRate", "0");
    param2.put("invcItmGstTxs", "0");
    param2.put("invcItmChrg", params.get("totalAmt").toString());
    param2.put("invcItmAmtDue", params.get("totalAmt").toString());
    param2.put("invcItmAdd1", "");
    param2.put("invcItmAdd2", "");
    param2.put("invcItmAdd3", "");
    param2.put("invcItmAdd4", "");
    param2.put("invcItmPostCode", "");
    param2.put("invcItmAreaName", "");
    param2.put("invcItmStateName", "");
    param2.put("invcItmCnty", "");
    param2.put("invcItmInstallDt", "");
    param2.put("invcItmRetnDt", "");
    param2.put("invcItmBillRefNo", "");

    // PAY0016D
    Map<String, Object> param3 = new HashMap();

    param3.put("accBillTaskId", "0");
    param3.put("accBillRefDt", new Date());
    param3.put("accBillRefNo", "1000");
    param3.put("accBillOrdId", params.get("salesOrdId").toString());
    param3.put("accBillTypeId", "1159"); // SYSTEM GENERATE BILL
    // param3.put("accBillModeId", "1263"); // AS BILL - SPARE PART
    param3.put("accBillModeId", "1163"); // AS BILL
    param3.put("accBillSchdulId", "0");
    param3.put("accBillSchdulPriod", "0");
    param3.put("accBillAdjId", "0");
    param3.put("accBillSchdulAmt", params.get("totalAmt").toString());
    param3.put("accBillAdjAmt", "0");
    param3.put("accBillTxsAmt", "0");
    param3.put("accBillNetAmt", params.get("totalAmt").toString());
    param3.put("accBillStus", "1");
    param3.put("accBillRem", String.valueOf(invoiceDocNo.get("asno")));
    param3.put("accBillCrtDt", new Date());
    param3.put("accBillCrtUserId", params.get("userId").toString());
    param3.put("accBillGrpId", "0");
    param3.put("accBillTaxCodeId", "0");
    param3.put("accBillTaxRate", "0");
    param3.put("accBillAcctCnvr", "0");
    param3.put("accBillCntrctId", "0");

    // PAY0006D
    Map<String, Object> param4 = new HashMap();

    param4.put("asId", params.get("asId").toString());
    param4.put("asDocNo", params.get("asResultNo").toString());
    param4.put("asLgDocTypeId", "163");// AS BILL
    param4.put("asLgDt", new Date());
    param4.put("asLgAmt", params.get("totalAmt").toString());
    param4.put("asLgUpdUserId", params.get("userId").toString());
    param4.put("asLgUpdDt", new Date());
    // pay0006dMap.put("asSoNo",""); //AS_SO_ID select
    param4.put("asResultNo", params.get("asResultNo").toString());
    param4.put("asSoId", params.get("salesOrdId").toString());
    param4.put("asAdvPay", "0");
    param4.put("r01", "0");

    // PAY0007D
    Map<String, Object> param5 = new HashMap();

    param5.put("billTypeId", "238"); // AS BILL
    param5.put("billSoId", params.get("salesOrdId").toString());
    param5.put("billMemId", "0");
    param5.put("billAsId", params.get("asId").toString());
    param5.put("billPayTypeId", "");
    param5.put("billNo", params.get("asResultNo").toString());
    param5.put("billMemShipNo", String.valueOf(asBillDocNo.get("asno")));
    param5.put("billDt", new Date());
    param5.put("billAmt", params.get("totalAmt").toString());
    param5.put("billRem", "");
    param5.put("billIsPaid", "1");
    param5.put("billIsComm", "0");
    param5.put("updUserId", params.get("userId").toString());
    param5.put("updDt", new Date());
    param5.put("syncChk", "0");
    param5.put("coursId", "0");
    param5.put("stusId", "1");

    hsManualMapper.insert_Pay0031d(param);
    hsManualMapper.insert_Pay0032d(param2);
    hsManualMapper.insert_Pay0016d(param3);
    hsManualMapper.insert_Pay0006d(param4);
    hsManualMapper.insert_Pay0007d(param5);

    EgovMap em = new EgovMap();

    em.put("TAX_INVC_ID", taxInvcId);
    em.put("TAX_INVC_REF_NO", String.valueOf(invoiceDocNo.get("asno")));

    logger.debug("===================================");
    logger.debug(em.toString());
    logger.debug("===================================");
    return em;

  }

  @Override
  public EgovMap checkStkDuration(Map<String, Object> params) {
    return hsManualMapper.checkStkDuration(params);
  }

  @Override
  public EgovMap checkHsBillASInfo(Map<String, Object> params) throws Exception {
	if (hsManualMapper.checkDuplicateReverse(params) >= 1) {
		throw new Exception("Duplicate reverse.");
	}
    if (params.get("revInd").equals("1")) {
      return hsManualMapper.checkHsBillASInfoPass(params);
    } else {
      return hsManualMapper.checkHsBillASInfo(params);
    }
  }

  public String reverseHSResult(Map<String, Object> params, SessionVO sessionVO) { // ADDED
                                                                                   // BY
                                                                                   // TPY
                                                                                   // -
                                                                                   // 18/06/2019

    logger.debug("reverseHSResult - params : " + params);

    params.put("SalesOrderId", params.get("salesOrdId"));
    params.put("ScheduleID", params.get("schdulId"));

    Map<String, Object> bsResultMas_Rev = new HashMap<String, Object>();

    int BS_RESULT = 11;
    bsResultMas_Rev.put("DOCNO", BS_RESULT);

    String docNo = null;

    EgovMap eMap = hsManualMapper.getHsResultDocNo(bsResultMas_Rev);
    docNo = String.valueOf(eMap.get("hsrno")).trim();
    logger.info("###docNo: " + docNo);

   /* String docNo = null;
    docNo = hsManualMapper.GetDocNo(bsResultMas_Rev);
    bsResultMas_Rev.put("docNo", docNo);

    String BS_RESULT_BSR = "HSR";

    String nextNo = getNextDocNo(BS_RESULT_BSR, docNo);

    bsResultMas_Rev.put("ID_New", BS_RESULT);
    bsResultMas_Rev.put("nextDocNo_New", nextNo);
    hsManualMapper.updateQry_New(bsResultMas_Rev);*/
    // int docNo1 = hsManualMapper.GetDocNo1(bsResultMas_Rev);

    EgovMap qryBS_Rev = null;
    logger.debug("reverseHSResult - params : " + params);
    qryBS_Rev = hsManualMapper.selectQryBS_Rev(params);
    logger.debug("qryBS_Rev : {}" + qryBS_Rev);

    if (qryBS_Rev != null) {
      int BSResultM_resultID = hsManualMapper.getBSResultM_resultID();
      bsResultMas_Rev.put("ResultID", BSResultM_resultID); // sequence
      bsResultMas_Rev.put("No", String.valueOf(docNo));
      bsResultMas_Rev.put("TypeID", String.valueOf("307"));
      bsResultMas_Rev.put("ScheduleID", String.valueOf(qryBS_Rev.get("schdulId")));
      bsResultMas_Rev.put("SalesOrderId", String.valueOf(qryBS_Rev.get("salesOrdId")));
      bsResultMas_Rev.put("CodyID", String.valueOf(qryBS_Rev.get("codyId")));
      bsResultMas_Rev.put("SettleDate", String.valueOf(qryBS_Rev.get("setlDt")));
      bsResultMas_Rev.put("ResultStatusCodeID", "4");// RESULT_STUS_CODE_ID --
                                                      // 12 - REOPEN CHANGE TO 4 - COMPLETE -- 20201111 BY TOMMY
      bsResultMas_Rev.put("FailReasonID", String.valueOf(qryBS_Rev.get("failResnId")));// FAIL_RESN_ID
      bsResultMas_Rev.put("RenCollectionID", String.valueOf(qryBS_Rev.get("renColctId")));// REN_COLCT_ID
      bsResultMas_Rev.put("WarehouseID", String.valueOf(qryBS_Rev.get("whId")));// WH_ID
      bsResultMas_Rev.put("ResultRemark", String.valueOf(qryBS_Rev.get("resultRem") + " HS Reversal - OMBAK"));// RESULT_REM
      // bsResultMas_Rev.put("ResultCreated", "sysdate");
      bsResultMas_Rev.put("ResultCreator", String.valueOf(sessionVO.getUserId()));
      bsResultMas_Rev.put("ResultIsSync", String.valueOf(1));
      bsResultMas_Rev.put("ResultIsEdit", String.valueOf(0));
      bsResultMas_Rev.put("ResultStockUse", String.valueOf(qryBS_Rev.get("resultStockUse")));// RESULT_STOCK_USE
      bsResultMas_Rev.put("ResultIsCurrent", String.valueOf(1));
      bsResultMas_Rev.put("ResultMatchID", String.valueOf(qryBS_Rev.get("resultId")));// RESULT_ID
      bsResultMas_Rev.put("ResultIsAdjust", String.valueOf(1));

      int count = hsManualMapper.selectTotalFilter(bsResultMas_Rev);
      logger.debug("selectQryResultDet : {}" + bsResultMas_Rev);
      List<EgovMap> qryResultDet = hsManualMapper.selectQryResultDet(bsResultMas_Rev);
      List<EgovMap> qryUsedFilter;
      if (count == 0) {
        qryUsedFilter = hsManualMapper.selectQryUsedFilterNew(bsResultMas_Rev);

      } else {
        qryUsedFilter = hsManualMapper.selectQryUsedFilter(bsResultMas_Rev);

      }
      logger.debug("qryResultDet : {}" + qryResultDet);
      logger.debug("qryResultDet.size() : {}" + qryResultDet.size());

      int checkInt = 0;

      // bsResultDet
      Map<String, Object> bsResultDet_Rev = null;
      Map<String, Object> usedFilter_Rev = null;
      for (int i = 0; i < qryResultDet.size(); i++) {

        bsResultDet_Rev = new HashMap<String, Object>();
        usedFilter_Rev = new HashMap<String, Object>();
        // bsResultDet_Rev.put("BSResultItemID", 0);
        bsResultDet_Rev.put("BSResultID", BSResultM_resultID);
        bsResultDet_Rev.put("BSResultPartID", String.valueOf(qryResultDet.get(i).get("bsResultPartId")));// BS_RESULT_PART_ID
        bsResultDet_Rev.put("BSResultPartDesc", CommonUtils.nvl(qryResultDet.get(i).get("bsResultPartDesc")));// BS_RESULT_PART_DESC
        if (String.valueOf(qryBS_Rev.get("resultId")) != null && String.valueOf(qryBS_Rev.get("resultId")) != "") {
          bsResultDet_Rev.put("BSResultPartQty", CommonUtils.intNvl(qryResultDet.get(i).get("bsResultPartQty")) * -1);// BS_RESULT_PART_QTY
          logger.debug("jinmu {}" + String.valueOf(qryBS_Rev.get("resultId")));
        } else {
          bsResultDet_Rev.put("BSResultPartQty", CommonUtils.intNvl(qryResultDet.get(i).get("bsResultPartQty")));
          logger.debug("jinmu111 {}" + String.valueOf(qryBS_Rev.get("resultId")));
        }
        bsResultDet_Rev.put("BSResultRemark",
            CommonUtils.nvl(qryResultDet.get(i).get("bsResultRem") + " HS Reversal - OMBAK"));// BS_RESULT_REM
        bsResultDet_Rev.put("BSResultCreateAt", "sysdate");// BS_RESULT_REM
        bsResultDet_Rev.put("BSResultCreateBy", String.valueOf(sessionVO.getUserId()));
        bsResultDet_Rev.put("BSResultFilterClaim", CommonUtils.intNvl(qryResultDet.get(i).get("bsResultFilterClm")));// BS_RESULT_FILTER_CLM

        usedFilter_Rev.put("HSNo", String.valueOf(qryUsedFilter.get(i).get("no")));
        usedFilter_Rev.put("CustId", CommonUtils.intNvl(qryUsedFilter.get(i).get("custId")));
        usedFilter_Rev.put("CreatedDt", String.valueOf(qryUsedFilter.get(i).get("resultCrtDt")));
        usedFilter_Rev.put("PartId", CommonUtils.intNvl(qryUsedFilter.get(i).get("bsResultPartId")));
        if (String.valueOf(qryBS_Rev.get("resultId")) != null && String.valueOf(qryBS_Rev.get("resultId")) != "") {
          usedFilter_Rev.put("PartQty", CommonUtils.intNvl(qryUsedFilter.get(i).get("bsResultPartQty")) * -1);// BS_RESULT_PART_QTY

        } else {
          usedFilter_Rev.put("PartQty", CommonUtils.intNvl(qryUsedFilter.get(i).get("bsResultPartQty")));

        }
        usedFilter_Rev.put("SerialNo", String.valueOf(qryUsedFilter.get(i).get("serialNo")));
        usedFilter_Rev.put("CodyId", CommonUtils.intNvl(qryUsedFilter.get(i).get("codyId")));
        usedFilter_Rev.put("ResultId", CommonUtils.intNvl(qryUsedFilter.get(i).get("resultId")));
        if (CommonUtils.intNvl(qryResultDet.get(i).get("bsResultPartQty")) > 0) {
          hsManualMapper.addbsResultDet_Rev(bsResultDet_Rev); // insert svc0007d

          hsManualMapper.addusedFilter_Rev(usedFilter_Rev); // insert log0082m

          checkInt++;
          if (i == (qryResultDet.size() - 1)) { // 마지막일때 넘기기

          }
        }
      }

      if (checkInt > 0) {
        hsManualMapper.addbsResultMas_Rev(bsResultMas_Rev); // insert svc0006d
        logger.debug("reverse JM" + String.valueOf(bsResultDet_Rev.get("BSResultID")));
        // 물류 프로시져 호출
        Map<String, Object> logPram = null;
        logPram = new HashMap<String, Object>();
        logPram.put("ORD_ID", String.valueOf(bsResultDet_Rev.get("BSResultID")));
        logPram.put("RETYPE", "RETYPE");
        logPram.put("P_TYPE", "OD06");
        logPram.put("P_PRGNM", "HSCEN");
        logPram.put("USERID", String.valueOf(sessionVO.getUserId()));

        logger.debug("HS Reversal Start ===>" + logPram.toString());

        // KR-OHK Serial check add start
        if ("Y".equals(params.get("serialRequireChkYn"))) {
          servicesLogisticsPFCMapper.SP_LOGISTIC_REQUEST_REVERSE_SERIAL(logPram);
        } else {
          servicesLogisticsPFCMapper.SP_LOGISTIC_REQUEST_REVERSE(logPram);
        }
        logger.debug("HS Reversal End  ===>" + logPram.toString());

        if (!"000".equals(logPram.get("p1"))) {
          throw new ApplicationException(AppConstants.FAIL,
              "[ERROR]" + logPram.get("p1") + ":" + "HS REVERSE Result Error");
        }
        // KR-OHK Serial check add end
      }
      Map<String, Object> bsResultMas = new HashMap<String, Object>();
      bsResultMas.put("ScheduleID", String.valueOf(qryBS_Rev.get("schdulId")));
      bsResultMas.put("CodyID", String.valueOf(qryBS_Rev.get("codyId")));
      bsResultMas.put("ResultStatusCodeID", "1");

      hsManualMapper.updateHsResultMas(bsResultMas_Rev); // update svc0006d
      hsManualMapper.updateQrySchedule(bsResultMas);// 업데이트 00008d

    }
    return docNo;
  }

  public String createCreditNote(Map<String, Object> params, SessionVO sessionVO) { // ADDED
                                                                                    // BY
                                                                                    // TPY
                                                                                    // -
                                                                                    // 18/06/2019
    int memoAdjustmentId = invoiceMapper.getAdjustmentId();
    String reportNo = commonMapper.selectDocNo("18");
    String adjustmentNo = "";
    adjustmentNo = commonMapper.selectDocNo("134");

    Map<String, Object> masterParamMap = null;
    masterParamMap = new HashMap<String, Object>();

    // 마스터 정보 등록
    masterParamMap.put("memoAdjustTypeID", 1293);
    masterParamMap.put("memoAdjustInvoiceNo", params.get("memoAdjustInvoiceNo").toString());
    masterParamMap.put("memoAdjustInvoiceTypeID", 128); // Coway Misc Invoice
    masterParamMap.put("memoAdjustStatusID", 4);
    masterParamMap.put("memoAdjustReasonID", 2038); // Invoice (Reversal)
    masterParamMap.put("memoAdjustRemark", "HS REVERSAL - OMBAK");
    masterParamMap.put("memoAdjustCreator", sessionVO.getUserId());
    masterParamMap.put("batchId", 0);
    masterParamMap.put("memoAdjustId", CommonUtils.intNvl(memoAdjustmentId));
    masterParamMap.put("memoAdjustRefNo", adjustmentNo);
    masterParamMap.put("memoAdjustReportNo", reportNo);
    masterParamMap.put("memoAdjustTaxesAmount", 0);
    masterParamMap.put("memoAdjustTotalAmount", params.get("memoAdjustTotalAmount").toString());

    params.put("memoAdjustId", CommonUtils.intNvl(memoAdjustmentId));

    logger.debug("Create Credit Note Start  ===>" + params);

    invoiceMapper.saveNewAdjMaster(masterParamMap); // PAY0011D

    invoiceMapper.saveNewAdjDetail(params);// PAY0012D

    invoiceMapper.saveNewAdjHist(masterParamMap); // PAY0122D

    params.put("adjId", memoAdjustmentId);

    int noteId = invoiceMapper.getNoteId();
    EgovMap masterData = invoiceMapper.selectAdjMasterForApprovalMisc(params);

    masterData.put("noteId", noteId);
    masterData.put("noteTypeId", 1293); // Credit Note
    masterData.put("userId", params.get("userId"));

    // 마스터 정보 등록(PAY0027D)
    invoiceMapper.insertAccTaxDebitCreditNote(masterData);

    List<EgovMap> detailDataList = invoiceMapper.selectAdjDetailsForApprovalMisc(params);
    HashMap<String, Object> ledgerMap = null;

    for (EgovMap obj : detailDataList) {
      // 상세 정보 등록(PAY0028D)
      obj.put("noteId", noteId);
      invoiceMapper.insertAccTaxDebitCreditNoteSub(obj);

      if ("459".equals(String.valueOf(obj.get("noteItmTypeId")))) { // AS Change
                                                                    // Filter
        // AS
        ledgerMap = new HashMap<String, Object>();
        ledgerMap.put("asDocNo", masterData.get("noteRefNo"));
        ledgerMap.put("asLgDocTypeId", 155); // Credit Notes
        ledgerMap.put("asLgAmt", Double.parseDouble(String.valueOf(obj.get("noteItmDueAmt"))) * -1.0);
        ledgerMap.put("asSoNo", obj.get("noteItmOrdNo"));
        ledgerMap.put("asSoId", obj.get("noteItmOrdId"));
        ledgerMap.put("asResultNo", masterData.get("noteGrpNo"));
        ledgerMap.put("asLgUpdUserId", sessionVO.getUserId());
        ledgerMap.put("asLgDt", new Date());
        ledgerMap.put("asLgUpdDt", new Date());
        ledgerMap.put("asAdvPay", "0");
        ledgerMap.put("r01", "0");

        // AS ledger 등록(PAY0006D)
        hsManualMapper.insert_Pay0006d(ledgerMap);

      }
    }
    logger.debug("Create Credit Note End  ===>" + params);

    return adjustmentNo + " / " + reportNo;
  }

  public String createASResults(Map<String, Object> params, SessionVO sessionVO) { // ADDED
                                                                                   // BY
                                                                                   // TPY
                                                                                   // -
                                                                                   // 18/06/2019
    // AS RESULT -- SVC0004D
    Map<String, Object> params2 = null;
    params2 = new HashMap<String, Object>();

    params2.put("DOCNO", "21");
    EgovMap seqMap2 = hsManualMapper.getResultASEntryId(params2);
    EgovMap eMap2 = hsManualMapper.getASEntryDocNo(params2);

    String AS_RESULT_NO = String.valueOf(eMap2.get("asno"));
    String AS_RESULT_ID = String.valueOf(seqMap2.get("seq"));

    String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);

    params2.put("AS_RESULT_ID", AS_RESULT_ID);
    params2.put("AS_RESULT_NO", AS_RESULT_NO);
    params2.put("AS_ENTRY_ID", params.get("asId").toString());
    params2.put("AS_SO_ID", params.get("salesOrdId").toString());
    params2.put("AS_CT_ID", "0");
    params2.put("AS_SETL_DT", toDay);
    params2.put("AS_SETL_TM", "0");
    params2.put("AS_RESULT_STUS_ID", "4");
    params2.put("AS_BRNCH_ID", "0");
    params2.put("AS_RESULT_REM", "HS REVERSAL - OMBAK");

    // params2.put("AS_RESULT_CRT_DT", "");
    params2.put("updator", sessionVO.getUserId());
    params2.put("AS_MALFUNC_ID", "9001700"); // GENERAL REQUEST
    params2.put("AS_MALFUNC_RESN_ID", "5"); // AS DURING INSTALLATION
    params2.put("AS_FILTER_AMT", CommonUtils.intNvl(params.get("invcItmChrg")) * -1);
    params2.put("AS_TOT_AMT", CommonUtils.intNvl(params.get("invcItmChrg")) * -1);
    params2.put("AS_RESULT_TYPE_ID", "457"); // AFTER SERVICE
    params2.put("AS_RESULT_UPD_DT", "");
    params2.put("AS_RESULT_UPD_USER_ID", "");
    params2.put("AS_DEFECT_TYPE_ID", "1103"); // DT5 - SERVICE MAINTANENCE
    params2.put("AS_DEFECT_ID", "662"); // I5 - OPERATING NORMALLY
    params2.put("AS_DEFECT_PART_ID", "1253"); // AI17 - LEAD ADAPTOR
    params2.put("AS_DEFECT_DTL_RESN_ID", "514"); // 11 - NO FILTER / PART CHANGE
    params2.put("AS_SLUTN_RESN_ID", "439"); // A2 - UPGRADE : UF , BOOSTER PUMP
                                            // , OPTIONAL
    params2.put("AS_RESULT_IS_CURR", "1");
    params2.put("AS_RESULT_MTCH_ID", "0");
    params2.put("AS_RESULT_NO_ERR", "");
    params2.put("AS_RESULT_MOBILE_ID", "");
    params2.put("APPNT_DT", "");
    params2.put("APPNT_TM", "");
    params2.put("IN_HUSE_REPAIR_REM", "");
    params2.put("IN_HUSE_REPAIR_REPLACE_YN", "");
    params2.put("IN_HUSE_REPAIR_PROMIS_DT", "");
    params2.put("IN_HUSE_REPAIR_GRP_CODE", "");
    params2.put("IN_HUSE_REPAIR_PRODUCT_CODE", "");
    params2.put("IN_HUSE_REPAIR_SERIAL_NO", "");
    params2.put("RESULT_CUST_NAME", "");
    params2.put("RESULT_MOBILE_NO", "");
    params2.put("RESULT_REP_EMAIL_NO", "");
    params2.put("RESULT_ACEPT_NAME", "");
    params2.put("SGN_DT", "");
    params2.put("TRNSC_ID", "");
    params2.put("NO", "");

    // AS FILTER USE -- SVC0005D
    Map<String, Object> params3 = null;
    params3 = new HashMap<String, Object>();
    params3.put("AS_RESULT_ID", AS_RESULT_ID);
    params3.put("ASR_ITM_PART_ID", params.get("bsResultPartId").toString());
    params3.put("ASR_ITM_PART_DESC", params.get("invcItmDesc1").toString());
    params3.put("ASR_ITM_PART_QTY", params.get("memoItemInvoiceItmQty").toString());
    params3.put("ASR_ITM_PART_PRC", CommonUtils.intNvl(params.get("invcItmChrg")) * -1);
    params3.put("ASR_ITM_CHRG_AMT", CommonUtils.intNvl(params.get("invcItmChrg")) * -1);
    params3.put("ASR_ITM_REM", "HS REVERSAL - OMBAK");
    params3.put("ASR_ITM_CRT_USER_ID", sessionVO.getUserId());
    // params3.put("ASR_ITM_CRT_DT", "");
    params3.put("ASR_ITM_EXCHG_ID", "0");
    params3.put("ASR_ITM_CHRG_FOC", "0");
    params3.put("ASR_ITM_CLM", "0");
    params3.put("ASR_ITM_TAX_CODE_ID", "0");
    params3.put("ASR_ITM_TXS_AMT", "0");

    // AS RESULT - SVC0004D WITH 0 AMOUNT

    // PAY0007D
    Map<String, Object> param5 = null;
    param5 = new HashMap<String, Object>();
    param5.put("billTypeId", "238"); // AS BILL
    param5.put("billSoId", params.get("salesOrdId").toString());
    param5.put("billMemId", "0");
    param5.put("billAsId", params.get("asId").toString());
    param5.put("billPayTypeId", "");
    param5.put("billNo", AS_RESULT_NO);
    param5.put("billMemShipNo", "");
    param5.put("billDt", new Date());
    param5.put("billAmt", CommonUtils.intNvl(params.get("invcItmChrg")) * -1);
    param5.put("billRem", "HS REVERSAL - OMBAK");
    param5.put("billIsPaid", "1");
    param5.put("billIsComm", "0");
    param5.put("updUserId", sessionVO.getUserId());
    param5.put("updDt", new Date());
    param5.put("syncChk", "0");
    param5.put("coursId", "0");
    param5.put("stusId", "4");

    hsManualMapper.insertSVC0004D(params2);
    hsManualMapper.updateIsCurrent_SVC0004D(params2);
    hsManualMapper.insertSVC0005D(params3);
    hsManualMapper.insert_Pay0007d(param5);

    return AS_RESULT_NO;
  }

  public String createReverseASResults(Map<String, Object> params, SessionVO sessionVO) { // ADDED
                                                                                          // BY
                                                                                          // TPY
                                                                                          // -
                                                                                          // 18/06/2019

    Map<String, Object> params4 = null;
    params4 = new HashMap<String, Object>();

    params4.put("DOCNO", "21");
    EgovMap seqMap3 = hsManualMapper.getResultASEntryId(params4);
    EgovMap eMap3 = hsManualMapper.getASEntryDocNo(params4);

    String AS_RESULT_NO2 = String.valueOf(eMap3.get("asno"));
    String AS_RESULT_ID2 = String.valueOf(seqMap3.get("seq"));

    String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);

    params4.put("AS_RESULT_ID", AS_RESULT_ID2);
    params4.put("AS_RESULT_NO", AS_RESULT_NO2);
    params4.put("AS_ENTRY_ID", params.get("asId").toString());
    params4.put("AS_SO_ID", params.get("salesOrdId").toString());
    params4.put("AS_CT_ID", "0");
    params4.put("AS_SETL_DT", toDay);
    params4.put("AS_SETL_TM", "0");
    params4.put("AS_RESULT_STUS_ID", "4");
    params4.put("AS_BRNCH_ID", "0");
    params4.put("AS_RESULT_REM", "HS REVERSAL - OMBAK");

    // params2.put("AS_RESULT_CRT_DT", "");
    params4.put("updator", sessionVO.getUserId());
    params4.put("AS_MALFUNC_ID", "9001700"); // GENERAL REQUEST
    params4.put("AS_MALFUNC_RESN_ID", "5"); // AS DURING INSTALLATION
    params4.put("AS_FILTER_AMT", "0");
    params4.put("AS_TOT_AMT", "0");
    params4.put("AS_RESULT_TYPE_ID", "457"); // AFTER SERVICE
    params4.put("AS_RESULT_UPD_DT", "");
    params4.put("AS_RESULT_UPD_USER_ID", "");
    params4.put("AS_DEFECT_TYPE_ID", "1103"); // DT5 - SERVICE MAINTANENCE
    params4.put("AS_DEFECT_ID", "662"); // I5 - OPERATING NORMALLY
    params4.put("AS_DEFECT_PART_ID", "1253"); // AI17 - LEAD ADAPTOR
    params4.put("AS_DEFECT_DTL_RESN_ID", "514"); // 11 - NO FILTER / PART CHANGE
    params4.put("AS_SLUTN_RESN_ID", "439"); // A2 - UPGRADE : UF , BOOSTER PUMP
                                            // , OPTIONAL
    params4.put("AS_RESULT_IS_CURR", "1");
    params4.put("AS_RESULT_MTCH_ID", "0");
    params4.put("AS_RESULT_NO_ERR", "");
    params4.put("AS_RESULT_MOBILE_ID", "");
    params4.put("APPNT_DT", "");
    params4.put("APPNT_TM", "");
    params4.put("IN_HUSE_REPAIR_REM", "");
    params4.put("IN_HUSE_REPAIR_REPLACE_YN", "");
    params4.put("IN_HUSE_REPAIR_PROMIS_DT", "");
    params4.put("IN_HUSE_REPAIR_GRP_CODE", "");
    params4.put("IN_HUSE_REPAIR_PRODUCT_CODE", "");
    params4.put("IN_HUSE_REPAIR_SERIAL_NO", "");
    params4.put("RESULT_CUST_NAME", "");
    params4.put("RESULT_MOBILE_NO", "");
    params4.put("RESULT_REP_EMAIL_NO", "");
    params4.put("RESULT_ACEPT_NAME", "");
    params4.put("SGN_DT", "");
    params4.put("TRNSC_ID", "");
    params4.put("NO", "");

    hsManualMapper.insertSVC0004D(params4);

    return AS_RESULT_NO2;
  }

  // CREATE HS ORDER POP UP NOTIFICATION -- TPY 24/06/2019

  public EgovMap checkWarrentyStatus(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return hsManualMapper.checkWarrentyStatus(params);
  }

  public EgovMap checkSvcMembershipInfo(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return hsManualMapper.checkSvcMembershipInfo(params);
  }

  public EgovMap checkRentalStatusInfo(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return hsManualMapper.checkRentalStatusInfo(params);
  }

  public EgovMap checkOrderStatusInfo(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return hsManualMapper.checkOrderStatusInfo(params);
  }

  @Override
  public List<EgovMap> getAppTypeList(Map<String, Object> params) {
    return hsManualMapper.getAppTypeList(params);
  }

  // KR-OHK SERIAL ADD
  @Override
  public String addIHsResultSerial(Map<String, Object> params, SessionVO sessionVO) {
    String msg = "";
    boolean success = false;

    Map<String, Object> resultValue = new HashMap<String, Object>();

    Map<String, Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
    List<Object> insList = (List<Object>) params.get(AppConstants.AUIGRID_ADD);
    List<Object> updList = (List<Object>) params.get(AppConstants.AUIGRID_UPDATE);
    List<Object> remList = (List<Object>) params.get(AppConstants.AUIGRID_REMOVE);

    logger.debug("insList : {}", insList);

    resultValue = this.SaveResult(true, formMap, insList, sessionVO);

    int status = 0;
    status = Integer.parseInt(formMap.get("cmbStatusType").toString());

    if (null != resultValue && status == 4) {

      HashMap spMap = (HashMap) resultValue.get("spMap");

      logger.debug("spMap :========>" + spMap.toString());

      if (!"000".equals(spMap.get("P_RESULT_MSG"))) {

        resultValue.put("logerr", "Y");
        msg = "Logistics call Error.";
      } else {

        msg = "Complete to Add a HS Order : " + resultValue.get("resultId");
      }

      servicesLogisticsPFCMapper.SP_SVC_LOGISTIC_REQUEST_SERIAL(spMap);

      String errCode = (String) spMap.get("pErrcode");
      String errMsg = (String) spMap.get("pErrmsg");

      logger.debug(">>>>>>>>>>>SP_SVC_LOGISTIC_REQUEST_SERIAL ERROR CODE : " + errCode);
      logger.debug(">>>>>>>>>>>SP_SVC_LOGISTIC_REQUEST_SERIAL ERROR MSG: " + errMsg);

      // pErrcode : 000 = Success, others = Fail
      if (!"000".equals(errCode)) {
        throw new ApplicationException(AppConstants.FAIL, "[ERROR]" + errCode + ":" + errMsg);
      }

    } else if (null != resultValue && (status == 21 || status == 10)) {

      msg = "Complete to Add a HS Order : " + resultValue.get("resultId");

    }

    // CHECKING FILTER LIST IN SVC0007D
    params.put("selSchdulId", formMap.get("hidschdulId").toString());
    EgovMap useFilterList = this.getBSFilterInfo(params);
    // logger.debug("useFilterList : "+ useFilterList.toString());

    // INSERT AS ENTRY FOR OMBAK -- TPY
    if (useFilterList != null) {
      String stkId = useFilterList.get("stkId").toString();
      if (stkId.equals("1428")) { // 1428 - MINERAL FILTER
        logger.debug("==================== saveASEntryResult [Start] ========================");
        // logger.debug("saveASEntryResult params :"+ params.toString());

        params.put("userId", sessionVO.getUserId());
        params.put("salesOrdId", formMap.get("hidSalesOrdId").toString());
        params.put("codyId", formMap.get("hidCodyId").toString());
        params.put("settleDate", formMap.get("settleDate").toString());
        params.put("stkId", useFilterList.get("stkId").toString());
        params.put("stkCode", useFilterList.get("stkCode").toString());
        params.put("stkDesc", useFilterList.get("stkDesc").toString());
        params.put("stkQty", useFilterList.get("bsResultPartQty").toString());
        params.put("amt", useFilterList.get("amt").toString());
        params.put("totalAmt", useFilterList.get("totalAmt").toString());
        params.put("no", useFilterList.get("no").toString());
        // params.put("stkFilterId",
        // useFilterList.get("srvFilterId").toString());
        logger.debug("saveASEntryResult params :" + params.toString());

        Map<String, Object> sm = new HashMap<String, Object>();
        sm = this.saveASEntryResult(params);
        params.put("asNo", sm.get("asNo").toString());
        params.put("asId", sm.get("asId").toString());
        params.put("asResultNo", sm.get("asResultNo").toString());

        logger.debug("==================== saveASEntryResult [End] ========================");

        // INSERT TAX INVOICE FOR OMBAK -- TPY
        logger.debug("==================== saveASTaxInvoice [Start] ========================");
        logger.debug("saveASTaxInvoice params :" + params.toString());
        Map<String, Object> pb = new HashMap<String, Object>();
        pb = this.saveASTaxInvoice(params);

        logger.debug("==================== saveASTaxInvoice [End] ========================");

        msg = msg + "<br /> AS NO : " + sm.get("asNo").toString() + "<br /> AS REF : "
            + sm.get("asResultNo").toString();
      }
    }

    // KR-OHK Barcode Save Start
    Map<String, Object> setmapEdit = new HashMap();
    setmapEdit.put("serialNo", formMap.get("stockSerialNo"));
    setmapEdit.put("salesOrdId", formMap.get("hidSalesOrdId"));
    setmapEdit.put("reqstNo", resultValue.get("hsrNo"));
    setmapEdit.put("callGbn", "HS");
    setmapEdit.put("mobileYn", "N");
    setmapEdit.put("userId", sessionVO.getUserId());

    servicesLogisticsPFCMapper.SP_SVC_BARCODE_SAVE(setmapEdit);

    String errCodeEdit = (String) setmapEdit.get("pErrcode");
    String errMsgEdit = (String) setmapEdit.get("pErrmsg");

    logger.debug(">>>>>>>>>>>SP_SVC_BARCODE_SAVE HS ERROR CODE : " + errCodeEdit);
    logger.debug(">>>>>>>>>>>SP_SVC_BARCODE_SAVE HS ERROR MSG: " + errMsgEdit);

    // pErrcode : 000 = Success, others = Fail
    if (!"000".equals(errCodeEdit)) {
      throw new ApplicationException(AppConstants.FAIL, "[ERROR]" + errCodeEdit + ":" + errMsgEdit);
    }
    // KR-OHK Barcode Save Start

    return msg;
  }

  // KR-OHK SERIAL ADD
  @Override
  public String hsReversalSerial(Map<String, Object> params, SessionVO sessionVO) {
    String msg = "";
    String msg2 = "";

    String hsResultNo = "";
    String CNRefNo = "";
    String ASResultNo = "";
    String ReverseASResultNo = "";

    EgovMap stkInfo;
	try {
		stkInfo = this.checkHsBillASInfo(params);
	} catch (Exception e) {
		msg = "HS result already reversed.";
		return msg;
	} // CHECK HS /
                                                      // AS / BILL
                                                      // INFORMATION
                                                      // - ADDED BY
                                                      // TPY -
                                                      // 18/06/2019
    logger.debug("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ITM_STK_ID : " + stkInfo.get("itmStkId").toString());
    String stkItem = stkInfo.get("itmStkId").toString();
    if (stkItem.equals("1427")) { // OMBAK - STK ID // 1243 - DEV // 1427 - PRD

      // ADD FUNCTION TO REVERSE HS
      hsResultNo = this.reverseHSResult(params, sessionVO);
      msg2 += "<br / > HS RESULT NO : " + hsResultNo;

      if (stkInfo.get("brNo") != null) {
        params.put("memoAdjustInvoiceNo", stkInfo.get("brNo").toString());
        params.put("memoAdjustTotalAmount", stkInfo.get("invcItmAmtDue").toString());
        params.put("MemoItemInvoiceItemID", stkInfo.get("txinvoiceitemid").toString());
        params.put("memoItemInvoiceItmQty", stkInfo.get("invcItmQty").toString());
        params.put("memoItemCreditAccID", "39"); // TRADE RECEIVABLE - A/S
        params.put("memoItemDebitAccID", "167");// SALES - A/S
        params.put("memoItemTaxCodeID", 0);
        params.put("memoItemStatusID", "4");
        params.put("memoItemRemark", "HS REVERSAL - OMBAK");
        params.put("memoItemGSTRate", stkInfo.get("invcItmGstRate").toString());
        params.put("memoItemCharges", stkInfo.get("invcItmChrg").toString());
        params.put("memoItemTaxes", stkInfo.get("invcItmGstTxs").toString());
        params.put("memoItemAmount", stkInfo.get("invcItmAmtDue").toString());

        params.put("invcSvcNo", stkInfo.get("invcSvcNo").toString());
        params.put("asId", stkInfo.get("asId").toString());
        params.put("bsResultPartId", stkInfo.get("bsResultPartId").toString());
        params.put("invcItmUnitPrc", CommonUtils.nvl(stkInfo.get("invcItmUnitPrc")));
        params.put("invcItmChrg", stkInfo.get("invcItmChrg").toString());
        params.put("invcItmDesc1", stkInfo.get("invcItmDesc1").toString());

        logger.debug("hsReversal params --- : " + params);

        // ADD FUNCTION TO CREATE CN BILLING AND INVOICE
        CNRefNo = this.createCreditNote(params, sessionVO);

        // ADD FUNCTION TO REVERSE AS
        ASResultNo = this.createASResults(params, sessionVO);

        ReverseASResultNo = this.createReverseASResults(params, sessionVO);

        msg2 += "<br /> CREDIT NOTE REF NO : " + CNRefNo + "<br /> AS REF : " + ReverseASResultNo;
      }

      msg = "HS REVERSAL SUCCESSFUL. <br /> HS ORDER NO : " + stkInfo.get("salesOrdNo").toString() + "<br />  HS NO : "
          + stkInfo.get("no").toString() + msg2;

      // KR-OHK Barcode Save Start
      Map<String, Object> setmap = new HashMap();
      setmap.put("serialNo", stkInfo.get("lastSerialNo"));
      setmap.put("salesOrdId", stkInfo.get("salesOrdId"));
      setmap.put("reqstNo", stkInfo.get("hsrNo"));
      setmap.put("callGbn", "HS_REVERSE");
      setmap.put("mobileYn", "N");
      setmap.put("userId", sessionVO.getUserId());

      servicesLogisticsPFCMapper.SP_SVC_BARCODE_SAVE(setmap);

      String errCode = (String) setmap.get("pErrcode");
      String errMsg = (String) setmap.get("pErrmsg");

      logger.debug(">>>>>>>>>>>SP_SVC_BARCODE_SAVE HS_REVERSE ERROR CODE : " + errCode);
      logger.debug(">>>>>>>>>>>SP_SVC_BARCODE_SAVE HS_REVERSE ERROR MSG: " + errMsg);

      // pErrcode : 000 = Success, others = Fail
      if (!"000".equals(errCode)) {
        throw new ApplicationException(AppConstants.FAIL, "[ERROR]" + errCode + ":" + errMsg);
      }
      // KR-OHK Barcode Save Start

    } else {
      // msg = "HS REVERSAL ONLY ALLOW FOR OMBAK PRODUCT.";
      msg = "HS REVERSAL IS NOT ALLOWED FOR THIS HS.";
    }

    return msg;
  }

  /* Woongjin Jun */
  @Override
  @Transactional
  public Map<String, Object> addIHtResult(Map<String, Object> params, List<Object> docType, SessionVO sessionVO)
      throws Exception {
    return SaveCsResult(true, params, docType, sessionVO);
  }

  private Map<String, Object> SaveCsResult(boolean isfreepromo, Map<String, Object> params, List<Object> docType,
      SessionVO sessionVO) {
    logger.debug("=========================SaveResult - START - ===============================");

    int schdulId = Integer.parseInt(params.get("hidschdulId").toString());
    String docNo = commonMapper.selectDocNo("11");
    int masterCnt = hsManualMapper.selectHSResultMCnt(params);
    int nextSeq = hsManualMapper.getNextSvc006dSeq();

    EgovMap insertHsResultfinal = new EgovMap();
    String LOG_SVC0008D_NO = "";
    LOG_SVC0008D_NO = (String) hsManualMapper.getSVC008D_NO(params);

    if (masterCnt > 0) {
      params.put("resultId", nextSeq);
      hsManualMapper.insertHsResultCopy(params);
    } else {
      params.put("resultId", nextSeq);

      logger.debug("= Next Sequence : {}", nextSeq);
      logger.debug("= Param : {}", params);

      int status = 0;
      status = Integer.parseInt(params.get("cmbStatusType").toString());

      insertHsResultfinal.put("resultId", nextSeq);
      insertHsResultfinal.put("docNo", docNo);
      insertHsResultfinal.put("typeId", 306);
      insertHsResultfinal.put("schdulId", schdulId);
      insertHsResultfinal.put("salesOrdId", params.get("hidSalesOrdId"));
      insertHsResultfinal.put("codyId", params.get("hidCodyId"));

      // SET DEFAULT AS 01/01/1900 IF SETTLE DATE ARE EMPTY
      if (params.get("settleDate") != null || params.get("settleDate") != "") {
        insertHsResultfinal.put("setlDt", String.valueOf(params.get("settleDate")));
      } else {
        insertHsResultfinal.put("setlDt", "01/01/1900");
      }

      insertHsResultfinal.put("resultStusCodeId", params.get("cmbStatusType"));
      insertHsResultfinal.put("failResnId", params.get("failReason"));

      if (status == 4) { // COMPLETE
        insertHsResultfinal.put("renColctId", params.get("cmbCollectType"));
      } else if (status == 21 || status == 10) { // FAIL & CANCELLED
        insertHsResultfinal.put("renColctId", params.get("cmbCollectType"));
      }

      insertHsResultfinal.put("whId", params.get("wareHouse"));
      insertHsResultfinal.put("resultRem", params.get("remark"));
      insertHsResultfinal.put("resultCrtUserId", sessionVO.getUserId());
      insertHsResultfinal.put("resultUpdUserId", sessionVO.getUserId());

      insertHsResultfinal.put("resultIsSync", '0');
      insertHsResultfinal.put("resultIsEdit", '0');
      insertHsResultfinal.put("resultStockUse", '1');
      insertHsResultfinal.put("resultIsCurr", '1');
      insertHsResultfinal.put("resultMtchId", '0');
      insertHsResultfinal.put("resultIsAdj", '0');

      // FOR MOBILE APPS DATA
      insertHsResultfinal.put("temperateSetng", params.get("temperateSetng"));
      insertHsResultfinal.put("nextAppntDt", params.get("nextAppntDt"));
      insertHsResultfinal.put("nextAppointmentTime", params.get("nextAppointmentTime"));
      insertHsResultfinal.put("ownerCode", params.get("ownerCode"));
      insertHsResultfinal.put("resultCustName", params.get("resultCustName"));
      insertHsResultfinal.put("resultMobileNo", params.get("resultMobileNo"));
      insertHsResultfinal.put("resultRptEmailNo", params.get("resultRptEmailNo"));
      insertHsResultfinal.put("resultAceptName", params.get("resultAceptName"));
      insertHsResultfinal.put("sgnDt", params.get("sgnDt"));
      insertHsResultfinal.put("codeFailRemark", params.get("codeFailRemark"));

      //param not exist in  care service
//      insertHsResultfinal.put("instChklstCheckBox", params.get("instChklstCheckBox"));
//      insertHsResultfinal.put("voucherRedemption", params.get("voucherRedemption"));
//      insertHsResultfinal.put("switchChkLst", params.get("switchChkLst"));

      logger.debug("= INSERT SVC0006D START : {}", insertHsResultfinal);
      hsManualMapper.insertHsResultfinal(insertHsResultfinal); // INSERT SVC0006D

      //Filter Change Code start
      List<EgovMap> qryUsedFilter = hsManualMapper.selectQryUsedFilter2(insertHsResultfinal);

      logger.debug("= LOOP ITEM : {}", docType.size());

      for (int i = 0; i < docType.size(); i++) {
        Map<String, Object> docSub = (Map<String, Object>) docType.get(i);

            docSub.put("bsResultId", nextSeq);
            docSub.put("bsResultPartId", docSub.get("stkId"));
            docSub.put("bsResultPartDesc", docSub.get("stkDesc"));
            docSub.put("bsResultPartQty", docSub.get("name"));
            docSub.put("bsResultRem", "");
            docSub.put("bsResultCrtUserId", sessionVO.getUserId());
            docSub.put("bsResultFilterClm", docSub.get("name"));
            //docSub.put("serialNo", docSub.get("filterBarcdSerialNo"));
            String srcform = params.get("srcform") == null ? "" : params.get("srcform").toString();
            if(srcform.equals("WEB")){
            	docSub.put("filterBarcdNewSerialNo",docSub.get("serialNo"));
            }else{
            	docSub.put("oldSerialNo", docSub.get("filterBarcdSerialNoOld"));
            	docSub.put("serialNo", docSub.get("filterBarcdNewSerialNo"));
            	docSub.put("filterSerialUnmatchReason", docSub.get("filterSerialUnmatchReason"));
            }

            EgovMap docSub2 = new EgovMap();
            Map<String, Object> docSub3 = (Map<String, Object>) docType.get(i);
            int custId = hsManualMapper.selectCustomer(params);
            int codyId = hsManualMapper.selectCody(params);
            params.put("bsResultId", nextSeq);

            docSub2.put("hsNo", LOG_SVC0008D_NO);
            docSub2.put("custId", custId);
            docSub2.put("bsResultPartId", docSub3.get("stkId"));
            docSub2.put("bsResultPartQty", docSub3.get("name"));
            docSub2.put("serialNo", docSub3.get("serialNo"));
            docSub2.put("bsCodyId", codyId);
            docSub2.put("bsResultId", nextSeq);
            docSub2.put("oldSerialNo", docSub3.get("filterBarcdSerialNoOld"));

            String vstkId = String.valueOf(docSub.get("stkId"));
            String filterBarcdSerialNoOld = String.valueOf(docSub.get("filterBarcdSerialNoOld"));
            String filterBarcdNewSerialNo = String.valueOf(docSub.get("filterBarcdNewSerialNo"));
            String filterBarcdNewSerialNoWeb = String.valueOf(docSub.get("serialNo"));
            logger.debug("= STOCK ID : {}", vstkId);
            logger.debug("= filterBarcdSerialNoOld : {}", filterBarcdSerialNoOld);
            logger.debug("= filterBarcdNewSerialNo : {}", filterBarcdNewSerialNo);

            if (!"".equals(vstkId) && !("null").equals(vstkId) && vstkId != null) {
              logger.debug("= INSERT SVC0007D VIA docSub: {}", docSub);
              hsManualMapper.insertHsResultD(docSub); // INSERT SVC0007D
              logger.debug("= INSERT LOG0082M VIA docSub2: {}", docSub2);
              hsManualMapper.insertUsedFilter(docSub2); // INSERT LOG0082M

              docSub.put("hidOrdId", params.get("hidSalesOrdId"));

              String filterLastserial = "";

              if (!CommonUtils.nvl(docSub.get("srvFilterId")).equals("")) {
                filterLastserial = hsManualMapper.select0087DFilter(docSub);
              } else {
                filterLastserial = hsManualMapper.select0087DFilter2(docSub);
              }

              docSub.put("prvSerialNo", CommonUtils.nvl(filterLastserial));
              docSub.put("lastSerialNo", CommonUtils.nvl(docSub.get("serialNo")));
              docSub.put("settleDate", params.get("settleDate"));
              docSub.put("hidCodyId", params.get("hidCodyId"));
              params.put("srvConfigId", docSub.get("srvConfigId"));

              if (!CommonUtils.nvl(docSub.get("srvFilterId")).equals("")) {
                hsManualMapper.updateHsFilterSiriNo(docSub); // UPDATE SAL0087D
              } else {

                hsManualMapper.updateHsFilterSiriNo2(docSub); // UPDATE SAL0087D
              }

              //April 2022 start - HLTANG - filter barcode scanner - update log0100m after serial has been used
              if (!"".equals(filterBarcdNewSerialNo) && !("null").equals(filterBarcdNewSerialNo) && filterBarcdNewSerialNo != null) {
            	  Map<String, Object> filter = new HashMap<String, Object>();
            	  filter.put("serialNo", filterBarcdNewSerialNo);
            	  filter.put("salesOrdId", params.get("hidSalesOrdId"));
            	  if(srcform.equals("WEB")){
            		  filter.put("serviceNo", params.get("hidSalesOrdCd"));
            	  }else{
            		  filter.put("serviceNo", params.get("serviceNo"));
            	  }
            	  int LocationID_Rev = 0;
                  if (Integer.parseInt(params.get("hidCodyId").toString()) != 0) {
                	  filter.put("codyId", params.get("hidCodyId"));
                	  LocationID_Rev = hsManualMapper.getMobileWarehouseByMemID(filter);
                  }

                  filter.put("lastLocId", LocationID_Rev);
                  int filterCnt = hsManualMapper.selectFilterSerial(filter);
            	  if (filterCnt == 0) {
          	        throw new ApplicationException(AppConstants.FAIL, "[ERROR]" + "HS Result Error : Cody did not have this serial on hand "+ filter.get("serialNo").toString());
          	      }

            	  hsManualMapper.updateHsFilterSerial(filter);
              }
              //April 2022 end - HLTANG
            }
          }

      hsManualMapper.updateHs009d(params); // UPDATE SAL0090D
    }

    EgovMap getHsResultMList = hsManualMapper.selectHSResultMList(params); // GET
                                                                           // SVC0006D
    int scheduleCnt = hsManualMapper.selectHSScheduleMCnt(params);

    if (scheduleCnt > 0) {
      EgovMap insertHsScheduleM = new EgovMap();

      insertHsScheduleM.put("hidschdulId", params.get("hidschdulId"));
      insertHsScheduleM.put("resultStusCodeId", params.get("cmbStatusType"));
      insertHsScheduleM.put("actnMemId", getHsResultMList.get("codyId"));

      hsManualMapper.updateHsScheduleM(insertHsScheduleM); // UPDATE SVC0008D
    }

    EgovMap srvConfiguration = hsManualMapper.selectSrvConfiguration(params);

    if (srvConfiguration.size() > 0) {
      // COMPLETE
      if (getHsResultMList.get("resultStusCodeId").toString().equals("4")) {
/**
 * Frango check did not use insertHsSrvConfigM anymore
 * **/
//        EgovMap insertHsSrvConfigM = new EgovMap();
//        insertHsSrvConfigM.put("salesOrdId", getHsResultMList.get("salesOrdId"));
//        insertHsSrvConfigM.put("srvRem", params.get("instruction"));
//        insertHsSrvConfigM.put("srvPrevDt", params.get("settleDate"));
//        insertHsSrvConfigM.put("srvBsWeek", params.get("srvBsWeek"));

        EgovMap callMas = new EgovMap();
        callMas.put("hcsoid", getHsResultMList.get("salesOrdId"));
        callMas.put("hcTypeNo", params.get("hidSalesOrdCd"));
        callMas.put("crtUserId", sessionVO.getUserId());
        callMas.put("updUserId", sessionVO.getUserId());

        hsManualMapper.insertCcr0001d(callMas);
      }
    }

    // LOGISTICS CALL
    Map<String, Object> logPram = null;
    if (Integer.parseInt(params.get("cmbStatusType").toString()) == 4) { // COMPLETED
      logPram = new HashMap<String, Object>();
      logPram.put("ORD_ID", LOG_SVC0008D_NO);
      logPram.put("RETYPE", "COMPLET");
      logPram.put("P_TYPE", "OD05");
      logPram.put("P_PRGNM", "HSCOM");
      logPram.put("USERID", sessionVO.getUserId());

      logger.debug("= HSCOM LOGISTICS CALL PARAM ===>" + logPram.toString());

      logger.debug("= HSCOM params ===>" +params);
      logger.debug("= HSCOM params ===>" +params.get("hidSerialRequireChkYn").toString());

      // KR-OHK Serial check add start
      if ("Y".equals(params.get("hidSerialRequireChkYn"))) {
        servicesLogisticsPFCMapper.SP_LOGISTIC_REQUEST_SERIAL(logPram);
      } else {
        servicesLogisticsPFCMapper.SP_LOGISTIC_REQUEST(logPram);
      }
      logger.debug("= HSCOMCALL LOGISTICS CALL RESULT ===> {}", logPram);

      if (!"000".equals(logPram.get("p1"))) {
        throw new ApplicationException(AppConstants.FAIL, "[ERROR]" + logPram.get("p1") + ":" + "HS Result Error");
      }
      // KR-OHK Serial check add end

      logPram.put("P_RESULT_TYPE", "HS");
      logPram.put("P_RESULT_MSG", logPram.get("p1"));
    }


    Map<String, Object> resultValue = new HashMap<String, Object>();
    resultValue.put("resultId", params.get("hidSalesOrdCd"));
    resultValue.put("spMap", logPram);
    resultValue.put("resultDocNo", docNo);

    return resultValue;
  }
  /* Woongjin Jun */

  @Override
  public void updateDisinfecSrv(Map<String, Object> params) {
    hsManualMapper.updateDisinfecSrv(params);
  }

   @Override
  public List<EgovMap> instChkLst() {
	  return hsManualMapper.instChkLst();
  }

   @Override
   public void editHSEditSettleDate(Map<String, Object> params) {
     // TODO Auto-generated method stub
     hsManualMapper.editHSEditSettleDate(params);
   }

   // Self Service (DIY) Project - Service Type add by Fannie - 14/08/2024
   @Override
   public int getSrvTypeChgTm(Map<String, Object> params) {
     return hsManualMapper.getSrvTypeChgTm(params);
   }

   // Self Service (DIY) Project - Service Type add by Fannie - 14/08/2024
   @Override
   public EgovMap getPromoItemInfo(Map<String, Object> params) {
     return hsManualMapper.getPromoItemInfo(params);
   }

   // Self Service (DIY) Project - Service Type add by Fannie - 14/08/2024
   //  check the outstanding order
   @Override
   public List<EgovMap> getOderOutsInfo(Map<String, Object> params) {
     hsManualMapper.getOderOutsInfo(params);
    return (List<EgovMap>) params.get("p1");
   }

   // Self Service (DIY) Project - Service Type add by Fannie - 14/08/2024
   @Override
   public List<EgovMap> getSrvTypeChgHistoryLogInfo(Map<String, Object> params) {
     return hsManualMapper.getSrvTypeChgHistoryLogInfo(params);
   }

   // [Project ID 7139026265] Self Service (DIY) Project add by Fannie - 05/12/2024
   @Override
   public EgovMap getSrvTypeChgInfo(Map<String, Object> params) {
     return hsManualMapper.getSrvTypeChgInfo(params);
   }
}
