package com.coway.trust.biz.logistics.stockmovement.impl;

import java.math.BigDecimal;
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
import com.coway.trust.biz.logistics.serialmgmt.SerialMgmtNewService;
import com.coway.trust.biz.logistics.stockmovement.StockMovementService;
import com.coway.trust.biz.logistics.stocktransfer.StockTransferService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("stockMovementService")
public class StockMovementServiceImpl extends EgovAbstractServiceImpl implements StockMovementService {

  private final Logger logger = LoggerFactory.getLogger(this.getClass());
  @Resource(name = "stockMoveMapper")
  private StockMovementMapper stockMoveMapper;

  @Resource(name = "serialMgmtNewService")
  private SerialMgmtNewService serialMgmtNewService;

  @Resource(name = "stocktranService")
  private StockTransferService stock;

  @Override
  public String insertStockMovementInfo(Map<String, Object> params) {
    List<Object> insList = (List<Object>) params.get("add");
    Map<String, Object> fMap = (Map<String, Object>) params.get("form");

    if (insList.size() > 0) {
      for (int i = 0; i < insList.size(); i++) {
        Map<String, Object> insMap = (Map<String, Object>) insList.get(i);

        insMap.put("tlocation", fMap.get("tlocation"));

        int iCnt = stockMoveMapper.selectAvaliableStockQty(insMap);
        if (iCnt == 1) {
          return "";
        }
      }
    }

    /* 2017-11-30 김덕호 위원 채번 변경 요청 */
    String seq = stockMoveMapper.selectStockMovementSeq();

    // String reqNo = fMap.get("headtitle") + seq;
    String reqNo = seq;

    fMap.put("reqno", reqNo);
    // fMap.put("reqno", fMap.get("headtitle") + seq);
    fMap.put("userId", params.get("userId"));

    stockMoveMapper.insStockMovementHead(fMap);

    if (insList.size() > 0) {
      for (int i = 0; i < insList.size(); i++) {
        Map<String, Object> insMap = (Map<String, Object>) insList.get(i);
        // insMap.put("reqno", fMap.get("headtitle") + seq);
        insMap.put("reqno", seq);
        insMap.put("userId", params.get("userId"));
        stockMoveMapper.insStockMovement(insMap);
      }
    }

    insertStockBooking(fMap);

    return reqNo;

  }

  @Override
  public List<EgovMap> selectStockMovementNoList(Map<String, Object> params) {
    // TODO Auto-generated method stub
    List<EgovMap> list = null;

    if ("stock".equals(params.get("groupCode"))) {
      list = stockMoveMapper.selectStockMovementNoList();
    } else {
      list = stockMoveMapper.selectDeliveryNoList();
    }
    return list;
  }

  @Override
  public List<EgovMap> selectStockMovementMainList(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return stockMoveMapper.selectStockMovementMainList(params);
  }

  @Override
  public List<EgovMap> selectStockMovementDeliveryList(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return stockMoveMapper.selectStockMovementDeliveryList(params);
  }

  @Override
  public List<EgovMap> selectTolocationItemList(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return stockMoveMapper.selectStockMovementToItem(params);
  }

  @Override
  public int stockMovementItemDeliveryQty(Map<String, Object> params) {
    Map<String, Object> map = stockMoveMapper.selectStockMovementItemDeliveryQty(params);
    int iCnt = 0;
    try {
      iCnt = (int) map.get("qty");
    } catch (Exception ex) {
      iCnt = 0;
    }
    return iCnt;
  }

  @Override
  public Map<String, Object> selectStockMovementDataDetail(String param) {

    Map<String, Object> hdMap = stockMoveMapper.selectStockMovementHead(param);

    List<EgovMap> list = stockMoveMapper.selectStockMovementItem(param);

    Map<String, Object> pMap = new HashMap();
    pMap.put("toloc", hdMap.get("rcivcr"));

    List<EgovMap> toList = stockMoveMapper.selectStockMovementToItem(pMap);

    Map<String, Object> reMap = new HashMap();
    reMap.put("hValue", hdMap);
    reMap.put("iValue", list);
    reMap.put("itemto", toList);

    return reMap;
  }

  @Override
  public void deleteDeliveryStockMovement(Map<String, Object> params) {
    List<Object> delList = (List<Object>) params.get("del");

    Map<String, Object> fMap = (Map<String, Object>) params.get("form");

    if (delList.size() > 0) {
      for (int i = 0; i < delList.size(); i++) {
        Map<String, Object> insMap = (Map<String, Object>) delList.get(i);
        insMap.put("reqno", fMap.get("reqno"));
        stockMoveMapper.deleteStockMovementItm(insMap);
        stockMoveMapper.deleteDeliveryStockMovementItm(insMap);
      }
    }

  }

  @Override
  public List<EgovMap> addStockMovementInfo(Map<String, Object> params) {
    List<Object> insList = (List<Object>) params.get("add");
    List<Object> updList = (List<Object>) params.get("upd");
    /* List<Object> delList = (List<Object>) params.get("rem"); */

    Map<String, Object> fMap = (Map<String, Object>) params.get("form");

    if (insList.size() > 0) {
      for (int i = 0; i < insList.size(); i++) {
        Map<String, Object> insMap = (Map<String, Object>) insList.get(i);
        insMap.put("reqno", fMap.get("reqno"));
        insMap.put("userId", params.get("userId"));
        stockMoveMapper.insStockMovement(insMap);
      }
    }
    if (updList.size() > 0) {
      for (int i = 0; i < updList.size(); i++) {
        Map<String, Object> insMap = (Map<String, Object>) updList.get(i);
        insMap.put("reqno", fMap.get("reqno"));
        insMap.put("userId", params.get("userId"));
        stockMoveMapper.insStockMovement(insMap);
      }
    }
    List<EgovMap> list = stockMoveMapper.selectStockMovementItem((String) fMap.get("reqno"));
    return list;
  }

  @Override
  public Map<String, Object> stockMovementReqDelivery(Map<String, Object> params) {
    List<Object> checkList = (List<Object>) params.get(AppConstants.AUIGRID_CHECK);
    List<Object> serialList = (List<Object>) params.get(AppConstants.AUIGRID_ADD);
    Map<String, Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
    /* 2017-11-30 김덕호 위원 채번 변경 요청 */
    logger.info(" checkList : {}", checkList.toString());
    logger.info(" checkList.size : {}", checkList.size());
    logger.info(" formMap : {}", formMap);
    boolean dupCheck = true;
    if (checkList.size() > 0) {

      Map<String, Object> insMap = null;
      for (int i = 0; i < checkList.size(); i++) {

        Map<String, Object> tmpMap = (Map<String, Object>) checkList.get(i);

        insMap = (Map<String, Object>) tmpMap.get("item");

        logger.info(" item : {}", tmpMap.get("item"));
        logger.info(" reqstno : {}", insMap.get("reqstno"));
        logger.info(" itmcd : {}", insMap.get("itmcd"));
        logger.info(" reqstqty : {}", insMap.get("reqstqty"));
        logger.info(" indelyqty : {}", insMap.get("indelyqty"));
        List<EgovMap> list = stockMoveMapper.selectDeliverydupCheck(insMap);
        logger.info(" list : {}", list.toString());
        logger.info(" list.size : {}", list.size());
        String ttmp1 = (String) insMap.get("reqstno");
        String ttmp2 = (String) insMap.get("itmcd");
        int ttmp3 = (int) insMap.get("reqstqty");
        int ttmp4 = (int) insMap.get("indelyqty");
        logger.info(" ttmp1 :ttmp2 : ttmp3 : ttmp4 {} : {} : {} : {}", ttmp1, ttmp2, ttmp3, ttmp4);
        if (list.size() > 0) {
          Map<String, Object> checkmap = null;
          checkmap = list.get(0);
          String tmp1 = (String) checkmap.get("reqstNo");
          String tmp2 = (String) checkmap.get("itmCode");
          // int tmp3 = 1;
          Integer count = ((BigDecimal) checkmap.get("delvryQty")).intValueExact();
          int tmp3 = count;
          // int tmp3 = Integer.parseInt((String) (checkmap.get("delvryQty")));

          logger.info(" tmp1 :tmp2 : tmp3 {} : {} : {}", tmp1, tmp2, tmp3);

          if (ttmp1.equals(tmp1) && ttmp2.equals(tmp2) && (ttmp4 + tmp3) > ttmp3) {
            dupCheck = false;
          }
        }

      }

    }

    if (dupCheck) {
      String deliSeq = stockMoveMapper.selectDeliveryStockMovementSeq();

      String scanno = "";

      if (checkList.size() > 0) {

        Map<String, Object> insMap = null;

        for (int i = 0; i < checkList.size(); i++) {

          Map<String, Object> tmpMap = (Map<String, Object>) checkList.get(i);

          insMap = (Map<String, Object>) tmpMap.get("item");

          logger.info(" item : {}", tmpMap.get("item"));
          logger.info(" reqstno : {}", insMap.get("reqstno"));

          insMap.put("delno", deliSeq);
          insMap.put("userId", params.get("userId"));
          stockMoveMapper.insertDeliveryStockMovementDetail(insMap);

          if (serialList.size() > 0) {
            int uCnt = 0;
            for (int j = 0; j < serialList.size(); j++) {

              Map<String, Object> insSerial = null;
              insSerial = (Map<String, Object>) serialList.get(j);
              insSerial.put("delno", deliSeq);
              insSerial.put("reqstno", insMap.get("reqstno"));
              insSerial.put("userId", params.get("userId"));
              int icnt = stockMoveMapper.insertMovementSerial(insSerial);
              logger.info(" :::: " + icnt);
              if (icnt > 0) {
                uCnt = uCnt + icnt;
                if (uCnt == (int) insMap.get("indelyqty")) {
                  break;
                }
              }
              scanno = (String) insSerial.get("scanno");
            }
            if (scanno != null)
              stockMoveMapper.updateMovementSerialScan(scanno);
          }

          insMap.put("scanno", scanno);
          stockMoveMapper.updateRequestMovement((String) insMap.get("reqstno"));

        }

        stockMoveMapper.insertDeliveryStockMovement(insMap);
      }
      String[] delvcd = { deliSeq };

      formMap.put("parray", delvcd);
      formMap.put("userId", params.get("userId"));
      // formMap.put("prgnm", params.get("prgnm"));
      formMap.put("refdocno", "");
      formMap.put("salesorder", "");

      stockMoveMapper.StockMovementIssue(formMap);
    } else {
      formMap.put("rdata", "8282∈dup");
    }
    /*
     * String deliSeq = stockMoveMapper.selectDeliveryStockMovementSeq();
     *
     * String scanno = "";
     *
     * if (checkList.size() > 0) {
     *
     * Map<String, Object> insMap = null;
     *
     * for (int i = 0; i < checkList.size(); i++) {
     *
     * Map<String, Object> tmpMap = (Map<String, Object>) checkList.get(i);
     *
     * insMap = (Map<String, Object>) tmpMap.get("item");
     *
     * logger.info(" item : {}", tmpMap.get("item")); logger.info(
     * " reqstno : {}", insMap.get("reqstno"));
     *
     * insMap.put("delno", deliSeq); insMap.put("userId", params.get("userId"));
     * stockMoveMapper.insertDeliveryStockMovementDetail(insMap);
     *
     * if (serialList.size() > 0) { int uCnt = 0; for (int j = 0; j <
     * serialList.size(); j++) {
     *
     * Map<String, Object> insSerial = null; insSerial = (Map<String, Object>)
     * serialList.get(j); insSerial.put("delno" , deliSeq);
     * insSerial.put("reqstno", insMap.get("reqstno")); insSerial.put("userId" ,
     * params.get("userId")); int icnt =
     * stockMoveMapper.insertMovementSerial(insSerial); logger.info(" :::: " +
     * icnt); if (icnt > 0 ){ uCnt = uCnt +icnt; if (uCnt ==
     * (int)insMap.get("indelyqty")){ break; } } scanno =
     * (String)insSerial.get("scanno"); } if (scanno != null)
     * stockMoveMapper.updateMovementSerialScan(scanno); }
     *
     * insMap.put("scanno" , scanno);
     *
     * }
     *
     * stockMoveMapper.insertDeliveryStockMovement(insMap);
     * stockMoveMapper.updateRequestMovement((String) formMap.get("reqstno")); }
     * String[] delvcd = { deliSeq };
     *
     * formMap.put("parray", delvcd); formMap.put("userId",
     * params.get("userId")); // formMap.put("prgnm", params.get("prgnm"));
     * formMap.put("refdocno", ""); formMap.put("salesorder", "");
     *
     * stockMoveMapper.StockMovementIssue(formMap);
     *
     */
    return formMap;
  }

  // KR - OHK
  @SuppressWarnings("unchecked")
  @Override
  public Map<String, Object> stockMovementReqDeliverySerial(Map<String, Object> params) {
	Map<String, Object> gridList = (Map<String, Object>) params.get("gridList");
	List<Object> serialGridList = (List<Object>)gridList.get(AppConstants.AUIGRID_ALL);

    boolean dupCheck = true;

    if (serialGridList.size() > 0) {
      Map<String, Object> insMap = null;

      for (int i = 0; i < serialGridList.size(); i++) {

        insMap = (Map<String, Object>) serialGridList.get(i);

        insMap.put("reqstno", insMap.get("reqstNo"));
        insMap.put("itmcd", insMap.get("itmCode"));

        List<EgovMap> list = stockMoveMapper.selectDeliverydupCheck(insMap);

        String ttmp1 = (String) insMap.get("reqstno");
        String ttmp2 = (String) insMap.get("itmcd");

        int ttmp3 = (int) insMap.get("reqstQty");  // 요청 수량
        int ttmp4 = (int) insMap.get("scanQty"); // 실제 화면에서 입력한 출고 수량

        if (list.size() > 0) {
          Map<String, Object> checkmap = null;
          checkmap = list.get(0);
          String tmp1 = (String) checkmap.get("reqstNo");
          String tmp2 = (String) checkmap.get("itmCode");

          Integer count = ((BigDecimal) checkmap.get("delvryQty")).intValueExact();
          int tmp3 = count; // 기 출고된 수량

          if (ttmp1.equals(tmp1) && ttmp2.equals(tmp2) && (ttmp4 + tmp3) > ttmp3) {
            dupCheck = false;
          }
        }
      }
    }

    if (dupCheck) { // 출고수량 <= 요청 수량
      String deliSeq = stockMoveMapper.selectDeliveryStockMovementSeq();

      if (serialGridList.size() > 0) {
        Map<String, Object> insMap = null;

        for (int i = 0; i < serialGridList.size(); i++) {

          insMap = (Map<String, Object>) serialGridList.get(i);

          insMap.put("reqstno", insMap.get("reqstNo"));
          insMap.put("reqitmno", insMap.get("reqstNoItm"));
          insMap.put("itmcd", insMap.get("itmCode"));
          insMap.put("itmname", insMap.get("itmName"));
          insMap.put("indelyqty", insMap.get("scanQty"));
          insMap.put("ttype", insMap.get("trnscType"));
          insMap.put("mtype", insMap.get("trnscTypeDtl"));
          insMap.put("delno", deliSeq);
          insMap.put("userId", params.get("userId"));

          if((Integer)insMap.get("scanQty") > 0) {
              stockMoveMapper.insertDeliveryStockMovementDetail(insMap);
          }
        }
        stockMoveMapper.updateRequestMovement((String) insMap.get("reqstno"));
        stockMoveMapper.insertDeliveryStockMovement(insMap);
      }

      String[] delvcd = { deliSeq };

      params.put("parray", delvcd);
      //params.put("userId", params.get("userId"));
      params.put("refdocno", "");
      params.put("salesorder", "");
      params.put("giptdate", params.get("zGiptdate"));
      params.put("gipfdate", params.get("zGipfdate"));
      params.put("doctext", params.get("zDoctext"));
      params.put("gtype", params.get("ztype"));

      //HLTANG 202111 - filter scan barcode
      params.put("reqstNo", params.get("zRstNo"));
      //update status 'D' to 'C'
      SessionVO sessionVO = new SessionVO();
      sessionVO.setUserId(Integer.valueOf(params.get("userId").toString()));
      try {
		serialMgmtNewService.saveSerialNo(params, sessionVO);
        } catch (Exception e) {
        	// TODO Auto-generated catch block
        	e.printStackTrace();
        }

      stockMoveMapper.StockMovementIssueSerial(params);

      String reVal = (String) params.get("rdata");
      String returnValue[] = reVal.split("∈");

      logger.debug(" **** StockMovementIssueSerial [" + returnValue[0]+ "]");
      logger.debug(" **** StockMovementIssueSerial [" + returnValue[1]+ "]");

  	  if(!"000".equals(returnValue[0])){
		    throw new ApplicationException(AppConstants.FAIL, "[ERROR]" + returnValue[0]+ ":" + returnValue[1]);
	    }

      logger.debug(">>>>>>>>>>> deliSeq : " +  deliSeq);

      // SERIAL SCAN SAVE
      params.put("reqstNo", params.get("zRstNo"));
      params.put("delvryNo", deliSeq);
      params.put("trnscType",params.get("zTrnscType"));
      params.put("ioType",params.get("zIoType"));

      stockMoveMapper.StockMovementIssueBarcodeSave(params);

      String errCode = (String)params.get("pErrcode");
	  String errMsg = (String)params.get("pErrmsg");

   	  logger.debug(">>>>>>>>>>>ERROR CODE : " + errCode);
	  logger.debug(">>>>>>>>>>>ERROR MSG: " + errMsg);

	  // pErrcode : 000  = Success, others = Fail
	  if(!"000".equals(errCode)){
		throw new ApplicationException(AppConstants.FAIL, "[ERROR]" + errCode + ":" + errMsg);
	  }

    } else {
    	params.put("rdata", "8282∈dup");
    }
    return params;
  }

  @Override
  public List<EgovMap> selectStockMovementSerial(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return stockMoveMapper.selectStockMovementSerial(params);
  }

  @Override
  public Map<String, Object> stockMovementDeliveryIssue(Map<String, Object> params) {
    List<Object> checklist = (List<Object>) params.get(AppConstants.AUIGRID_CHECK);
    Map<String, Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);

    String gtype = (String) formMap.get("gtype");
    int iCnt = 0;
    String tmpdelCd = "";
    String delyCd = "";
    String delyno = "";
    if (checklist.size() > 0) {
      for (int i = 0; i < checklist.size(); i++) {
        Map<String, Object> map = (Map<String, Object>) checklist.get(i);

        Map<String, Object> imap = new HashMap();
        imap = (Map<String, Object>) map.get("item");

        String delCd = (String) imap.get("delyno");
        delyno = (String) imap.get("delyno");
        if (delCd != null && !(tmpdelCd.equals(delCd))) {
          tmpdelCd = delCd;
          if (iCnt == 0) {
            delyCd = delCd;
          } else {
            delyCd += "∈" + delCd;
          }
          iCnt++;
        }
      }
    }

    if ("RC".equals(gtype)) {
      logger.info("stockMovementDeliveryIssue RC: {}", gtype);
      String[] delvcd = delyCd.split("∈");

      formMap.put("parray", delvcd);
      formMap.put("userId", params.get("userId"));
      // formMap.put("prgnm", params.get("prgnm"));
      formMap.put("refdocno", "");
      formMap.put("salesorder", "");
      logger.debug("formMap : {}", formMap);
      if ("RC".equals(formMap.get("gtype"))) {
        // for (int i = 0 ; i < delvcd.length ; i ++){
        // String receiptFlag = stockMoveMapper.getReceiptFlag(delvcd[i]);
        // if (receiptFlag != null && "Y".equals(receiptFlag)){
        // formMap.put("retMsg" , "fail");
        // return formMap;
        // }
        // }
        stockMoveMapper.StockMovementCancelIssue(formMap); // movement receipt
                                                           // cancel
      }

      formMap.put("retMsg", "succ");

    } else {

      Map<String, Object> grlist = stockMoveMapper.selectDelvryGRcmplt(delyno);

      if (null == grlist) {

      }

      String grmplt = (String) grlist.get("DEL_GR_CMPLT");
      String gimplt = (String) grlist.get("DEL_GI_CMPLT");

      if ("Y".equals(grmplt)) {

        formMap.put("failMsg", "Already processed.");

      } else {

        String[] delvcd = delyCd.split("∈");

        formMap.put("parray", delvcd);
        formMap.put("userId", params.get("userId"));
        // formMap.put("prgnm", params.get("prgnm"));
        formMap.put("refdocno", "");
        formMap.put("salesorder", "");
        logger.debug("formMap : {}", formMap);
        if ("RC".equals(formMap.get("gtype"))) {
          // for (int i = 0 ; i < delvcd.length ; i ++){
          // String receiptFlag = stockMoveMapper.getReceiptFlag(delvcd[i]);
          // if (receiptFlag != null && "Y".equals(receiptFlag)){
          // formMap.put("retMsg" , "fail");
          // return formMap;
          // }
          // }
          stockMoveMapper.StockMovementCancelIssue(formMap); // movement receipt
                                                             // cancel
        } else {
          Map<String, Object> grade = (Map<String, Object>) params.get("grade");
          logger.info(" grade : {}", grade);
          if ("GR".equals(formMap.get("gtype")) & null != grade) {
            List<Object> gradelist = (List<Object>) grade.get(AppConstants.AUIGRID_UPDATE);
            logger.info(" gradelist : {}", gradelist);
            logger.info(" gradelist size : {}", gradelist.size());
            for (int i = 0; i < gradelist.size(); i++) {
              Map<String, Object> getmap = (Map<String, Object>) gradelist.get(i);
              logger.info(" getmap: {}", getmap);
              logger.info(" getmap delvryNo: {}", getmap.get("delvryNo"));
              Map<String, Object> setmap = new HashMap();
              setmap.put("delvryNo", getmap.get("delvryNo"));
              setmap.put("serialNo", getmap.get("serialNo"));
              setmap.put("grade", getmap.get("grade"));
              setmap.put("userId", params.get("userId"));
              stockMoveMapper.insertReturnGrade(setmap);
              logger.info(" setmap: {}", setmap);
            }
          }

          stockMoveMapper.StockMovementIssue(formMap);
        }
        formMap.put("retMsg", "succ");
        // }
      }
    }

    return formMap;

  }

  // KR - OHK
  @SuppressWarnings("unchecked")
  @Override
  public Map<String, Object> stockMovementDeliveryIssueSerial(Map<String, Object> params) {
    //List<Object> checklist = (List<Object>) params.get(AppConstants.AUIGRID_CHECK);
    //Map<String, Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);

    Map<String, Object> gridList = (Map<String, Object>) params.get("gridList");
	List<Object> serialGridList = (List<Object>)gridList.get(AppConstants.AUIGRID_ALL);

    int iCnt = 0;
    String tmpdelCd = "";
    String delyCd = "";
    String delyno = "";

    if (serialGridList.size() > 0) {
      for (int i = 0; i < serialGridList.size(); i++) {
        Map<String, Object> map = (Map<String, Object>) serialGridList.get(i);

        String delCd = (String) map.get("delvryNo");
        delyno = (String) map.get("delvryNo");

        if (delCd != null && !(tmpdelCd.equals(delCd))) {
          tmpdelCd = delCd;
          if (iCnt == 0) {
            delyCd = delCd;
          } else {
            delyCd += "∈" + delCd;
          }
          iCnt++;
        }
      }
    }
    logger.info(" delyCd : {}", delyCd);

    Map<String, Object> grlist = stockMoveMapper.selectDelvryGRcmplt(delyno);

    String grmplt = (String) grlist.get("DEL_GR_CMPLT");

    if ("Y".equals(grmplt)) {
    	//params.put("failMsg", "Already processed.");
    	throw new ApplicationException(AppConstants.FAIL, "Already processed.");
    } else {

        String[] delvcd = delyCd.split("∈");

        params.put("parray", delvcd);
        params.put("refdocno", "");
        params.put("salesorder", "");

        params.put("giptdate", params.get("zGrptdate"));
        params.put("gipfdate", params.get("zGrpfdate"));
        params.put("doctext", params.get("zDoctext"));
        params.put("gtype", params.get("ztype"));

        stockMoveMapper.StockMovementIssueSerial(params);

        String reVal = (String) params.get("rdata");

        String returnValue[] = reVal.split("∈");
        logger.debug(" **** StockMovementIssueSerial [" + returnValue[0]+ "]");
        logger.debug(" **** StockMovementIssueSerial [" + returnValue[1]+ "]");

    	if(!"000".equals(returnValue[0])){
 		    throw new ApplicationException(AppConstants.FAIL, "[ERROR]" + returnValue[0]+ ":" + returnValue[1]);
 	    }

        Map<String, Object> gradeList = (Map<String, Object>) params.get("gradeList");

         if ("GR".equals(params.get("ztype")) & null != gradeList) {
             List<Object> gradeGridList = (List<Object>) gradeList.get(AppConstants.AUIGRID_UPDATE);

             for (int i = 0; i < gradeGridList.size(); i++) {
               Map<String, Object> getmap = (Map<String, Object>) gradeGridList.get(i);

               logger.info(" getmap: {}", getmap);
               logger.info(" getmap delvryNo: {}", getmap.get("delvryNo"));

               Map<String, Object> setmap = new HashMap();
               setmap.put("delvryNo", getmap.get("delvryNo"));
               setmap.put("serialNo", getmap.get("serialNo"));
               setmap.put("locStkGrad", getmap.get("lastLocStkGrad"));
               setmap.put("trnscType", params.get("zTrnscType"));
               setmap.put("ioType", params.get("zIoType"));
               setmap.put("userId", params.get("userId"));

               stockMoveMapper.StockMovementIssueBarcodeRetSave(setmap);

                // pErrcode : 000  = Success, others = Fail
         	    if(!"000".equals((String)setmap.get("pErrcode"))){
         		    throw new ApplicationException(AppConstants.FAIL, "[ERROR]" + (String)setmap.get("pErrcode") + ":" + (String)setmap.get("pErrmsg"));
         	    }
             }
         }

        // SERIAL SCAN SAVE
        params.put("delvryGrDt",params.get("zGrptdate"));
  	    params.put("reqstNo", params.get("zRstNo"));
        params.put("delvryNo", params.get("zDelyNo"));
  	    params.put("trnscType",params.get("zTrnscType"));
        params.put("ioType",params.get("zIoType"));

        //HLTANG 202111 - filter scan barcode
        params.put("reqstNo", params.get("zDelyNo"));
        //update status 'D' to 'C'
        SessionVO sessionVO = new SessionVO();
        sessionVO.setUserId(Integer.valueOf(params.get("userId").toString()));
        try {
  		serialMgmtNewService.saveSerialNo(params, sessionVO);
          } catch (Exception e) {
          	// TODO Auto-generated catch block
          	e.printStackTrace();
          }

        stockMoveMapper.StockMovementIssueBarcodeSave(params);

        String errCode = (String)params.get("pErrcode");
  	    String errMsg = (String)params.get("pErrmsg");

     	logger.debug(">>>>>>>>>>>ERROR CODE : " + errCode);
  	    logger.debug(">>>>>>>>>>>ERROR MSG: " + errMsg);

  	    // pErrcode : 000  = Success, others = Fail
  	    if(!"000".equals(errCode)){
  		    throw new ApplicationException(AppConstants.FAIL, "[ERROR]" + errCode + ":" + errMsg);
  	    }
      }

      return params;

  }

  // 백업

  // @Override
  // public Map<String, Object> stockMovementDeliveryIssue(Map<String, Object>
  // params) {
  // List<Object> checklist = (List<Object>)
  // params.get(AppConstants.AUIGRID_CHECK);
  // Map<String, Object> formMap = (Map<String, Object>)
  // params.get(AppConstants.AUIGRID_FORM);
  //
  // int iCnt = 0;
  // String tmpdelCd = "";
  // String delyCd = "";
  // if (checklist.size() > 0) {
  // for (int i = 0; i < checklist.size(); i++) {
  // Map<String, Object> map = (Map<String, Object>) checklist.get(i);
  //
  // Map<String, Object> imap = new HashMap();
  // imap = (Map<String, Object>) map.get("item");
  //
  // String delCd = (String) imap.get("delyno");
  // if (delCd != null && !(tmpdelCd.equals(delCd))) {
  // tmpdelCd = delCd;
  // if (iCnt == 0) {
  // delyCd = delCd;
  // } else {
  // delyCd += "∈" + delCd;
  // }
  // iCnt++;
  // }
  // }
  // }
  //
  // String[] delvcd = delyCd.split("∈");
  //
  // formMap.put("parray", delvcd);
  // formMap.put("userId", params.get("userId"));
  // // formMap.put("prgnm", params.get("prgnm"));
  // formMap.put("refdocno", "");
  // formMap.put("salesorder", "");
  // logger.debug("formMap : {}", formMap);
  // if ("RC".equals(formMap.get("gtype"))) {
  // // for (int i = 0 ; i < delvcd.length ; i ++){
  // // String receiptFlag = stockMoveMapper.getReceiptFlag(delvcd[i]);
  // // if (receiptFlag != null && "Y".equals(receiptFlag)){
  // // formMap.put("retMsg" , "fail");
  // // return formMap;
  // // }
  // // }
  // stockMoveMapper.StockMovementCancelIssue(formMap); // movement receipt
  // cancel
  // } else {
  // Map<String, Object> grade = (Map<String, Object>) params.get("grade");
  // logger.info(" grade : {}", grade);
  // if ("GR".equals(formMap.get("gtype")) & null != grade) {
  // List<Object> gradelist = (List<Object>)
  // grade.get(AppConstants.AUIGRID_UPDATE);
  // logger.info(" gradelist : {}", gradelist);
  // logger.info(" gradelist size : {}", gradelist.size());
  // for (int i = 0; i < gradelist.size(); i++) {
  // Map<String, Object> getmap = (Map<String, Object>) gradelist.get(i);
  // logger.info(" getmap: {}", getmap);
  // logger.info(" getmap delvryNo: {}", getmap.get("delvryNo"));
  // Map<String, Object> setmap = new HashMap();
  // setmap.put("delvryNo", getmap.get("delvryNo"));
  // setmap.put("serialNo", getmap.get("serialNo"));
  // setmap.put("grade", getmap.get("grade"));
  // setmap.put("userId", params.get("userId"));
  // stockMoveMapper.insertReturnGrade(setmap);
  // logger.info(" setmap: {}", setmap);
  // }
  // }
  //
  // stockMoveMapper.StockMovementIssue(formMap);
  // }
  // formMap.put("retMsg", "succ");
  // // }
  //
  // return formMap;
  //
  // }

  @Override
  public List<EgovMap> selectStockMovementDeliverySerial(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return stockMoveMapper.selectStockMovementDeliverySerial(params);
  }

  @Override
  public List<EgovMap> selectStockMovementMtrDocInfoList(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return stockMoveMapper.selectStockMovementMtrDocInfoList(params);
  }

  @Override
  public void insertStockBooking(Map<String, Object> params) {
    // TODO Auto-generated method stub
    // return stocktran.selectStockTransferMtrDocInfoList(params);
    stockMoveMapper.insertStockBooking(params);
  }

  @Override
  public List<EgovMap> selectGetSerialDataCall(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return stockMoveMapper.selectGetSerialDataCall(params);
  }

  @Override
  public void deleteSmoNo(Map<String, Object> params) {

    String reqsmono = (String) params.get("reqsmono");
    logger.info(" reqsmono ???? : {}", params.get("reqsmono"));
    if (!"".equals(reqsmono) || null != reqsmono) {
    	// 20120103 KR-MIN
    	// check good issue -> No delete
    	String outYn = stockMoveMapper.getSmoOutYn(reqsmono);
    	if("Y".equals(outYn)){
    		throw new ApplicationException(AppConstants.FAIL, "[ERROR]" + "99:You cannot delete issued smo.");
    	}

      // stockMoveMapper.updateStockHead(reqsmono);
      stockMoveMapper.deleteStockDelete(reqsmono);
      stockMoveMapper.deleteStockBooking(reqsmono);
    }
  }

  @Override
  public String selectDefToLocation(Map<String, Object> param) {

    return stockMoveMapper.selectDefToLocation(param);

  }

  @Override
  public String defToLoc(Map<String, Object> param) {
    // TODO Auto-generated method stub
    return null;
  }

  @Override
  public List<EgovMap> SelectStockfromForecast(Map<String, Object> params) {
    // TODO Auto-generated method stub
    return stockMoveMapper.SelectStockfromForecast(params);
  }

  @Override
  public String insertStockMovementbyForecast(Map<String, Object> params) {
    List<Object> insList = (List<Object>) params.get("add");
    Map<String, Object> fMap = (Map<String, Object>) params.get("form");

    if (insList.size() > 0) {
      for (int i = 0; i < insList.size(); i++) {
        Map<String, Object> insMap = (Map<String, Object>) insList.get(i);

        insMap.put("tlocation", fMap.get("tlocation"));
        insMap.put("rqty", insMap.get("itmfcastqty"));

        logger.info("###insMap: " + insMap.toString());

        int iCnt = stockMoveMapper.selectAvaliableStockQty(insMap);
        if (iCnt == 1) {
          return "";
        }
      }
    }

    String reqNo = stockMoveMapper.selectStockMovementSeq();

    fMap.put("reqno", reqNo);
    fMap.put("userId", params.get("userId"));

    stockMoveMapper.insStockMovementHead(fMap);

    if (insList.size() > 0) {
      for (int i = 0; i < insList.size(); i++) {
        Map<String, Object> insMap = (Map<String, Object>) insList.get(i);
        insMap.put("reqno", reqNo);
        insMap.put("userId", params.get("userId"));
        stockMoveMapper.insStockMovement(insMap);
      }
    }

    insertStockBooking(fMap);

    String mdnNo = "";
    String dvrNo = "";

    logger.info("###isCody: " + fMap.get("isCody"));

    // Added for Direct GI after SMO key in enhancement by Hui Ding, 29-03-2020
    // start Close for Filter Barcode Scan by HLTANG, 11-2021 - to remove auto GI when using forecast
//    if(fMap.get("isCody") != null && fMap.get("isCody").equals("Y")){
//        String deliSeq = stockMoveMapper.selectDeliveryStockMovementSeq();
//        String[] delvcd = { deliSeq };
//
//        Map<String, Object> insMapGi = null;
//
//        if (insList.size() > 0) {
//            for (int i = 0; i < insList.size(); i++) {
//
//            	int itmNo = i + 1;
//            	insMapGi = (Map<String, Object>) insList.get(i);
//
//            	insMapGi.put("delno", deliSeq);
//            	insMapGi.put("reqstno", reqNo);
//            	insMapGi.put("reqitmno", itmNo);
//            	insMapGi.put("indelyqty", insMapGi.get("itmfcastqty"));
//            	insMapGi.put("userId", params.get("userId"));
//
//            	stockMoveMapper.insertDeliveryStockMovementDetail(insMapGi);
//
//              }
//
//            insMapGi.put("ttype", fMap.get("sttype"));
//            insMapGi.put("mtype", fMap.get("smtype"));
//
//            stockMoveMapper.insertDeliveryStockMovement(insMapGi);
//        }
//
//        Map<String, Object> giMap = new HashMap<String, Object>();
//
//        giMap.put("parray", delvcd);
//        giMap.put("gtype", "GI");
//        giMap.put("userId", params.get("userId"));
//        giMap.put("prgnm", params.get("prgnm"));
//
//        SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");
//        Date currDate = new Date();
//        giMap.put("giptdate", formatter.format(currDate));
//
//        logger.info("###giMap content: " + giMap.toString());
//
//        stockMoveMapper.StockMovementIssue(giMap);
//
//        if (giMap.get("rdata") != null){
//        	String result = giMap.get("rdata").toString();
//        	logger.info("###giMap rdata: " + result);
//
//        	String returnValue[] = result.split("∈");
//            for (int i = 0; i < returnValue.length; i++) {
//              returnValue[i] = returnValue[i].replaceAll(" ", "");
//            }
//
//            if (returnValue[0].equals("000")){
//            	mdnNo = returnValue[1];
//            }
//
//        }
//        dvrNo = deliSeq;
//    }
 // end Close for Filter Barcode Scan by HLTANG, 11-2021
    String result = "SMO No: " + reqNo ;

    if (mdnNo != null && !mdnNo.equals("")){
    	result = result +"</br>MDN No: " + mdnNo;
    }
    if (dvrNo != null && !dvrNo.equals("")){
    	result = result + "</br>DVR No: " + dvrNo;
    }

    return result;

  }

  @Override
  public String insertStockMovementForOnLoanUnit(Map<String, Object> params) {
    List<Object> insList = (List<Object>) params.get("add");
    Map<String, Object> fMap = (Map<String, Object>) params.get("form");
    String reqstTypDtl = "OD03";

    if (insList.size() > 0) {
      for (int i = 0; i < insList.size(); i++) {
        Map<String, Object> insMap = (Map<String, Object>) insList.get(i);

        insMap.put("tlocation", fMap.get("tlocation"));

        int iCnt = stockMoveMapper.selectAvaliableStockQty(insMap);
        if (iCnt == 1) {
          return "";
        }
      }
    }

    String reqNo = stockMoveMapper.selectStockMovementSeq();

    fMap.put("reqno", reqNo);
    fMap.put("userId", params.get("userId"));
    fMap.put("reqstTypDtl", reqstTypDtl);

    stockMoveMapper.insStockMovementHeadForOnLoanUnit(fMap);

    if (insList.size() > 0) {
      for (int i = 0; i < insList.size(); i++) {
        Map<String, Object> insMap = (Map<String, Object>) insList.get(i);
        insMap.put("reqno", reqNo);
        insMap.put("userId", params.get("userId"));
        stockMoveMapper.insStockMovement(insMap);
      }
    }

    insertStockBooking(fMap);

    // insert new table, get from Wayne.
    int seqSVC111D = stockMoveMapper.crtSeqSVC0111D();
    fMap.put("seqSVC111D", seqSVC111D);

    stockMoveMapper.insSVC0111D(fMap);

    //REFER BACK TO SMO TABLE
    //stockMoveMapper.insSVC0112D(fMap);

    return reqNo;

  }

  @Override
  public int getASNo(Map<String, Object> params) {
    int count = 0;
    if ("1".equals(params.get("IND"))) {
      count = stockMoveMapper.getIHNo(params);
    } else {
      count = stockMoveMapper.getASNo(params);
    }
    return count;
  }

  @Override
  public int chkASNoExist(Map<String, Object> params) {
    int smo = stockMoveMapper.chkASNoExist(params);
    return smo;
  }

  @Override
  public List<EgovMap> selectSmoIssueOutPop(Map<String, Object> params) {
	  // KR OHK : SMO Serial Check Popup
	  return stockMoveMapper.selectSmoIssueOutPop(params);
  }

  @Override
  public List<EgovMap> selectSmoIssueInPop(Map<String, Object> params) {
	  // KR OHK : SMO Serial Check Popup
	  return stockMoveMapper.selectSmoIssueInPop(params);
  }

  @Override
  public List<EgovMap> selectSMOIssueInSerialGradeList(Map<String, Object> params) {
	  // KR OHK : SMO Serial Grade List
	  return stockMoveMapper.selectSMOIssueInSerialGradeList(params);
  }
}
