package com.coway.trust.biz.services.sim.impl;

import java.math.BigDecimal;
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
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.services.sim.SrvItmMgmtListService;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import oracle.sql.DATE;

/*********************************************************************************************
 * DATE          PIC        VERSION     COMMENT
 *--------------------------------------------------------------------------------------------
 * 20/06/2019    ONGHC      1.0.1       - CREATE SERVICE ITEM MANAGEMENT
 * 29/08/2019    ONGHC      1.0.2       - Enhance to Support DSC Branch
 *********************************************************************************************/

@Service("SrvItmMgmtListService")
public class SrvItmMgmtListServiceImpl extends EgovAbstractServiceImpl implements SrvItmMgmtListService {

  private static final Logger LOGGER = LoggerFactory.getLogger(SrvItmMgmtListServiceImpl.class);

  @Resource(name = "SrvItmMgmtListMapper")
  private SrvItmMgmtListMapper SrvItmMgmtListMapper;

  @Override
  public List<EgovMap> getBchTyp(Map<String, Object> params) {
    return SrvItmMgmtListMapper.getBchTyp(params);
  }

  @Override
  public List<EgovMap> getBch(Map<String, Object> params) {
    return SrvItmMgmtListMapper.getBch(params);
  }

  @Override
  public List<EgovMap> getItm(Map<String, Object> params) {
    return SrvItmMgmtListMapper.getItm(params);
  }

  @Override
  public List<EgovMap> searchSrvItmLst(Map<String, Object> params) {
    return SrvItmMgmtListMapper.searchSrvItmLst(params);
  }

  @Override
  public String getBchTypDesc(String params) {
    return SrvItmMgmtListMapper.getBchTypDesc(params);
  }

  @Override
  public String getBrTypId(String params) {
    return SrvItmMgmtListMapper.getBrTypId(params);
  }

  @Override
  public String getBchDesc(String params) {
    return SrvItmMgmtListMapper.getBchDesc(params);
  }

  @Override
  public String getItmCde(String params) {
    return SrvItmMgmtListMapper.getItmCde(params);
  }

  @Override
  public String getItmDesc(String params) {
    return SrvItmMgmtListMapper.getItmDesc(params);
  }

  @Override
  public String getBrTypDesc(String params) {
    return SrvItmMgmtListMapper.getBrTypDesc(params);
  }

  @Override
  public List<EgovMap> getSrvItmRcd(Map<String, Object> params) {
    return SrvItmMgmtListMapper.getSrvItmRcd(params);
  }

  @Override
  public List<EgovMap> getMovTyp(Map<String, Object> params) {
    return SrvItmMgmtListMapper.getMovTyp(params);
  }

  @Override
  public List<EgovMap> getMovDtl(Map<String, Object> params) {
    return SrvItmMgmtListMapper.getMovDtl(params);
  }

  @SuppressWarnings({ "unchecked", "rawtypes" })
  @Override
  public EgovMap insertSrvItm(Map<String, Object> params) {
    Map resultM = (Map) params.get("resultMst");
    resultM.put("updator", params.get("updator"));
    List<EgovMap> itmResult = (List<EgovMap>) params.get("allRowItems");

    int noItm = 0;
    int totalInQty = 0;
    int totalOutQty = 0;
    int totalQty = 0;

    EgovMap rtnRst = new EgovMap();

    LOGGER.debug("===================================================");
    LOGGER.debug("= resultM " + resultM.toString());
    LOGGER.debug("= itmResult " + itmResult.toString());

    EgovMap log89M = SrvItmMgmtListMapper.get89MPrxNo(resultM);
    if (log89M == null) { // NEW ITEM DOES NOT EXIST ON LOG0089M
      // INSERT LOG0089M HERE
      int noRowAffected = SrvItmMgmtListMapper.insertLog89M(resultM);
      LOGGER.debug("= noRowAffected " + noRowAffected);
      if (noRowAffected == 0) {
        rtnRst.put("msg", "99");
        rtnRst.put("row", 0);
        rtnRst.put("inQty", 0);
        rtnRst.put("outQty", 0);
        rtnRst.put("gtQty", 0);
        return rtnRst;
      } else {
        log89M = SrvItmMgmtListMapper.get89MPrxNo(resultM);
        if (log89M == null) {
          rtnRst.put("msg", "99");
          rtnRst.put("row", 0);
          rtnRst.put("inQty", 0);
          rtnRst.put("outQty", 0);
          rtnRst.put("gtQty", 0);
          return rtnRst;
        }
        log89M.put("updator", params.get("updator"));
        LOGGER.debug("= log89M " + log89M.toString());
      }
    } else {
      log89M.put("updator", params.get("updator"));
      LOGGER.debug("= log89M " + log89M.toString());
    }

    if (log89M != null) {
      int noRowAffected = SrvItmMgmtListMapper.updUsrLog89(log89M);
    }

    if (itmResult != null) {
      String prxNo = (String) log89M.get("refNo");
      String log91DseqNo = "0";

      noItm = itmResult.size();
      for (int i = 0; i < itmResult.size(); i++) {
        Map itmAdd = itmResult.get(i);
        itmAdd.put("updator", params.get("updator"));
        itmAdd.put("prxNo", prxNo);

        if (itmAdd.get("movTypCde").equals("0")) {
          totalInQty = totalInQty + Integer.parseInt((String) itmAdd.get("qty"));
        } else if (itmAdd.get("movTypCde").equals("1")) {
          totalOutQty = totalOutQty + Integer.parseInt((String) itmAdd.get("qty"));
        }

        totalQty = totalQty + Integer.parseInt((String) itmAdd.get("qty"));

        // START INSERT
        int noRowAffected = SrvItmMgmtListMapper.insertLog91D(itmAdd);
        LOGGER.debug(itmAdd.toString());
        log91DseqNo = itmAdd.get("log91DseqNo").toString();
        LOGGER.debug("= noRowAffected " + noRowAffected);

        // PREPARE DATA TO INSERT LOG0090D
        log89M.put("refDocNo", itmAdd.get("refNo").toString());
        log89M.put("memId", itmAdd.get("memId").toString());
        log89M.put("deptCode", itmAdd.get("cmgroup").toString());

        LOGGER.debug("= Total Quantity " + totalQty);

        log89M.put("log91DseqNo", log91DseqNo);

        if (totalQty > 0) { // INSERT SUB DATA LOG0090D
          for (int x = 0; x < totalQty; x++) {

            noRowAffected = SrvItmMgmtListMapper.insertLog90D(log89M);
          }
        }
      }

      rtnRst.put("msg", "0");
      rtnRst.put("row", noItm);
      rtnRst.put("inQty", totalInQty);
      rtnRst.put("outQty", totalOutQty);
      rtnRst.put("gtQty", totalQty);
    }

    LOGGER.debug("===================================================");

    return rtnRst;
  }

  @Override
  public int deactivateLog91d(Map<String, Object> params) {
    return SrvItmMgmtListMapper.deactivateLog91d(params);
  }
}
