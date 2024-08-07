package com.coway.trust.biz.logistics.pointofsales.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.logistics.pointofsales.PointOfSalesService;
import com.coway.trust.biz.logistics.stockmovement.impl.StockMovementMapper;
import com.coway.trust.cmmn.exception.ApplicationException;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/*********************************************************************************************
 * DATE          PIC        VERSION     COMMENT
 *--------------------------------------------------------------------------------------------
 * 09/10/2019    ONGHC      1.0.1       - AMEND FOR LATEST CHANGES
 *********************************************************************************************/

@Service("PointOfSalesService")
public class PointOfSalesServiceImpl extends EgovAbstractServiceImpl implements PointOfSalesService {

  private final Logger logger = LoggerFactory.getLogger(this.getClass());
  @Resource(name = "PointOfSalesMapper")
  private PointOfSalesMapper PointOfSalesMapper;

  @Resource(name = "stockMoveMapper")
  private StockMovementMapper stockMoveMapper;

  @Override
  public List<EgovMap> getTrxTyp(Map<String, Object> params) {
    return PointOfSalesMapper.getTrxTyp(params);
  }

  @Override
  public List<EgovMap> PosSearchList(Map<String, Object> params) {
    return PointOfSalesMapper.PosSearchList(params);
  }

  @Override
  public List<EgovMap> posItemList(Map<String, Object> params) {
    return PointOfSalesMapper.posItemList(params);
  }

  @Override
  public List<EgovMap> selectTypeList(Map<String, Object> params) {
    return PointOfSalesMapper.selectTypeList(params);
  }

  @Override
  public List<EgovMap> selectAdjRsn(Map<String, Object> params) {
    return PointOfSalesMapper.selectAdjRsn(params);
  }

  @Override
  public List<EgovMap> getRqstLocLst(Map<String, Object> params) {
    return PointOfSalesMapper.getRqstLocLst(params);
  }

  @Override
  public List<EgovMap> selectPointOfSalesSerial(Map<String, Object> params) {
    return PointOfSalesMapper.selectPointOfSalesSerial(params);
  }

  @Override
  public String insertPosInfo(Map<String, Object> params) {
    /* 2017-11-30 김덕호 위원 채번 변경 요청 */
    String seq = PointOfSalesMapper.selectPosSeq();

    List<Object> checkList = (List<Object>) params.get(AppConstants.AUIGRID_CHECK);
    Map<String, Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
    // List<Object> serialList = (List<Object>)
    // params.get(AppConstants.AUIGRID_ADD);

    // for (int i = 0; i < checkList.size(); i++) {
    // logger.debug("checkList 값 : {}", checkList.get(i));
    // }
    //
    // if (serialList.size() > 0) {
    // for (int i = 0; i < serialList.size(); i++) {
    // logger.debug("serialList 값 : {}", serialList.get(i));
    // }
    // }

    formMap.put("reqno", seq);
    formMap.put("userId", params.get("userId"));
    // String posSeq = formMap.get("headtitle") + seq;

    PointOfSalesMapper.insOtherReceiptHead(formMap);

    if (checkList.size() > 0) {
      for (int i = 0; i < checkList.size(); i++) {
        // logger.debug("checkList 값 : {}", checkList.get(i));
        Map<String, Object> insMap = (Map<String, Object>) checkList.get(i);
        // insMap.put("reqno", formMap.get("headtitle") + seq);
        insMap.put("reqno", seq);
        insMap.put("userId", params.get("userId"));
        PointOfSalesMapper.insRequestItem(insMap);
      }
    }

    // if (serialList.size() > 0) {
    // for (int i = 0; i < serialList.size(); i++) {
    // Map<String, Object> serialMap = (Map<String, Object>) serialList.get(i);
    // serialMap.put("reqno", posSeq);
    // serialMap.put("ttype", formMap.get("trnscType"));
    // serialMap.put("userId", params.get("userId"));
    //
    // PointOfSalesMapper.insertSerial(serialMap);
    // }
    // }

    if (!("OH03".equals(formMap.get("insReqType")) || "OH09".equals(formMap.get("insReqType"))
        || "OG".equals(formMap.get("insTransType")))) {// OH03 , OH09
      insertStockBooking(formMap);
    }
    return seq;
  }

  @Override
  public String insertGiInfo(Map<String, Object> params) {
    List<EgovMap> GIList = (List<EgovMap>) params.get(AppConstants.AUIGRID_CHECK);
    Map<String, Object> GiMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
    List<Object> serialList = (List<Object>) params.get(AppConstants.AUIGRID_ADD);

    logger.debug("===========================insertGiInfo===============================");
    logger.debug("== GIList " + GIList.toString());
    logger.debug("== GiMap " + GiMap.toString());
    logger.debug("== serialList " + serialList.toString());
    logger.debug("===========================insertGiInfo===============================");

    String reVal = "";

    int iCnt = 0;
    String ttype = "";
    String docno = "";
    String tmpdelCd = "";
    String delyCd = "";

    if (GIList.size() > 0) {

      for (int i = 0; i < GIList.size(); i++) {

        Map<String, Object> tmpMap = GIList.get(i);
        Map<String, Object> imap = new HashMap();
        imap = (Map<String, Object>) tmpMap.get("item");
        ttype = (String) imap.get("ttype");
        docno = (String) imap.get("docno");

        String delCd = (String) imap.get("reqstno");

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

    logger.debug("reqstno ???    값 : {}", GiMap.get("reqstno"));
    logger.debug("ttype ???    값 : {}", ttype);

    if (serialList != null && serialList.size() > 0) {

      for (int i = 0; i < serialList.size(); i++) {
        Map<String, Object> serialMap = (Map<String, Object>) serialList.get(i);

        serialMap.put("reqno", GiMap.get("reqstno"));
        serialMap.put("ttype", ttype);
        serialMap.put("userId", params.get("userId"));

        PointOfSalesMapper.insertSerial(serialMap);
      }

    }

    String[] delvcd = delyCd.split("∈");
    GiMap.put("parray", delvcd);
    GiMap.put("gtype", ttype);
    GiMap.put("prgnm", "Other GI/GR");
    GiMap.put("refdocno", docno);
    GiMap.put("salesorder", "");
    GiMap.put("userId", params.get("userId"));
    logger.debug("GiMap ???    값 : {}", GiMap);
    if ("GC".equals(GiMap.get("gitype"))) {
      PointOfSalesMapper.GICancelIssue(GiMap);
      reVal = (String) GiMap.get("rdata");
    } else {
      PointOfSalesMapper.GIRequestIssue(GiMap);
      reVal = (String) GiMap.get("rdata");
    }
    String returnValue[] = reVal.split("∈");
    return returnValue[1];
  }

  @Override
  public Map<String, Object> PosDataDetail(String param) {
    Map<String, Object> hdMap = PointOfSalesMapper.selectPosHead(param);

    List<EgovMap> list = PointOfSalesMapper.selectPosItem(param);

    Map<String, Object> pMap = new HashMap();
    pMap.put("reqloc", hdMap.get("reqcr"));

    List<EgovMap> toList = PointOfSalesMapper.selectPosToItem(pMap);

    Map<String, Object> reMap = new HashMap();
    reMap.put("hValue", hdMap);
    reMap.put("iValue", list);
    reMap.put("itemto", toList);

    return reMap;
  }

  @Override
  public List<EgovMap> selectSerial(Map<String, Object> params) {
    List<EgovMap> list = PointOfSalesMapper.selectSerial(params);

    return list;
  }

  @Override
  public void insertStockBooking(Map<String, Object> params) {
    // return stocktran.selectStockTransferMtrDocInfoList(params);
    PointOfSalesMapper.insertStockBooking(params);
  }

  @Override
  public List<EgovMap> selectMaterialDocList(Map<String, Object> params) {
    return PointOfSalesMapper.selectMaterialDocList(params);
  }

  @Override
  public int selectOtherReqChk(Map<String, Object> params) {
    List<EgovMap> GIList = (List<EgovMap>) params.get(AppConstants.AUIGRID_CHECK);
    String reqno = "";
    String reqstatus = "";
    int reqcnt = 0;

    if (GIList.size() > 0) {

      for (int i = 0; i < GIList.size(); i++) {
        Map<String, Object> tmpMap = GIList.get(i);
        Map<String, Object> imap = new HashMap();
        imap = (Map<String, Object>) tmpMap.get("item");
        reqno = (String) imap.get("reqstno");
        reqstatus = (String) imap.get("status");
      }

      if ("O".equals(reqstatus)) {
        logger.debug("cancle NO 값 : {}");
        reqcnt = PointOfSalesMapper.selectOtherReqChk(reqno);
        if (reqcnt == 0) {
          reqcnt = 0;
        } else {
          reqcnt = 1;
        }
      } else if ("C".equals(reqstatus)) {
        logger.debug("cancle YES 값 : {}");
        reqcnt = PointOfSalesMapper.selectOtherReqCancleChk(reqno);
        if (reqcnt == 0) {
          reqcnt = 0;
        } else {
          reqcnt = 1;
        }
      }

    }

    return reqcnt;
  }

  @Override
  public void deleteStoNo(Map<String, Object> params) {
    String reqstono = (String) params.get("reqstono");
    logger.info(" otherNo ~ ???? : {}", params.get("reqstono"));
    if (!"".equals(reqstono) || null != reqstono) {
      PointOfSalesMapper.updateStockHead(reqstono);
      PointOfSalesMapper.deleteStockDelete(reqstono);
      PointOfSalesMapper.deleteStockBooking(reqstono);
    }
  }

  public EgovMap selectAttachmentInfo(Map<String, Object> params) {
    return PointOfSalesMapper.selectAttachmentInfo(params);
}

  // KR-OHK Serial add
  @Override
  public List<EgovMap> selectReqItemList(String taskType, String param) {
      List<EgovMap> list = null;

      if("VIEW".equals(taskType)) {
    	  list = PointOfSalesMapper.selectPosItem(param);
      } else if("INS".equals(taskType)) {
    	  list = PointOfSalesMapper.selectReqItemList(param);
      }

      return list;
  }

  // KR-OHK Serial add
  @SuppressWarnings("unchecked")
  @Override
  public String insertGiInfoSerial(Map<String, Object> params) {
    List<EgovMap> GIList = (List<EgovMap>) params.get(AppConstants.AUIGRID_CHECK);
    Map<String, Object> GiMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);

    logger.debug("===========================insertGiInfoSerial===============================");
    logger.debug("== GIList " + GIList.toString());
    logger.debug("== GiMap " + GiMap.toString());
    logger.debug("===========================insertGiInfoSerial===============================");

    String reVal = "";

    int iCnt = 0;
    String ttype = "";
    String docno = "";
    String tmpdelCd = "";
    String delyCd = "";

    if (GIList.size() > 0) {
      for (int i = 0; i < GIList.size(); i++) {

        Map<String, Object> tmpMap = GIList.get(i);
        Map<String, Object> imap = new HashMap<String, Object>();
        imap = (Map<String, Object>) tmpMap.get("item");
        ttype = (String) imap.get("ttype");
        docno = (String) imap.get("docno");

        String delCd = (String) imap.get("reqstno");

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

    String[] delvcd = delyCd.split("∈");
    GiMap.put("parray", delvcd);
    GiMap.put("gtype", ttype);
    GiMap.put("prgnm", "Other GI/GR");
    GiMap.put("refdocno", docno);
    GiMap.put("salesorder", "");
    GiMap.put("userId", params.get("userId"));
    logger.debug("GiMap ???    : {}", GiMap);

    stockMoveMapper.StockMovementIssueSerial(GiMap);

    reVal = (String) GiMap.get("rdata");
    String returnValue[] = reVal.split("∈");

    if(!"000".equals(returnValue[0])){
	    throw new ApplicationException(AppConstants.FAIL, "[ERROR]" + returnValue[0] + ":" + returnValue[1]);
    }

    // KR-OHK Barcode save/reverse Start
    String errCode = "";
    String errMsg = "";
    String reqstno = "";
    String ioType = "";

    if (GIList.size() > 0) {
        for (int i = 0; i < GIList.size(); i++) {

            Map<String, Object> tmpMap = GIList.get(i);
            Map<String, Object> imap = new HashMap<String, Object>();
            imap = (Map<String, Object>) tmpMap.get("item");

            ttype = (String) imap.get("ttype");
            reqstno = (String) imap.get("reqstno");

            if("OI".equals(ttype)) {
            	ioType = "O";
            } else if("OG".equals(ttype)) {
            	ioType = "I";
            }

        	if ("GC".equals(GiMap.get("gitype"))) { // Cancel(Not use!!)
            	Map<String, Object> canMap = new HashMap<String, Object>();

            	canMap.put("reqstNo", reqstno);
                canMap.put("trnscType", ttype);
                canMap.put("ioType", ioType);
                canMap.put("userId", params.get("userId"));

            	PointOfSalesMapper.SP_LOGISTIC_BARCODE_REVS_OGOI(canMap);

                errCode = (String)canMap.get("pErrcode");
                errMsg = (String)canMap.get("pErrmsg");

                logger.debug(">>>>>>>>>>>SP_LOGISTIC_BARCODE_REVS_OGOI ERROR CODE : " + errCode);
                logger.debug(">>>>>>>>>>>SP_LOGISTIC_BARCODE_REVS_OGOI ERROR MSG: " + errMsg);
            } else { // GI/GR
            	Map<String, Object> otherMap = new HashMap<String, Object>();

            	otherMap.put("delvryGrDt", GiMap.get("giptdate"));
                otherMap.put("reqstNo", reqstno);
                otherMap.put("trnscType", ttype);
                otherMap.put("ioType", ioType);
                otherMap.put("userId", params.get("userId"));

            	PointOfSalesMapper.SP_LOGISTIC_BARCODE_SAVE_OGOI(otherMap);

            	errCode = (String)otherMap.get("pErrcode");
                errMsg = (String)otherMap.get("pErrmsg");

                logger.debug(">>>>>>>>>>>SP_LOGISTIC_BARCODE_SAVE_OGOI ERROR CODE : " + errCode);
                logger.debug(">>>>>>>>>>>SP_LOGISTIC_BARCODE_SAVE_OGOI ERROR MSG: " + errMsg);
            }
            // pErrcode : 000  = Success, others = Fail
            if(!"000".equals(errCode)){
        	    throw new ApplicationException(AppConstants.FAIL, "[ERROR]" + errCode + ":" + errMsg);
            }
        }
    }
    // KR-OHK Barcode save/reverse End

    return returnValue[1];
  }

  // KR-OHK Serial add
  @Override
  public void deleteStoNoSerial(Map<String, Object> params) {
    String reqstono = (String) params.get("reqstono");
    logger.info(" otherNo ~ ???? : {}", params.get("reqstono"));
    if (!"".equals(reqstono) || null != reqstono) {
      PointOfSalesMapper.updateStockHead(reqstono);
      PointOfSalesMapper.deleteStockDelete(reqstono);
      PointOfSalesMapper.deleteStockBooking(reqstono);
    }

    // KR-OHK Barcode delete Start
    String trnscType = (String) params.get("ttype");
    String ioType = "";

    if("OI".equals(trnscType)) {
    	ioType = "O";
    } else if("OG".equals(trnscType)) {
    	ioType = "I";
    }

    Map<String, Object> otherMap = new HashMap<String, Object>();

    otherMap.put("allYn", "Y");
    otherMap.put("reqstNo", reqstono);
    otherMap.put("locId", params.get("locId"));
    otherMap.put("trnscType", trnscType);
    otherMap.put("ioType", ioType);
    otherMap.put("userId", params.get("userId"));

    PointOfSalesMapper.SP_LOGISTIC_BARCODE_DEL_OGOI(otherMap);

    String errCode = (String)otherMap.get("pErrcode");
    String errMsg = (String)otherMap.get("pErrmsg");

    logger.debug(">>>>>>>>>>>SP_LOGISTIC_BARCODE_DEL_OGOI ERROR CODE : " + errCode);
    logger.debug(">>>>>>>>>>>SP_LOGISTIC_BARCODE_DEL_OGOI ERROR MSG: " + errMsg);

    // pErrcode : 000  = Success, others = Fail
    if(!"000".equals(errCode)){
	    throw new ApplicationException(AppConstants.FAIL, "[ERROR]" + errCode + ":" + errMsg);
    }
    // Barcode delete End
  }
}
