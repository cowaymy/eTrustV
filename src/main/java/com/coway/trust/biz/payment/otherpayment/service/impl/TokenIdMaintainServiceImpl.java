package com.coway.trust.biz.payment.otherpayment.service.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.payment.otherpayment.service.TokenIdMaintainService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("tokenIdMaintainService")
public class TokenIdMaintainServiceImpl extends EgovAbstractServiceImpl implements TokenIdMaintainService {

	@Resource(name = "tokenIdMaintainMapper")
	private TokenIdMaintainMapper tokenIdMaintainMapper;

  @Override
  public List<EgovMap> selectTokenIdMaintain(Map<String, Object> params) {
    return tokenIdMaintainMapper.selectTokenIdMaintain(params);
  }

  @Override
  public List<EgovMap> selectTokenIdMaintainDetailPop(Map<String, Object> params) {
    return tokenIdMaintainMapper.selectTokenIdMaintainDetailPop(params);
  }

  @SuppressWarnings("unchecked")
  @Override
  public int saveTokenIdMaintainUpload(Map<String, Object> params, List<Map<String, Object>> list) {

    if(list.size() > 0){
      List  buLit = new ArrayList();
      for(int i=0 ; i < list.size() ; i++){
         buLit.add(list.get(i));
      }

      params.put("list", buLit);
      tokenIdMaintainMapper.saveTokenIdMaintainBulk(params);
    }

    return list.size();

  }

}
