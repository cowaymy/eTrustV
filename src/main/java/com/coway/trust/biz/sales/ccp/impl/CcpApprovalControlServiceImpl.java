package com.coway.trust.biz.sales.ccp.impl;

import javax.annotation.Resource;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.sales.ccp.CcpApprovalControlService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;


@Service("ccpApprovalControlService")
public class CcpApprovalControlServiceImpl extends EgovAbstractServiceImpl implements CcpApprovalControlService{

  @Resource(name = "ccpApprovalControlMapper")
  private CcpApprovalControlMapper ccpApprovalControlMapper;

  @Override
  public List<EgovMap> selectProductControlList(Map<String, Object> params) throws Exception {
    return ccpApprovalControlMapper.selectProductControlList(params);
  }

  @SuppressWarnings("unchecked")
  @Override
  public void saveProductionControl(Map<String, ArrayList<Object>> params, int userId) {
    List<Object> updateList = params.get(AppConstants.AUIGRID_UPDATE);

    updateList.forEach(r -> {
      ((Map<String, Object>) r).put("userId", userId);
      ccpApprovalControlMapper.updateProductControl((Map<String, Object>) r);
    });
  }

  @Override
  public List<EgovMap> selectChsControlList(Map<String, Object> params) throws Exception {
    return ccpApprovalControlMapper.selectChsControlList(params);
  }

  @SuppressWarnings("unchecked")
  @Override
  public void saveChsControl(Map<String, ArrayList<Object>> params, int userId) {
    List<Object> updateList = params.get(AppConstants.AUIGRID_UPDATE);

    updateList.forEach(r -> {
      ((Map<String, Object>) r).put("userId", userId);
      ccpApprovalControlMapper.updateChsControl((Map<String, Object>) r);
    });

  }

  @Override
  public List<EgovMap> selectScoreRangeControlList(Map<String, Object> params) throws Exception {
    return ccpApprovalControlMapper.selectScoreRangeControlList(params);
  }

  @SuppressWarnings("unchecked")
  @Override
  public void saveScoreRangeControl(Map<String, ArrayList<Object>> params, int userId) {
    List<Object> updateList = params.get(AppConstants.AUIGRID_UPDATE);

    updateList.forEach(r -> {
      ((Map<String, Object>) r).put("userId", userId);
      ccpApprovalControlMapper.updateScoreRangeControl((Map<String, Object>) r);
    });

  }


}
