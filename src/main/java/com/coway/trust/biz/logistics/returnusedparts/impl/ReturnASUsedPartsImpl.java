	package com.coway.trust.biz.logistics.returnusedparts.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.logistics.returnusedparts.ReturnASUsedPartsService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/*********************************************************************************************
 * DATE          PIC        VERSION     COMMENT
 *--------------------------------------------------------------------------------------------
 * 18/12/2019    ONGHC      1.0.1       - Create AS Used Filter
 *********************************************************************************************/

@Service("returnASUsedPartsService")
public class ReturnASUsedPartsImpl extends EgovAbstractServiceImpl implements ReturnASUsedPartsService {

  private final Logger logger = LoggerFactory.getLogger(this.getClass());
  @Resource(name = "returnASUsedPartsMapper")
  private ReturnASUsedPartsMapper returnASUsedPartsMapper;

  @Override
  public List<EgovMap> returnPartsList(Map<String, Object> params) {
    return returnASUsedPartsMapper.returnPartsList(params);
  }

  @Override
  public void returnPartsUpdate(Map<String, Object> params, int loginId) {
    List<Object> checkList = (List<Object>) params.get(AppConstants.AUIGRID_CHECK);
        int size = 1000;
        int page = checkList.size() % size == 0 ? (checkList.size() / size) - 1 : checkList.size() / size;
        int start;
        int end;

        if (checkList.size() > 0) {
            Map<String, Object> bulkMap = new HashMap<>();
            for (int i = 0; i <= page; i++) {
              start = i * size  ;
              end = i == page ? checkList.size() : size;

        	  bulkMap.put("list", checkList.stream().skip(start).limit(end).collect(Collectors.toCollection(ArrayList::new)));
              bulkMap.put("userId", loginId);
              returnASUsedPartsMapper.upReturnParts(bulkMap);
            }
        }
  }

  @Override
  public void returnPartsCanCle(Map<String, Object> params) {
    List<Object> checkList = (List<Object>) params.get(AppConstants.AUIGRID_CHECK);

    for (int i = 0; i < checkList.size(); i++) {
      logger.debug("checkList    값 : {}", checkList.get(i));
    }

    if (checkList.size() > 0) {
      for (int i = 0; i < checkList.size(); i++) {
        Map<String, Object> insMap = (Map<String, Object>) checkList.get(i);
        returnASUsedPartsMapper.returnPartsCanCle(insMap);
      }
    }
  }

  @Override
  public void returnPartsInsert(String param) {
    returnASUsedPartsMapper.returnPartsInsert(param);
  }

  @Override
  public void returnPartsdelete(String param) {
    returnASUsedPartsMapper.returnPartsdelete(param);
  }

  @Override
  public int validMatCodeSearch(String matcode) {
    return returnASUsedPartsMapper.validMatCodeSearch(matcode);

  }

  @Override
  public int returnPartsdupchek(Map<String, Object> insMap) {
    return returnASUsedPartsMapper.returnPartsdupchek(insMap);
  }

  @Override
  public List<EgovMap> getDeptCodeList(Map<String, Object> params) {
    return returnASUsedPartsMapper.getDeptCodeList(params);
  }

  @Override
  public List<EgovMap> getCodyCodeList(Map<String, Object> params) {
    return returnASUsedPartsMapper.getCodyCodeList(params);
  }

  @Override
  public List<EgovMap> selectBranchCodeList(Map<String, Object> params) {
    return returnASUsedPartsMapper.selectBranchCodeList(params);
  }

  @Override
  public List<EgovMap> getBchBrowse(Map<String, Object> params) {
    return returnASUsedPartsMapper.getBchBrowse(params);
  }

  @Override
  public List<EgovMap> getLoc(Map<String, Object> params) {

    String searchgb = (String) params.get("searchlocgb");
    String[] searchgbvalue = searchgb.split("∈");
    int searchBranch = Integer.parseInt((String) params.get("searchBranch"));

    params.put("searchlocgb", searchgbvalue);
    params.put("brnch", searchBranch);

    return returnASUsedPartsMapper.getLoc(params);
  }

  @Override
  public List<EgovMap> getDefGrp(Map<String, Object> params) {
    return returnASUsedPartsMapper.getDefGrp(params);
  }

  @Override
  public List<EgovMap> getSltCde(Map<String, Object> params) {
    return returnASUsedPartsMapper.getSltCde(params);
  }

  @Override
  public List<EgovMap> getProdCat(Map<String, Object> params) {
    return returnASUsedPartsMapper.getProdCat(params);
  }

  @Override
  public List<EgovMap> getdefCde(Map<String, Object> params) {
    return returnASUsedPartsMapper.getdefCde(params);
  }

  @Override
  public List<EgovMap> getRptType() {
    return returnASUsedPartsMapper.getRptType();
  }

  @Override
  public List<EgovMap> getRtnStat() {
    return returnASUsedPartsMapper.getRtnStat();
  }

}
