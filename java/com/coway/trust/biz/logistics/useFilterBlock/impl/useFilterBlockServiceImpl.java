package com.coway.trust.biz.logistics.useFilterBlock.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.logistics.useFilterBlock.useFilterBlockService;
import com.coway.trust.biz.logistics.useFilterBlock.impl.useFilterBlockMapper;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("useFilterBlockService")
public class useFilterBlockServiceImpl extends EgovAbstractServiceImpl implements useFilterBlockService {
  private final Logger logger = LoggerFactory.getLogger(this.getClass());

  @Autowired
  private MessageSourceAccessor messageAccessor;

  @Resource(name = "useFilterBlockMapper")
  private useFilterBlockMapper useFilterBlockMapper;

  @Override
  public List<EgovMap> searchUseFilterBlockList(Map<String, Object> params) {


    return useFilterBlockMapper.searchUseFilterBlockList(params);
  }

  @Override
  public EgovMap selectUseFilterBlockInfo(Map<String, Object> params) {
    return useFilterBlockMapper.selectUseFilterBlockInfo(params);
  }

  @Override
  public void saveUseFilterBlock(Map<String, Object> params,SessionVO sessionVO) {

    Map<?, ?> useFilterBlockParams = (Map<?, ?>) params.get("useFilterBlock");

    String viewType = useFilterBlockParams.get("viewType").toString();


    params.put("stkId", useFilterBlockParams.get("stkId"));
    params.put("status", useFilterBlockParams.get("status"));
    params.put("remark", "etrust - UFB");
    params.put("crtUserId", sessionVO.getUserId());
    params.put("updUserId", sessionVO.getUserId());

    //check duplicate in SYS0100M
    String useFilterBlock = useFilterBlockMapper.selectUseFilterBlockByStkId(params);
    if(!StringUtils.isEmpty(useFilterBlock)){
      throw new ApplicationException(AppConstants.FAIL,
      messageAccessor.getMessage(AppConstants.RESPONSE_DESC_DUP));
    }

    if("1".equals(viewType)){
      useFilterBlockMapper.addUseFilterBlock(params);
    }else{
      useFilterBlockMapper.updateUseFilterBlock(params);
    }

  }


}
