package com.coway.trust.biz.payment.otherpayment.service.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.payment.otherpayment.service.CustVaExcludeService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("custVaExcludeService")
public class CustVaExcludeServiceImpl extends EgovAbstractServiceImpl implements CustVaExcludeService {

	@Resource(name = "custVaExcludeMapper")
	private CustVaExcludeMapper custVaExcludeMapper;

  @Override
  public List<EgovMap> selectCustVaExcludeList(Map<String, Object> params) {
    return custVaExcludeMapper.selectCustVaExcludeList(params);
  }

  @Override
  public EgovMap getCustIdByVaNo(Map<String, Object> params) {
    return custVaExcludeMapper.getCustIdByVaNo(params);
  }

  @Override
  public void saveCustVaExclude(Map<String, Object> params) {
    custVaExcludeMapper.insertCustVaExclude(params);
  }

  @SuppressWarnings("unchecked")
  @Override
  public void updCustVaExclude(List<Object> updList, int userId) {


    for (Object obj : updList) {
      ((Map<String, Object>) obj).put("userId", userId);
      custVaExcludeMapper.updateCustVaExclude((Map<String, Object>) obj);
    }

  }

  @SuppressWarnings("unchecked")
  @Override
  public int saveCustVaExcludeUpload(Map<String, Object> params, List<Map<String, Object>> list) {

    if(list.size() > 0){
      List  buLit = new ArrayList();
      for(int i=0 ; i < list.size() ; i++){
         buLit.add(list.get(i));
      }

      params.put("list", buLit);
      custVaExcludeMapper.saveCustVaExcludeBulk(params);
    }

    return list.size();

  }



}
