package com.coway.trust.biz.homecare.services.impl;

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
import com.coway.trust.biz.sales.ccp.impl.CcpAgreementMapper;
import com.coway.trust.biz.services.as.impl.ServicesLogisticsPFCMapper;
import com.coway.trust.biz.services.bs.impl.HsManualMapper;
import com.coway.trust.biz.homecare.services.htManualService;
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

@Service("htManualService")
public class htManualServiceImpl extends EgovAbstractServiceImpl implements htManualService {

  private static final Logger logger = LoggerFactory.getLogger(MemberEventListController.class);

  @Value("${app.name}")
  private String appName;

  @Resource(name = "commonMapper")
  private CommonMapper commonMapper;

  @Resource(name = "htManualMapper")
  private htManualMapper htManualMapper;

  @Resource(name = "hsManualMapper")
  private HsManualMapper hsManualMapper;

  @Resource(name = "returnUsedPartsService")
  private ReturnUsedPartsService returnUsedPartsService;

  @Resource(name = "servicesLogisticsPFCMapper")
  private ServicesLogisticsPFCMapper servicesLogisticsPFCMapper;

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

        logger.debug("selectHsConfigList : {}", i);

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

    return htManualMapper.selectHsConfigList(params);
  }

  @Override
  public List<EgovMap> selectHsManualList(Map<String, Object> params) {
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

    return htManualMapper.selectHsManualList(params);
  }

  @Override
  public List<EgovMap> selectHsAssiinlList(Map<String, Object> params) {
    // TODO Auto-generated method stub
    logger.debug("myBSMonth : {}", params.get("myBSMonth"));
    StringTokenizer str1 = new StringTokenizer(params.get("myBSMonth").toString());
    logger.debug("myBSMonth : {}", params.get("myBSMonth"));

    return htManualMapper.selectHsAssiinlList(params);
  }

  @Override
  public List<EgovMap> selectBranchList(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return htManualMapper.selectBranchList(params);
  }

  @Override
  public List<EgovMap> selectCtList(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return htManualMapper.selectCtList(params);
  }

  @Override
  public List<EgovMap> getCdUpMemList(Map<String, Object> params) {
    // TODO Auto-generated method stub
    params.put("memLvl", 3);
    return htManualMapper.getCdUpMemList(params);
  }

  @Override
  public List<EgovMap> getCdDeptList(Map<String, Object> params) {
    // TODO Auto-generated method stub
    params.put("memLvl", 3);
    return htManualMapper.getCdDeptList(params);
  }

  /*
   * BY KV - Change to textBox - txtcodyCode and below code no more used.
   *
   * @Override public List<EgovMap> getCdList(Map<String, Object> params) { //
   * TODO Auto-generated method stub params.put("memLvl", 4); return
   * htManualMapper.getCdUpMemList(params); }
   */

  @Override
  public List<EgovMap> getCdList_1(Map<String, Object> params) {
    // TODO Auto-generated method stub
    params.put("memLvl", 3);
    return htManualMapper.getCdList_1(params);
  }

  @Override
  public List<EgovMap> selectHsManualListPop(Map<String, Object> params) {
    // TODO Auto-generated method stub

    if (params.get("ManuaMyBSMonth") != null) {
      StringTokenizer str1 = new StringTokenizer(params.get("ManuaMyBSMonth").toString());

      for (int i = 0; i <= 1; i++) {
        str1.hasMoreElements();
        String result = str1.nextToken("/"); // 특정문자로 자를시 사용

        logger.debug("selectHsManualListPop : {}", i);

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

    return htManualMapper.selectHsManualListPop(params);
  }

  public Map<String, Object> insertHsResult(Map<String, Object> params, List<Object> docType , SessionVO sessionVO) {

    Boolean success = false;

    String appId = "";
    String saveDocNo = "";
    Map<String, Object> codeMap1 = new HashMap<String, Object>();
    Map<String, Object> MemApp = new HashMap<String, Object>();
    Map<String, Object> resultValue = new HashMap<String, Object>();

    for (int i = 0; i < docType.size(); i++) {
      // for(Object obj : docType){

      Map<String, Object> docSub = (Map<String, Object>) docType.get(i);

      String fomSalesOrdNo = (String) docSub.get("salesOrdNo");
      // int nextSchId = (int) docSub.get("salesOrdNo");
      int nextSchId = htManualMapper.getNextSchdulId();
      String docNo = commonMapper.selectDocNo("10");
      String yyyyDD = docSub.get("year").toString();
/*      if (docSub.get("year") != null) {
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

      }*/

      docSub.put("no", docNo);
      docSub.put("schdulId", nextSchId);
      docSub.put("salesOrdId", docSub.get("salesOrdId"));
      docSub.put("resultID", 0);
      // hsResult.put("custId", (params.get("custId").toString()));
      //docSub.put("salesOrdNo", String.format("%08d", fomSalesOrdNo));
      docSub.put("month", yyyyDD.substring(0,yyyyDD.indexOf("/")));
      docSub.put("year", yyyyDD.substring(yyyyDD.lastIndexOf("/")+1));
      docSub.put("typeId", "438");
      docSub.put("stus", docSub.get("stus"));
      docSub.put("lok", "4");
      docSub.put("lastSvc", "0");
      docSub.put("codyId", docSub.get("codyId"));
      docSub.put("creator", sessionVO.getUserId());
      docSub.put("created", new Date());

      htManualMapper.insertHsResult(docSub);
      // htManualMapper.insertHsResult((Map<String, Object>)obj);

      saveDocNo += docNo;

      if (docType.size() > 1 && docType.size() > i) {
        saveDocNo += ",";
      }

      resultValue.put("docNo", saveDocNo);
    }

    success = true;
    // htManualMapper.insertHsResult(MemApp);

    return resultValue;
  }

  private boolean Save(boolean isfreepromo, Map<String, Object> params, SessionVO sessionVO) throws ParseException {

    String appId = "";
    Map<String, Object> codeMap1 = new HashMap<String, Object>();
    Map<String, Object> MemApp = new HashMap<String, Object>();

    htManualMapper.insertHsResult(MemApp);

    insertHs(MemApp);

    return true;
  }

  @Transactional
  private boolean insertHs(Map<String, Object> hsResult) throws ParseException {

    String appId = "";
    Map<String, Object> codeMap1 = new HashMap<String, Object>();
    Map<String, Object> MemApp = new HashMap<String, Object>();

    htManualMapper.insertHsResult(MemApp);
    return true;
  }

  @Override
  public EgovMap selectHsInitDetailPop(Map<String, Object> params) {
    // TODO Auto-generated method stub

    return htManualMapper.selectHsInitDetailPop(params);
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

    int schdulId = Integer.parseInt(params.get("hidschdulId").toString());
    String docNo = commonMapper.selectDocNo("11");
    // EgovMap selectHSResultMList = htManualMapper.selectHSResultMList(params);
    int masterCnt = htManualMapper.selectHSResultMCnt(params);
    // EgovMap selectDetailList = htManualMapper.selectDetailList(params);
    int nextSeq = htManualMapper.getNextSvc006dSeq();

    EgovMap insertHsResultfinal = new EgovMap();
    String LOG_SVC0008D_NO = "";
    LOG_SVC0008D_NO = (String) htManualMapper.getSVC008D_NO(params);

    if (masterCnt > 0) { // master y
      params.put("resultId", nextSeq);
      htManualMapper.insertHsResultCopy(params);

    } else {// master n
      params.put("resultId", nextSeq);

      logger.debug("nextSeq : {}", nextSeq);
      logger.debug("nextSeq : {}", params);

      int status = 0;
      status = Integer.parseInt(params.get("cmbStatusType").toString());

      // BSResultM
      insertHsResultfinal.put("resultId", nextSeq);

      insertHsResultfinal.put("docNo", docNo);
      insertHsResultfinal.put("typeId", 306);
      insertHsResultfinal.put("schdulId", schdulId);
      insertHsResultfinal.put("salesOrdId", params.get("hidSalesOrdId"));
      insertHsResultfinal.put("codyId", params.get("hidCodyId"));

      // insertHsResultfinal.put("setlDt", params.get("settleDate"));
      if (params.get("settleDate") != null || params.get("settleDate") != "") {
        insertHsResultfinal.put("setlDt", String.valueOf(params.get("settleDate")));
      } else {
        insertHsResultfinal.put("setlDt", "01/01/1900");
      }

      insertHsResultfinal.put("resultStusCodeId", params.get("cmbStatusType"));
      insertHsResultfinal.put("failResnId", params.get("failReason"));
      insertHsResultfinal.put("renColctId", params.get("cmbCollectType"));

//      if (status == 4) { // Completed
//        insertHsResultfinal.put("renColctId", params.get("cmbCollectType"));
//      } else if (status == 21 || status == 10) { // Fail & Cancelled
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
      insertHsResultfinal.put("resultStockUse", '1'); //Unsure for no filter use
      insertHsResultfinal.put("resultIsCurr", '1');
      insertHsResultfinal.put("resultMtchId", '0');
      insertHsResultfinal.put("resultIsAdj", '0');

      // api추가
      insertHsResultfinal.put("temperateSetng", params.get("temperateSetng"));
      insertHsResultfinal.put("nextAppntDt", status == SalesConstants.STATUS_COMPLETED ? params.get("nextAppntDt") : dateFormatter.format(defaultNextAppntDt));
      insertHsResultfinal.put("nextAppointmentTime", status == SalesConstants.STATUS_COMPLETED ? params.get("nextAppointmentTime") : "0900");
      insertHsResultfinal.put("ownerCode", params.get("ownerCode"));
      insertHsResultfinal.put("resultCustName", params.get("resultCustName"));
      insertHsResultfinal.put("resultMobileNo", params.get("resultMobileNo"));
      insertHsResultfinal.put("resultRptEmailNo", params.get("resultRptEmailNo"));
      insertHsResultfinal.put("resultAceptName", params.get("resultAceptName"));
      insertHsResultfinal.put("sgnDt", params.get("sgnDt"));
      // api추가 end

      logger.debug("### insertHsResultfinal : {}", insertHsResultfinal);
      htManualMapper.insertHsResultfinal(insertHsResultfinal); // INSERT SVC0006D

      /* START
       * using hsManualMapper as logic same for filter product handling
       */
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
      /* END
       * using hsManualMapper as logic same for filter product handling
       */

      htManualMapper.updateHs009d(params); // UPDATE SAL0090D
    }

    EgovMap getHsResultMList = htManualMapper.selectHSResultMList(params);

    // BSScheduleM
    int scheduleCnt = htManualMapper.selectHSScheduleMCnt(params);

    if (scheduleCnt > 0) {

      EgovMap insertHsScheduleM = new EgovMap();

      insertHsScheduleM.put("hidschdulId", params.get("hidschdulId"));
      insertHsScheduleM.put("resultStusCodeId", params.get("cmbStatusType"));
      insertHsScheduleM.put("actnMemId", getHsResultMList.get("codyId"));

      htManualMapper.updateHsScheduleM(insertHsScheduleM); // UPDATE SVC0008D

    }

    // SrvConfiguration
    EgovMap srvConfiguration = htManualMapper.selectSrvConfiguration(params);

    if (srvConfiguration.size() > 0) {

      if (getHsResultMList.get("resultStusCodeId").toString().equals("4")) {

        EgovMap insertHsSrvConfigM = new EgovMap();
        insertHsSrvConfigM.put("salesOrdId", getHsResultMList.get("salesOrdId"));
        insertHsSrvConfigM.put("srvRem", params.get("instruction"));
        insertHsSrvConfigM.put("srvPrevDt", params.get("settleDate"));
        insertHsSrvConfigM.put("srvBsWeek", params.get("srvBsWeek"));

        EgovMap callMas = new EgovMap();
        callMas.put("hcsoid", getHsResultMList.get("salesOrdId"));
        // Edited to capture HS no (both request from Web or Mobile). Hui Ding, 22/06/2023
        callMas.put("hcTypeNo", (params.get("hidSalesOrdCd") == null ? params.get("serviceNo") : params.get("hidSalesOrdCd")));
        // callMas.put("hcTypeNo", params.get("serviceNo") );
        callMas.put("crtUserId", sessionVO.getUserId());
        callMas.put("updUserId", sessionVO.getUserId());

        htManualMapper.insertCcr0001d(callMas);


      } else {
        // OTHER STATUS
        // qryConfig.SrvRemark = bsInstruction;
        // qryConfig.SrvBSWeek = bsPreferWeek;
        // entity.SaveChanges();
      }

    }

    // LOGISTICS CALL
    Map<String, Object> logPram = null;
    if (Integer.parseInt(params.get("cmbStatusType").toString()) == 4) { // Completed
      logPram = new HashMap<String, Object>();
      logPram.put("ORD_ID", LOG_SVC0008D_NO);
      logPram.put("RETYPE", "COMPLET");
      logPram.put("P_TYPE", "OD05");
      logPram.put("P_PRGNM", "HSCOM");
      logPram.put("USERID", sessionVO.getUserId());

      logger.debug("HSCOM 물류 호출 PRAM ===>" + logPram.toString());
      // KR-OHK Serial check add start
      if ("Y".equals(params.get("hidSerialRequireChkYn"))) {
        servicesLogisticsPFCMapper.SP_LOGISTIC_REQUEST_SERIAL(logPram);
      } else {
        servicesLogisticsPFCMapper.SP_LOGISTIC_REQUEST(logPram);
      }
      logger.debug("HSCOMCALL 물류 호출 결과 ===> {}", logPram);

      if (!"000".equals(logPram.get("p1"))) {
          throw new ApplicationException(AppConstants.FAIL, "[ERROR]" + logPram.get("p1") + ":" + "HS Result Error");
        }
      logPram.put("P_RESULT_TYPE", "HS");
      logPram.put("P_RESULT_MSG", logPram.get("p1"));
    }

    Map<String, Object> resultValue = new HashMap<String, Object>();
    resultValue.put("resultId", params.get("hidSalesOrdCd"));
    resultValue.put("spMap", logPram);
    resultValue.put("hsrNo", insertHsResultfinal.get("docNo")); // KR-OHK Serial Check add
    return resultValue;
  }

  @Transactional
  private boolean insertHsResultfinal(int statusId, Map<String, Object> installResult, Map<String, Object> callEntry,
      Map<String, Object> callResult, Map<String, Object> orderLog) throws ParseException {
    // installEntry status가 1,21 이면 그 밑에 있는걸 ㅌ야된다(컴플릿이 되어도 다시 상태값 변경 가능하게 해야된다
    // String maxId = ""; //각 테이블에 maxid 값 가져온다(다음 실행할 쿼리에 값을 넣기 위해 사용)
    // EgovMap maxIdValue = new EgovMap();
    htManualMapper.insertHsResultfinal(installResult);
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
    // htManualMapper.insertOrderLog(orderLog);
    // }
    return true;
  }

  @Override
  public List<EgovMap> cmbCollectTypeComboList(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return htManualMapper.cmbCollectTypeComboList();
  }

  @Override
  public List<EgovMap> cmbCollectTypeComboList2(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return htManualMapper.cmbCollectTypeComboList2();
  }

  @Override
  public List<EgovMap> cmbServiceMemList(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return htManualMapper.cmbServiceMemList();
  }

  @Override
  public List<EgovMap> selectHsFilterList(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return htManualMapper.selectHsFilterList(params);
  }

  @Override
  public EgovMap selectHsViewBasicInfo(Map<String, Object> params) {

    return htManualMapper.selectHsViewBasicInfo(params);
  }

  @Override
  public List<EgovMap> failReasonList(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return htManualMapper.failReasonList(params);
  }

  @Override
  public List<EgovMap> serMemList(Map<String, Object> params) {
    return htManualMapper.serMemList(params);
  }

  @Override
  public List<EgovMap> selectHsViewfilterInfo(Map<String, Object> params) {
    // TODO Auto-generated method stub
    params.put("selSchdulId2", params.get("selSchdulId"));
    logger.debug("jinmu{}", params);
    return htManualMapper.selectHsViewfilterInfo(params);
  }

  @Override
  public EgovMap selectSettleInfo(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return htManualMapper.selectSettleInfo(params);
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

      htManualMapper.updateHsResultD(docSub);
    }

    // BSResultM
    EgovMap HsResultUdateEdit = new EgovMap();
    HsResultUdateEdit.put("hidschdulId", params.get("hidschdulId"));
    HsResultUdateEdit.put("srvRem", params.get("instruction"));
    HsResultUdateEdit.put("codyId", params.get("cmbServiceMem"));
    HsResultUdateEdit.put("failReason", params.get("failReason"));
    HsResultUdateEdit.put("renColctId", params.get("cmbCollectType"));
    HsResultUdateEdit.put("srvBsWeek", params.get("srvBsWeek"));

    htManualMapper.updateHsResultM(HsResultUdateEdit); // m

    // BSScheduleM
    int scheduleCnt = htManualMapper.selectHSScheduleMCnt(params);

    if (scheduleCnt > 0) {
      EgovMap insertHsScheduleM = new EgovMap();
      insertHsScheduleM.put("hidschdulId", params.get("hidschdulId"));
      insertHsScheduleM.put("resultStusCodeId", params.get("cmbStatusType2"));
      insertHsScheduleM.put("actnMemId", params.get("cmbServiceMem"));

      htManualMapper.updateHsScheduleM(insertHsScheduleM);
    }

    EgovMap updateHsSrvConfigM = new EgovMap();

    updateHsSrvConfigM.put("salesOrdId", params.get("hidschdulId"));
    updateHsSrvConfigM.put("srvBsWeek", params.get("srvBsWeek"));

    // htManualMapper.updateHsSrvConfigM(updateHsSrvConfigM);

    return resultValue;
  }

  @Override
  public List<EgovMap> selectFilterTransaction(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return htManualMapper.selectFilterTransaction(params);
  }

  @Override
  public List<EgovMap> selectHistoryHSResult(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return htManualMapper.selectHistoryHSResult(params);
  }

  @Override
  public EgovMap selectConfigBasicInfo(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return htManualMapper.selectConfigBasicInfo(params);
  }

  @Override
  public int updateHsConfigBasic(Map<String, Object> params, SessionVO sessionVO) {
    // TODO Auto-generated method stub

    int cnt = 0;

    LinkedHashMap hsBasicmap = (LinkedHashMap) params.get("hsResultM");

    logger.debug("hsResultM services ===>" + params);
    EgovMap selectConfigBasicInfoYn = htManualMapper.selectConfigBasicInfoYn(hsBasicmap);


    if (selectConfigBasicInfoYn.size() > 0) {
      Map<String, Object> sal0090 = new HashMap<String, Object>();

      sal0090.put("salesOrderId", hsBasicmap.get("salesOrderId"));
      sal0090.put("availability", hsBasicmap.get("availability"));
      sal0090.put("srvConfigId", selectConfigBasicInfoYn.get("srvConfigId"));
      sal0090.put("cmbServiceMem", hsBasicmap.get("cmbServiceMem"));
      sal0090.put("lstHSDate", hsBasicmap.get("lstHSDate"));
      sal0090.put("remark", hsBasicmap.get("remark"));
      sal0090.put("srvBsWeek", hsBasicmap.get("srvBsWeek"));
      sal0090.put("SrvUpdateAt", sessionVO.getUserId());
      sal0090.put("hscodyId", hsBasicmap.get("hscodyId"));
      // sal0090.put("SrvUpdateAt", SYSDATE);

      //htManualMapper.updateHsSVC0006D(sal0090);
      cnt = htManualMapper.updateHsConfigBasic(sal0090);

      // SrvConfigSetting --> Installation : 281
      List<EgovMap> configSettingMap = htManualMapper.selectConfigSettingYn(hsBasicmap);

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

         // htManualMapper.updateHsconfigSetting(sal0089);

        }
      }
    }

    return cnt;
  }

  @Override
  public EgovMap selectHSOrderView(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return htManualMapper.selectHSOrderView(params);
  }

  @Override
  public List<EgovMap> selectOrderInactiveFilter(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return htManualMapper.selectOrderInactiveFilter(params);
  }

  @Override
  public List<EgovMap> selectOrderActiveFilter(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return htManualMapper.selectOrderActiveFilter(params);
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
        htManualMapper.updateAssignCody(updateMap);
        htManualMapper.updateAssignCody90D(updateMap);

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
    return htManualMapper.selectBranch_id(params);
  }

  @Override
  public List<EgovMap> selectCTMByDSC_id(Map<String, Object> params) {
    return htManualMapper.selectCTMByDSC_id(params);
  }

  @Override
  public EgovMap selectCheckMemCode(Map<String, Object> params) {

    return htManualMapper.selectCheckMemCode(params);
  }

  @Override
  public EgovMap serMember(Map<String, Object> params) {

    return htManualMapper.selectSerMember(params);
  }

  @Override
  public List<EgovMap> selectHTMemberList(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return htManualMapper.selectHTMemberList(params);
  }

  @Override
  public String getSrvCodyIdbyMemcode(Map<String, Object> params) {

    return htManualMapper.selectMemberId(params);
  }

  @Override
  public int updateSrvCodyId(Map<String, Object> params) {
    int cnt = 0;
    htManualMapper.updateSrvCodyId(params);
    return cnt;
  }

  @Override
  public List<EgovMap> selectHSAddFilterSetInfo(Map<String, Object> params) {
    return htManualMapper.selectHSAddFilterSetInfo(params);
  }

  @Override
  public List<EgovMap> addSrvFilterIdCnt(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return htManualMapper.addSrvFilterIdCnt(params);
  }

  @Override
  public int updateFilterInfo(Map<String, Object> params, SessionVO sessionVO) {
    // TODO Auto-generated method stub
    return htManualMapper.updateFilterInfo(params);
  }

  @Override
  public String getSrvConfigId_SAL009(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return htManualMapper.getSrvConfigId_SAL009(params);
  }

  @Override
  public String getbomPartPriod_LOG0001M(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return htManualMapper.getbomPartPriod_LOG0001M(params);
  }

  @Override
  public String getSalesDtSAL_0001D(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return htManualMapper.getSalesDtSAL_0001D(params);
  }

  @Override
  public EgovMap getSrvConfigFilter_SAL0087D(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return htManualMapper.getSrvConfigFilter_SAL0087D(params);
  }

  @Override
  public int saveHsFilterInfoAdd(Map<String, Object> params) {
    // TODO Auto-generated method stub
    int result = -1;

    String configID = htManualMapper.getSrvConfigId_SAL009(params);
    String filterPeriod = htManualMapper.getbomPartPriod_LOG0001M(params);
    String orderdate = htManualMapper.getSalesDtSAL_0001D(params);

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
      EgovMap sal0087D = htManualMapper.getSrvConfigFilter_SAL0087D(params);

      if (sal0087D != null) {
        /*
         * send_sal0087D.put("SRV_FILTER_PRIOD", filterPeriod);
         * send_sal0087D.put("SRV_FILTER_PRV_CHG_DT",
         * params.get("lastChangeDate"));
         * send_sal0087D.put("SRV_FILTER_STUS_ID", 1);
         * send_sal0087D.put("SRV_FILTER_UPD_USER_ID" , params.get("updator"));
         * send_sal0087D.put("SRV_FILTER_REM", params.get("remark"));
         *
         * htManualMapper.saveChanges(send_sal0087D);
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
         * htManualMapper.saveChanges(send_sal0087D);
         */

        // Insert SAL0087D
        htManualMapper.saveHsFilterInfoAdd(params);
        result = 1;

      }
    }

    return result;
  }

  @Override
  public int saveDeactivateFilter(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return htManualMapper.saveDeactivateFilter(params);
  }

  @Override
  public int saveFilterUpdate(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return htManualMapper.saveFilterUpdate(params);
  }

  @Override
  public List<EgovMap> selecthSFilterUseHistorycall(Map<String, Object> params) {
    return htManualMapper.selecthSFilterUseHistorycall(params);
  }

  @Override
  @Transactional
  public Map<String, Object> UpdateHsResult2(Map<String, Object> params, List<Object> docType, SessionVO sessionVO)
      throws ParseException {

	logger.debug("params : "+params);
    Map<String, Object> resultValue = new HashMap<String, Object>();

    List<Map<String, Object>> bsResultDet = new ArrayList<Map<String, Object>>();

    if(docType != null){
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
    }

    Map<String, Object> bsResultMas = new HashMap<String, Object>();

    bsResultMas.put("No", "");
    bsResultMas.put("TypeID", String.valueOf(306));
    bsResultMas.put("ScheduleID", String.valueOf(params.get("hidschdulId")));
    bsResultMas.put("SalesOrderId", String.valueOf(params.get("hidSalesOrdId")));

    if (params.get("cmbServiceMem") == null || params.get("cmbServiceMem") == "") {
      bsResultMas.put("CodyID", String.valueOf(sessionVO.getUserId()));
    } else {
      bsResultMas.put("CodyID", String.valueOf(params.get("cmbServiceMem")));
    }



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

//    if (params.get("cmbCollectType") == null || params.get("cmbCollectType") == "") {
//    	bsResultMas.put("RenCollectionID", String.valueOf("0"));
//    } else {
//    	bsResultMas.put("RenCollectionID", String.valueOf(params.get("cmbCollectType")));
//    }


    bsResultMas.put("ResultRemark", String.valueOf(params.get("txtRemark")));
    // [19-09-2018] ADD HS INSTRUCTION REMARK FOR MAPPER USE
    bsResultMas.put("ResultInstRemark", String.valueOf(params.get("txtInstruction")));
    // bsResultMas.put("ResultCreated", sysdate);

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

    bsResultMas.put("ResultCreator", String.valueOf(sessionVO.getUserId()));
    // bsResultMas.put("ResultUpdated", sysdate);
    bsResultMas.put("RenCollectionID", String.valueOf("0"));
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

    Map<String, Object> bsResultMas_Rev = new HashMap<String, Object>();


    String ResultNo_Rev = "";
    int BS_RESULT = 11;
    String docNo = null;

    bsResultMas_Rev.put("DOCNO", BS_RESULT);
    EgovMap eMap = htManualMapper.getHsResultDocNo(bsResultMas_Rev);
    docNo = String.valueOf(eMap.get("hsrno")).trim();
    bsResultMas_Rev.put("docNo", docNo);
    logger.info("###HSRNO: " + docNo);

    EgovMap qryBS_Rev = null;
    qryBS_Rev = htManualMapper.selectQryBS_Rev(bsResultMas);
    logger.debug("qryBS_Rev : {}" + qryBS_Rev);

    if (qryBS_Rev != null) {
    	 int BSResultM_resultID = htManualMapper.getBSResultM_resultID();
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

//         if(qryBS_Rev.get("instChklstCheckBox") != null) {
//             bsResultMas_Rev.put("instChklstCheckBox", qryBS_Rev.get("instChklstCheckBox"));
//          } else {
//        	 bsResultMas_Rev.put("instChklstCheckBox", params.get("instChklstCheckBox"));
//          }

         int count = htManualMapper.selectTotalFilter(bsResultMas_Rev);
         logger.debug("selectQryResultDet : {}" + bsResultMas_Rev);
         List<EgovMap> qryResultDet = htManualMapper.selectQryResultDet(bsResultMas_Rev);
         List<EgovMap> qryUsedFilter;
         if (count == 0) {
           qryUsedFilter = htManualMapper.selectQryUsedFilterNew(bsResultMas_Rev);

         } else {
           qryUsedFilter = htManualMapper.selectQryUsedFilter(bsResultMas_Rev);

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
               htManualMapper.addbsResultDet_Rev(bsResultDet_Rev); // insert svc
                                                                   // 0007d c
               htManualMapper.addusedFilter_Rev(usedFilter_Rev); // insert log0082m

               checkInt++;
               if (i == (qryResultDet.size() - 1)) { // 마지막일때 넘기기

               }
             }
         }

         if (checkInt > 0) {
             htManualMapper.addbsResultMas_Rev(bsResultMas_Rev); // svc 0006d B
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
         qry_stkReqM = htManualMapper.selectQry_stkReqM(bsResultMas_Rev);

         if (qry_stkReqM != null) {
        	 String PDONo = null;
             int PDO_REQUEST = 26;
             bsResultMas_Rev.put("docType", PDO_REQUEST);
             PDONo = htManualMapper.GetDocNo(bsResultMas_Rev);
             bsResultMas_Rev.put("PDONo", PDONo);

             String PDO_REQUEST_PDO = "PDO";

             String nextDocNo_PDO = getNextDocNo(PDO_REQUEST_PDO, PDONo);

             bsResultMas_Rev.put("ID_New", PDO_REQUEST);
             bsResultMas_Rev.put("nextDocNo_New", nextDocNo_PDO);
             htManualMapper.updateQry_New(bsResultMas_Rev);

             Map<String, Object> stkReqM_Rev = new HashMap<String, Object>();
             // stkReqM_Rev.put("StkReqID", 0);
             stkReqM_Rev.put("StkReqNo", String.valueOf(PDONo));
             stkReqM_Rev.put("StkReqLocFromID", String.valueOf(qry_stkReqM.get("stkReqLocFromId")));// STK_REQ_LOC_FROM_ID
             stkReqM_Rev.put("StkReqLocToID", String.valueOf(qry_stkReqM.get("stkReqLocToId")));// STK_REQ_LOC_TO_ID
             stkReqM_Rev.put("StkReqRemark", String.valueOf(qry_stkReqM.get("stkReqRem")));// STK_REQ_REM
             stkReqM_Rev.put("StkReqCreateAt", "sysdate");// STK_REQ_REM
             stkReqM_Rev.put("StkReqCreateBy", String.valueOf(sessionVO.getUserId()));// STK_REQ_REM

             htManualMapper.addstkReqM_Rev(stkReqM_Rev);

             int LocationID_Rev = 0;
             if (Integer.parseInt(qryBS_Rev.get("codyId").toString()) != 0) {
               LocationID_Rev = htManualMapper.getMobileWarehouseByMemID(qryBS_Rev);
             }

             int stkReqM_StkReqID = htManualMapper.getStkReqM_StkReqID();

             EgovMap qryBS = null;
             qryBS = htManualMapper.selectQryBS(bsResultMas);
             // bsResultMas_Rev.put("ResultMatchID
             EgovMap qry_stkReqD_Rev = null;
             qry_stkReqD_Rev = htManualMapper.qry_stkReqD_Rev(bsResultMas_Rev);
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

                 htManualMapper.addStkReqD_Rev(stkReqD_Rev);

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

         htManualMapper.updateQry_CurBS(qry_CurBS); // 업데이트 svc0006d

         String ResultNo_New = null;
         BS_RESULT = 11;
         bsResultMas_Rev.put("DOCNO", String.valueOf(BS_RESULT));

         eMap = htManualMapper.getHsResultDocNo(bsResultMas_Rev);
         ResultNo_New = String.valueOf(eMap.get("hsrno")).trim();
         logger.info("###ResultNo_New: " + ResultNo_New);

         int BSResultM_resultID2 = htManualMapper.getBSResultM_resultID();
         bsResultMas.put("No", ResultNo_New);
         bsResultMas.put("ResultId", BSResultM_resultID2);
         bsResultMas.put("CodyId", String.valueOf(bsResultMas_Rev.get("codyId")));


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
               htManualMapper.addbsResultDet_Rev(row); // 인서트 svc 0007d
               htManualMapper.addusedFilter(usedFilter);
               cnt++;
               if (i == (bsResultDet.size() - 1)) {
                 logger.debug("request JM" + i + String.valueOf(row.get("BSResultID")));

               }

             }
           }

         if (cnt != 0) { // 0이 아닐 경우 인서트
             htManualMapper.addbsResultMas(bsResultMas); // insert 1건 svc0006d
           } else if (cnt == 0) { // 0일 경우 업데이트
             if (bsResultMas.get("SettleDate") != null || bsResultMas.get("SettleDate") != "") {
               bsResultMas.put("SettleDate", String.valueOf(bsResultMas.get("SettleDate")));
             } else {
               bsResultMas.put("SettleDate", "01/01/1900");
             }
             logger.debug(">>>>>>>>>>bsResultMas : {}", bsResultMas);
             htManualMapper.updatebsResultMas(bsResultMas); // UPDATE 1건 svc0006d
           }

         htManualMapper.updateQry_CurBSZero(qry_CurBS);// 최신거 업데이트

         htManualMapper.updateQrySchedule(bsResultMas);// 업데이트 00008d

         Map<String, Object> qrySchedule = new HashMap<String, Object>();
         qrySchedule = htManualMapper.selectQrySchedule(bsResultMas);

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

         htManualMapper.updateQryConfig(bsResultMas);
         Map<String, Object> qryConfig = new HashMap<String, Object>();
         qryConfig = htManualMapper.selectQryConfig(bsResultMas);

         if (Integer.parseInt(bsResultMas.get("ResultStatusCodeID").toString()) == 4) {
             htManualMapper.updateQryConfig4(bsResultMas);
         } else {
             htManualMapper.updateQryConfig(bsResultMas);
         }

         if (bsResultDet.size() > 0) {
             int ItemNo = 1;

             for (int i = 0; i < bsResultDet.size(); i++) {
               bsResultDet.get(i).put("BSResultID", BSResultM_resultID);

               int LocationID = 0;

               LocationID = htManualMapper.selectLocationID(bsResultMas);

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

                 htManualMapper.addStkCrd_new(stkCrd_new);
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
               htManualMapper.updateQryFilter(qryFilter_param);

               ItemNo = ItemNo + 1;
             }
           }
    }

//    logger.debug("bsResultMas : "+ bsResultMas);
//    htManualMapper.updatebsResultMas(bsResultMas); // UPDATE SVC0006D
//
//    htManualMapper.updateQrySchedule(bsResultMas); // UPDATE SVC0008D
//
//    if (Integer.parseInt(bsResultMas.get("ResultStatusCodeID").toString()) == 4) {
//    	htManualMapper.updateQryConfig4(bsResultMas); // UPDATE SAL0090D
//      } else {
//    	  htManualMapper.updateQryConfig(bsResultMas);
//      }

    return resultValue;
  }

  @Override
  public int isHsAlreadyResult(Map<String, Object> params) {
    return htManualMapper.isHsAlreadyResult(params);
  }

  @Override
  public int saveValidation(Map<String, Object> params) {
    return htManualMapper.saveValidation(params);
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
    return htManualMapper.selectHsOrderInMonth(params);
  }

  @Override
  public List<EgovMap> hSMgtResultViewResultFilter(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return htManualMapper.hSMgtResultViewResultFilter(params);
  }

  @Override
  public EgovMap hSMgtResultViewResult(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return htManualMapper.hSMgtResultViewResult(params);
  }

  @Override
  public List<EgovMap> assignDeptMemUp(Map<String, Object> params) {
    return htManualMapper.assignDeptMemUp(params);
  }


  @Override
  public int updateAssignHT(Map<String, Object> params) {
	  int cnt = 0 ;

	  htManualMapper.updateAssignHT(params);
	  return cnt;
  }

  @Override
  public List<EgovMap> selectCMList(Map<String, Object> params) {
    return htManualMapper.selectCMList(params);
  }

  @Override
  public int hsResultSync(Map<String, Object> params) {
    return htManualMapper.hsResultSync(params);
  }

  @Override
  public EgovMap getBSFilterInfo(Map<String, Object> params) {
    return htManualMapper.getBSFilterInfo(params);
  }

  // OMBAK - AS ENTRY RESULT & INVOICE BILLING -- TPY
  public Map<String, Object> saveASEntryResult(Map<String, Object> params) {

    params.put("DOCNO", "17");
    EgovMap eMap = htManualMapper.getASEntryDocNo(params);

    EgovMap seqMap = htManualMapper.getASEntryId(params);

    // AS ENTRY -- SVC0001D
    params.put("AS_ID", String.valueOf(seqMap.get("seq")).trim());
    params.put("AS_NO", String.valueOf(eMap.get("asno")).trim());
    params.put("AS_SO_ID", params.get("salesOrdId").toString());
    params.put("AS_MEM_ID", "0");
    params.put("AS_REQST_DT", params.get("settleDate").toString());
    params.put("AS_APPNT_DT", params.get("settleDate").toString());
    params.put("AS_BRNCH_ID", "0");
    params.put("AS_MALFUNC_ID", "9004100");// GENERAL REQUEST
    params.put("AS_MALFUNC_RESN_ID", "2");// AS DURING INSTALLATION
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
    EgovMap seqMap2 = htManualMapper.getResultASEntryId(params2);
    EgovMap eMap2 = htManualMapper.getASEntryDocNo(params2);

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
    params2.put("AS_RESULT_REM", "");
    // params2.put("AS_RESULT_CRT_DT", "");
    params2.put("updator", params.get("userId").toString());
    params2.put("AS_MALFUNC_ID", "9004100"); // GENERAL REQUEST
    params2.put("AS_MALFUNC_RESN_ID", "2"); // AS DURING INSTALLATION
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

    htManualMapper.insertSVC0001D(params);
    htManualMapper.insertSVC0004D(params2);
    htManualMapper.insertSVC0005D(params3);

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
    EgovMap invoiceDocNo = htManualMapper.getASEntryDocNo(params);
    int taxInvcId = htManualMapper.getSeqPay0031D();
    EgovMap taxPersonInfo = htManualMapper.selectTaxInvoice(params);
    params.put("DOCNO", "22");
    EgovMap asBillDocNo = htManualMapper.getASEntryDocNo(params);

    Map<String, Object> param = new HashMap();

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

    htManualMapper.insert_Pay0031d(param);
    htManualMapper.insert_Pay0032d(param2);
    htManualMapper.insert_Pay0016d(param3);
    htManualMapper.insert_Pay0006d(param4);
    htManualMapper.insert_Pay0007d(param5);

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
    return htManualMapper.checkStkDuration(params);
  }


	@Override
	public List<EgovMap> selectDeptCodeList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return htManualMapper.selectDeptCodeList(params);
	}

	@Override
	public List<EgovMap> selectDscCodeList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return htManualMapper.selectDscCodeList(params);
	}

	@Override
	public List<EgovMap> selectInsStatusList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return htManualMapper.selectInsStatusList(params);
	}

	@Override
	public List<EgovMap> selectCodyCodeList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return htManualMapper.selectCodyCodeList(params);
	}


	@Override
	public List<EgovMap> selectAreaCodeList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return htManualMapper.selectAreaCodeList(params);
	}

	@Override
	public List<EgovMap> selectCodyCodeList_1(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return htManualMapper.selectCodyCodeList_1(params);
	}

	@Override
	public List<EgovMap> selectHSReportSingle(Map<String, Object> params) {
		return htManualMapper.selectHSReportSingle(params);
	}

	@Override
	public List<EgovMap> selectHSReportGroup(Map<String, Object> params) {
		return htManualMapper.selectHSReportGroup(params);
	}

	@Override
	public List<EgovMap> selectHTCodeListByHTCode(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return htManualMapper.selectHTCodeListByHTCode(params);
	}

	 @Override
	  public int updateHsConfigBasicMultiple(Map<String, Object> params, SessionVO sessionVO) {
	    // TODO Auto-generated method stub
	    int cnt = 0;

	    params.put("updUserId", sessionVO.getUserId());
	    htManualMapper.updateHTConfigBasicMultiple(params);
	    htManualMapper.updateAssignHTMultiple(params);

	    return cnt;
	 }


	 @Override
	  public EgovMap selectHsOrder1Time(Map<String, Object> params) {
	    if (params.get("selectHsOrder1Time") != null) {
	    }
	    return htManualMapper.selectHsOrder1Time(params);

	 }

	   @Override
	      public int selectHsOrderTotal1Year(Map<String, Object> params) {
	        return htManualMapper.selectHsOrderTotal1Year(params);
	     }

       @Override
       public int selectTotalCS(Map<String, Object> params) {
         return htManualMapper.selectTotalCS(params);
      }

       @Override
 	  public EgovMap selectCSOrderView(Map<String, Object> params) {
 	    // TODO Auto-generated method stub
 	    return htManualMapper.selectCSOrderView(params);
 	  }

       @Override
      public EgovMap checkMatOrFra(Map<String, Object> params){
   	    // TODO Auto-generated method stub
   	    return htManualMapper.checkMatOrFra(params);
       }

}
